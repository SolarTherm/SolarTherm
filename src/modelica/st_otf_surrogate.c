//#include "on_the_fly_surrogate/ontheflysurrogate.h" 
#include "st_otf_surrogate.h"

#include "otf/kriging.h"
#include "otf/ann.h"
#include "otf/sscpb.h"
#include "otf/util.h"

#include <gsl/gsl_linalg.h>
#include <gsl/gsl_cblas.h>
#include <gsl/gsl_blas.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <dirent.h>
#include <Python.h>

#define limitSize 1000000

// max filename length for generated file paths
#define MAXLEN 1024

#define NEW(TYPE) (TYPE*)malloc(sizeof(TYPE))
#define NEW_ARRAY(TYPE,SIZE) (TYPE*)malloc(sizeof(TYPE)*(SIZE))

/*
This C code is used to generate surrogate model for sCO2 PB on the fly. Choice of surrogate modelling techniques are Kriging interpolation and Artificial Neural Network (ANN).
SolarTherm component passes a series of sCO2 PB parameters to construct the surrogate model. The code then check whether a surrogate model based on these parameters has been generated before, and load the surrogate model if it exists, otherwise, a new surrogate is generated. There are two power block model choices: 1) SAM Power Block and 2) CEA Power block. CEA Power block is still work in progress, implemented 100% in Modelica.

The generation of surrogate model makes use of SAM Simulation Core (SSC) sCO2 recompression cycle library, made available by SAM team https://samrepo.nrelcloud.org/beta-releases/sam-beta-linux-2020-11-12.run . Shall new surrogate is generated, this code will fire SSC based on the PB parameters, simulate the sCO2 PB module on- and off- design, gather the training data, train the model and return it as a pointer back to SolarTherm.

Lib dependency: tensorflow, GSL (GNU Scientific Library), Python 3, SSC
*/

//******************** SEQUENCE 1
/*
Initialisation of SSC Power Block makes use of the initNREPB function. The function receives inputs from SolarTherm, and passes the input to SSC PB module. SSC then simulates the on-design sCO2 recup PB cycle.
The function assign the on-design calculation result in `res` (pointer to double) and SolarTherm then grabs the values inside res for further use.

@params:
	P_net					: type double, net power of the power block in W at design point
	T_in_ref_blk			: type double, inlet HTF temp. to the primary heat exchanger (PHX) in K at design point
	p_high					: type double, outlet pressure of main compressor in Pa at design point
	dt_PHX_cold_approach	: type double, delta temp. between incoming sCO2 to PHX and outgoing HTF temp from PHX in K at design point
	eta_isen_mc				: type double, main compressor isentropic efficiency at design point
	eta_isen_rc				: type double, re-compressor isentropic efficiency at design point
	eta_isen_t				: type double, turbine isentropic efficiency at design point
	dT_mc_approach			: type double, design point temperature difference between ambient temperature and desired outlet temperature of CO2 after the mian cooler in K
	T_amb_base				: type double, temperature of the ambient at design point in K at design point
	HTF_name				: type string, HTF name, shall HTF_choice == 50 (user choice), the code will look into the data base whether the requested HTF properies exist based on HTF_name. If does not exist, it will stop the simulation
	HTF_choice				: type int, put 50 for user choice, 1 for solar salt (built in HTF properties within SSC). For more info look into SAM SSC github
	SolarTherm_path			: type string, path where SolarTherm is located
	T_HTF_cold_des			: type double, the target outlet temp. of HTF from the PHX at design point in K. Internal variable within SSC called dt_PHX_hot_approach is iterated.
	res						: type double*, array to store the on-design result

	res indexing:
	*            res[0] = HTR_UA;                    [W/K] 			--> UA value of high temp. recuperator
	*            res[1] = LTR_UA;                    [W/K]			--> UA value of low temp. recuperator
	*            res[2] = W_turb_des;                [W]			--> Turbine gross size 
	*            res[3] = W_maincomp_des;            [W]			--> Main comp. gross size
	*            res[4] = W_recomp_des;              [W]			--> Recompressor gross size
	*            res[5] = Cooler_UA;                 [W/K]			--> Main cooler UA value (dry cooler)
	*            res[6] = PHX_UA;                    [W/K]			--> UA value for the PHX
	*            res[7] = m_dot_CO2_des;             [kg/s]			--> mass flow rate of CO2 at design point
	*            res[8] = m_dot_HTF_des;             [kg/s]			--> mass flow rate of HTF at design point
	*            res[9] = Q_dot_PHX_des;             [W]			--> PHX thermal rating at desing point
	*            res[10] = eta_gross_base;           [-]			--> Cycle efficiency at design point (W_turb_des - W_comp_des - W_recomp_des - W_main_cooler (fan)) / Q_dot_PHX_des
	*            res[11] = eta_Q_base;               [-]			--> Q_dot_PHX/Q_dot_PHX_des which equals to 1 since it is on design calculation
	*            res[12] = dT_PHX_hot_approach;      [K]			--> delta temp. between sCO2 inlet flow to turbine and incoming HTF to PHX

*/

