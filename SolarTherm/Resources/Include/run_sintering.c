#include <python2.7/Python.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <dirent.h>

#include "ascend_models/ascend_utils.h"

/*Function Prototype*/
int run_sintering_thermal_model_off_design(const char* SolarTherm_path, const char* solstice_wd, const double vars[], char* iron_sample,  char* opt_file);

double* run_sintering_thermal_model_designpoint(const char* SolarTherm_path, const char* solstice_wd, const double vars[], char* iron_sample, const char* opt_file, double* results);

double interpolate_sintering_thermal_model(const char* ppath, const char* pname, const char* pfunc, const char* modelica_wd, double declination, double sun_hour_angle, double flux_multiple_off);




double* run_sintering_thermal_model_designpoint(const char* SolarTherm_path, const char* solstice_wd, const double vars[], char* iron_sample, const char* opt_file, double* results){

	/*Build destination fn destination*/
	fprintf(stderr, "RUN THERMAL MODEL FOR DESIGN CONDITION......................................................\n");
	fprintf(stderr, "OPT_FILE On Design: %s......................................................\n",opt_file);

	/*Build destination fn source*/
	char* fmfile = NEW_ARRAY(char, MAXLEN);
	snprintf(fmfile,MAXLEN,"%s/receiver_1D_FluxMap_des_point.csv",solstice_wd);

	int status_run = run_ascend_sintering_model_CLI(
		vars, solstice_wd, SolarTherm_path, iron_sample, "on_design", fmfile
	);
	
	/*Read the design point file here*/
	char str[MAXLEN];
	char* fn_res_py = NEW_ARRAY(char, MAXLEN);

	snprintf(fn_res_py, MAXLEN,"%s/des_point_calc.csv",solstice_wd);

	if (fopen(fn_res_py,"r") == NULL){
		fprintf(stderr,"File does not exist: %s\n",fn_res_py);
		exit(EXIT_FAILURE);
	}
	FILE* f = fopen(fn_res_py,"r");
	if(f != NULL){
		fgets(str, MAXLEN, f);
		sscanf(str,"%lf,%lf,%lf",&results[0],&results[1],&results[2]);
	}
	else{
		fprintf(stderr,"%s/des_point_calc.csv can not be found. Exiting the simulation..........................\n",solstice_wd);
		EXIT(EXIT_FAILURE);
	}
	fclose(f);

	fprintf(stderr, "DONE RUNNING THERMAL MODEL FOR DESIGN CONDITION......................................................\n\n");

	return results;
}

int run_sintering_thermal_model_off_design(const char* SolarTherm_path, const char* solstice_wd, const double vars[], char* opt_file, char* iron_sample){
	fprintf(stderr,"START GATHERING DATA FOR SURROGATE MODEL............................\n\n");
	fprintf(stderr, "OPT_FILE Off Design: %s......................................................\n",opt_file);
	
	char* fmfile = NEW_ARRAY(char, MAXLEN);
	snprintf(fmfile, MAXLEN,"%s/receiver_1D_FluxMap_sunpos_1.csv",solstice_wd);

	if(fopen(fmfile,"r")==NULL){
		fprintf(stderr,"File does not exist: fname %s\n",fmfile);
		exit(EXIT_FAILURE);
	}

	/*Delete old file if exists*/
	char* old_file = NEW_ARRAY(char, MAXLEN);
	snprintf(old_file, MAXLEN, "%s/sintering_performance_data.csv",(solstice_wd));
	remove(old_file);
	free(old_file);

	int status_run;

	for(size_t file_index=1; file_index<27; file_index++){
		snprintf(fmfile, MAXLEN,"%s/receiver_1D_FluxMap_sunpos_%zu.csv",solstice_wd, file_index);

		/*Run ASCEND thru system call instead of using python C-API --> creates problem not sure why*/
		int status_run = run_ascend_sintering_model_CLI(
			vars, solstice_wd, SolarTherm_path, iron_sample, "off_design", fmfile
		);
	}

	assert(status_run == 0);

	fprintf(stderr,"FINISH GATHERING DATA FOR SURROGATE MODEL............................\n\n");
	return status_run;

}

double interpolate_sintering_thermal_model(const char* ppath, const char* pname, const char* pfunc, const char* solstice_wd, double declination, double sun_hour_angle, double flux_multiple_off){
	double mdot_ore;
	mdot_ore = run_interpolation(ppath, pname, pfunc, solstice_wd, declination, sun_hour_angle, flux_multiple_off);
	//fprintf(stderr,"mdot_ore = %lf kg/s\n", mdot_ore);
	return mdot_ore;
}
