#include "sscpb.h"
#include "util.h"
#include "assert.h"

#include <Python.h>

//#define SSCPB_DEBUG
#ifdef SSCPB_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif
#define ERR(FMT,...) fprintf(stderr,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)

/*=================================== STARTING FROM HERE IS FUNCTIONS TO CALL POWER BLOCK MODEL ==============================*/
/*
	This function is to create off design input array for CEA PB to simulate shall new surrogate model is needed
	char* training_or_validation controls the sampling process
*/
void generateOffDesignFile(double T_in_ref_blk, double load_des, double T_amb_des
		,char* trainingdir, char* SolarTherm_path, int numinputs, int numdata
		,char* training_or_validation
){
	double UB_1 = T_in_ref_blk + 20; //*************** Maximum temperature of the HTF at off design case [C]
	double UB_2 = 1.5; //******************** maximum load
	double UB_3 = 50; //******************* maximum ambient temperature [C]

	double LB_1 = T_in_ref_blk - 50; //*************** Minimum temperature of the HTF at off design case [C]
	double LB_2 = 0.45; //******************** minimum part load
	double LB_3 = -20; //******************* minimum ambient temperature [C]

	char* cmd = NEW_ARRAY(char,MAXLEN);
	snprintf(
		cmd,
		MAXLEN, 
		"python %s/Resources/Library/gen_OD_matrix.py --UB1 %lf --UB2 %lf --UB3 %lf --LB1 %lf --LB2 %lf --LB3 %lf --T_HTF_des %lf --load_des %lf --T_amb_des %lf --numinputs %d --numdata %d --trainingdir %s --type %s",
		SolarTherm_path, UB_1, UB_2, UB_3, LB_1, LB_2, LB_3,T_in_ref_blk, load_des, T_amb_des, numinputs, numdata, trainingdir, training_or_validation
	);

	//Try system call instead of subprocess --> problems with Python C API for Python 3
	system(cmd);
	free(cmd);
	
	/*
	PyObject *pName, *pModule, *pFunc;
	PyObject *pArgs, *inputs;

	//char* ppath = base_path;
	char* ppath = NEW_ARRAY(char, MAXLEN);
	snprintf(ppath,MAXLEN,"%s/Resources/Library",SolarTherm_path);

	char* pname = "gen_OD_matrix"; //gen_OD_matrix.py
	char* pfunc;
	if(strcmp(training_or_validation,"training")==0){
		pfunc = "generate_matrix_factorial"; //training data matrix is full factorial
	}else if(strcmp(training_or_validation,"validation")==0){
		pfunc = "generate_matrix_validation"; //validation data matrix is full factorial
	}else if(strcmp(training_or_validation,"LHS")==0){
		pfunc = "generate_matrix"; //doesn't care which data it is, go with LHS
	}else{
		ERR("Function is invalid. Choose either validation or training. Your choice: %s",training_or_validation);
		exit(EXIT_FAILURE);
	}

	Py_Initialize(); 

	//Obtain the python path, append it with the ppath
	PyObject *sys_path = PySys_GetObject("path");
	PyList_Append(sys_path, PyUnicode_FromString((char *) ppath));

	//Convert the pname into Python String
	pName = PyUnicode_FromString(pname);

	//Import the script into C environment using PyImport_Import
	pModule = PyImport_Import(pName);
	Py_DECREF(pName);

	if (pModule != NULL){
		
		pFunc = PyObject_GetAttrString(pModule, pfunc);

		pArgs = PyTuple_New(1);

		if (pFunc && PyCallable_Check(pFunc)){
		    inputs = PyDict_New();

		    PyDict_SetItemString(inputs, "UB_1", PyFloat_FromDouble(UB_1));
		    PyDict_SetItemString(inputs, "UB_2", PyFloat_FromDouble(UB_2));
		    PyDict_SetItemString(inputs, "UB_3", PyFloat_FromDouble(UB_3));

		    PyDict_SetItemString(inputs, "LB_1", PyFloat_FromDouble(LB_1));
		    PyDict_SetItemString(inputs, "LB_2", PyFloat_FromDouble(LB_2));
		    PyDict_SetItemString(inputs, "LB_3", PyFloat_FromDouble(LB_3));

		    PyDict_SetItemString(inputs, "T_HTF_des", PyFloat_FromDouble(T_in_ref_blk));
		    PyDict_SetItemString(inputs, "load_des", PyFloat_FromDouble(load_des));
		    PyDict_SetItemString(inputs, "T_amb_des", PyFloat_FromDouble(T_amb_des));
		    
		    PyDict_SetItemString(inputs, "num_inputs", PyLong_FromLong(numinputs));
		    PyDict_SetItemString(inputs, "numdata", PyLong_FromLong(numdata));

		    PyDict_SetItemString(inputs, "trainingdir", PyUnicode_FromString((char *)trainingdir));
		    
		    PyTuple_SetItem(pArgs, 0, inputs);


		    PyObject_CallObject(pFunc, pArgs);

		    Py_DECREF(inputs);
		    Py_DECREF(pArgs);
		}else{
		    if (PyErr_Occurred()){
		        PyErr_Print();
		    }else{
		        ERR("Cannot find function \"%s\"", pfunc);
		    }
		}
		Py_XDECREF(pFunc);
		Py_DECREF(pModule);
	}else{
		PyErr_Print();
		ERR("Failed to load \"%s\"", pname);
	}
	*/
}