void initNRELPB(double P_net,double T_in_ref_blk, double p_high, double dT_PHX_cold_approach
		,double eta_isen_mc,double eta_isen_rc,double eta_isen_t,double dT_mc_approach
		,double T_amb_base, char* HTF_name, int HTF_choice
		,char* SolarTherm_path, double T_HTF_cold_des, double* res
){
	fprintf(stderr,"======================Initialising NREL Power Block  based on //doi.org/10.1016/j.solener.2019.01.078====================\n");

	double delta = 100;
	ssc_data_t simulation_result;
	double guess_val = 5;
	while(delta>0.5){
		simulation_result = runNRELPB(
				10, P_net, T_in_ref_blk, p_high, T_amb_base
				,guess_val, dT_PHX_cold_approach, eta_isen_mc, eta_isen_rc, eta_isen_t
				,dT_mc_approach, HTF_name, HTF_choice, ".", SolarTherm_path
				,".", 0, 0, 0, 0
			);

		double T_HTF_cold_calculated;
		ssc_data_get_number(simulation_result,"T_htf_cold_des",&T_HTF_cold_calculated);
		fprintf(stderr,"HTF outlet temperature at design point: %lf C\n",T_HTF_cold_calculated);

		delta = fabs(T_HTF_cold_des - (T_HTF_cold_calculated+273.15));
		fprintf(stderr,"dT_PHX_hot_approach iteration: %lf C\n",guess_val);
		
		if(delta>0.5){
			guess_val = guess_val + (delta-0.5);
		}
	}

	double dT_PHX_hot_approach = guess_val;
	fprintf(stderr,"dT_PHX_hot_approach at design point: %lf C\n",dT_PHX_hot_approach);

	double HTR_UA;
	ssc_data_get_number(simulation_result, "HTR_UA_calculated", &HTR_UA);
	fprintf(stderr,"HTR_UA at design point = %lf [MW/K]\n",HTR_UA);

	double C_cooler;
	ssc_data_get_number(simulation_result, "cooler_tot_cost", &C_cooler);
	fprintf(stderr,"Cooler cost = %lf [M.USD]\n",C_cooler);

	double LTR_UA;
	ssc_data_get_number(simulation_result,"LTR_UA_calculated",&LTR_UA);
	fprintf(stderr,"LTR_UA at design point = %lf [MW/K]\n",LTR_UA);

	double W_turb_des;
	ssc_data_get_number(simulation_result,"t_W_dot",&W_turb_des);
	fprintf(stderr,"Turbine power at design point = %lf [MW]\n",W_turb_des);

	double W_maincomp_des;
	ssc_data_get_number(simulation_result,"mc_W_dot",&W_maincomp_des);
	fprintf(stderr,"Main compressor power at design point = %lf [MW]\n",W_maincomp_des);

	double W_recomp_des;
	ssc_data_get_number(simulation_result,"rc_W_dot",&W_recomp_des);
	fprintf(stderr,"Re-compressor power at design point = %lf [MW]\n",W_recomp_des);

	double Cooler_UA;
	ssc_data_get_number(simulation_result,"cooler_tot_UA",&Cooler_UA);
	fprintf(stderr,"Cooler UA value design point = %lf [MW/K]\n",Cooler_UA);

	double PHX_UA;
	ssc_data_get_number(simulation_result,"UA_PHX",&PHX_UA);
	fprintf(stderr,"HX UA value design point = %lf [MW/K]\n",PHX_UA);

	double m_dot_CO2_des;
	ssc_data_get_number(simulation_result,"m_dot_co2_full",&m_dot_CO2_des);
	fprintf(stderr,"Mass flow rate of CO2 at design point = %lf [kg/s]\n",m_dot_CO2_des);

	double m_dot_HTF_des;
	ssc_data_get_number(simulation_result,"m_dot_htf_des",&m_dot_HTF_des);
	fprintf(stderr,"Mass flow rate of HTF at design point = %lf [kg/s]\n",m_dot_HTF_des);

	double Q_dot_PHX_des;
	ssc_data_get_number(simulation_result,"q_dot_PHX",&Q_dot_PHX_des);
	fprintf(stderr,"PHX heat transfer at design point: %lf MWth\n",Q_dot_PHX_des);

	double W_dot_cooler_des;
	ssc_data_get_number(simulation_result,"cooler_tot_W_dot_fan",&W_dot_cooler_des);
	fprintf(stderr,"Cooler fan power at design point: %lf MW\n",W_dot_cooler_des);

	double eta_gross_pure = (P_net)/(Q_dot_PHX_des*1e6);
	fprintf(stderr,"PB cycle thermal efficiency (before cooling fan) = %lf \n",eta_gross_pure);

	double eta_gross_base = (P_net-(W_dot_cooler_des*1e6))/(Q_dot_PHX_des*1e6);
	fprintf(stderr,"PB cycle thermal efficiency (cooler fan has been included) = %lf \n",eta_gross_base);

	/*Assigning values*/
	res[0] = HTR_UA * 1e6;           /*Converting from MW/K to W/K*/
	res[1] = LTR_UA * 1e6;           /*Converting from MW/K to W/K*/
	res[2] = W_turb_des *1e6;        /*Converting from MW to W*/
	res[3] = W_maincomp_des * 1e6;
	res[4] = W_recomp_des * 1e6;     /*Converting from MW to W*/
	res[5] = Cooler_UA * 1e6;        /*Converting from MW/K to W/K*/
	res[6] = PHX_UA  * 1e6;          /*Converting from MW/K to W/K*/
	res[7] = m_dot_CO2_des;
	res[8] = m_dot_HTF_des;
	res[9] = Q_dot_PHX_des * 1e6;    /*Heat exchanger thermal power rate [W]*/

	res[10] = eta_gross_base;
	res[11] = 1;                     /*ratio of Q_PHX / Q_PHX at design point will always be 1
			                           since there's no deviation from the on design 
			                           in the operating condition*/
	res[12] = dT_PHX_hot_approach;   /*Approach temperature*/

	ssc_data_free(simulation_result);
	fprintf(stderr,"====================== Done initialising NREL PB ====================\n");

	return;
}

