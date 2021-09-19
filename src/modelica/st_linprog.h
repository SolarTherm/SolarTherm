#ifndef STLINPROG_H
#define STLINPROG_H

#include "st_motab.h"

double st_linprog(MotabData *wd, MotabData *pd, 
		int horizon, double dt, double time_simul,
		double etaC[], double etaG, double t_stg,
		double DEmax, double SLmax, double SLinit, 
		double SLminrel, double Ahelio
);

#endif

