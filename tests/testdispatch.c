//#include "ModelicaStandardTables.h"

#include "st_motab.h"
#include "st_linprog.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <assert.h>

#define SEC_PER_HOUR (3600.)

void ModelicaError(const char *str){
	fprintf(stderr,"ERROR: %s\n",str);
}

void ModelicaFormatError(const char *fmt,...){
	va_list args;
	va_start(args,fmt);
	vfprintf(stderr,fmt,args);
}

void usage(const char *prog){
	fprintf(stderr,"%s: simple linear optimal dispatch calculator\n\
\n\
%s DNIFILE PRICEFILE T\n\
    DNIFILE     weather file name\n\
    PRICEFILE   price file name\n\
    T           timestep for evaluation (fractional days 1 Jan 0:00)\n",prog,prog);
}

int main(int argc, char *argv[] ){

	char *prog = "testdispatch";
	if(argc >= 1)prog = argv[0];
	if(argc != 4){
		usage(prog);
		return 1;
	}
	char *fdni = argv[1];
	char *fprice = argv[2];
	double t = atof(argv[3]) * SEC_PER_HOUR;
	
	int horizon = 48;
	double dt = 1 * SEC_PER_HOUR;
	
	double etaC[horizon];
	for(int i=0;i<horizon;++i){
		etaC[i] = 1;
	}
	
	double t_stg = 6.;
	double DEmax = 100; // MW
	double SLmax = 100*6.; // MWh. FIXME why do I need this AS WELL AS t_stg??
	double SLinit = 0.3 * SLmax; // MWh
	double SLmin = 0.05 * SLmax; // = SLmin/SLmax
	double Ahelio = 10000; // m²
	
	double etaG = 0.4;

	MotabData *wd = motab_load(fdni);
	MotabData *pd = motab_load(fprice);
	
	assert(motab_find_col_by_label(wd,"dni")!=-1);
	assert(motab_find_col_by_label(pd,"price")!=-1);

	double DE = st_linprog(wd, pd
		,horizon, dt, t
		,etaC, etaG
		,DEmax, SLmax, SLinit
		,SLmin, Ahelio
	);

	fprintf(stderr,"DE = %f\n",DE);
}


