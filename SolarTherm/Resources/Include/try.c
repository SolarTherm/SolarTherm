#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "tensorflow/c/c_api.h"
#include <dirent.h>

#include "st_on_the_fly_surrogate.c"

int main()
{
    double P_net = 10e6;
    double T_in_ref_blk = 1073.15;
    double T_cold_set = 550 + 273.15;
    double dT_PHX_cold_approach = 15;
    double p_high = 25e6;
    double eta_comp_main = 0.89;
    double eta_comp_re = 0.89;
    double dT_mc_approach = 6;
    double CIT = 41 + 273.15;
    double blk_T_amb_des = CIT - dT_mc_approach;
    double eta_isen_t = 0.85;
    char* SolarTherm_path = "/home/philgun/solartherm-particle/SolarTherm";
    char* base_path = "/home/philgun/solartherm-particle/SolarTherm/Resources/Include";
	double dT_PHX_hot_approach; //product of iteration
	double NREL_PB_configurations[13];
	initNRELPB(
		P_net/0.9, 
		T_in_ref_blk, 
		p_high, 
		dT_PHX_cold_approach, 
		eta_comp_main, 
		eta_comp_re, 
		eta_isen_t, 
		dT_mc_approach, 
		blk_T_amb_des, 
		"CarboHSP", 
		50, 
		SolarTherm_path, 
		T_cold_set,
		NREL_PB_configurations
		);
}

