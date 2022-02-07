#include <glpk.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "linprog/linprog.h"

//#define ST_LINPROG_DEBUG

#ifdef ST_LINPROG_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d:" FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
# define MSG1(FMT,...) fprintf(stdout,"%s:%d:" FMT,__FILE__,__LINE__,##__VA_ARGS__)
# define MSG2(FMT,...) fprintf(stdout,FMT,##__VA_ARGS__)
# define MSGL fprintf(stderr,"\n")
#else
# define MSG(...) ((void)0)
# define MSG1(...) ((void)0)
# define MSG2(...) ((void)0)
# define MSGL ((void)0)
#endif

/*METRIC OF THE INPUTS
horizon = hour
dt = hour
time_simul = second
etaC = scalar
etaG = scalar
t_stg = hour
DEmax = MW
SLmax = MWh
SL0rel = scalar
SLminrel = scalar
Ahelio = m.sq
*/

double st_linprog(char* filepathDNI, char* filepathPrice, 
		int horizon, double dt, double time_simul,
		double etaC[], double etaG, double t_stg,
		double DEmax, double SLmax, double SLinit, 
		double SLminrel, double Ahelio
){
	const int vars = 4; // variables in this problem SLn, SEn, DEn, XE
	const int time_index = time_simul / 3600;
	//const float SLinit = SL0rel * SLmax;
	const double SLmin = SLminrel * SLmax;

	// Get the DNI data 
	double* DNI_yearly  = malloc(sizeof(double*)*8760);
	double* time = malloc(sizeof(double*)*8760);
	getDNIMotabData(filepathDNI,DNI_yearly,time,8760);
	int lengthDNI = 8760 + 2*horizon;
	double* DNI = malloc(sizeof(double*)*lengthDNI);

	MSG("time_simul [s], time_index: %f, %d",time_simul,time_index);
	MSG("DEmax [MWth]: %f",DEmax);
	MSG("SLmax [MWh_th]: %f",SLmax);
	MSG("SLinit [MWh_th]: %f",SLinit);
	MSG("SLmin [MWh_th]: %f",SLmin);
	for(size_t i=0;i<8760;i++){
		DNI[i] = DNI_yearly[i];
	}

	for(size_t i=8760;i<lengthDNI;i++){
		DNI[i] = DNI_yearly[i-8760];
	}

	// Get the price data
	double* price_yearly  = malloc(sizeof(double*)*8760);
	double* time_price = malloc(sizeof(double*)*8760);
	getPriceMotabData(filepathPrice,price_yearly,time_price,8760);
	double* price = malloc(sizeof(double*)*lengthDNI);


	for(size_t i=0;i<8760;i++){
		price[i] = price_yearly[i];
	}

	for(size_t i=8760;i<lengthDNI;i++){
		price[i] = price_yearly[i-8760];
	}

	/*Free unused address*/
	free(price_yearly);
	free(DNI_yearly);
	free(time_price);
	free(time);

	// Initialise variable for GLPK
	int var = 4; //SL,DE,DE,XE
	int row = 5 * horizon;
	int col = var * horizon;
	int ia[1+row*col], ja[1+row*col];
	double ar[1+row*col], z, x[horizon];

	// Create dummy matrix A
	double dummyA[row][col];

	for(size_t i=0;i<row;i++){
		for(size_t j=0;j<col;j++)
		{
		    dummyA[i][j]=0;
		}
	}

	for(size_t i=0;i<horizon;i++){
		//-SLn + SL n-1 + SEn.Δt - DEn.Δt = 0
		if(i>0){
		    dummyA[i][i-1] = 1;
		}
		dummyA[i][i] = -1;
		dummyA[i][i+horizon] = -dt;
		dummyA[i][i+2*horizon] = dt;

		//SLn - SL n-1 - SEn.Δt + DEn.Δt = 0
		if(i>0){
		    dummyA[i+horizon][i-1] = -1;
		}
		dummyA[i+horizon][i] = 1;
		dummyA[i+horizon][i+horizon] = dt;
		dummyA[i+horizon][i+2*horizon] = -dt;

		//-SEn.Δt - XEn.Δt = -A * ηC * DNIn.Δt
		dummyA[i+2*horizon][i+2*horizon] = -dt;
		dummyA[i+2*horizon][i+3*horizon] = -dt;

		//SEn.Δt + XEn.Δt = A * ηC * DNIn.Δt
		dummyA[i+3*horizon][i+2*horizon] = dt;
		dummyA[i+3*horizon][i+3*horizon] = dt;
	}

	for(size_t i=0;i<horizon;i++){
		for(size_t j=0;j<horizon;j++){
		    //∑(DEn-SEn) = 0
		    dummyA[i+4*horizon][j+horizon]=1;
		    dummyA[i+4*horizon][j+2*horizon]=-1;
		}
	}

	// Initialise problem object lp
	glp_prob* lp;
	lp = glp_create_prob();

	// Initialise the type of the problem, MAXIMISATION
	glp_set_obj_dir(lp,GLP_MAX);

	// Populate the Right Hand Side of equalities
	glp_add_rows(lp,row);
	for(size_t i=1;i<horizon+1;i++){
		if(i==1){   
		    //-SL0 + SE0.Δt - DE0.Δt ≤ -SLinit  --> Upper bound
		    glp_set_row_bnds(lp,(int)i,GLP_UP,0.0,-SLinit);
		    //SL0 - SE0.Δt + DE0.Δt ≤ SLinit  --> Upper bound
		    glp_set_row_bnds(lp,(int)i+horizon,GLP_UP,0,SLinit);           
		}else{   //-SLn + SL n-1 + SEn.Δt - DEn.Δt ≤ 0 --> Upper bound
		    glp_set_row_bnds(lp,(int)i,GLP_UP,0,0);
		    //SLn - SL n-1 - SEn.Δt + DEn.Δt ≤ 0 --> Upper bound
		    glp_set_row_bnds(lp,(int)i+horizon,GLP_UP,0,0);
		}
		//-SEn.Δt - XEn.Δt ≤ -A * ηC * DNIn.Δt --> Upper bound
		glp_set_row_bnds(lp,(int)i+2*horizon,GLP_UP,0.0,-Ahelio*etaC[i]*DNI[time_index+i-1]*dt/1e6) /*converting from Wh to MWh*/;

		//SEn.Δt + XEn.Δt ≤ A * ηC * DNIn.Δt --> Upper bound
		glp_set_row_bnds(lp,(int)i+3*horizon,GLP_UP,0.0,Ahelio*etaC[i]*DNI[time_index+i-1]*dt/1e6) /*converting from Wh to MWh*/;

		//∑(DEn-SEn) ≤ 0 --> Upper bound
		glp_set_row_bnds(lp,(int)i+4*horizon,GLP_UP,0.0,0.0);
	}

	// Populate the column (variables) in respect to each boundaries
	glp_add_cols(lp,col);

	for(size_t i=1;i<horizon+1;i++){
		/*SLn ==> SLmin ≤ SLn ≤ SLmax n = 1 -> horizon*/
		glp_set_col_bnds(lp,(int)i,GLP_DB,SLmin,SLmax);
		glp_set_obj_coef(lp,(int)i,0); //==> coefficient of objective function

		/*DEn ==> 0 ≤ DEn ≤ DEmax n = horizon + 1 -> 2 * horizon*/
		glp_set_col_bnds(lp,(int)i+horizon,GLP_DB,0.0,DEmax);
		glp_set_obj_coef(lp,(int)i+horizon,etaG*price[time_index+i-1]); //==> coefficient of objective function

		/*SEn ==> 0 ≤ SEn ≤ A * ηC * DNIn n = 2 * horizon + 1 -> 3 horizon*/
		double cons = Ahelio*etaC[i]*DNI[time_index+i-1];
		if (cons != 0){
		    glp_set_col_bnds(lp,(int)i+2*horizon,GLP_DB,0.0,cons);
		    glp_set_col_bnds(lp,(int)i+3*horizon,GLP_DB,0.0,cons);
		}else{
		    glp_set_col_bnds(lp,(int)i+2*horizon,GLP_FX,0.0,0.0);
		    glp_set_col_bnds(lp,(int)i+3*horizon,GLP_FX,0.0,0.0);
		}
		
		/*SEn ==> 0 ≤ SEn ≤ A * ηC * DNIn*/
		glp_set_obj_coef(lp,(int)i+2*horizon,0); //==> objective function

		/*XEn ==> 0 ≤ XEn ≤ A * ηC * DNIn*/
		glp_set_obj_coef(lp,(int)i+3*horizon,0); //==> objective function
	}

	// Populate the array
	for (size_t i = 1; i < row+1; i++){
		size_t iterator = 1;
		while(iterator<col+1){
		    ia[(i-1)*col+iterator]=(int)i;
		    iterator++;
		}
	}

	for (size_t i = 1; i < row+1; i++){
		size_t iterator = 1;
		while(iterator<col+1){
		    ja[(i-1)*col+iterator]=(int)iterator;
		    iterator++;
		}
	}

	for(size_t i=0;i<row;i++){
		for(size_t j=0;j<col;j++){
		    ar[i*col+j+1]= dummyA[i][j];
		}
	}

	// Load the matrix to lp
	glp_load_matrix(lp,row*col,ia,ja,ar);

	// Message attribute
	glp_smcp parm;
	glp_init_smcp(&parm);
#ifdef ST_LINPROG_DEBUG
	parm.msg_lev = GLP_MSG_ERR;
#else
	parm.msg_lev = GLP_MSG_OFF;
#endif

	// Solve the lp
	glp_simplex(lp,&parm);

	// Get the value of the optimal obj. function
	z = glp_get_obj_val(lp);
	MSG("OPTIMAL OBJ FUNCTION = %f USD",z);

	MSG1("DNI [W/m.sq] :");
	for(size_t i=1;i<horizon+1;i++){
		x[i-1] = DNI[time_index+i-1];
		MSG2("[%.1f] ", x[i-1]);      
	}
	MSGL;

	MSG1("Optical efficiency :");
	for(size_t i=1;i<horizon+1;i++){
		MSG2("[%.4f] ", etaC[i]);      
	}
	MSGL;

	MSG1("Optimal Dispatch Energy DE [MWth] :");
	for(size_t i=1;i<horizon+1;i++){
		x[i-1] = glp_get_col_prim(lp,(int)i+horizon);
		MSG2("[%.2f]", x[i-1]);      
	}

	MSGL;
	
	MSG1("Price [USD/MWh] :");
	for(size_t i=1;i<horizon+1;i++){
		MSG2("[%.2f]", price[time_index+i-1]);      
	}
	MSGL;

	double optimalDispatch = x[0];

	MSG("OPTIMAL DISPATCH FOR THE NEXT HOUR: %f",optimalDispatch);

	/*Free all the memory used in this script*/

	glp_free_env();
	free(DNI);
	free(price);

	/*end of the code*/

	return optimalDispatch;
}

// vim: ts=4:sw=4:noet
