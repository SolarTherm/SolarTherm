#include "linprog/linprog.h"

#include <glpk.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define ST_LINPROG_DEBUG

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

#define ST_ERRVAL (-999999.)
/**
	Calculate an optimal dispatch strategy
	
	Maximise revenue over a specified forecast horizon, given varying DNI and
	varying spot-market selling price for electricity. This function
	implements a linearised model of the CSP system.
	
	@param wd            pointer to WeatherData, loaded from a .motab file.
	@param pd            pointer to PriceData, as loaded from a .motab file.
	@param horizon       forecast horizon (hours)
	@param dt            forecasting timestep (hours)
	@param time_simul    current simulation timestep (seconds)
	@param etaC          efficiency of the solar collector (array of values for
	                     each of the forecast timesteps), including the effect
	                     of both thermal and optical losses. NOTE: etaC[0]
	                     should be the value for the first hour, etaC[1] for the
	                     second hour, etc, up to horizon-1.
	@param etaG          power block (generator) efficiency (constant value)
	@param t_stg         storage capacity, rel to PB nameplate output (hours)
	@param DEmax         max dispatched THERMAL energy in an hour (MWhth)
	@param SLmax         maximum storage level (MWhth)
	@param SLinit        initial storage level, at time_simul (MWhth?)
	@param SLmin         minimum allowed storage level (MWhth)
	@param A             total heliostat field area, m²
	
	FIXME as Philipe has pointed out, the correct implementation should allow
	for weather file and price file with unequal timestep size, by using
	interpolation.

	This should if possible be done using ModelicaStandardTables (ie
	ExternalCombiTable1D) instead of a different approach. But maybe we
	can do it from here in the C code, including the end-of-year wraparound?
	
	FIXME end-of-year wraparound is not yet implemented, will need checking.
*/
double st_linprog(MotabData *wd, MotabData *pd, 
		int horizon, double dt, double time_simul,
		double etaC[], double etaG, double t_stg,
		double DEmax, double SLmax, double SLinit, 
		double SLmin, double A
){

	double wdstep, pdstep;
	assert(0 == motab_check_timestep(wd,&wdstep));
	assert(wdstep == 3600.);
	assert(0 == motab_check_timestep(pd,&pdstep));
	assert(pdstep == 3600.);

	const int time_index = time_simul / 3600;

	MSG("time_simul [s], time_index: %f, %d",time_simul,time_index);
	MSG("DEmax [MWth]: %f",DEmax);
	MSG("SLmax [MWh_th]: %f",SLmax);
	MSG("SLinit [MWh_th]: %f",SLinit);
	MSG("SLmin [MWh_th]: %f",SLmin);

	if(NULL==wd)return ST_ERRVAL;
	if(NULL==pd)return ST_ERRVAL;

	MSG("nrows wd = %d",wd->nrows);
	
	assert(pd->nrows == 8760);
	assert(wd->nrows == 8760);
	
	int price_col = motab_find_col_by_label(pd,"price");
	assert(price_col != -1);

	int dni_col = motab_find_col_by_label(wd,"dni");
	assert(dni_col != -1);

#define MP(I) MOTAB_VAL(pd,time_index+I-1,price_col)
#define ETAC(I) etaC[i-1]
#define DNI(I) MOTAB_VAL(wd,time_index + I - 1,dni_col)

	// Initialise problem object lp
	glp_prob *P = glp_create_prob();

	/* VARIABLES IN THE PROBLEM
	
	SLi (Storage Level) : Energy stored in the tank at end of ith hour [MWh_th]
	DEi (Dispatch Energy) : Sold energy rate [MW_th]
	SEi (Storage Energy) : The input energy in the tank from the sun [MW_th]
	XEi (Dumped Energy) : Lost energy [MW_th]
	
	NOTE that in GLPK, the indices count from, so: I=1...N inclusive.
	*/
	// These 4·N equations are organised with column indices as follows:
#define N (horizon)
#define SL(I) (I)
#define DE(I) (SL(N) + I)
#define SE(I) (DE(N) + I)
#define XE(I) (SE(N) + I)

	glp_add_cols(P, XE(N));
	
	MSG("Number of cols = %d",XE(N));

	
#define NAMEMAX 255
	char sss[NAMEMAX];
	for(int i=1; i<=N; ++i){
		snprintf(sss,NAMEMAX,"SL%02d",i); glp_set_col_name(P,SL(i),sss);
		snprintf(sss,NAMEMAX,"DE%02d",i); glp_set_col_name(P,DE(i),sss);
		snprintf(sss,NAMEMAX,"SE%02d",i); glp_set_col_name(P,SE(i),sss);
		snprintf(sss,NAMEMAX,"XE%02d",i); glp_set_col_name(P,XE(i),sss);
	}

	/* OBJECTIVE FUNCTION
	
		max ∑(DEi·MPi·ηG)                      Maximise the revenue over the
		                                       forecast interval.
	*/
	glp_set_obj_dir(P, GLP_MAX);
	for(int i=1; i<= N; ++i){
		glp_set_obj_coef(P,DE(i),MP(i)*etaG);
	}
	
	/* VARIABLE BOUNDS
		
		SLmin ≤ SLi ≤ SLmax
		0 ≤ DEi ≤ DEmax
		0 ≤ SEi ≤ A · ηC · DNIi
		0 ≤ XEi ≤ A · ηC · DNIi
	*/
	for(int i=1; i<= N; ++i){
		glp_set_col_bnds(P, SL(i), GLP_DB, SLmin, SLmax             );
		glp_set_col_bnds(P, DE(i), GLP_DB, 0    , DEmax             );
		glp_set_col_bnds(P, SE(i), GLP_DB, 0    , A * ETAC(I) * DNI(i) );
		glp_set_col_bnds(P, XE(i), GLP_DB, 0    , A * ETAC(I) * DNI(i) );
	}
		
	/* CONSTRAINTS */
	
	// 2N+1 constraint equations are mapped as follows:
#define SEB(I) (I)    // stored energy balance, 1..N
#define EDX(I) (I+N)  // energy stored and dumped N+1...2N
#define LEB    (1+2*N)// 2N+1.

	glp_add_rows(P, LEB);
	
	MSG("Number of rows = %d",LEB);

	/*
	1. Dispatched energy balance (N equations)
		SLi - SLi-1 = SEi - DEi        Change in storage level equals
		                               net (stored minus dispatche) energy.	
		                               
		Terms on the left hand side are positive, right hand side negative.
	*/
	for(unsigned i=1;i<=N;++i){
		if(i == 1){
			//MSG("SL(%d) = %d, SE(%i) = %d, DE(%d) = %d", i,SL(i),i,SE(i),i,DE(i));
			glp_set_mat_row(P, SEB(i), 3
				,   (int[]){0, SL(i),  SE(i),  DE(i)}
				,(double[]){0,  +1. ,    -1.,    +1.}
			);
			glp_set_row_bnds(P,SEB(i),GLP_FX,SLmin,99999);
		}else{
			//MSG("SL(%d) = %d, SE(%i) = %d, DE(%d) = %d", i,SL(i),i,SE(i),i,DE(i));
			glp_set_mat_row(P, SEB(i), 4
				,   (int[]){0, SL(i),  SL(i-1),  SE(i),  DE(i)}
				,(double[]){0, +1. ,    -1.  ,    -1.,    +1.}
			);
			glp_set_row_bnds(P,SEB(i),GLP_FX,0.,99999);
		}
		snprintf(sss,NAMEMAX,"SEB%02d",i); glp_set_row_name(P,SEB(i),sss);
	/*
	2. Stored energy balance (N equations)
		SEi + XEn = A·ηC·DNIi·Δt       Collected energy is either stored (SE)
		                               or dumped (XE).
	*/
		glp_set_mat_row(P, EDX(i), 2
			,   (int[]){0, SE(i),  XE(i)}
			,(double[]){0,  +1. ,    +1.}
		);
		glp_set_row_bnds(P,EDX(i),GLP_FX,A*ETAC(I)*DNI(i),99999);
		snprintf(sss,NAMEMAX,"EDX%02d",i); glp_set_row_name(P,EDX(i),sss);
	}
	/*
	3. Long-term energy balance (1 equation)
		∑(DEi-SEi) = 0                 No net change in storage level over
		                               the forecast interval.
		-- or --
		SL(N) = SLinit.
	*/
	glp_set_mat_row(P,LEB, 1
		,   (int[]){0, SL(N)}
		,(double[]){0,  +1. }
	);
	glp_set_row_bnds(P,LEB,GLP_FX,0.,99999);
	glp_set_row_name(P,LEB,"LEB");

	// Message attribute
	glp_smcp parm;
	glp_init_smcp(&parm);
#ifdef ST_LINPROG_DEBUG
	parm.msg_lev = GLP_MSG_ALL; // GLP_MSG_ERR;
#else
	parm.msg_lev = GLP_MSG_OFF;
#endif

	// Solve the lp
	int res = glp_simplex(P,&parm);
	if(res == 0){
		MSG("LP successfully solved");
	}else{
		MSG("glp_simplex returned error code %d",res);
	}
	
	glp_print_sol(P,"glpksolution.txt");

#ifdef ST_LINPROG_DEBUG
	// Get the value of the optimal obj. function
	MSG("OPTIMAL OBJ FUNCTION = %f USD",glp_get_obj_val(P));

	MSG1("DNI [W/m.sq] :");
	for(int i=1;i <= N; i++){
		MSG2("[%.1f] ", DNI(i));      
	}
	MSGL;

	MSG1("Optical efficiency :");
	for(int i=1;i<= N; i++){
		MSG2("[%.4f] ", ETAC(i));      
	}
	MSGL;

	MSG1("Optimal Dispatch Energy DE [MWth] :");
	for(int i=1;i<= N; i++){
		MSG2("[%.2f]", glp_get_col_prim(P,DE(i)));
	}
	MSGL;
	
	MSG1("Price [USD/MWh] :");
	for(int i=1;i<= N; i++){
		MSG2("[%.2f]", MP(i));
	}
	MSGL;
#endif

	double optimalDispatch = glp_get_col_prim(P,DE(1));

	MSG("OPTIMAL DISPATCH FOR THE NEXT HOUR: %f",optimalDispatch);

	/*Free all the memory used in this script*/

	glp_free_env();
	motab_free(wd);
	motab_free(pd);

	/*end of the code*/

	return optimalDispatch;
}

// vim: ts=4:sw=4:noet:tw=80