//******************** SEQUENCE 2
/*
After all the values within res* from SEQ.1 grabbed by SolarTherm, the on-design result is passed to either constructKriging (SEQUENCE 2.1) or constructANN (SEQUENCE 2.2). These sequences are responsible to check the availability of the surrogate model, load it if it is available or train a new surrogate.
*/

//******************** SEQUENCE 2.1
/*
Function constructKriging is the constructor function which returns a pointer to an object called Kriging_variables (type Kriging_struct) which contains all the information of the surrogate model e.g. the inverse matrix, variogram matrix, existing data for interpolation purpose. The inverse of the matrices are pre-calculated during the construction process to reduce the runtime.

@params:
	P_net					: type double, net power of the power block in W at design point
	T_in_ref_blk			: type double, inlet HTF temp. to the primary heat exchanger (PHX) in K at design point
	p_high					: type double, outlet pressure of main compressor in Pa at design point
	load_base				: type double, full load design (default is always 1 since we design a PB to operate at full load)
	eta_gross_base			: type double, cycle efficiency after cooling fan at design point
	eta_Q_base				: type double, effectiveness of PHX at design point
	base_path				: type string, path to where this C- code is located
	SolarTherm_path			: type string, path to SolarTherm library
	inputsize				: type int, input dimension of the surrogate model
	outpusize				: type int, output dimension of the surrogate model
	tolerance				: type double, termination criteria of surrogate training
	PB_model				: type int, 0 for CEA PB, 1 for SSC
	
	CEA PB params:
		PR					: type double, pressure ratio between compressor and turbine outlet at design point
		pinch_PHX			: type double, pinch point of PHX in K (HTF temperature outlet from PHX - sCO2 inlet temperature to PHX) at design point
		dTemp_HTF_PHX		: type double, temperature difference between outlet and inlet flow to PHX of the HTF in K at design point

	SSC PB params:
		htf_choice			: type int, 50 for user choice, 1 for solar salt
		dT_PHX_hot_approach	: type double, design point temperature difference between sCO2 PB going into the turbine and HTF going into the PHX
		dT_PHX_cold_apprahch: type double, design point temperature difference between sCO2 PB going into the PHX and HTF going from the PHX
		eta_isen_mc			: type double, main compressor isentropic efficiency at design point
		eta_isen_rc			: type double, re-compressor isentropic efficiency at design point
		eta_isen_t			: type double, turbine isentropic efficiency at design point
		dT_mc_approach		: type double, design point temperature difference between ambient temperature and desired outlet temperature of CO2 after the mian cooler in K
		HTF_name			: type string, HTF name, shall HTF_choice == 50 (user choice), the code will look into the data base whether the requested HTF properies exist based on HTF_name. If does not exist, it will stop the simulation
*/

