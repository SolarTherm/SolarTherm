#include <python2.7/Python.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <dirent.h>

#include "ascend_models/ascend_utils.h"

/*Function Prototype*/
int run_sintering_thermal_model(const char* ppath, const char* pname, const char* SolarTherm_path, const char* solstice_wd, const char* varnames[], const double vars[], char* opt_file, char* iron_sample);

double interpolate_sintering_thermal_model(const char* ppath, const char* pname, const char* pfunc, const char* modelica_wd, double declination, double sun_hour_angle, double flux_multiple_off);

double* run_sintering_thermal_model_designpoint(const char* ppath, const char* pname, const char* pfunc, const char* SolarTherm_path, const char* solstice_wd, const char* varnames[], const double vars[], int argc, char* iron_sample, char* opt_file, double* results);






double* run_sintering_thermal_model_designpoint(const char* ppath, const char* pname, const char* pfunc, const char* SolarTherm_path, const char* solstice_wd, const char* varnames[], const double vars[], int argc, char* iron_sample, char* opt_file, double* results){

	/*Build destination fn destination*/
	fprintf(stderr, "RUN THERMAL MODEL FOR DESIGN CONDITION......................................................\n\n");

	char* fn_destination = NEW_ARRAY(char, MAXLEN);
	snprintf(fn_destination, MAXLEN, "%s/fluxmap.csv",solstice_wd);

	/*Build destination fn source*/
	char* fn_source = NEW_ARRAY(char, MAXLEN);
	snprintf(fn_source,MAXLEN,"%s/receiver_1D_FluxMap_des_point.csv",solstice_wd);

	fprintf(stderr,"Copy flux array from : %s to %s\n",fn_source, fn_destination);

	//Start reading the file starting from line 1 of fn_flux
	FILE* f_source = fopen(fn_source, "r");
	FILE* f_dest = fopen(fn_destination, "w");
	char ch = fgetc(f_source);

	while(ch != EOF){
		fputc(ch, f_dest);
		ch = fgetc(f_source);
	}
	fclose(f_source);
	fclose(f_dest);
	free(fn_destination);
	free(fn_source);
	
	int num_segment = read_num_segment(solstice_wd);
	double* angles = NEW_ARRAY(double,2);
	angles[0] = 0;
	angles[1] = 0;

	run_ascend_sintering_model(ppath, pname, pfunc, argc, num_segment, varnames, vars, solstice_wd, SolarTherm_path, angles, results, iron_sample);
	free(angles);

	fprintf(stderr, "DONE RUNNING THERMAL MODEL FOR DESIGN CONDITION......................................................\n\n");
	return results;
}

int run_sintering_thermal_model(const char* ppath, const char* pname, const char* SolarTherm_path, const char* solstice_wd, const char* varnames[], const double vars[], char* opt_file, char* iron_sample){
	fprintf(stderr,"START GATHERING DATA FOR SURROGATE MODEL............................\n\n");
	char* CSV_test = NEW_ARRAY(char, MAXLEN);
	snprintf(CSV_test, MAXLEN,"%s/receiver_1D_FluxMap_sunpos_1.csv",solstice_wd);

	if(fopen(CSV_test,"r")==NULL){
		fprintf(stderr,"File does not exist: fname %s\n",CSV_test);
		exit(EXIT_FAILURE);
	}

	free(CSV_test);

	/*Delete old file if exists*/
	char* old_file = NEW_ARRAY(char, MAXLEN);
	snprintf(old_file, MAXLEN, "%s/sintering_performance_data.csv",(solstice_wd));
	remove(old_file);
	free(old_file);

	int num_segment = read_num_segment(solstice_wd);
	double* angles = NEW_ARRAY(double, 2);

	int status_run;

	for(size_t file_index=1; file_index<27; file_index++){
		/*Read solar angles*/
		read_solar_angles(angles, file_index, solstice_wd);

		/*Copy flux array*/
		write_flux_array(file_index, SolarTherm_path, solstice_wd);
		
		/*Run ASCEND thru system call instead of using python C-API --> creates problem not sure why*/
		status_run = run_ascend_sintering_model_CLI(ppath, pname, num_segment, vars, solstice_wd, SolarTherm_path, angles, iron_sample);
	}

	assert(status_run == 0);
	free(angles);

	fprintf(stderr,"FINISH GATHERING DATA FOR SURROGATE MODEL............................\n\n");
	return status_run;

}

double interpolate_sintering_thermal_model(const char* ppath, const char* pname, const char* pfunc, const char* solstice_wd, double declination, double sun_hour_angle, double flux_multiple_off){
	double mdot_ore;
	mdot_ore = run_interpolation(ppath, pname, pfunc, solstice_wd, declination, sun_hour_angle, flux_multiple_off);
	fprintf(stderr,"mdot_ore = %lf kg/s\n", mdot_ore);
	return mdot_ore;
}
