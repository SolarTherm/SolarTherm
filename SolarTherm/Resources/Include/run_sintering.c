#include <python2.7/Python.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <dirent.h>
#include <time.h>

#include "ascend_models/ascend_utils.h"

/*Function Prototype*/
int run_sintering_thermal_model_off_design(const char* SolarTherm_path, const char* solstice_wd, const double vars[], char* iron_sample,  char* opt_file);

double* run_sintering_thermal_model_designpoint(const char* SolarTherm_path, const char* solstice_wd, const double vars[], char* iron_sample, const char* opt_file, double* results);

double interpolate_sintering_thermal_model(const char* ppath, const char* pname, const char* pfunc, const char* modelica_wd, double declination, double sun_hour_angle, double flux_multiple_off, double time_simul);

int post_processing(char* solstice_wd, char* SolarTherm_path, char* opt_file, int dummy_status_run);


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

	free(fmfile);
	free(fn_res_py);

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

	if(fopen(old_file,"r")){
		remove(old_file);
	}

	free(old_file);

	int status_run;

	for(size_t file_index=1; file_index<28; file_index++){
		snprintf(fmfile, MAXLEN,"%s/receiver_1D_FluxMap_sunpos_%zu.csv",solstice_wd, file_index);

		/*Run ASCEND thru system call instead of using python C-API --> creates problem not sure why*/
		status_run = run_ascend_sintering_model_CLI(
			vars, solstice_wd, SolarTherm_path, iron_sample, "off_design", fmfile
		);

		/*Remove the fluxmap file*/
		remove(fmfile);

	}
	
	/*Remove the fluxmap file*/
	snprintf(fmfile, MAXLEN, "%s/receiver_1D_FluxMap_des_point.csv",solstice_wd);
	remove(fmfile);

	//assert(status_run == 0);
	status_run = 0;
	free(fmfile);

	fprintf(stderr,"FINISH GATHERING DATA FOR SURROGATE MODEL............................\n\nPOSTPROCESSING THE DATA.........\n");
	return status_run;

}

int post_processing(char* solstice_wd, char* SolarTherm_path, char* opt_file, int dummy_status_run){
	/*Post processing*/
	char* fnres = NEW_ARRAY(char, MAXLEN);
	snprintf(fnres, MAXLEN, "%s/sintering_performance_data.csv",solstice_wd);

	char* cmd = NEW_ARRAY(char, MAXLEN);
	
	/*Build fnres and call the postproc script to generate interp3d motab file*/
	snprintf(
		cmd,MAXLEN,
		"python %s/Resources/Include/run_sintering_thermal_model.py --which_run postproc --fnres %s --solstice_wd %s",
		SolarTherm_path, 
		fnres, solstice_wd
	);

	//fprintf(stderr,"%s\n",cmd);
	system(cmd);
	free(fnres);
	free(cmd);
		
	/*Make sure the 3d Interp files (MOTAB) has been generated*/
	char* test_file = NEW_ARRAY(char, MAXLEN);
	snprintf(test_file, MAXLEN, "%s/flux_map_DNI_0.motab",solstice_wd);
	fprintf(stderr, "testfile: %s\n", test_file);
	int status_run;

	if(fopen(test_file,"r")!=NULL){
		fprintf(stderr,"Motab for 3d interp generated sucessfully!\n");
		status_run=0;	
	}else{
		fprintf(stderr,"Failed generating motab for 3d interp!\n");
		status_run=1;
	}
	free(test_file);

	/*Deleting yaml file*/
	char* yaml_file = NEW_ARRAY(char, MAXLEN);
	snprintf(yaml_file, MAXLEN, "%s/input.yaml",solstice_wd);
	remove(yaml_file);
	free(yaml_file);

	/*Deleting pos and aiming .csv*/
	//char* aiming_file = NEW_ARRAY(char, MAXLEN);
	//snprintf(aiming_file, MAXLEN, "%s/pos_and_aiming.csv",solstice_wd);
	//remove(aiming_file);
	//free(aiming_file);

	/*Deleting lookup_table.csv*/
	char* lookuptable_file = NEW_ARRAY(char, MAXLEN);
	snprintf(lookuptable_file, MAXLEN, "%s/lookup_table.csv",solstice_wd);
	remove(lookuptable_file);
	free(lookuptable_file);

	/*Deleting testname.a4c*/
	char* a4c_file = NEW_ARRAY(char, MAXLEN);
	snprintf(a4c_file, MAXLEN, "%s/testname.a4c",solstice_wd);
	remove(a4c_file);
	free(a4c_file);

	/*Deleting input-rcv.yaml*/
	char* input_rcv_yaml = NEW_ARRAY(char, MAXLEN);
	snprintf(input_rcv_yaml, MAXLEN, "%s/input-rcv.yaml",solstice_wd);
	remove(input_rcv_yaml);
	free(input_rcv_yaml);

	/*Deleting table_view.csv*/
	char* table_view_csv = NEW_ARRAY(char, MAXLEN);
	snprintf(table_view_csv, MAXLEN, "%s/table_view.csv",solstice_wd);
	remove(table_view_csv);
	free(table_view_csv);

	/*Deleting sintering_performance_data.csv*/
	char* sintering_performance_data = NEW_ARRAY(char, MAXLEN);
	snprintf(sintering_performance_data, MAXLEN, "%s/sintering_performance_data.csv",solstice_wd);
	remove(sintering_performance_data);
	free(sintering_performance_data);

	/*Deleting fluxmap if the off-design run in skipped due to Q_RCV at design point < than 50 MWth*/
	char* fmfile = NEW_ARRAY(char,MAXLEN);

	/*Test file*/
	snprintf(fmfile, MAXLEN, "%s/receiver_1D_FluxMap_des_point.csv",solstice_wd);

	if(fopen(fmfile,"r")!=NULL){
		/*All the flux maps are actually still there*/
		for(size_t file_index=1; file_index<28; file_index++){
			snprintf(fmfile, MAXLEN,"%s/receiver_1D_FluxMap_sunpos_%zu.csv",solstice_wd, file_index);

			/*Remove the fluxmap file*/
			remove(fmfile);
		}
		/*Remove the fluxmap design point file*/
		snprintf(fmfile, MAXLEN, "%s/receiver_1D_FluxMap_des_point.csv",solstice_wd);
		remove(fmfile);
	}

	free(fmfile);
	
	assert(status_run==0);

	return status_run;
}

double interpolate_sintering_thermal_model(const char* ppath, const char* pname, const char* pfunc, const char* solstice_wd, double declination, double sun_hour_angle, double flux_multiple_off, double time_simul){
	fprintf(stderr,"Simulation time: %lf seconds\n",time_simul);
	clock_t start = clock();

	double mdot_ore;
	mdot_ore = run_interpolation(ppath, pname, pfunc, solstice_wd, declination, sun_hour_angle, flux_multiple_off);

	clock_t end = clock();
	double time_spent = (double)(end-start) / CLOCKS_PER_SEC;

	fprintf(stderr,"It takes %lf seconds to call this C function\nmdot_ore = %lf kg/s\n\n", time_spent, mdot_ore);
	return mdot_ore;
}
