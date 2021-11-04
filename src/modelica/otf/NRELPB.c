#include <stdio.h>
#include <stdlib.h>
#include <python2.7/Python.h>
#include "SAM/sscapi.h"
#include "NRELPB.h"
#define limitSize 5000

void ssc_test()
{
    printf("SSC version = %d\n", ssc_version());

    ssc_data_t data = ssc_data_create();

    ssc_data_set_string( data, "solar_resource_file", "aaa" );
    const char* text = ssc_data_get_string( data, "solar_resource_file" );
    assert(strcmp(text,"aaa")==0);

    double val = 0.3;
    ssc_data_set_number( data, "dens_mirror", val );

    ssc_number_t dens_mirror;
    ssc_bool_t nerr = ssc_data_get_number( data, "dens_mirror", &dens_mirror );\
    assert(nerr);
    //fprintf(stderr,"dens mirror: %f\n", dens_mirror );
    assert(dens_mirror==val);
}

void generateOffDesignFile(double T_HTF_in_des, double load_des, double T_amb_des, char* trainingdir, int numinputs, int numdata)
{   
    
    double UB_1 = T_HTF_in_des + 20; //*************** Maximum temperature of the HTF at off design case [C]
    double UB_2 = 1.5; //******************** maximum load
    double UB_3 = 50; //******************* maximum ambient temperature [C]

    double LB_1 = T_HTF_in_des - 50; //*************** Minimum temperature of the HTF at off design case [C]
    double LB_2 = 0.45; //******************** minimum part load
    double LB_3 = -20; //******************* minimum ambient temperature [C]

    char* dirname = ".";

    PyObject *pName, *pModule, *pFunc;
    PyObject *pArgs, *inputs;

    char* ppath = ".";
    char* pname = "gen_OD_matrix"; //gen_OD_matrix.py
    char* pfunc = "generate_matrix"; //def generate_matrix(inputs)

    Py_Initialize(); /*  Initialize Interpreter  */

    //Obtain the python path, append it with the ppath
    PyObject *sys_path = PySys_GetObject("path");
    PyList_Append(sys_path, PyString_FromString((char *) ppath));
  
    //Convert the pname into Python String
    pName = PyString_FromString(pname);

    //Import the script into C environment using PyImport_Import
    pModule = PyImport_Import(pName);
    Py_DECREF(pName);
    
    
    /*Check python script: exist or not!*/
    if (pModule != NULL) 
    {
        /*Obtain the function from the imported python script*/
        pFunc = PyObject_GetAttrString(pModule, pfunc);

        pArgs = PyTuple_New(1);

        /*if the function is callable*/
        if (pFunc && PyCallable_Check(pFunc)) 
        {
            /*Instantiate a python dictionary and assign it to inputs (pointer type)*/
            inputs = PyDict_New();

            /*Populate the python dictionary*/
            PyDict_SetItemString(inputs, "UB_1", PyFloat_FromDouble(UB_1));
            PyDict_SetItemString(inputs, "UB_2", PyFloat_FromDouble(UB_2));
            PyDict_SetItemString(inputs, "UB_3", PyFloat_FromDouble(UB_3));

            PyDict_SetItemString(inputs, "LB_1", PyFloat_FromDouble(LB_1));
            PyDict_SetItemString(inputs, "LB_2", PyFloat_FromDouble(LB_2));
            PyDict_SetItemString(inputs, "LB_3", PyFloat_FromDouble(LB_3));

            PyDict_SetItemString(inputs, "T_HTF_des", PyFloat_FromDouble(T_HTF_in_des));
            PyDict_SetItemString(inputs, "load_des", PyFloat_FromDouble(load_des));
            PyDict_SetItemString(inputs, "T_amb_des", PyFloat_FromDouble(T_amb_des));
            
            PyDict_SetItemString(inputs, "num_inputs", PyInt_FromLong(numinputs));
            PyDict_SetItemString(inputs, "numdata", PyInt_FromLong(numdata));

            PyDict_SetItemString(inputs, "trainingdir", PyString_FromString((char *)dirname));
            
            PyTuple_SetItem(pArgs, 0, inputs);


            PyObject_CallObject(pFunc, pArgs);

            Py_DECREF(inputs);
            Py_DECREF(pArgs);
        }
        else 
        {
            if (PyErr_Occurred())
            {
                PyErr_Print();
            }
            else
            {
                fprintf(stderr, "Cannot find function \"%s\"\n", pfunc);
            }
        }
        Py_XDECREF(pFunc);
        Py_DECREF(pModule);
    }

    /*if python script does not exist*/
    else 
    {
        PyErr_Print();
        fprintf(stderr, "Failed to load \"%s\"\n", pname);
    }

    return;
}