void* constructKriging(double P_net, double T_in_ref_blk, double p_high, double PR, 
		double pinch_PHX, double dTemp_HTF_PHX, double load_base,  double T_amb_base, 
		double eta_gross_base, double eta_Q_base, char* base_path,  char* SolarTherm_path,
		int inputsize, int outputsize, double tolerance, int PB_model, 
		int htf_choice, double dT_PHX_hot_approach,  double dT_PHX_cold_approach,
		double eta_isen_mc, double eta_isen_rc, double eta_isen_t,double dT_mc_approach, 
		char* HTF_name
){
	fprintf(stderr,"User surrogate choice: Kriging..........................................\n");

	Kriging_struct* Kriging_variables;

	char line[limitSize];

	int* index_and_status = NEW_ARRAY(int,2); 

	/*Check the configurations database whether the requested configuration exists or not in the database*/
	checkConfig(
		P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX,index_and_status, base_path, PB_model,
		dT_PHX_hot_approach, dT_PHX_cold_approach, eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach, T_amb_base
		);

	int match_index = index_and_status[0];
	int status_config = index_and_status[1];

	char* traindir_base = "/training_data/";
	char* config_base;

	if(PB_model==0){ /*CEA PB*/
		config_base = "config";
	}else if(PB_model==1){
		config_base = "configNREL";
	}else{
		fprintf(stderr,"PB model choice is invalid. Choose 0 for CEA PB, 1 for NREL-SAM PB. Your choice is %d\n",PB_model);
		exit(EXIT_FAILURE);
	}

	if(status_config == 1){
		/*Generate new config txt*/
		/*Construct Kriging including validation*/
		Kriging_variables = buildKriging(
		    P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, 
		    T_amb_base, eta_gross_base, eta_Q_base, base_path, SolarTherm_path, match_index,traindir_base, config_base, status_config,
		    inputsize, outputsize, tolerance, PB_model, 
		    htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
		    HTF_name
		    );
	}else{ 
		/*If a configuration exists in the data bank*/
		char* name_training = "/scaled_Kriging_training_data_deviation.csv";
		char* trainingdir = build_trainingdir_path(base_path,traindir_base,config_base,match_index); //e.g. base_path/training_data/config0
		char* filepathtraining  = concat_training_dir(trainingdir,name_training); //e.g. base_path/training_data/config0/scaled_Kriging_training_data_deviation.csv

		FILE* check_path = fopen(filepathtraining,"r");
		
		if(check_path == NULL){ //********* if filepath training doesn't exist
			fprintf(stderr,"Configuration exists, but training data for Kriging doesn't\n");
			/*Construct Kriging including validation*/
			Kriging_variables = buildKriging(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, 
				T_amb_base, eta_gross_base, eta_Q_base, base_path, SolarTherm_path, match_index,traindir_base, config_base, 
				status_config, inputsize , outputsize, tolerance, PB_model,
				htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
				HTF_name
			);
		}else{
			fprintf(stderr,"Training data exists. Start constructing Kriging..............\n");
			            
			char* name_prediction_validation_dump = "/validation_prediction.csv";
			char* name_R_squared = "/R_Squared.txt";
			char* name_validation = "/validation_data.csv";
			char* name_min = "/min.txt";
			char* name_max = "/max.txt";
			char* name_krig_param_eta_PB = "/Kriging_Param_eta_PB.txt";
			char* name_krig_param_eta_Q = "/Kriging_Param_eta_Q.txt";

			//Start building file name
			char* filepathpredictionvalidation = concat_training_dir(trainingdir,name_prediction_validation_dump);
			char* filepathRsquared = concat_training_dir(trainingdir,name_R_squared);
			char* filepathvalidation = concat_training_dir(trainingdir,name_validation);
			char* filepathmin = concat_training_dir(trainingdir,name_min);
			char* filepathmax = concat_training_dir(trainingdir,name_max);
			char* filepath_kriging_param_eta_PB = concat_training_dir(trainingdir,name_krig_param_eta_PB);
			char* filepath_kriging_param_eta_Q = concat_training_dir(trainingdir,name_krig_param_eta_Q);
			/*End building the file name*/

			/*Reading Kriging Parameters*/
			//***********************PB
			FILE* fnkrigparam = fopen(filepath_kriging_param_eta_PB,"r");
			if(fnkrigparam==NULL)
			{
			    fprintf(stderr,"File path Kriging Param for PB doesn't exist! Check your path %s\n",filepath_kriging_param_eta_PB);
			}
			double* krig_param_PB = NEW_ARRAY(double,3);
			fgets(line,limitSize,fnkrigparam);
			sscanf(line,"%lf,%lf,%lf",&krig_param_PB[0],&krig_param_PB[1],&krig_param_PB[2]);
			fclose(fnkrigparam);

			double sill_PB = krig_param_PB[0];
			double Nugget_PB = krig_param_PB[1];
			//double Spherical_PB = 1-Nugget_PB;
			double Range_PB = krig_param_PB[2];

			//***********************HX
			fnkrigparam = fopen(filepath_kriging_param_eta_Q,"r");
			if(fnkrigparam==NULL){
			    printf("File path Kriging Param for HX doesn't exist! Check your path %s\n",filepath_kriging_param_eta_Q);
			}
			double* krig_param_HX = NEW_ARRAY(double,3);
			fgets(line,limitSize,fnkrigparam);
			sscanf(line,"%lf,%lf,%lf",&krig_param_HX[0],&krig_param_HX[1],&krig_param_HX[2]);
			fclose(fnkrigparam);

			double sill_HX = krig_param_HX[0];
			double Nugget_HX = krig_param_HX[1];
			//double Spherical_HX = 1-Nugget_HX;
			double Range_HX = krig_param_HX[2];

			//*************************** input and outputsize
			int inputsize = 3;
			int outputsize = 2;

			//************************** Scaler
			FILE *fnmax = fopen(filepathmax,"r"); //instantiate pointer to the filepathmax
			if(fnmax==NULL)
			{
			    fprintf(stderr,"File path max data doesn't exist! Check your path %s\n",filepathmax);
			}

			double* UB = NEW_ARRAY(double,5);
			size_t i = 0;
			fgets(line,limitSize,fnmax); //get the first line of fnmax, and store it in variable line
			while(!feof(fnmax)){
			    sscanf(line,"%lf",&UB[i]);
			    i++;
			    fgets(line,limitSize,fnmax); //get the next line
			}

			fclose(fnmax);


			FILE *fnmin = fopen(filepathmin,"r"); //instantiate pointer to the filepathmin

			if(fnmin==NULL){
			    fprintf(stderr,"File path min data doesn't exist! Check your path %s\n",filepathmin);
			}

			double* LB = NEW_ARRAY(double,5);
			i = 0;
			fgets(line,limitSize,fnmin);
			while(!feof(fnmin)){
			    sscanf(line,"%lf",&LB[i]);
			    i++;
			    fgets(line,limitSize,fnmin);
			}
			
			fclose(fnmin);
			
			double deviation_load_max = UB[0];    
			double deviation_T_in_max = UB[1];    
			double deviation_T_amb_max = UB[2];   
			double deviation_eta_gross_max = UB[3];   
			double deviation_eta_Q_max = UB[4];   
			
			double deviation_load_min = LB[0];    
			double deviation_T_in_min = LB[1];   
			double deviation_T_amb_min = LB[2];   
			double deviation_eta_gross_min = LB[3];
			double deviation_eta_Q_min = LB[4];
			/*End scaler*/

			Kriging_variables = load_KrigingVariables(filepathtraining, inputsize, outputsize, Nugget_PB, 
			    Nugget_HX, sill_PB, sill_HX, Range_PB, Range_HX,
			    load_base, T_in_ref_blk, T_amb_base,  deviation_load_max,deviation_T_in_max, deviation_T_amb_max ,
			    deviation_eta_gross_max, deviation_eta_Q_max, deviation_load_min, deviation_T_in_min,  
			    deviation_T_amb_min, deviation_eta_gross_min,  deviation_eta_Q_min, "spherical"
			);

			fprintf(stderr,"Done constructing Kriging..............\n");

			free(filepathpredictionvalidation);
			free(filepathRsquared);
			free(filepathvalidation);
			free(filepathmin);
			free(filepathmax);
			free(filepath_kriging_param_eta_PB);
			free(filepath_kriging_param_eta_Q);
		}
		free(filepathtraining);
	}

	free(index_and_status);

	Kriging_variables->count = 0;
	return (void*)Kriging_variables;
}

