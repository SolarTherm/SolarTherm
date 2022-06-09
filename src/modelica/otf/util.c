#include "util.h"

#include <stdio.h>
#include <stdlib.h>
#include <Python.h>

#define ST_UTIL_DEBUG
#ifdef ST_UTIL_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif
#define ERR(FMT,...) fprintf(stderr,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)

/*=================================== STARTING FROM HERE IS GENERAL UTILITIES FUNCS ==============================*/
/*
	This function checks number of data in the training data file s.t. the memory allocation for the kriging struct is on point
*/
int getNumOfData(char* filepath){   
	/*Declare a variable to store the string from CSV*/
	char line[limitSize];
	int i = 0;

	/*Open the file*/
	FILE* training_file = fopen(filepath,"r");
	if (training_file==NULL)
	{
		ERR("Your file doesn't exist! Check your address %s!",filepath);
		return -1;
	}

	/*Let's skip the header, shall we?!*/
	fgets(line,limitSize,training_file);

	/*Read the data!*/
	fgets(line,limitSize,training_file);
	while(!feof(training_file))
	{
		i++;
		fgets(line,limitSize,training_file);
	}
	fclose(training_file);

	return i;
}

/**
	This function is to check the existing sCO2 PB configurations against the requested configuration by the system model. When the configuration exists, no need to generate new surrogate model, instead the program will load the existing surrogate model and proceed with simulation. Checking confiugration is done by reading txt files located in ./configurations directory.
*/
void checkConfig(double P_net, double T_in_ref_blk, double p_high, double PR, double pinch_PHX, 
		double dTemp_HTF_PHX, int* index_and_status, char* SolarTherm_path, int PB_model,
		double dT_PHX_hot_approach,  double dT_PHX_cold_approach,
		double eta_isen_mc, double eta_isen_rc, double eta_isen_t,double dT_mc_approach,double T_amb_base
){
	char line[limitSize];
	int matching_index = -1000;
	int status = -1000;

	/*Check if the design param is already existing*/
	int file_index = 0;
	char* config_base = (PB_model == 0 ? "config" : (PB_model == 1 ? "configNREL" : NULL));
	if(!config_base){
		ERR("PB model choice is invalid. Choose 0 for CEA PB, 1 for NREL-SAM PB. Your choice is %d",PB_model);
		exit(EXIT_FAILURE);
	}
	char* config_file_path = NEW_ARRAY(char,MAXLEN);

	while(1){
		snprintf(config_file_path,MAXLEN,"%s/Data/SurrogateModels/PowerBlock/configurations/%s%d.txt",SolarTherm_path,config_base,file_index);
		MSG("Reading config '%s'...",config_file_path);

		FILE* configfile = fopen(config_file_path,"r");
		
		if(!configfile)break; // no more saved configurations

		//**************** get the 1st line
		fgets(line,limitSize,configfile);

		//**************** get the 2nd line where the information is
		fgets(line,limitSize,configfile);

		//**************** start scanning the information
		//Initialise CEA PB and NREL parameters that want to be compared
		double P_net_exisiting, T_in_ref_blk_existing, p_high_existing, 
		PR_existing, pinch_PHX_existing, dTemp_HTF_PHX_existing, 
		dT_PHX_hot_approach_existing, dT_PHX_cold_approach_existing, eta_isen_mc_existing, 
		eta_isen_rc_existing,eta_isen_t_existing, dT_mc_approach_existing, T_amb_base_existing;

		double deviation_of_configurations;

		if(PB_model==0){/*CEA PB config file template*/
		    sscanf(
		        line,"%lf,%lf,%lf,%lf,%lf,%lf",
		        &P_net_exisiting,
		        &T_in_ref_blk_existing,
		        &p_high_existing,
		        &PR_existing,
		        &pinch_PHX_existing,
		        &dTemp_HTF_PHX_existing
		    );
		    double deviation_P_net = P_net_exisiting - P_net;
		    double deviation_T_in_ref_blk = T_in_ref_blk_existing - T_in_ref_blk;
		    double deviation_p_high = p_high_existing - p_high;
		    double deviation_PR = PR_existing - PR;
		    double deviation_pinch_PHX = pinch_PHX_existing - pinch_PHX;
		    double deviation_dTemp_HTF_PHX = dTemp_HTF_PHX_existing - dTemp_HTF_PHX;
		    deviation_of_configurations = fabs(deviation_P_net + deviation_T_in_ref_blk + 
		                                     deviation_p_high + deviation_PR + deviation_pinch_PHX + 
		                                     deviation_dTemp_HTF_PHX);
		}else{
		    sscanf(
		        line,"%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf",
		        &P_net_exisiting,
		        &T_in_ref_blk_existing,
		        &p_high_existing,
		        &dT_PHX_hot_approach_existing,
		        &dT_PHX_cold_approach_existing,
		        &eta_isen_mc_existing,
		        &eta_isen_rc_existing,
		        &eta_isen_t_existing,
		        &dT_mc_approach_existing,
		        &T_amb_base_existing
		    );
		    double deviation_P_net = P_net_exisiting - P_net;
		    double deviation_T_in_ref_blk = T_in_ref_blk_existing - T_in_ref_blk;
		    double deviation_p_high = p_high_existing - p_high;
		    double deviation_dT_PHX_hot_approach = dT_PHX_hot_approach_existing - dT_PHX_hot_approach;
		    double deviation_dT_PHX_cold_approach = dT_PHX_cold_approach_existing - dT_PHX_cold_approach;
		    double deviation_eta_isen_mc = eta_isen_mc_existing - eta_isen_mc;
		    double deviation_eta_isen_rc = eta_isen_rc_existing - eta_isen_rc;
		    double deviation_eta_isen_t = eta_isen_t_existing - eta_isen_t;
		    double deviation_dT_mc_approach = dT_mc_approach_existing - dT_mc_approach;
		    double deviation_T_amb_base = T_amb_base_existing - T_amb_base;
		    deviation_of_configurations = fabs(deviation_P_net + deviation_T_in_ref_blk + 
		                                     deviation_p_high + deviation_dT_PHX_hot_approach + deviation_dT_PHX_cold_approach+
		                                     deviation_eta_isen_mc + deviation_eta_isen_rc + deviation_eta_isen_t +
		                                     deviation_dT_mc_approach+deviation_T_amb_base);            
		}
		
		if(deviation_of_configurations < 1e-3){
		    matching_index = file_index;
		    status = 0; //******changing status to 0 from -1000 s.t. we dont need to gather the data
		    MSG("Configuration match in: %s",config_file_path);
		}else{ 
		    MSG("Configuration doesn't match in: %s",config_file_path);
		}
		
		file_index++; //**********increasing the file index
	}

	//************** If no file is matching --> matching index is -1000, 
	//************** force the value of matching index = file_index for foldering purpose of the new training data
	if(matching_index == -1000){
		MSG("No match in the data base!");
		matching_index = file_index;
		status = 1;
	}

	/*If status == 1, then we have to gather the training data, if status-*/
	index_and_status[0] = matching_index; 
	index_and_status[1] = status;

	free(config_file_path);
}

