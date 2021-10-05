#include "st_motab.h"
#include "st_linprog.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <assert.h>

#define SEC_PER_HOUR (3600.)

int main(int argc, char *argv[] ){

	int nsteps = 6;
	double dt = 1;
	
	double etac[nsteps];
	for(int i=0;i<nsteps;++i){
		etac[i] = 1;
	}
	
	double t_stg = 3.;
	double DEmax = 100; // MW
	double SLmax = 100*t_stg; // MWh. FIXME why do I need this AS WELL AS t_stg??
	double SLinit = 0; // MWh
	double SLmin = 0;
	double Ahelio = 100000; // m²
	
	double etag = 1;

	MotabData *wd = motab_new(nsteps,2,"weather","time,dni","s,W/m2");
	MotabData *pd = motab_new(nsteps,2,"price","time,tod","s,1");
	
	int wdt_col = motab_find_col_by_label(wd,"time"); assert(wdt_col == 0);
	int dni_col = motab_find_col_by_label(wd,"dni"); assert(dni_col == 1);
	int pdt_col = motab_find_col_by_label(pd,"time"); assert(pdt_col == 0);
	int tod_col = motab_find_col_by_label(pd,"tod"); assert(tod_col == 1);
	
	for(int i=0;i<nsteps;++i){
		MOTAB_VAL(wd,i,0) = (i+1)*dt;
		MOTAB_VAL(wd,i,dni_col) = 1000;
		MOTAB_VAL(pd,i,0) = i*dt;
		MOTAB_VAL(pd,i,tod_col) = 1;
	}
	for(int i=nsteps/2;i<nsteps;++i){
		MOTAB_VAL(wd,i,dni_col) = 0;
		MOTAB_VAL(pd,i,tod_col) = 3;
	}
	
	double t = 0;
	
	double DE = st_linprog(wd, pd
		,nsteps, dt, t
		,etac, etag
		,DEmax, SLmax, SLinit
		,SLmin, Ahelio
	);

	fprintf(stderr,"DE = %f\n",DE);
	
	return 0;
}