//******************** SEQUENCE 2.2
/*
Function constructKriging is the constructor function which returns a pointer to an object called Kriging_variables (type Kriging_struct) which contains all the information of the surrogate model e.g. the inverse matrix, variogram matrix, existing data for interpolation purpose. The inverse of the matrices are pre-calculated during the construction process to reduce the runtime.

@params:
	P_net					: type double, net power of the power block in W at design point
	T_in_ref_blk			: type double, inlet HTF temp. to the primary heat exchanger (PHX) in K at design point
	p_high					: type double, outlet pressure of main compressor in Pa at design point
	load_base				: type double, full load design (default is always 1 since we design a PB to operate at full load)
	eta_gross_base			: type double, cycle efficiency after cooling fan at design point
	eta_Q_base				: type double, effectiveness of PHX at design point
	base_path				: type string, path to where this C- code is located
	SolarTherm_path			: type string, path to SolarTherm library
	inputsize				: type int, input dimension of the surrogate model
	outpusize				: type int, output dimension of the surrogate model
	tolerance				: type double, termination criteria of surrogate training
	PB_model				: type int, 0 for CEA PB, 1 for SSC
	which_ANN_model			: type int, 0 for surrogate model to predict deviation in cycle efficiency, 1 for surrogate model to predict deviation in HX effectiveness

	CEA PB params:
		PR					: type double, pressure ratio between compressor and turbine outlet at design point
		pinch_PHX			: type double, pinch point of PHX in K (HTF temperature outlet from PHX - sCO2 inlet temperature to PHX) at design point
		dTemp_HTF_PHX		: type double, temperature difference between outlet and inlet flow to PHX of the HTF in K at design point

	SSC PB params:
		htf_choice			: type int, 50 for user choice, 1 for solar salt
		dT_PHX_hot_approach	: type double, design point temperature difference between sCO2 PB going into the turbine and HTF going into the PHX
		dT_PHX_cold_apprahch: type double, design point temperature difference between sCO2 PB going into the PHX and HTF going from the PHX
		eta_isen_mc			: type double, main compressor isentropic efficiency at design point
		eta_isen_rc			: type double, re-compressor isentropic efficiency at design point
		eta_isen_t			: type double, turbine isentropic efficiency at design point
		dT_mc_approach		: type double, design point temperature difference between ambient temperature and desired outlet temperature of CO2 after the mian cooler in K
		HTF_name			: type string, HTF name, shall HTF_choice == 50 (user choice), the code will look into the data base whether the requested HTF properies exist based on HTF_name. If does not exist, it will stop the simulation
*/
void* constructANN(double P_net, double T_in_ref_blk, double p_high, double PR, 
		double pinch_PHX, double dTemp_HTF_PHX, double load_base, double T_amb_base, 
		double eta_gross_base, double eta_Q_base, int which_ANN_model, char* base_path, char* SolarTherm_path, 
		int inputsize, int outputsize, double tolerance, int PB_model,
		int htf_choice, double dT_PHX_hot_approach,  double dT_PHX_cold_approach,
		double eta_isen_mc, double eta_isen_rc, double eta_isen_t,double dT_mc_approach,
		char* HTF_name
){
	fprintf(stderr,"User surrogate choice: ANN..........................................\n");
	char line[limitSize];
	Session_Props* sess;

	int* index_and_status = NEW_ARRAY(int,2); 

	/*Check the configurations database whether the requested configuration exists or not in the database*/
	checkConfig(
		P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX,index_and_status, base_path, PB_model,
		dT_PHX_hot_approach, dT_PHX_cold_approach, eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
		T_amb_base
		);

	int match_index = index_and_status[0];
	int status_config = index_and_status[1];

	char* traindir_base = "/training_data/";
	char* config_base;
	if(PB_model==0)/*CEA PB*/
	{
		config_base = "config";
	}
	else if(PB_model==1)
	{   
		config_base = "configNREL";
	}
	else
	{
		fprintf(stderr,"PB model choice is invalid. Choose 0 for CEA PB, 1 for NREL-SAM PB. Your choice is %d\n",PB_model);
		exit(EXIT_FAILURE);
	}

	if(status_config == 1) /*Generate new config txt since no config found in the database*/
	{

		fprintf(stderr,"Configuration doesn't exist, generating the training data and surrogate model!\n");
		int gen_data = 1;

		/*Building path to ANN PB and ANN HX*/
		char* ANN_PB_model_name = "/surrogate_model_0";
		char* ANN_HX_model_name = "/surrogate_model_1";

		char* trainingdir = build_trainingdir_path(base_path,traindir_base,config_base,match_index);
		char* ANN_PB_path = concat_training_dir(trainingdir,ANN_PB_model_name);
		char* ANN_HX_path = concat_training_dir(trainingdir,ANN_HX_model_name);

		fprintf(stderr,"%s\n",ANN_PB_path);
		fprintf(stderr,"%s\n",ANN_HX_path);

		/*Construct ANN including validation*/
		if(which_ANN_model==0){ //***************** Load ANN PB model
			sess = buildANN(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, 
					dTemp_HTF_PHX, load_base, T_amb_base, eta_gross_base, 
					base_path, SolarTherm_path, match_index, traindir_base, config_base, 
					ANN_PB_path, which_ANN_model,gen_data, status_config, inputsize, outputsize, tolerance, PB_model,
					htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
					HTF_name
			);
			
			fprintf(stderr,"Training and Validation of ANN eta PB: Done!\n");   
		}else if(which_ANN_model==1){ //***************** Load ANN HX model
			sess = buildANN(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, 
					dTemp_HTF_PHX, load_base, T_amb_base, eta_Q_base, 
					base_path, SolarTherm_path, match_index, traindir_base, config_base, 
					ANN_HX_path, which_ANN_model,gen_data, status_config, inputsize, outputsize, tolerance, PB_model,
					htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
					HTF_name
			);
			
			fprintf(stderr,"Training and Validation of ANN eta HX: Done!\n");
		}else{
			fprintf(stderr,"ANN model choice is invalid. Your choice = %d. Available choice is 0 for loading ANN PB, 2 for ANN HX\n",which_ANN_model);
			exit(EXIT_FAILURE);
		}
		free(ANN_PB_path);
		free(ANN_HX_path);
		free(trainingdir);
	}else{ /*If a configuration exists in the data bank*/
		/*Building filepath to ANN PB and ANN HX and filepathtrianing*/
		char* name_training = "/deviation_eta_Q.csv";
		char* ANN_PB_model_name = "/surrogate_model_0";
		char* ANN_HX_model_name = "/surrogate_model_1"; 

		char* trainingdir = build_trainingdir_path(base_path,traindir_base,config_base,match_index);
		char* filepathtraining = concat_training_dir(trainingdir,name_training);
		char* ANN_PB_path = concat_training_dir(trainingdir,ANN_PB_model_name);
		char* ANN_HX_path = concat_training_dir(trainingdir,ANN_HX_model_name);
		
		/*End the filepath building*/

		FILE* check_path = fopen(filepathtraining,"r");
		fprintf(stderr,"%s\n",filepathtraining);
		
		if(check_path == NULL){ //********* if filepath training doesn't exist
			fprintf(stderr,"Training data doesn't exist even though configuration exists.......Start gathering data.............\n");
			clock_t begin = clock();

			int initialnumdata = 150;

			if(PB_model==0){
				//*********** Run CEA Model
				generateTrainingData(P_net, T_in_ref_blk, p_high, PR, pinch_PHX,
					dTemp_HTF_PHX, match_index, initialnumdata, base_path, status_config, SolarTherm_path
				);
			}else if(PB_model==1){
				//*********** Run SSC Model
				/*ssc_data_t NRELPBSimulationResult = */
				runNRELPB(
					initialnumdata, P_net, T_in_ref_blk, p_high,
					T_amb_base, dT_PHX_hot_approach, dT_PHX_cold_approach, 
					eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
					HTF_name, htf_choice, trainingdir,SolarTherm_path, base_path, status_config, match_index,
					1, /*OD simulated*/
					0 /*Test function false*/
				);
			}else{
				fprintf(stderr,"PB model choice is invalid. Choose 0 for CEA PB, 1 for NREL-SAM PB. Your choice is %d\n",PB_model);
				exit(EXIT_FAILURE);
			}
		
			clock_t end = clock();
			double time_spent = (double)(end-begin) / CLOCKS_PER_SEC;
			
			fprintf(stderr, "It took %lf seconds to generate %d data points\n",time_spent,initialnumdata);
		}else{
			fprintf(stderr,"Training data exists. Start constructing ANN..............\n");
		}

		//************* Need not to generate another data points otherwise specified in build ANN func, (tolerance not stasified)
		int gen_data = 0; 
		
		DIR* check_dir;
		
		if(which_ANN_model == 0){ //***************** Load ANN PB model
			if ((check_dir = opendir(ANN_PB_path)) == NULL){
				fprintf(stderr,"No ANN model for PB exists: Building the ANN!\n");

				sess = buildANN(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, 
					dTemp_HTF_PHX, load_base, T_amb_base, eta_gross_base, 
					base_path, SolarTherm_path, match_index, traindir_base, config_base, 
					ANN_PB_path, which_ANN_model, gen_data, status_config, inputsize, outputsize, tolerance, PB_model,
					htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
					HTF_name
				);
				fprintf(stderr,"Training and Validation of ANN eta PB: Done!\n");
				
			}else{
				fprintf(stderr,"ANN model for PB exists\n");
				closedir(check_dir);
				fprintf(stderr,"loading ANN PB model = %s\n",ANN_PB_path);

				char* name_min = "/min.txt";
				char* name_max = "/max.txt";

				/*Build the file name for min, max -> ANN scaler*/           
				char* filepathmin = concat_training_dir(trainingdir,name_min);
				char* filepathmax = concat_training_dir(trainingdir,name_max);
				/*End building the file name*/

				//*************Reading scaler
				FILE *fnmax = fopen(filepathmax,"r"); //instantiate pointer to the filepathmax
				if(fnmax==NULL){
				    fprintf(stderr,"File path max data doesn't exist! Check your path %s\n",filepathmax);
				}

				double* UB = NEW_ARRAY(double,inputsize+outputsize);
				size_t i = 0;
				fgets(line,limitSize,fnmax); //get the first line of fnmax, and store it in variable line
				while(!feof(fnmax)){
				    sscanf(line,"%lf",&UB[i]);
				    i++;
				    fgets(line,limitSize,fnmax); //get the next line
				}

				fclose(fnmax);

				FILE *fnmin = fopen(filepathmin,"r"); //instantiate pointer to the filepathmin

				if(fnmin==NULL){
				    fprintf(stderr,"File path min data doesn't exist! Check your path %s\n",filepathmin);
				}

				double* LB = NEW_ARRAY(double,inputsize+outputsize);
				i = 0;
				fgets(line,limitSize,fnmin);
				while(!feof(fnmin)){
				    sscanf(line,"%lf",&LB[i]);
				    i++;
				    fgets(line,limitSize,fnmin);
				}
				
				fclose(fnmin);

				/*Load ANN session!*/
				double* X_max = NEW_ARRAY(double,inputsize);
				double* X_min = NEW_ARRAY(double,inputsize);
				double* y_max = NEW_ARRAY(double,outputsize);
				double* y_min = NEW_ARRAY(double,outputsize);

				for(int i=0;i<inputsize;i++){
				    X_max[i] = UB[i];
				    X_min[i] = LB[i];
				}
				
				for(int i=0;i<outputsize;i++){
				    y_max[i] = UB[i+inputsize];
				    y_min[i] = LB[i+inputsize];
				}

				sess = load_session(ANN_PB_path,X_max,X_min,y_max,y_min,inputsize,outputsize, load_base,T_in_ref_blk,T_amb_base); 

				free(UB);
				free(LB);
			}
		}else if(which_ANN_model==1){ 
			// Load ANN HX model
			if ((check_dir = opendir(ANN_HX_path)) == NULL){   
				fprintf(stderr,"No ANN model for HX exists: Building the ANN!\n");
				
				sess = buildANN(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, 
					dTemp_HTF_PHX, load_base, T_amb_base, eta_Q_base, 
					base_path, SolarTherm_path, match_index, traindir_base, config_base, 
					ANN_HX_path, which_ANN_model, gen_data, status_config, inputsize, outputsize, tolerance, PB_model,
					htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
					HTF_name
					);
				fprintf(stderr,"Training and Validation of ANN eta HX: Done!\n");
			}
			else 
			{
				fprintf(stderr,"ANN model for HX exists\n");
				closedir(check_dir);
				fprintf(stderr,"loading ANN HX model = %s\n",ANN_HX_path);

				char* name_min = "/min.txt";
				char* name_max = "/max.txt";

				/*Build the file name for min, max -> ANN scaler*/           
				char* filepathmin = concat_training_dir(trainingdir,name_min);
				char* filepathmax = concat_training_dir(trainingdir,name_max);
				/*End building the file name*/

				//*************Reading scaler
				FILE *fnmax = fopen(filepathmax,"r"); //instantiate pointer to the filepathmax
				if(fnmax==NULL){
				    fprintf(stderr,"File path max data doesn't exist! Check your path %s\n",filepathmax);
				}

				double* UB = NEW_ARRAY(double,inputsize+outputsize);
				size_t i = 0;
				fgets(line,limitSize,fnmax); //get the first line of fnmax, and store it in variable line
				while(!feof(fnmax)){
				    sscanf(line,"%lf",&UB[i]);
				    i++;
				    fgets(line,limitSize,fnmax); //get the next line
				}

				fclose(fnmax);

				FILE *fnmin = fopen(filepathmin,"r"); //instantiate pointer to the filepathmin

				if(fnmin==NULL){
				    fprintf(stderr,"File path min data doesn't exist! Check your path %s\n",filepathmin);
				}

				double* LB = NEW_ARRAY(double,inputsize+outputsize);
				i = 0;
				fgets(line,limitSize,fnmin);
				while(!feof(fnmin)){
				    sscanf(line,"%lf",&LB[i]);
				    i++;
				    fgets(line,limitSize,fnmin);
				}
				
				fclose(fnmin);

				/*Load ANN session!*/
				double* X_max = NEW_ARRAY(double,inputsize);
				double* X_min = NEW_ARRAY(double,inputsize);
				double* y_max = NEW_ARRAY(double,outputsize);
				double* y_min = NEW_ARRAY(double,outputsize);

				for(int i=0;i<inputsize;i++){
				    X_max[i] = UB[i];
				    X_min[i] = LB[i];
				}
				
				for(int i=0;i<outputsize;i++){
				    y_max[i] = UB[i+inputsize];
				    y_min[i] = LB[i+inputsize];
				}

				sess = load_session(ANN_HX_path,X_max,X_min,y_max,y_min,inputsize,outputsize, load_base,T_in_ref_blk,T_amb_base); 


				free(UB);
				free(LB);
			}
		}else{
			fprintf(stderr,"ANN model choice is invalid. Your choice = %d. "
				"Available choice is 0 for loading ANN PB, 2 for ANN HX\n",which_ANN_model);
			exit(EXIT_FAILURE);
		}

		free(ANN_HX_path);
		free(ANN_PB_path);
		free(filepathtraining);
		free(trainingdir);
	}

	free(index_and_status);

	sess->count=0;

	return (void *)sess;
}




