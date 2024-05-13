#ifndef STLINPROG_H
#define STLINPROG_H

#include "st_motab.h"

double st_linprog(MotabData *wd, MotabData *pd
		,int horizon, double dt, double t0
		,double etaC[], double etaG
		,double DEmax, double SLmax, double SLinit
		,double SLmin, double A
);

double st_linprog_variability(MotabData *pvd, MotabData *wnd
		,double P_elec_max_pv, double P_elec_max_wind
		,double P_elec_pv_ref_size, double P_elec_wind_ref_size
		,int horizon, double dt, double t0
		,double etaH, double etaG
		,double DEmax, double SLmax, double SLinit
		,double SLmin, double ramp_up_fraction, double P_elec_max
		,double pre_dispatched_heat
);

#endif