/*Python function to run CEA PB shall new training data should be generated*/
void generateTrainingData(double P_net, double T_in_ref_blk, double p_high
		,double PR, double pinch_PHX, double dTemp_HTF_PHX, int match_index
		,int numdata, char* base_path, int status_config
		,char* SolarTherm_path
){
	char* training_dir = NEW_ARRAY(char, MAXLEN);
	char* training_dir_name = "/training_data/";

	snprintf(training_dir, MAXLEN, "%s%s",base_path, training_dir_name); //e.g. base_path/training_data/

	char* configbase = "config";

	/*Convert matching_index from integer to string*/
	char* index_string = NEW_ARRAY(char,MAXLEN); 
	sprintf(index_string,"%d",match_index); //convert integer into string e.g. cofig0

	char* dirname = NEW_ARRAY(char,MAXLEN);
	snprintf(dirname, MAXLEN, "%s%s%s",training_dir,configbase,index_string);

	/*Call python function here to gather data*/
	// ppath: path of the Python script
	// pname: name of the Python script
	// pfunc: name of the Python function
	// psave: directory of saving the results from mcrt

	PyObject *pName, *pModule, *pFunc;
	PyObject *pArgs, *inputs;

	char* ppath = base_path;
	char* pname = "gatherdata"; //gatherdata.py
	char* pfunc = "gather_data"; //def gather_data(inputs)

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
	if(pModule != NULL){
		/*Obtain the function from the imported python script*/
		pFunc = PyObject_GetAttrString(pModule, pfunc);

		pArgs = PyTuple_New(1);

		/*if the function is callable*/
		if(pFunc && PyCallable_Check(pFunc)){
		    /*Instantiate a python dictionary and assign it to inputs (pointer type)*/
		    inputs = PyDict_New();

		    /*Populate the python dictionary*/
		    PyDict_SetItemString(inputs, "P_net", PyFloat_FromDouble(P_net));
		    PyDict_SetItemString(inputs, "T_in_ref_blk", PyFloat_FromDouble(T_in_ref_blk));
		    PyDict_SetItemString(inputs, "p_high", PyFloat_FromDouble(p_high));
		    PyDict_SetItemString(inputs, "PR", PyFloat_FromDouble(PR));
		    PyDict_SetItemString(inputs, "pinch_PHX", PyFloat_FromDouble(pinch_PHX));
		    PyDict_SetItemString(inputs, "dTemp_HTF_PHX", PyFloat_FromDouble(dTemp_HTF_PHX));
		    PyDict_SetItemString(inputs, "numdata", PyLong_FromLong(numdata));
		    PyDict_SetItemString(inputs, "dirres", PyUnicode_FromString((char *)dirname));
		    PyDict_SetItemString(inputs, "status_config", PyLong_FromLong(status_config));
		    PyDict_SetItemString(inputs, "SolarTherm_path",PyUnicode_FromString((char*)SolarTherm_path));
		    
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
		/*if python script does not exist*/
		PyErr_Print();
		ERR("Failed to load \"%s\"", pname);
	}


	/*Free the heap*/
	free(training_dir);
	free(index_string);
	free(dirname);

	//Py_DECREF(ppath);
	//Py_DECREF(pname);
	//Py_DECREF(pfunc);
	//Py_DECREF(sys_path);
	//Py_Finalize();
}

/**
	String formating from fragmented path
*/
char* build_trainingdir_path(
		char* base_path, char* traindir_base, char* config_base, int match_index
){
	char* trainingdir = NEW_ARRAY(char,MAXLEN);
	snprintf(trainingdir,MAXLEN,"%s%s%s%d",base_path,traindir_base,config_base,match_index);
	return trainingdir;
}

char* concat_training_dir(char* trainingdir, char* concat_string){
	char *resultpath = NEW_ARRAY(char,MAXLEN);
	snprintf(resultpath,MAXLEN,"%s%s",trainingdir,concat_string);
	return resultpath;
}
/*=================================== END OF GENERAL UTILITIES FUNCS ==============================*/


// vim: ts=4:sw=4:noet