/*
	Load properties array from text file `fn_props` and store in sim_struct `sim`.
*/
void loadPropsArray(char* fn_props, sim_struct* sim){
	char line[limitSize];

	FILE* fn = fopen(fn_props,"r");

	if(fn==NULL){
		ERR("File doesn't exist. File path: %s",fn_props);
		exit(EXIT_FAILURE);
	}

	//************ Skip the 1st line of the CSV
	fgets(line,limitSize,fn); //************> Skip the 1st line

	//************ First get number of rows
	int rows = 0;
	fgets(line,limitSize,fn); //************> Start from the second line
	while(!feof(fn)){
		rows++;
		fgets(line,limitSize,fn); 
	}
	fclose(fn);

	sim->rows_props = rows;

	//************* Allocating memory space for array_props array
	sim->array_props = NEW_ARRAY(ssc_number_t,sim->rows_props*7);

	//************* Start reading the file and put the data into a flatten array
	fn = fopen(fn_props,"r");
	fgets(line,limitSize,fn); //************> Skip the 1st line

	fgets(line,limitSize,fn); //************> Start from the second line
	size_t i = 0;
	while(!feof(fn)){
		sscanf(
		    line,"%lf,%lf,%lf,%lf,%lf,%lf,%lf",
		    &sim->array_props[i],
		    &sim->array_props[i+1], 
		    &sim->array_props[i+2], 
		    &sim->array_props[i+3], 
		    &sim->array_props[i+4],
		    &sim->array_props[i+5],
		    &sim->array_props[i+6]
		);
		i = i + 7;
		fgets(line,limitSize,fn);
	}
	fclose(fn);
}

/*
	Read an off-design from a text file named `fn_OD`, and
	store the results in a provided sim_struct `sim`.
*/
void loadOffDesignArray(char* fn_OD, sim_struct* sim){
	char line[limitSize];

	FILE* fn = fopen(fn_OD,"r");

	if(fn==NULL){
		ERR("File doesn't exist. File path: %s",fn_OD);
		exit(EXIT_FAILURE);
	}

	//************ First get number of rows
	int rows = 0;
	fgets(line,limitSize,fn);
	while(!feof(fn)){
		rows++;
		fgets(line,limitSize,fn); 
	}
	fclose(fn);

	sim->rows_OD = rows;

	//************* Allocating memory space for array_props array
	sim->array_OD = NEW_ARRAY(ssc_number_t,sim->rows_OD * 6);

	//************* Start reading the file and put the data into a flatten array
	fn = fopen(fn_OD,"r");
	fgets(line,limitSize,fn); 
	size_t i = 0;
	while(!feof(fn)){
		sscanf(
		    line,"%lf,%lf,%lf,",
		    &sim->array_OD[i],
		    &sim->array_OD[i+1], 
		    &sim->array_OD[i+2]
		);
		sim->array_OD[i+3] = 1;
		sim->array_OD[i+4] = 1;
		sim->array_OD[i+5] = 1;
		i = i + 6;
		fgets(line,limitSize,fn);
	}
	fclose(fn);

	/*
	for(size_t i=0;i<sim->rows_OD*6;i++)
	{
		printf("%lf\n",sim->array_OD[i]);
	}
	*/

	return;
}

