#include "st_motab.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#define TESTMOTAB_DEBUG
#ifdef TESTMOTAB_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif

int main(void){
	const char *filepath = "../SolarTherm/Data/Weather/Mildura_Real2010_Created20130430.motab";
	MotabData *tab = motab_load(filepath);
	
	MSG("Testing assertions...");
	assert(MOTAB_VAL(tab,0,0) == 0);
	assert(MOTAB_VAL(tab,0,1) == 0);
	assert(MOTAB_VAL(tab,0,2) == 0);
	assert(MOTAB_VAL(tab,0,3) == 25.2);
	assert(MOTAB_VAL(tab,0,4) == 19.9);
	
	//assert(NULL == motab_find_meta_row(NULL,"hello"));
	assert(NULL == motab_find_meta_row(tab,"TABLEXXXX"));
	assert(NULL != motab_find_meta_row(tab,"TABLELABELS"));
	assert(NULL != motab_find_meta_row(tab,"TABLEUNITS"));
	assert(NULL != motab_find_meta_row(tab,"METALABELS"));
	assert(NULL != motab_find_meta_row(tab,"METAUNITS"));
	assert(NULL != motab_find_meta_row(tab,"METADATA"));
	
	assert(-1 == motab_find_col_by_label(tab, "txxx"));
	
	int dni_col = motab_find_col_by_label(tab, "dni"); assert(dni_col == 2);
	int time_col = motab_find_col_by_label(tab, "time"); assert(time_col == 0);
	int Tdry_col = motab_find_col_by_label(tab, "dry"); assert(Tdry_col != -1);
	int wspd_col = motab_find_col_by_label(tab, "wspd"); assert(wspd_col == 8);
	
	assert(MOTAB_VAL(tab,9,dni_col) == 678.);
	assert(MOTAB_VAL(tab,8759,dni_col) == 0.0);
	assert(MOTAB_VAL(tab,8759,Tdry_col) == 30.9);
	assert(MOTAB_VAL(tab,8759,time_col) == 31532400.);
	assert(MOTAB_VAL(tab,8759,wspd_col) == 6.5);
	
	char *units = motab_get_col_units(tab,"time");
	assert(units); assert(0 == strcmp(units,"s")); free(units);
	units = motab_get_col_units(tab,"dni");
	assert(units); assert(0 == strcmp(units,"W/m2")); free(units);
	units = motab_get_col_units(tab,"wspd");
	assert(units); assert(0 == strcmp(units,"m/s")); free(units);
	
	double step;
	assert(0 == motab_check_timestep(tab,&step));
	assert(step == 3600.);
	
	motab_free(tab);
	
	return 0;
}
