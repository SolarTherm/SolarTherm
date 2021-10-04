/*
	Test file for st_motab, reading .motab files including
	metadata comments included at the start of the file.
*/
#include "st_motab.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define TESTMOTAB_DEBUG
#ifdef TESTMOTAB_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif

int main(void){
	const char *filepath = "../SolarTherm/Data/Weather/Mildura_Real2010_Created20130430.motab";
	MotabData *tab = motab_load(filepath);
	
	MSG("Testing loaded values...");
	assert(MOTAB_VAL(tab,0,0) == 0);
	assert(MOTAB_VAL(tab,0,1) == 0);
	assert(MOTAB_VAL(tab,0,2) == 0);
	assert(MOTAB_VAL(tab,0,3) == 25.2);
	assert(MOTAB_VAL(tab,0,4) == 19.9);
	
	//assert(NULL == motab_find_meta_row(NULL,"hello"));
	MSG("Testing metadata row names...");
	assert(NULL == motab_find_meta_row(tab,"TABLEXXXX"));
	assert(NULL != motab_find_meta_row(tab,"TABLELABELS"));
	assert(NULL != motab_find_meta_row(tab,"TABLEUNITS"));
	assert(NULL != motab_find_meta_row(tab,"METALABELS"));
	assert(NULL != motab_find_meta_row(tab,"METAUNITS"));
	assert(NULL != motab_find_meta_row(tab,"METADATA"));

	MSG("Testing column labels...");	
	assert(-1 == motab_find_col_by_label(tab, "txxx"));
	int dni_col = motab_find_col_by_label(tab, "dni"); assert(dni_col == 2);
	int time_col = motab_find_col_by_label(tab, "time"); assert(time_col == 0);
	int Tdry_col = motab_find_col_by_label(tab, "dry"); assert(Tdry_col != -1);
	int wspd_col = motab_find_col_by_label(tab, "wspd"); assert(wspd_col == 8);
	
	MSG("Testing values from names columns...");	
	assert(MOTAB_VAL(tab,9,dni_col) == 678.);
	assert(MOTAB_VAL(tab,8759,dni_col) == 0.0);
	assert(MOTAB_VAL(tab,8759,Tdry_col) == 30.9);
	assert(MOTAB_VAL(tab,8759,time_col) == 31532400.);
	assert(MOTAB_VAL(tab,8759,wspd_col) == 6.5);
	
	MSG("Testing units of named columns...");	
	char *units = motab_get_col_units(tab,"time");
	assert(units); assert(0 == strcmp(units,"s")); free(units);
	units = motab_get_col_units(tab,"dni");
	assert(units); assert(0 == strcmp(units,"W/m2")); free(units);
	units = motab_get_col_units(tab,"wspd");
	assert(units); assert(0 == strcmp(units,"m/s")); free(units);

	MSG("Testing timestep...");		
	double step;
	assert(0 == motab_check_timestep(tab,&step));
	assert(step == 3600.);
	
	MSG("Testing interpolation...");
	double t = 126000;
	double val = motab_get_value(tab,t,dni_col);
	MSG("t = %f, val = %f",t, val);
	assert(fabs(932. - val) < 1e-5);
	t = 31528800;
	val = motab_get_value(tab,t,Tdry_col);
	MSG("t = %f, val = %f",t, val);
	assert(fabs(34.3 - val) < 1e-7);
	t = 31532400;
	val = motab_get_value(tab,t,Tdry_col);
	MSG("t = %f, val = %f",t, val);
	assert(fabs(30.9 - val) < 1e-7);
	t = 0;
	val = motab_get_value(tab,t,Tdry_col);
	MSG("t = %f, val = %f",t, val);
	assert(fabs(25.2 - val) < 1e-7);
	
	MSG("Testing metadata read...");
	int err = 0;
	char *mname = motab_get_meta_str(tab,"name",&err);
	assert(mname != NULL);
	assert(err == 0);
	MSG("meta = %s",mname);
	assert(strcmp(mname,"76031-\"MILDURA AIRPORT\"")==0);
	free(mname);
	
	double mlat, mlon;
	mlat = motab_get_meta_real(tab,"lat",&units,&err);
	assert(err == 0);
	MSG("lat = %f %s",mlat,units);
	assert(fabs(mlat - (-34.236)) < 5e-4);
	assert(strcmp(units,"deg") == 0);
	free(units);

	mlon = motab_get_meta_real(tab,"lon",&units,&err);
	assert(err == 0);
	assert(strcmp(units,"deg") == 0);
	MSG("lon = %f %s",mlon,units);
	assert(fabs(mlon - (142.087)) < 5e-4);
	free(units);
	
	MSG("Freeing memory...");
	motab_free(tab);
	
	return 0;
}