/* 
	destructor for ANN session
*/
void destructANN(void *sess0){
	assert(sess0);
	Session_Props* sess = (Session_Props *)sess0;

	fprintf(stderr,"ANN is called %d times to predict 1 eta during the simulation\n",sess->count);

	TF_DeleteSession(sess->Session,sess->Status);
	TF_DeleteGraph(sess->Graph);
	TF_DeleteStatus(sess->Status);
	TF_DeleteSessionOptions(sess->SessionOpts);
	TF_DeleteBuffer(sess->RunOpts);

	free(sess->X_max);
	free(sess->X_min);
	free(sess->y_max);
	free(sess->y_min);

	free(sess);
}

/* 
	destructor for Kriging
*/
void destructKriging(void *krigingdata){
	assert(krigingdata);
	Kriging_struct* Kriging_variables = (Kriging_struct *)krigingdata;

	fprintf(stderr,"Kriging is called %d times to predict 1 eta during the simulation\n",Kriging_variables->count/2);

	for(int i=0; i<Kriging_variables->rows;i++){
		free(Kriging_variables->trainingData[i]);
	}

	gsl_matrix_free(Kriging_variables->DISTANCE);
	gsl_matrix_free(Kriging_variables->VARIOGRAM_HX);
	gsl_matrix_free(Kriging_variables->COVARIANCE_HX);
	gsl_matrix_free(Kriging_variables->INVERSE_HX);
	gsl_matrix_free(Kriging_variables->VARIOGRAM_PB);
	gsl_matrix_free(Kriging_variables->COVARIANCE_PB);
	gsl_matrix_free(Kriging_variables->INVERSE_PB);


	free(Kriging_variables);
}

/*
// WORK IN PROGRESS...

void* constructOnTheFlyReceiver(double H_drop, double T_HTF_in_des, double T_HTF_out_des, char* base_path)
{
    char line[limitSize];
   
    int* index_and_status = NEW_ARRAY(int,2);

    checkConfigReceiver(H_drop,T_HTF_in_des,T_HTF_out_des,base_path, index_and_status);

    int match_index = index_and_status[0];
    int status_config = index_and_status[1];

    if(match_index==-1000) 
    {

    }


}*/

// vim: ts=4:sw=4:noet
