#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "st_linprog_dualtank.c"


int main()
{
    double c0 = 20;
    double c1 = 10;                           
    int n_horizon = 24;   
    double dt = 1.0;
    double c_ratio = 7.58259;

    double etaPB = 0.5;      
    double* etaSF = malloc(sizeof(double) * n_horizon);  
    for(int i=0;i<n_horizon;i++){
        etaSF[i] = 0.6;
    }        
    double etaRCV = 0.88;                                               
    double etaPV = 0.20;                                                
    double etaAEL = 0.55;                                              
    double etaBurner = 0.76;
    double etaResistive = 1; 
    double dni[] = {0,0,0,0,0,0,0,176,492,862,749,761,844,676,481,501,0,0,0,0,0,0,0,0,};
    double ghi[] = {0,0,0,0,0,0,0,50,201,396,461,507,522,421,286,162,21,0,0,0,0,0,0,0}; 
    double* P_PV_in_z = malloc(sizeof(double) * n_horizon);
    double A_sf = 90000.0;
    double A_pv = 1500000.0;
    for(unsigned i=0;i<n_horizon;i++){
        P_PV_in_z[i] = ghi[i] * etaRCV * A_pv;
    }
    
    double P_AEL_nameplate = 100;
    double PB_size = 100;
    double TES_capacity = 1058.258;
    double Q_TES_HX_max = 32;
    double E_TES_init = 0.05 * TES_capacity;
    double E_TES_min = 0.05* TES_capacity;
    double LHV = 120;
    double mdot_H2_feedstock = 2.5755;
    double Q_H2_reactor_max = mdot_H2_feedstock * LHV;
    double delta_h_H2 = 1633200.0/1000000;
    double t_storage_H2 = 720; 
    double H2stg_capacity = mdot_H2_feedstock * LHV * t_storage_H2*3600 * 0.0002777778;
    double H2stg_init = 0.25  * H2stg_capacity;
    double H2stg_min = 0.05  * H2stg_capacity;

    double t0 = 0;

    double* optimalSolution = malloc(sizeof(double) * 7);
    
    st_linprog_dualtank(
        c0, c1, n_horizon, dt, c_ratio,
        etaPB, etaSF, etaRCV, etaAEL, etaBurner, etaResistive,
        dni, P_PV_in_z, P_AEL_nameplate, A_sf, 
        PB_size, TES_capacity, Q_TES_HX_max, E_TES_init, E_TES_min,
        Q_H2_reactor_max, LHV, delta_h_H2, H2stg_capacity, H2stg_init, H2stg_min,
        t0, optimalSolution  
    );
}