/*
	The MAIN FUNCTION to run SSC sCO2 PB module
*/
ssc_data_t runNRELPB(int numdata,double P_net, double T_in_ref_blk, double p_high
		,double T_amb_base, double dT_PHX_hot_approach, double dT_PHX_cold_approach
		,double eta_isen_mc, double eta_isen_rc, double eta_isen_t
		,double dT_mc_approach, char* HTF_name, int HTF_choice, char* trainingdir
		,char* SolarTherm_path, char* base_path, int status_config, int match_index
		,int is_OD_simulated, int is_run_test_func
){
	//******************************************** WRITE CONFIGURATIONS ******************************************************//
	if(status_config==1){
		 // dump the configurations
		char *path_config = NEW_ARRAY(char,MAXLEN);
		snprintf(path_config,MAXLEN,"%s/configurations/configNREL%d.txt",base_path,match_index);
		MSG("Writing '%s'...\n",path_config);

		FILE* f = fopen(path_config,"w");
		if(f==NULL){
			ERR("Unable to open file '%s' for writing.",path_config);
		}
		fprintf(f,
		    "P_net,T_in_ref_blk,p_high,dT_PHX_hot_approach,dT_PHX_cold_approach,eta_isen_mc,eta_isen_rc,eta_isen_t,dT_mc_approach,T_amb_base\n"
		);

		fprintf(f,
		"%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf",
		    P_net,T_in_ref_blk,p_high,dT_PHX_hot_approach,dT_PHX_cold_approach,
		    eta_isen_mc,eta_isen_rc,eta_isen_t,dT_mc_approach,T_amb_base
		);

		fclose(f);
		free(path_config);
	}

	//******************************************** LOAD FLUID PROPS *********************************************************//
	char *fn_props = NEW_ARRAY(char,MAXLEN);
	snprintf(fn_props,MAXLEN,"%s/Data/%s/props_for_NREL_PB.csv",SolarTherm_path,HTF_name);

	sim_struct* sim = NEW(sim_struct);
	loadPropsArray(fn_props, sim);
	ssc_number_t* htf_props = NEW_ARRAY(ssc_number_t, sim->rows_props*7);
	htf_props = sim->array_props;
	free(fn_props);

	/*Create SSC Data*/
	ssc_data_t data = ssc_data_create();
	ssc_data_set_number( data, "htf", HTF_choice);                      /*[-] Solar Salt ==> integer, 50 = for User Defined Props*/
	if(HTF_choice==50){
		ssc_data_set_matrix( data, "htf_props", htf_props, sim->rows_props, 7 ); /*user defined HTF property data*/
	}
	
	if(is_OD_simulated==1){
		//******************************************** LOAD OD MATRIX *********************************************************//
		/*Generate OD training data array*/
		if(is_run_test_func == 1){
			generateOffDesignFile(
				T_in_ref_blk-273.15, 
				1, 
				T_amb_base-273.15,
				trainingdir, 
				SolarTherm_path,  //Before it was base_path --> change to SolarTherm_path
				3, 
				2, //===> running test function for only 1 data point
				"LHS" 
			);
		}
		else{
			generateOffDesignFile(
				T_in_ref_blk-273.15, 
				1, 
				T_amb_base-273.15,
				trainingdir, 
				SolarTherm_path,  //Before it was base_path --> change to SolarTherm_path
				3, 
				numdata,
				"training"
			);
		}

		/*Generate OD training data array*/
		char* fn_OD = NEW_ARRAY(char, strlen(trainingdir) + strlen("/OD_matrix.csv") + 1);
		strcpy(fn_OD,trainingdir);
		strcat(fn_OD,"/OD_matrix.csv"); //e.g. /home/philgun/solartherm-intermediate/SolarTherm/Resources/Library/training_data/configNREL0/OD_matrix.csv
		
		loadOffDesignArray(fn_OD, sim);
		ssc_number_t* OD_array = NEW_ARRAY(ssc_number_t, sim->rows_OD*6);
		//sim->array_OD = OD_array; // flipped this around... only way it makes sense -- JP
		OD_array = sim->array_OD; // reflip this one since JP's suggestion does not work

		//**************************************************************************************************************************//
		double eff_max = 1; 
		double deltaP_recup_HP = 0.0056;                            /*[-] 0.0056 = 0.14[MPa]/25[MPa]. Fraction of press. loss*/
		double deltaP_recup_LP = 0.0311;                            /*[-] 0.0311 = 0.28[MPa]/9[MPa]. Fraction of press. loss*/

		//************************************************ DESIGN POINT ***********************************************************//
		ssc_data_set_number( data, "T_htf_hot_des", (T_in_ref_blk-273.15));  /*[-] Hot tank target temperature*/
		ssc_data_set_number( data, "dT_PHX_hot_approach", dT_PHX_hot_approach);    /*[C/K] Temp. difference between hot HTF and TIT*/
		ssc_data_set_number( data, "dT_PHX_cold_approach", dT_PHX_cold_approach);   /*[C/K] Temp. difference between cold HTF and cold CO2 PHX inlet*/
		ssc_data_set_number( data, "T_amb_des", (T_amb_base-273.15));              /*[C] Ambient temperature at design point*/
		ssc_data_set_number( data, "dT_mc_approach", dT_mc_approach);          /*[C/K] Temp. difference between main compressor CO2 inlet and ambient*/
		ssc_data_set_number( data, "site_elevation", 588.0);        /*[m] Elevation of the site. 588 MASL is Dagget*/    
		ssc_data_set_number( data, "W_dot_net_des", (P_net/1e6));          /*[MWe] Design cle power output ~ no cooling and other parasitics*/ 
		
		/*Simulation configurations*/
		ssc_data_set_number( data, "design_method", 3);             /*[-] 1=specify efficiency ==> integer
		                                                                2=specify total Recup UA, 
		                                                                3=specify each recuperator design*/
		ssc_data_set_number( data, "eta_thermal_des", -1);          /*[-] Power cycle target thermal eff. at design point. Not used here*/
		ssc_data_set_number( data, "UA_recup_tot_des",-1);          /*[kW/K] total UA recuperators value - not used here*/

		ssc_data_set_number( data, "cycle_config",1);               /*[-] 1=Recompression cycle ==> integer
		                                                                2=Partial cooling cycle*/
		
		ssc_data_set_number( data, "is_recomp_ok", 1);              /*[-] 1=Recompression cycle ==> integer
		                                                                2=Partial cooling cycle*/
		ssc_data_set_number( data, "is_P_high_fixed", 1);           /*[-] 1 = Yes (=P_high_limit), 0 = No, optimized (default)
		                                                                ==> integer*/
		
		ssc_data_set_number( data, "is_PR_fixed", 0);               /*[-] 1=Yes, 0=no ==> integer*/

		ssc_data_set_number( data, "des_objective", 1);             /* 2 = hit min deltaT then max efficiency, 
		                                                            != 2 = max efficiency*/

		ssc_data_set_number( data, "min_phx_deltaT", 1000.0);       /*[C] Min allowable deltaT across PHX*/
		
		ssc_data_set_number( data, "rel_tol", 3);                   /*[-] Baseline solver and optimization relative 
		                                                            tolerance exponent (10^-rel_tol)*/

		ssc_data_set_number( data, "eta_isen_mc", eta_isen_mc);     /*isentropic eff. of the main comp.*/
		ssc_data_set_number( data, "eta_isen_pc", 0.85 );           /*isentropic eff. of the pre-comp. ==> not used*/
		ssc_data_set_number( data, "eta_isen_rc", eta_isen_rc);     /*isentropic eff. of the re-comp.*/


		ssc_data_set_number( data, "eta_isen_t", eta_isen_t);             /*Turbine isentropic eff. at design point*/
		ssc_data_set_number( data, "P_high_limit", (p_high/1e6));         /*Compressor pressure limit [MPa]*/
		
		/*LTR Design Parameters*/
		ssc_data_set_number( data, "LTR_design_code", 2);           /*[-] 1=UA, 2=min dT, 3=effectiveness ==> integer*/
		ssc_data_set_number( data, "LTR_UA_des_in", -1);            /*[kW/K] ((required if LTR_design_code == 1 and design_method == 3) 
		                                                            not used now*/
		ssc_data_set_number( data, "LTR_min_dT_des_in", 10.0);      /*[C/K]required if LTR_design_code == 2 and design_method == 3) 
		                                                            reasonable value" from Neises/Turchi*/
		ssc_data_set_number( data, "LTR_eff_des_in", -1);           /*required if LTR_design_code == 3 and design_method == 3*/
		ssc_data_set_number( data, "LT_recup_eff_max", eff_max);
		ssc_data_set_number( data, "LTR_LP_deltaP_des_in", deltaP_recup_LP);
		ssc_data_set_number( data, "LTR_HP_deltaP_des_in", deltaP_recup_HP);

		/*HTR Design Parameters*/
		ssc_data_set_number( data, "HTR_design_code", 2);           /*[-] 1=UA, 2=min dT, 3=effectiveness ==> integer*/
		ssc_data_set_number( data, "HTR_UA_des_in", -1);            /*[kW/K] ((required if HTR_design_code == 1 and design_method == 3) 
		                                                            not used now*/
		ssc_data_set_number( data, "HTR_min_dT_des_in", 10.0);      /*[C/K]required if LTR_design_code == 2 and design_method == 3) 
		                                                            reasonable value" from Neises/Turchi*/
		ssc_data_set_number( data, "HTR_eff_des_in", -1);           /*required if LTR_design_code == 3 and design_method == 3*/
		ssc_data_set_number( data, "HT_recup_eff_max", eff_max);    
		ssc_data_set_number( data, "HTR_LP_deltaP_des_in", deltaP_recup_LP);                                                           
		ssc_data_set_number( data, "HTR_HP_deltaP_des_in", deltaP_recup_HP);

		/*PHX Design Parameters*/
		ssc_data_set_number( data, "PHX_co2_deltaP_des_in",deltaP_recup_HP);  /*Pressure drop in heat exchanger*/

		/*Dry Cooler Parameters*/
		ssc_data_set_number( data, "deltaP_cooler_frac", 0.005);    /*[-] Fraction of CO2 inlet pressure that is design point 
		                                                                cooler CO2 pressure drop*/
		ssc_data_set_number( data, "fan_power_frac", 0.02);         /*[-] Fraction of net cycle power consumed by air cooler fan. 
		                                                                2% here per Turchi et al.*/                                                                     
		
		/*Default Parameters*/
		ssc_data_set_number( data, "deltaP_counterHX_frac",-1); /*[-] Fraction of CO2 inlet pressure that is design point counterflow HX 
		                                                            (recups & PHX) pressure drop*/


		/*Off-design Parameters*/
		ssc_data_set_number( data, "od_rel_tol", 3);            /*[-] Baseline off-design relative 
		                                                        convergence tolerance exponent (10^-od_rel_tol)*/

		//************************************************ OFF DESIGN POINT ********************************************************//
		ssc_data_set_matrix( data, "od_cases", OD_array, sim->rows_OD, 6); /*user Off design cases*/

		printf("Rows properties: %d, Rows OD: %d \n",sim->rows_props,sim->rows_OD);

		
		/*Instantiate the sCO2 PB module in SAM*/
		ssc_module_t module = ssc_module_create("sco2_csp_system");

		if(ssc_module_exec(module,data)==0){
		    ERR("Error in simulation while running ssc_module_exec.");
		    ssc_module_free(module);
		    ssc_data_free(data);
		    exit(EXIT_FAILURE);
		}

		//ssc_number_t val;
		//ssc_bool_t status_call; /*= ssc_data_get_number(data,"eta_thermal_calc",&val) */; //address of the value is assigned to eta
		//double eta_thermal_cycle_des = val; //************************retrieve eta cycle at design point

		ssc_number_t m;
		ssc_data_get_number(data, "m_dot_htf_des",&m);
		
		ssc_number_t p_low;
		ssc_data_get_number(data,"t_P_out_des",&p_low);

		ssc_number_t Q_dot_PHX_des;
		ssc_data_get_number(data,"q_dot_PHX",&Q_dot_PHX_des);

		ssc_number_t T_HTF_cold_des;
		ssc_data_get_number(data,"T_htf_cold_des",&T_HTF_cold_des);

		/*Get the off design result*/
		int len = sim->rows_OD;

		ssc_number_t* Q_dot_cycle = ssc_data_get_array(data, "Q_dot_od",&len);
		//ssc_number_t* eta_cycle_OD = ssc_data_get_array(data,"eta_thermal_od",&len);
		ssc_number_t* W_cooler_OD = ssc_data_get_array(data,"cooler_tot_W_dot_fan_od",&len);
		ssc_number_t* W_net_OD = ssc_data_get_array(data,"W_dot_net_od",&len); //*********** Before cooling power

		/*Start writing the training data*/
		int length_fn = strlen(trainingdir) + strlen("/training_data.csv") + 1;
		char* fn = NEW_ARRAY(char,length_fn);
		strcpy(fn,trainingdir);
		strcat(fn,"/training_data.csv");

		//FILE* f = fopen(fn,"r"); PG CHANGE
		FILE* f;
		if(fopen(fn,"r") == NULL){
			 /*If file doesn't exist, create the file and write the header*/
		    f = fopen(fn,"w");
		    fprintf(f,"P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,load,T_HTF_in,T_amb_input,eta_gross,eta_Q,\n");
		    fclose(f);
		}
		
		//fclose(f); PG CHANGE

		f = fopen(fn,"a");
		
		for(int i=0;i<len;i++){
		    fprintf(f,"%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,\n",
		        P_net,T_in_ref_blk,p_high,-1.0,-1.0,-1.0,
		        sim->array_OD[i*6 + 1],                              /*Load*/
		        sim->array_OD[i*6] + 273.15,                        /*T_HTF_in [K]*/                                               
		        sim->array_OD[i*6 + 2] + 273.15,                    /*T_amb_in [K]*/
		        (W_net_OD[i] - W_cooler_OD[i])/(Q_dot_cycle[i]),    /*eta_gross = (W cycle - W cooler) / Q_HX*/
		        Q_dot_cycle[i]/Q_dot_PHX_des                        /*eta_Q = Q_HX/Q_HX_design*/
		    );
		}
		
		fclose(f);

		/*Generate validation data array*/
		int rowval = 15;
		if(is_run_test_func==1){
			generateOffDesignFile(
				T_in_ref_blk-273.15, 
				1, 
				T_amb_base-273.15,
				trainingdir, 
				SolarTherm_path,  //Before it was base_path --> change to SolarTherm_path
				3, 
				2, //===> running test function for only one data point
				"LHS" 
			);

		}else{
			generateOffDesignFile(
				T_in_ref_blk-273.15, 
				1, T_amb_base-273.15,
				trainingdir, 
				base_path, 
				3, 
				rowval,
				"validation"
			);
		}

		loadOffDesignArray(fn_OD, sim);
		free(fn_OD);
		len = sim->rows_OD;

		OD_array = NEW_ARRAY(ssc_number_t, sim->rows_OD*6);
		OD_array = sim->array_OD;
		ssc_data_set_matrix( data, "od_cases", OD_array, sim->rows_OD, 6); /*user Off design cases*/
		if(ssc_module_exec(module,data)==0){
		    ERR("Error in simulation while running ssc_module_exec!");
		    ssc_module_free(module);
		    ssc_data_free(data);
		    exit(EXIT_FAILURE);
		}

		ssc_number_t* Q_dot_cycle_val = ssc_data_get_array(data, "Q_dot_od",&rowval);
		ssc_number_t* W_cooler_OD_val = ssc_data_get_array(data,"cooler_tot_W_dot_fan_od",&rowval);
		ssc_number_t* W_net_OD_val = ssc_data_get_array(data,"W_dot_net_od",&rowval); //*********** Before cooling power

		/*Start writing the validation data*/    
		int length_fnval = strlen(trainingdir) + strlen("/validation_data.csv") + 1;
		char* fn_val = NEW_ARRAY(char,length_fnval);
		strcpy(fn_val,trainingdir);
		strcat(fn_val,"/validation_data.csv");

		// FILE* g = fopen(fn_val,"r"); CHANGE PG
		FILE* g;
		if(fopen(fn_val,"r") == NULL){
		     /*If file doesn't exist, create the file and write the header*/
		    g = fopen(fn_val,"w");
		    fprintf(g,"P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,load,T_HTF_in,T_amb_input,eta_gross,eta_Q,\n");
		    fclose(g);
		}
		
		//fclose(g); CHANGE PG
		g = fopen(fn_val,"a");
		
		for(int i=0;i<rowval;i++){
		    fprintf(g, "%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,\n",
		        P_net,T_in_ref_blk,p_high,-1.0,-1.0,-1.0,
		        sim->array_OD[i*6 + 1],            /*Load*/
		        sim->array_OD[i*6] + 273.15,       /*T_HTF_in [K]*/                                               
		        sim->array_OD[i*6 + 2] + 273.15,   /*T_amb_in [K]*/
		        (W_net_OD_val[i] - W_cooler_OD_val[i])/(Q_dot_cycle_val[i]),
		        				    /*eta_gross = (W cycle - W cooler) / Q_HX*/
		        Q_dot_cycle_val[i]/Q_dot_PHX_des   /*eta_Q = Q_HX/Q_HX_design*/
		    );
		}
		
		fclose(g);

		/*Data Processing*/
		if(is_run_test_func==0){
			/*If not test func, run data processing*/
			dataProcessing(fn, trainingdir, SolarTherm_path);
		}
		
		ssc_module_free(module);
		
		free(OD_array);
		free(fn);
		free(fn_val);

	}else{

		MSG("===========================SIMULATE NREL SAM PB ON DESIGN ONLY =================================\n");
		
		//**************************************************************************************************************************//
		double eff_max = 1; 
		double deltaP_recup_HP = 0.0056;                            /*[-] 0.0056 = 0.14[MPa]/25[MPa]. Fraction of press. loss*/
		double deltaP_recup_LP = 0.0311;                            /*[-] 0.0311 = 0.28[MPa]/9[MPa]. Fraction of press. loss*/

		//************************************************ DESIGN POINT ***********************************************************//
		ssc_data_set_number( data, "T_htf_hot_des", (T_in_ref_blk-273.15));  /*[-] Hot tank target temperature*/
		ssc_data_set_number( data, "dT_PHX_hot_approach", dT_PHX_hot_approach);    /*[C/K] Temp. difference between hot HTF and TIT*/
		ssc_data_set_number( data, "dT_PHX_cold_approach", dT_PHX_cold_approach);   /*[C/K] Temp. difference between cold HTF and cold CO2 PHX inlet*/
		ssc_data_set_number( data, "T_amb_des", (T_amb_base-273.15));              /*[C] Ambient temperature at design point*/
		ssc_data_set_number( data, "dT_mc_approach", dT_mc_approach);          /*[C/K] Temp. difference between main compressor CO2 inlet and ambient*/
		ssc_data_set_number( data, "site_elevation", 588.0);        /*[m] Elevation of the site. 588 MASL is Dagget*/    
		ssc_data_set_number( data, "W_dot_net_des", (P_net/1e6));          /*[MWe] Design cle power output ~ no cooling and other parasitics*/ 
		
		/*Simulation configurations*/
		ssc_data_set_number( data, "design_method", 3);             /*[-] 1=specify efficiency ==> integer
		                                                                2=specify total Recup UA, 
		                                                                3=specify each recuperator design*/
		ssc_data_set_number( data, "eta_thermal_des", -1);          /*[-] Power cycle target thermal eff. at design point. Not used here*/
		ssc_data_set_number( data, "UA_recup_tot_des",-1);          /*[kW/K] total UA recuperators value - not used here*/

		ssc_data_set_number( data, "cycle_config",1);               /*[-] 1=Recompression cycle ==> integer
		                                                                2=Partial cooling cycle*/
		
		ssc_data_set_number( data, "is_recomp_ok", 1);              /*[-] 1=Recompression cycle ==> integer
		                                                                2=Partial cooling cycle*/
		ssc_data_set_number( data, "is_P_high_fixed", 1);           /*[-] 1 = Yes (=P_high_limit), 0 = No, optimized (default)
		                                                                ==> integer*/
		
		ssc_data_set_number( data, "is_PR_fixed", 0);               /*[-] 1=Yes, 0=no ==> integer*/

		ssc_data_set_number( data, "des_objective", 1);             /* 2 = hit min deltaT then max efficiency, 
		                                                            != 2 = max efficiency*/

		ssc_data_set_number( data, "min_phx_deltaT", 1000.0);       /*[C] Min allowable deltaT across PHX*/
		
		ssc_data_set_number( data, "rel_tol", 3);                   /*[-] Baseline solver and optimization relative 
		                                                            tolerance exponent (10^-rel_tol)*/

		ssc_data_set_number( data, "eta_isen_mc", eta_isen_mc);     /*isentropic eff. of the main comp.*/
		ssc_data_set_number( data, "eta_isen_pc", 0.85 );           /*isentropic eff. of the pre-comp. ==> not used*/
		ssc_data_set_number( data, "eta_isen_rc", eta_isen_rc);     /*isentropic eff. of the re-comp.*/


		ssc_data_set_number( data, "eta_isen_t", eta_isen_t);             /*Turbine isentropic eff. at design point*/
		ssc_data_set_number( data, "P_high_limit", (p_high/1e6));         /*Compressor pressure limit [MPa]*/
		
		/*LTR Design Parameters*/
		ssc_data_set_number( data, "LTR_design_code", 2);           /*[-] 1=UA, 2=min dT, 3=effectiveness ==> integer*/
		ssc_data_set_number( data, "LTR_UA_des_in", -1);            /*[kW/K] ((required if LTR_design_code == 1 and design_method == 3) 
		                                                            not used now*/
		ssc_data_set_number( data, "LTR_min_dT_des_in", 10.0);      /*[C/K]required if LTR_design_code == 2 and design_method == 3) 
		                                                            reasonable value" from Neises/Turchi*/
		ssc_data_set_number( data, "LTR_eff_des_in", -1);           /*required if LTR_design_code == 3 and design_method == 3*/
		ssc_data_set_number( data, "LT_recup_eff_max", eff_max);
		ssc_data_set_number( data, "LTR_LP_deltaP_des_in", deltaP_recup_LP);
		ssc_data_set_number( data, "LTR_HP_deltaP_des_in", deltaP_recup_HP);

		/*HTR Design Parameters*/
		ssc_data_set_number( data, "HTR_design_code", 2);           /*[-] 1=UA, 2=min dT, 3=effectiveness ==> integer*/
		ssc_data_set_number( data, "HTR_UA_des_in", -1);            /*[kW/K] ((required if HTR_design_code == 1 and design_method == 3) 
		                                                            not used now*/
		ssc_data_set_number( data, "HTR_min_dT_des_in", 10.0);      /*[C/K]required if LTR_design_code == 2 and design_method == 3) 
		                                                            reasonable value" from Neises/Turchi*/
		ssc_data_set_number( data, "HTR_eff_des_in", -1);           /*required if LTR_design_code == 3 and design_method == 3*/
		ssc_data_set_number( data, "HT_recup_eff_max", eff_max);    
		ssc_data_set_number( data, "HTR_LP_deltaP_des_in", deltaP_recup_LP);                                                           
		ssc_data_set_number( data, "HTR_HP_deltaP_des_in", deltaP_recup_HP);

		/*PHX Design Parameters*/
		ssc_data_set_number( data, "PHX_co2_deltaP_des_in",deltaP_recup_HP);  /*Pressure drop in heat exchanger*/

		/*Dry Cooler Parameters*/
		ssc_data_set_number( data, "deltaP_cooler_frac", 0.005);    /*[-] Fraction of CO2 inlet pressure that is design point 
		                                                                cooler CO2 pressure drop*/
		ssc_data_set_number( data, "fan_power_frac", 0.02);         /*[-] Fraction of net cycle power consumed by air cooler fan. 
		                                                                2% here per Turchi et al.*/                                                                     
		
		/*Default Parameters*/
		ssc_data_set_number( data, "deltaP_counterHX_frac",0.005); /*[-] Fraction of CO2 inlet pressure that is design point counterflow HX 
		                                                            (recups & PHX) pressure drop*/


		/*Off-design Parameters*/
		ssc_data_set_number( data, "od_rel_tol", 3);            /*[-] Baseline off-design relative 
		                                                        convergence tolerance exponent (10^-od_rel_tol)*/

		/*Instantiate the sCO2 PB module in SAM*/
		ssc_module_t module = ssc_module_create("sco2_csp_system");

		if(ssc_module_exec(module,data)==0){
		    ERR("Error in simulation while running ssc_module_exec!");
		    ssc_module_free(module);
		    ssc_data_free(data);
		    exit(EXIT_FAILURE);
		}
	}

	free(htf_props);
	return data;
}

