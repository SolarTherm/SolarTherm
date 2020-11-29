#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "tensorflow/c/c_api.h"
#include <dirent.h>

#include "st_on_the_fly_surrogate.c"

int main()
{
    //double P_net[] = {100e6,50e6,10e6,250e6,500e6,115e6*0.9};
	double P_net[] = {10e6,20e6,30e6,40e6,50e6,60e6,70e6,80e6,90e6,100e6,110e6,120e6,130e6,140e6,150e6};
    double T_in_ref_blk = 800 + 273.15;
    double T_cold_set = 550 + 273.15;
    double dT_PHX_cold_approach = 15;
    double p_high = 25e6;
    double eta_comp_main = 0.89;
    double eta_comp_re = 0.89;
    double dT_mc_approach = 6;
    double CIT = 41 + 273.15;
    double blk_T_amb_des = CIT - dT_mc_approach;
    double eta_isen_t;
    char* SolarTherm_path = "/home/philgun/solartherm-particle/SolarTherm";
    char* base_path = "/home/philgun/solartherm-particle/SolarTherm/Resources/Include";

    double dT_PHX_hot_approach; //product of iteration

    double NREL_PB_configurations[13];
    
    for(size_t i=0;i<sizeof(P_net)/sizeof(P_net[0]);i++)
    {
        double P_gross = P_net[i] / (1-0.1);

        if(P_gross>3e7)
        {
            eta_isen_t = 0.93; //#   Weiland & Thimsen 2016
                               //    Recommended turbine efficiencies are 90% for axial turbines above 30 MW, 
                               //    and 85% for radial turbines below 30 MW.
                               //    93 is used here referring to Dyreby off design paper
        }
        else
        {
            eta_isen_t = 0.85; //#   Assuming radial turbine
        }

        initNRELPB(
            P_gross, 
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
      	/*  
        double eta_gross_base = NREL_PB_configurations[10];
        double eta_Q_base = NREL_PB_configurations[11];
        dT_PHX_hot_approach = NREL_PB_configurations[12];

        fprintf(stderr,"P_gross = %lf W, dT_PHX_approach = %lf K\n",P_gross,dT_PHX_hot_approach);

        Kriging_struct* Kriging_variables = constructKriging(
            P_gross,
            T_in_ref_blk,
            p_high,
            1,
            1,
            1,
            1,
            blk_T_amb_des,
            eta_gross_base,
            eta_Q_base,
            base_path,
            SolarTherm_path,
            3,
            2,
            10,                                     
            1,
            50,
            dT_PHX_hot_approach,
            dT_PHX_cold_approach,
            eta_comp_main,
            eta_comp_re,
            eta_isen_t,
            dT_mc_approach,
            "CarboHSP"
        );

        destructKriging(Kriging_variables);

		Session_Props* sess0 = constructANN(
			P_gross, 
			T_in_ref_blk, 
			p_high,  
			1, 
    		1, 
			1, 
			1, 
			blk_T_amb_des, 
    		eta_gross_base, 
			eta_Q_base, 
			0, 
			base_path, 
			SolarTherm_path, 
    		3, 
			2, 
			10, 
			1,
    		50, 
			dT_PHX_hot_approach,  
			dT_PHX_cold_approach,
    		eta_comp_main, 
			eta_comp_re, 
			eta_isen_t,
			dT_mc_approach,
    		"CarboHSP");
			
		Session_Props* sess1 = constructANN(
			P_gross, 
			T_in_ref_blk, 
			p_high,  
			1, 
			1, 
			1, 
			1, 
			blk_T_amb_des, 
			eta_gross_base, 
			eta_Q_base, 
			1, 
			base_path, 
			SolarTherm_path, 
			3, 
			2, 
			10, 
			1,
			50, 
			dT_PHX_hot_approach,  
			dT_PHX_cold_approach,
			eta_comp_main, 
			eta_comp_re, 
			eta_isen_t,
			dT_mc_approach,
			"CarboHSP");

			destructANN(sess0);
			destructANN(sess1);*/

    }

     
}
