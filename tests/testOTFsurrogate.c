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

#define MAXLEN 1024

#define TESTOTF_DEBUG
#ifdef TESTOTF_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif

/*
	Simple function to grab SolarTherm path
*/
char* grab_SolarTherm_path(){
	//****************** Grab CWD
	char* cwd = NEW_ARRAY(char,MAXLEN);
	cwd = getcwd(cwd, MAXLEN);
	
	//****************** Grab parrent dir for CWD
	char* one_dir_up = NEW_ARRAY(char, MAXLEN);
	one_dir_up = dirname(cwd);

	//****************** String fomrating for SolarTherm_path
	char* SolarTherm_path = NEW_ARRAY(char, MAXLEN);
	snprintf(SolarTherm_path, MAXLEN, "%s/SolarTherm",one_dir_up);

	return SolarTherm_path;
}

/*
	Initialtisation of NREL Power Block. Return 0 if pass, -1 if fail
*/
int test_initNRELPB(){
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
			
	char* SolarTherm_path = NEW_ARRAY(char, MAXLEN);
	SolarTherm_path = grab_SolarTherm_path();

	double T_HTF_cold_des = 823.15;

	double* res = NEW_ARRAY(double,13);

	initNRELPB(
		P_net, T_in_ref_blk, p_high, 
		dT_PHX_cold_approach, eta_isen_mc, eta_isen_rc, 
		eta_isen_t, dT_mc_approach, T_amb_base, HTF_name, HTF_choice, 
		SolarTherm_path, T_HTF_cold_des, res
	);

	double dT_PHX_hot_approach = res[12];
	fprintf(stderr, "dt PHX hot approach at design point = %lf\n", dT_PHX_hot_approach);
	assert(
		abs(dT_PHX_hot_approach - 93.831340) < 0.1
	);
	return 0;
}

/*
	Test function to load existing Kriging model
*/
int test_loadExistingKriging(){
	double P_net = 100000000/0.9; 
	double T_in_ref_blk = 1073.15;
	double p_high = 25000000.0;
	double PR = 2.57;
	double pinch_PHX = 15.0;
	double dTemp_HTF_PHX = 250.0;
	double load_base = 1.0;
	double eta_gross_base = 0.5;
	double eta_Q_base = 1.0;
	char* SolarTherm_path = NEW_ARRAY(char, MAXLEN);
	SolarTherm_path = grab_SolarTherm_path();

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
	Kriging_struct* Kriging_variables = constructKriging(
		P_net, T_in_ref_blk, p_high, PR, 
		pinch_PHX, dTemp_HTF_PHX, load_base,  T_amb_base, 
		eta_gross_base, eta_Q_base, base_path, SolarTherm_path,
		inputsize, outputsize, tolerance, PB_model, 
		htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,
		eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach, 
		HTF_name
	);

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

	return 0;
}


typedef int (TestFunction)(void);
typedef struct{
	TestFunction *fn;
	char *name;
} NamedFunction;
#define FN(N) {test_##N, #N}
const NamedFunction tests[] = {
	FN(initNRELPB), FN(loadExistingKriging), {NULL,NULL}
};	

int main(int argc, const char **argv){
	TestFunction *fn = NULL;
	if(argc>1){
		for(const NamedFunction *i = &(tests[0]); i->name != NULL; ++i){
			if(strcmp(argv[1],i->name)==0)fn = i->fn;
		}
	}
	if(!fn){
		const char *pname = "testOTFsurrogate";
		if(argc > 0)pname = argv[0];
		fprintf(stderr,"%s NAME\n",pname);
		fprintf(stderr,"Run test routine, return 0 on success. Available NAMEs are:\n");
		for(const NamedFunction *i = &(tests[0]); i->name != NULL; ++i){
			fprintf(stderr,"\t%s\n",i->name);
		}
		return(1);
	}
	MSG("\nTesting OTF surrogate '%s'...\n",argv[1]);
	int res = (*fn)();
	MSG("res = %d",res);
	return res;
}