/*
	Test if parameters are passed successfully to SSC
*/
void ssc_test(){
	printf("SSC version = %d\n", ssc_version());

	ssc_data_t data = ssc_data_create();

	ssc_data_set_string( data, "solar_resource_file", "aaa" );
	const char* text = ssc_data_get_string( data, "solar_resource_file" );
	assert(strcmp(text,"aaa")==0);

	double val = 0.3;
	ssc_data_set_number( data, "dens_mirror", val );

	ssc_number_t dens_mirror;
	ssc_bool_t nerr = ssc_data_get_number( data, "dens_mirror", &dens_mirror );
	assert(nerr);
	//MSG("dens mirror: %f\n", dens_mirror );
	assert(dens_mirror==val);
}

/*
	Processing the off-design data array before training the surrogate model. Using Python script
*/
void dataProcessing(char* fntrain, char* trainingdir, char* SolarTherm_path){
	PyObject *pName, *pModule, *pFunc;
	PyObject *pArgs, *inputs;

	/*
		Change PG--> char* ppath = basepath;
	*/

	char* ppath = NEW_ARRAY(char, MAXLEN);
	snprintf(ppath,MAXLEN,"%s/Resources/Library", SolarTherm_path);
	fprintf(stderr,"PPATH: %s\n",ppath);

	char* pname = "gatherdata"; //gatherdata.py
	char* pfunc = "processing_data"; //def processing_data(inputs)

	Py_Initialize(); /*  Initialize Interpreter  */

	//Obtain the python path, append it with the ppath
	PyObject *sys_path = PySys_GetObject("path");
	PyList_Append(sys_path, PyUnicode_FromString((char *) ppath));

	//Convert the pname into Python String
	pName = PyUnicode_FromString(pname);

	//Import the script into C environment using PyImport_Import
	pModule = PyImport_Import(pName);
	Py_DECREF(pName);


	/*Check python script: exist or not!*/
	if (pModule != NULL){
		/*Obtain the function from the imported python script*/
		pFunc = PyObject_GetAttrString(pModule, pfunc);

		pArgs = PyTuple_New(1);

		/*if the function is callable*/
		if (pFunc && PyCallable_Check(pFunc)){
		    /*Instantiate a python dictionary and assign it to inputs (pointer type)*/
		    inputs = PyDict_New();

		    /*Populate the python dictionary*/
		    PyDict_SetItemString(inputs, "fntrain", PyUnicode_FromString((char *)fntrain));

		    PyDict_SetItemString(inputs, "resdir", PyUnicode_FromString((char *)trainingdir));
		    
		    PyTuple_SetItem(pArgs, 0, inputs);

		    PyObject_CallObject(pFunc, pArgs);

		    Py_DECREF(inputs);
		    Py_DECREF(pArgs);
		}else{
		    if (PyErr_Occurred()){
		        PyErr_Print();
		    }else{
		        ERR("Cannot find function \"%s\"", pfunc);
		        exit(EXIT_FAILURE);
		    }
		}
		Py_XDECREF(pFunc);
		Py_DECREF(pModule);
	}else{
		/*if python script does not exist*/
		PyErr_Print();
		ERR("Failed to load \"%s\"", pname);
		exit(EXIT_FAILURE);
	}

	free(ppath);
}

/*=================================== END OF FUNCTIONS TO CALL POWER BLOCK MODEL ==============================*/

