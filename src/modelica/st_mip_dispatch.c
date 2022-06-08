#include <glpk.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

double st_linprog(const double * price, int horizon, double dt, double time_simul,
						const double * DNI, const double * etaC, const double * etaR, double etaG, 
						double DEmax, double SLmax, double SLinit, double SLminrel, double A_field)
{
	int time_index = time_simul / 3600;
	double SLmin = SLminrel * SLmax;
	double Qraw;

	printf("time_simul [s], time_index: %f, %d\n",time_simul,time_index);
	printf("DEmax [MWth]: %f\n",DEmax);
	printf("SLmax [MWh_th]: %f\n",SLmax);
	printf("SLinit [MWh_th]: %f\n",SLinit);
	printf("SLmin [MWh_th]: %f\n",SLmin);

	// ************ MATRICES AND VECTORS ********************
	int i, j, var = 4;                                        //SL,DE,DE,XE
	int rows = 2*horizon+1, cols = var*horizon;
	double coefs[rows][cols];
	int ia[1+rows*cols], ja[1+rows*cols];
	double ar[1+rows*cols], z;

	// ************ COEFFICIENTS ****************************
	for (i=0; i<rows; i++){
		for (j=0; j<cols; j++){
			coefs[i][j] = 0.0;
		}
	}

	// ************ CONSTRAINTS *****************************
	for (i=0; i<horizon; i++){
		//SL(i)-SL(i-1)-SE(i)*Δt+DE(i)*Δt=0
		if (i>0){
			coefs[i][i-1] = -1;							// SL(i-1)
		}
		coefs[i][i] = 1;									// SL(i)
		coefs[i][i+1*horizon] =  dt;					// DE(i)
		coefs[i][i+2*horizon] = -dt;					// SE(i)
		//SE(i)Δt+XE(i)Δt=A ηC DNI(i)Δt
		coefs[i+horizon][i+2*horizon] = dt;			// SE(i)
		coefs[i+horizon][i+3*horizon] = dt;			// XE(i)
		//∑[DE(i)-SE(i)] = 0
		coefs[rows-1][i+1*horizon] = DEmax;				// DE(i)
		coefs[rows-1][i+2*horizon] = -1;				// SE(i)
	}

	// Initialise problem object lp
	glp_prob* lp;
	lp = glp_create_prob();

	// Initialise the type of the problem, MAXIMISATION
	glp_set_obj_dir(lp, GLP_MAX);

	// ************ ADDING AUXILIARY VARIABLES **************
	glp_add_rows(lp, rows);
	for(i=1; i<horizon+1; i++){
		if(i==1){
			//-SL0 + SL1 + SE1.Δt - DE1.Δt = 0
			glp_set_row_bnds(lp, i, GLP_FX, SLinit, SLinit);
		}
		else{
			//-SLn + SL(n-1) + SEn.Δt - DEn.Δt = 0
			glp_set_row_bnds(lp, i, GLP_FX, 0.0, 0.0);
		}
		//SEn.Δt + XEn.Δt = A * ηC * DNIn.Δt
		Qraw = A_field*etaC[i-1]*etaR[i-1]*DNI[i-1]*dt/1e6;
		glp_set_row_bnds(lp, i+horizon, GLP_FX, Qraw, Qraw);
	}
	//∑(DEn-SEn) = 0
	glp_set_row_bnds(lp, rows-1, GLP_FX, 0.0, 0.0);

	// ************ ADDING STRUCTURAL VARIABLES *************
	glp_add_cols(lp, cols);
	for(i=1; i<horizon+1; i++){
		//************************** BOUNDARIES *****************************************************************
		glp_set_col_bnds(lp, i, GLP_DB, SLmin, SLmax);                                // SL(i)
		glp_set_col_kind(lp, i+horizon, GLP_BV);                                 // DE(i)
		Qraw = A_field*etaC[i-1]*etaR[i-1]*DNI[i-1];
		if (Qraw > 0){
			glp_set_col_bnds(lp, i+2*horizon, GLP_DB,0.0,Qraw);                        // SE(i) is above zero
			glp_set_col_bnds(lp, i+3*horizon, GLP_DB,0.0,Qraw);                        // XE(i) is above zero
		}
		else{
			glp_set_col_bnds(lp, i+2*horizon, GLP_FX, 0.0, 0.0);                       // SE(i) when DNI is zero
			glp_set_col_bnds(lp, i+3*horizon, GLP_FX, 0.0, 0.0);                       // XE(i) when DNI is zero
		}
		glp_set_obj_coef(lp, i, 0);                                                   // SL(i) objective function
		glp_set_obj_coef(lp, i+horizon, DEmax*etaG*price[i-1]);                             // DE(i) objective function
		glp_set_obj_coef(lp, i+2*horizon, 0);                                         // SE(i) objective function
		glp_set_obj_coef(lp, i+3*horizon, 0);                                         // XE(i) objective function
	}

	// Populating coefficients in the coefficient matrix
	int k = 1;
	for (i=0; i<rows; i++){
		for (j=0; j<cols; j++){
			ia[k] = i+1, ja[k] = j+1, ar[k] = coefs[i][j];
			k += 1;
		}
	}
	glp_load_matrix(lp,rows*cols,ia,ja,ar);

	// ************ SOLVING THE PROBLEM *********************
	glp_iocp parm;
	glp_init_iocp(&parm);
	parm.presolve = GLP_ON;
	int err = glp_intopt(lp, &parm);

	// Get the value of the optimal obj. function
	z = glp_get_obj_val(lp);
	printf("OPTIMAL OBJ FUNCTION = %f USD\n",z);

	printf("DNI [W/m.sq] :\n");
	for(size_t i=1;i<=horizon;i++){
		printf("[%.1f] ", DNI[i-1]);
	}

	printf("\n");
	printf("Optical efficiency :\n");
	for(size_t i=1;i<horizon+1;i++){
		printf("[%.4f] ", etaC[i]);
	}

	printf("\n");
	printf("Optimal Dispatch Energy DE [MWth] :\n");
	for(size_t i=1;i<horizon+1;i++){
		printf("[%.2f]", glp_get_col_prim(lp,i+horizon));
	}

	printf("\n");
	printf("Price [USD/MWh] :\n");
	for(size_t i=1;i<horizon+1;i++){
		printf("[%.2f]", price[i-1]);
	}

	int dis = glp_mip_col_val(lp, 1+horizon);
	double optimalDispatch = ((double) dis)*DEmax;


	printf("OPTIMAL DISPATCH FOR THE NEXT HOUR: %f\n\n",optimalDispatch);

	// ************ FREE MEMORY *****************************
	glp_delete_prob(lp);

	return optimalDispatch;
}
