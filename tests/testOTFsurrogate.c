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
#include <unistd.h>

#define MAXLEN 1024

#define TESTOTF_DEBUG
#ifdef TESTOTF_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif

int test_initNRELPB();
int test_runNRELPBOffDesign();

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

	char cwd[5000];

	getcwd(cwd, 5000);

	char* xx = dirname(cwd);

	const char* SolarTherm_path = NEW_ARRAY(char, 5000);
	snprintf(SolarTherm_path, 5000, "%s/SolarTherm",xx);
			
	//const char* SolarTherm_path = "../SolarTherm"; 

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
	Running off design NREL PB and save the training data
*/
int test_runNRELPBOffDesign(){
	//****************** Run parameters
	int numdata = 10;
	double P_net = 70000000/0.9; 
	double T_in_ref_blk = 1073.15;
	double p_high = 25000000.0;
	double dT_PHX_hot_approach = 93.831340;
	double dT_PHX_cold_approach = 15.0;
	double eta_isen_mc = 0.89;
	double eta_isen_rc = 0.89;
	double eta_isen_t = 0.93;
	double dT_mc_approach = 6.0;
	double T_amb_base = 41.0 + 273.15 - dT_mc_approach;
	char* HTF_name = "CarboHSP";
	int htf_choice = 50;

	char cwd[5000];

	getcwd(cwd, 5000);

	char* xx = dirname(cwd);

	const char* SolarTherm_path = NEW_ARRAY(char, 5000);
	snprintf(SolarTherm_path, 5000, "%s/SolarTherm",xx);

	//char* SolarTherm_path = "../SolarTherm";

	char* trainingdir = NEW_ARRAY(char, MAXLEN);
	snprintf(trainingdir, MAXLEN, "%s/Data/SurrogateModels/PowerBlock/training_data/configNREL3000", SolarTherm_path);
	
	char* base_path = NEW_ARRAY(char,MAXLEN);
	snprintf(base_path, MAXLEN,"%s/Data/SurrogateModels/PowerBlock",SolarTherm_path);

	int status_config = 1;
	int match_index = 3000;

	ssc_data_t simulation_result = runNRELPB(
		numdata, P_net, T_in_ref_blk, p_high,
		T_amb_base, dT_PHX_hot_approach, dT_PHX_cold_approach, 
		eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
		HTF_name, htf_choice, trainingdir, SolarTherm_path, base_path, status_config, match_index, 
		1, /*OD simulated*/
		1 /*test mode*/
	);

	//Deleting directory and files will be done in Python

	/*Check of files are generated*/
	FILE* check_file;
	check_file = fopen("../SolarTherm//Data/SurrogateModels/PowerBlock/configurations/configNREL3000.txt","r");
	
	if(check_file == NULL){
		fprintf(stderr,"configNREL3000.txt is not generated. Generating new config of NREL PB failed\n\n");
		return -1;
	}

	fclose(check_file);

	check_file = fopen("../SolarTherm/Data/SurrogateModels/PowerBlock/training_data/configNREL3000/scaled_Kriging_training_data_deviation.csv","r");
	if(check_file == NULL){
		fprintf(stderr,"Training data not generated. Generating new training data of NREL PB failed\n\n");
		return -1;
	} 
	
	return 0;
}

typedef int (TestFunction)(void);
typedef struct{
	TestFunction *fn;
	char *name;
} NamedFunction;
#define FN(N) {test_##N, #N}
const NamedFunction tests[] = {
	FN(initNRELPB), 
	FN(runNRELPBOffDesign),
	{NULL,NULL}
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