void genPropsArray(char* fn_props, sim_struct* sim)
{
    char line[limitSize];
    
    FILE* fn = fopen(fn_props,"r");

    if(fn==NULL)
    {
        fprintf(stderr,"File doesn't exist. File path: %s\n",fn_props);
        exit(EXIT_FAILURE);
    }

    //************ Skip the 1st line of the CSV
    fgets(line,limitSize,fn); //************> Skip the 1st line

    //************ First get number of rows
    int rows = 0;
    fgets(line,limitSize,fn); //************> Start from the second line
    while(!feof(fn))
    {
        rows++;
        fgets(line,limitSize,fn); 
    }
    fclose(fn);

    sim->rows_props = rows;

    //************* Allocating memory space for array_props array
    sim->array_props = malloc(sizeof(ssc_number_t*)*(sim->rows_props*7));

    //************* Start reading the file and put the data into a flatten array
    fn = fopen(fn_props,"r");
    fgets(line,limitSize,fn); //************> Skip the 1st line

    fgets(line,limitSize,fn); //************> Start from the second line
    size_t i = 0;
    while(!feof(fn))
    {
        sscanf
        (
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
    return;
    
}

void genOffDesignArray(char* fn_OD, sim_struct* sim)
{
    char line[limitSize];
    
    FILE* fn = fopen(fn_OD,"r");

    if(fn==NULL)
    {
        fprintf(stderr,"File doesn't exist. File path: %s\n",fn_OD);
        exit(EXIT_FAILURE);
    }


    //************ First get number of rows
    int rows = 0;
    fgets(line,limitSize,fn);
    while(!feof(fn))
    {
        rows++;
        fgets(line,limitSize,fn); 
    }
    fclose(fn);

    sim->rows_OD = rows;

    //************* Allocating memory space for array_props array
    sim->array_OD = malloc(sizeof(ssc_number_t*)*(sim->rows_OD*6));

    //************* Start reading the file and put the data into a flatten array
    fn = fopen(fn_OD,"r");
    fgets(line,limitSize,fn); 
    size_t i = 0;
    while(!feof(fn))
    {
        sscanf
        (
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

ssc_data_t runNRELPB(char* fn_props, double T_HTF_in_des)
{
    //******************************************** LOAD FLUID PROPS *********************************************************//
    
    sim_struct* sim = malloc(sizeof(sim_struct));
    genPropsArray(fn_props, sim);
    ssc_number_t* htf_props = malloc(sizeof(ssc_number_t)*(sim->rows_props*7));
    htf_props = sim->array_props;

    //******************************************** LOAD OD MATRIX *********************************************************//
    int numdata = 200;
    generateOffDesignFile(T_HTF_in_des, 1, 40.0,".",3,numdata);
    char* fn_OD = "OD_matrix.csv";
    genOffDesignArray(fn_OD, sim);
    ssc_number_t* OD_array = malloc(sizeof(ssc_number_t)*(sim->rows_OD*6));
    OD_array = sim->array_OD;

    //**************************************************************************************************************************//
    double eff_max = 1; 
    double deltaP_recup_HP = 0.0056;                            /*[-] 0.0056 = 0.14[MPa]/25[MPa]. Fraction of press. loss*/
    double deltaP_recup_LP = 0.0311;                            /*[-] 0.0311 = 0.28[MPa]/9[MPa]. Fraction of press. loss*/

    /*Create SSC Data*/
    ssc_data_t data = ssc_data_create();

    //************************************************ DESIGN POINT ***********************************************************//
    ssc_data_set_number( data, "htf", 50);                      /*[-] Solar Salt ==> integer, 50 = for User Defined Props*/
    ssc_data_set_matrix( data, "htf_props", htf_props, sim->rows_props, 7 ); /*user defined HTF property data*/
    ssc_data_set_number( data, "T_htf_hot_des", T_HTF_in_des);  /*[-] Hot tank target temperature*/
    ssc_data_set_number( data, "dT_PHX_hot_approach", 20.0);    /*[C/K] Temp. difference between hot HTF and TIT*/
    ssc_data_set_number( data, "dT_PHX_cold_approach", 20.0);   /*[C/K] Temp. difference between cold HTF and cold CO2 PHX inlet*/
    ssc_data_set_number( data, "T_amb_des", 40.0);              /*[C] Ambient temperature at design point*/
    ssc_data_set_number( data, "dT_mc_approach", 6.0);          /*[C/K] Temp. difference between main compressor CO2 inlet and ambient*/
    ssc_data_set_number( data, "site_elevation", 588.0);        /*[m] Elevation of the site. 588 MASL is Dagget*/    
    ssc_data_set_number( data, "W_dot_net_des", 50.0);          /*[MWe] Design cle power output ~ no cooling and other parasitics*/ 
    
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

    ssc_data_set_number( data, "eta_isen_mc", 0.85);            /*Main compressor isentropic eff. of the main comp.*/
    ssc_data_set_number( data, "eta_isen_pc", 0.85 );           /*Main compressor isentropic eff. of the re-comp.*/
    ssc_data_set_number( data, "eta_isen_rc", 0.85);            /*Main compressor isentropic eff. of the pre-comp.*/


    ssc_data_set_number( data, "eta_isen_t", 0.90);             /*Turbine isentropic eff. at design point*/
    ssc_data_set_number( data, "P_high_limit", 25);             /*Compressor pressure limit [MPa]*/
    
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

    if(ssc_module_exec(module,data)==0)
    {
        fprintf(stderr,"Error in simulation!\n");
        ssc_module_free(module);
        ssc_data_free(data);
        exit(EXIT_FAILURE);
    }

    printf("\n\n####################################### ON DESIGN CALCULTION OUTPUT #####################################\n\n");
    ssc_number_t val;
    ssc_bool_t status_call = ssc_data_get_number(data,"eta_thermal_calc",&val); //address of the value is assigned to eta
    double eta_thermal_cycle_des = val; //************************retrieve eta cycle at design point
    printf("Cycle thermal efficiency at design point: %lf \n",eta_thermal_cycle_des);

    ssc_number_t m;
    status_call = ssc_data_get_number(data, "m_dot_HTF_des",&m);
    double m_dot_HTF_des = m;
    printf("Mass flow rate of the PB at design point: %lf kg/s\n",m_dot_HTF_des);

    ssc_number_t p_low;
    status_call = ssc_data_get_number(data,"t_P_out_des",&p_low);
    printf("Low side pressure at design point: %lf MPa\n",p_low);

    ssc_number_t Q_dot_PHX_des;
    status_call = ssc_data_get_number(data,"q_dot_PHX",&Q_dot_PHX_des);
    printf("PHX heat transfer at design point: %lf MWth\n",Q_dot_PHX_des);

    ssc_number_t T_HTF_cold_des;
    status_call = ssc_data_get_number(data,"T_htf_cold_des",&T_HTF_cold_des);
    printf("Cold tank temperature: %lf C\n",T_HTF_cold_des);

    /*Get the off design result*/
    int len = sim->rows_OD;

    ssc_number_t* Q_dot_cycle = ssc_data_get_array(data, "Q_dot_od",&len);
    ssc_number_t* eta_cycle_OD = ssc_data_get_array(data,"eta_thermal_od",&len);
    ssc_number_t* W_cooler_OD = ssc_data_get_array(data,"cooler_tot_W_dot_fan_od",&len);
    ssc_number_t* W_net_OD = ssc_data_get_array(data,"W_dot_net_od",&len); //*********** Before cooling power

    printf("\n\n=========================================OFF DESIGN==================================================\n\n");
    for(size_t i=0;i<len;i++)
    {
        printf("\n\n########################## OFF DESIGN CASE %zu ############################\n\n",i+1);
        printf("Off-design thermal input = %lf MWth\n",Q_dot_cycle[i]);
        printf("Off-design ratio Q PHX off design / Q PHX on design = %lf\n",Q_dot_cycle[i]/Q_dot_PHX_des);
        printf("Off-design cycle thermal efficiency = %lf \n",eta_cycle_OD[i]);
        printf("Off-design cycle output power before cooler parasitic = %lf MWe\n",W_net_OD[i]);
        printf("Off-design cooler power = %lf MWe\n",W_cooler_OD[i]);
        printf("Off-design net power output = %lf MWe\n",W_net_OD[i] - W_cooler_OD[i]);
    } 

    ssc_module_free(module);
    ssc_data_free(data);
    free(htf_props);
    free(OD_array);

    return data;
}



    
/*
for(size_t i=0;i<rows*7;i++)
{
    printf("%lf\n",sim->array_props[i]);
}
*/