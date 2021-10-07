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

//#define TESTMOTAB_DEBUG
#ifdef TESTMOTAB_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif

int test_mildura(){
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

	MSG("Testing reading labels by number...");	
	char *label;
	label = motab_get_label_col(tab,2); assert(strcmp(label,"dni")==0);free(label);
	label = motab_get_label_col(tab,0); assert(strcmp(label,"time")==0);free(label);
	label = motab_get_label_col(tab,8); assert(strcmp(label,"wspd")==0);free(label);
	//label = motab_get_label_col(tab,392); assert(label == NULL); // causes crash, due to embedded assertion

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
	
	assert(mlon == motab_get_meta_lon(tab));
	
	assert(mlat == motab_get_meta_lat(tab));
	
	assert(fabs(motab_get_meta_elev(tab) - 50.) < 1e-9);

	assert(fabs(motab_get_meta_tzone(tab) - 10.) < 1e-9);

#ifdef TESTMOTAB_DEBUG
	motab_write_hrt_stdout(tab);
#endif

	MSG("Freeing memory...");
	motab_free(tab);
	
	return 0;
}


int test_daggett(){
	const char *filepath = "../SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab";
	MotabData *tab = motab_load(filepath);
	
	char *loc = motab_get_meta_loc(tab);
	assert(loc);
	MSG("Location = '%s'",loc);
	free(loc);

	double lat = motab_get_meta_lat(tab);
	assert(lat == 34.85);
	MSG("Lat = %lf",lat);
	double lon = motab_get_meta_lon(tab);
	assert(lon == -116.78);
	MSG("Lon = %lf",lon);
	
	return 0;
}


int test_wrap(){
	int nsteps = 6;
	double dt = 1;
	MotabData *wd = motab_new(nsteps,3,"weather","time,dni,bb","s,W/m2,kg");
	
	int t_col = motab_find_col_by_label(wd,"time"); assert(t_col == 0);
	int dni_col = motab_find_col_by_label(wd,"dni"); assert(dni_col == 1);
	int bb_col = motab_find_col_by_label(wd,"bb"); assert(bb_col == 2);
	
	for(int i=0;i<nsteps;++i){
		MOTAB_VAL(wd,i,0) = (i+1)*dt;
		MOTAB_VAL(wd,i,dni_col) = 1000.;
		MOTAB_VAL(wd,i,bb_col) = 100.;
	}
	for(int i=nsteps/2;i<nsteps;++i){
		MOTAB_VAL(wd,i,dni_col) = 0;
		MOTAB_VAL(wd,i,bb_col) = 0;
	}
	MOTAB_VAL(wd,5,bb_col) = 50;

#ifdef TESTMOTAB_DEBUG	
	motab_write_hrt_stdout(wd);
#endif

	assert(motab_get_value_wraparound(wd,1,dni_col) == 1000.);
	assert(motab_get_value_wraparound(wd,2,dni_col) == 1000.);
	assert(motab_get_value_wraparound(wd,3,dni_col) == 1000.);
	assert(motab_get_value_wraparound(wd,4,dni_col) == 0.);
	assert(motab_get_value_wraparound(wd,5,dni_col) == 0.);
	assert(motab_get_value_wraparound(wd,6,dni_col) == 0.);
	assert(motab_get_value_wraparound(wd,7,dni_col) == 1000.);
	assert(motab_get_value_wraparound(wd,8,dni_col) == 1000.);
	assert(motab_get_value_wraparound(wd,9,dni_col) == 1000.);
	assert(motab_get_value_wraparound(wd,10,dni_col) == 0.);
	assert(motab_get_value_wraparound(wd,11,dni_col) == 0.);
	assert(motab_get_value_wraparound(wd,12,dni_col) == 0.);
	assert(motab_get_value_wraparound(wd,13,dni_col) == 1000.);

	assert(motab_get_value_wraparound(wd,1,bb_col) == 100.);
	assert(motab_get_value_wraparound(wd,2,bb_col) == 100.);
	assert(motab_get_value_wraparound(wd,3,bb_col) == 100.);
	assert(motab_get_value_wraparound(wd,3.25,bb_col) == 75.);
	assert(motab_get_value_wraparound(wd,3.5,bb_col) == 50.);
	assert(motab_get_value_wraparound(wd,3.75,bb_col) == 25.);
	assert(motab_get_value_wraparound(wd,4,bb_col) == 0.);
	assert(motab_get_value_wraparound(wd,4.5,bb_col) == 0.);
	assert(motab_get_value_wraparound(wd,5,bb_col) == 0.);
	assert(motab_get_value_wraparound(wd,5.5,bb_col) == 25.);
	assert(motab_get_value_wraparound(wd,6,bb_col) == 50.);
	assert(motab_get_value_wraparound(wd,6.5,bb_col) == 75.);
	assert(motab_get_value_wraparound(wd,7,bb_col) == 100.);
	assert(motab_get_value_wraparound(wd,8,bb_col) == 100.);
	assert(motab_get_value_wraparound(wd,10,bb_col) == 0.);	
}

typedef int (TestFunction)(void);
typedef struct{
	TestFunction *fn;
	char *name;
} NamedFunction;
#define FN(N) {test_##N, #N}
const NamedFunction tests[] = {
	FN(mildura), FN(daggett), FN(wrap), {NULL,NULL}
};	

int main(int argc, const char **argv){
	TestFunction *fn = NULL;
	if(argc>1){
		for(const NamedFunction *i = &(tests[0]); i->name != NULL; ++i){
			if(strcmp(argv[1],i->name)==0)fn = i->fn;
		}
	}
	if(!fn){
		const char *pname = "testmotab";
		if(argc > 0)pname = argv[0];
		fprintf(stderr,"%s NAME\n",pname);
		fprintf(stderr,"Run test routine, return 0 on success. Available NAMEs are:\n");
		for(const NamedFunction *i = &(tests[0]); i->name != NULL; ++i){
			fprintf(stderr,"\t%s\n",i->name);
		}
		return(1);
	}
	MSG("\nTesting motab '%s'...\n",argv[1]);
	return (*fn)();
}

