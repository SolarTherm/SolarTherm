#ifndef STLINPROG_H
#define STLINPROG_H

#include "st_motab.h"

double st_linprog(MotabData *wd, MotabData *pd
		,int horizon, double dt, double t0
		,double etaC[], double etaG
		,double DEmax, double SLmax, double SLinit
		,double SLmin, double A
);

#endif

