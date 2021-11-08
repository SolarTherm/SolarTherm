/*
	Test code for testing on the fly surrogate functionality
*/
#include "otf/kriging.h"
#include "otf/ann.h"
#include "otf/sscpb.h"
#include "otf/util.h"

#include <gsl/gsl_linalg.h>
#include <gsl/gsl_cblas.h>
#include <gsl/gsl_blas.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <libgen.h>
#include <math.h>
#include <dirent.h>
//#include <Python.h>

#define limsize 512

#define TESTOTF_DEBUG
#ifdef TESTOTF_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif

/*
	Simple function to grab SolarTherm path
*/
void grab_SolarTherm_path(char* SolarTherm_path){
	//****************** Grab CWD
	fprintf(stderr,"MARKER A\n");
	char* cwd = NEW_ARRAY(char,limsize);
	cwd = getcwd(cwd, limsize);
	fprintf(stderr,"MARKER B\n");
	fprintf(stderr,"CWD: %s\n",cwd);

	snprintf(SolarTherm_path, MAXLEN, "%s/SolarTherm",dirname(cwd));
	fprintf(stderr,"MARKER C\n");
	fprintf(stderr,"SolarTherm path: %s\n",SolarTherm_path);
}

/*
	Initialtisation of NREL Power Block. Return 0 if pass, -1 if fail
*/
int test_initNRELPB(){
	fprintf(stderr,"MARKER 1\n");
	double P_net = 100000000/0.9; 
	double T_in_ref_blk = 1073.15;
	double p_high = 25000000.0;
	double dT_PHX_cold_approach = 15.0;
	double eta_isen_mc = 0.89;
	double eta_isen_rc = 0.89;
	double eta_isen_t = 0.93;
	double dT_mc_approach = 6.0;
	double T_amb_base = 41.0 + 273.15 - dT_mc_approach;
	char* HTF_name = "CarboHSP";
	int HTF_choice = 50;
			
	char* SolarTherm_path = "../SolarTherm";

	double T_HTF_cold_des = 823.15;

	double* res = NEW_ARRAY(double,13);
	fprintf(stderr,"MARKER 2\n");

	initNRELPB(
		P_net, T_in_ref_blk, p_high, 
		dT_PHX_cold_approach, eta_isen_mc, eta_isen_rc, 
		eta_isen_t, dT_mc_approach, T_amb_base, HTF_name, HTF_choice, 
		SolarTherm_path, T_HTF_cold_des, res
	);

	fprintf(stderr,"MARKER 3\n");
	double dT_PHX_hot_approach = res[12];
	fprintf(stderr, "dt PHX hot approach at design point = %lf\n", dT_PHX_hot_approach);
	assert(
		abs(dT_PHX_hot_approach - 93.831340) < 0.1
	);
	fprintf(stderr,"MARKER 4\n");
	return 0;
}

/*
	Test function to load existing Kriging model
*/
int test_loadExistingKriging(){
	fprintf(stderr,"MARKER 5\n");
	double P_net = 100000000/0.9; 
	double T_in_ref_blk = 1073.15;
	double p_high = 25000000.0;
	double PR = 2.57;
	double pinch_PHX = 15.0;
	double dTemp_HTF_PHX = 250.0;
	double load_base = 1.0;
	double eta_gross_base = 0.5;
	double eta_Q_base = 1.0;
	char* SolarTherm_path = "../SolarTherm";

	char* base_path  = NEW_ARRAY(char, MAXLEN);
	snprintf(base_path, MAXLEN, "%s/Data/SurrogateModels/PowerBlock",SolarTherm_path);

	int inputsize = 3;
	int outputsize = 2;
	double tolerance = 0.006;
	int PB_model = 1 /*SSC sCO2 PB*/;
	int htf_choice = 50;
	double dT_PHX_hot_approach = 93.831340;
	double dT_PHX_cold_approach = 15.0;
	double eta_isen_mc = 0.89;
	double eta_isen_rc = 0.89;
	double eta_isen_t = 0.93;
	double dT_mc_approach = 6.0;
	double T_amb_base = 41.0 + 273.15 - dT_mc_approach;
	char* HTF_name = "CarboHSP";

	/*Start building*/
	fprintf(stderr,"MARKER 6\n");
	Kriging_struct* Kriging_variables = constructKriging(
		P_net, T_in_ref_blk, p_high, PR, 
		pinch_PHX, dTemp_HTF_PHX, load_base,  T_amb_base, 
		eta_gross_base, eta_Q_base, base_path, SolarTherm_path,
		inputsize, outputsize, tolerance, PB_model, 
		htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,
		eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach, 
		HTF_name
	);
	fprintf(stderr,"MARKER 7\n");

	fprintf(stderr,"%lf , %lf \n",Kriging_variables->sill_HX, 0.10501801002768738);
	fprintf(stderr,"%lf , %lf \n",Kriging_variables->Nugget_HX, 0.006652692211982437);
	fprintf(stderr,"%lf , %lf \n",Kriging_variables->Range_HX, 1.7320508075688772);

	assert(
		abs(Kriging_variables->sill_HX - 0.10501801002768738) < 0.01
	);

	assert(
		abs(Kriging_variables->Nugget_HX - 0.006652692211982437) < 0.0001
	);

	assert(
		abs(Kriging_variables->Range_HX - 1.7320508075688772) < 0.01
	);
	fprintf(stderr,"MARKER 8\n");

	return 0;
}

int main(){
	test_initNRELPB();
	fprintf(stderr,"Init PB done\n");
	test_loadExistingKriging();
	fprintf(stderr,"Load existing Kriging done\n");
}
