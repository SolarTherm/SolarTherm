#ifndef STLINPROG_H
#define STLINPROG_H

#include "st_motab.h"

double st_linprog(MotabData *wd, MotabData *pd
		,int horizon, double dt, double t0
		,double etaC[], double etaG
		,double DEmax, double SLmax, double SLinit
		,double SLmin, double A
);

double st_mip(
		 MotabData *pvd
		,MotabData *wnd
		,double P_elec_max_pv
		,double P_elec_max_wind
		,double P_elec_pv_ref_size
		,double P_elec_wind_ref_size
        ,int horizon // Time horizon for the optimization
        ,double dt // Time step duration
        ,double t0 // Initial time
        ,double eff_heater // Efficiency of the heater
        ,double eff_process // Efficiency of the process
        ,double DEmax // Maximum dispatched energy
        ,double SLmax // Maximum stored energy (storage limit)
        ,double SLinit // Initial stored energy
        ,double SLmin // Minimum stored energy
        ,double ramp_up_fraction // Fraction of DEmax allowed for ramping up
        ,double ramp_dw_fraction // Fraction of DEmax allowed for ramping up
        ,double P_elec_max // Maximum electrical power
        ,double upper_threshold // Minimum energy delivery to the process
        ,double pre_dispatched_heat // Initially pre-dispatched heat
);

#endif

