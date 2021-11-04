#include "otfreceiver.h"

/*=================================== WORK IN PROGRESS WITH OTF RECEIVER ==============================*/
/*
	Work in progress --> generate receiver surrogate model on the fly for a given receiver size. 
	Current implementation in SolarTherm was to pre-train a global surrogate model encompassing both on and off design parameters
*/
void checkConfigReceiver(double H_drop, double T_HTF_in_des
		, double T_HTF_out_des, char* base_path, int* index_and_status
){
	char line[limitSize];
	int matching_index = -1000;
	int status = -1000;

	/*Check if the design param is already existing*/
	int file_index = 0;
	char* config_base = "configParticleReceiver";

	char* config_file_path = NEW_ARRAY(char, MAXLEN);
	
	while(1){
		//************** String refactoring operation
		snprintf(config_file_path,MAXLEN,"%s/configurations/%s%d.txt", base_path, config_base, file_index);

		fprintf(stderr,"Reading config '%s'...\n",config_file_path);
		
		//************** Try open the config_file_path
		FILE* configfile = fopen(config_file_path, "r");

		//************** If fail to open, break out of the while loop
		if(!configfile)break; //Finished looping over all configfile
		
		//**************** get the 1st line
		fgets(line,limitSize,configfile);

		//**************** get the 2nd line where the information is located
		fgets(line,limitSize,configfile);

		//**************** Start scanning the information
		//Initialise the particle receiver parameters that want to be compared
		double H_drop_existing, T_HTF_in_des_existing,T_HTF_out_des_existing;

		double deviation_of_configurations;
		sscanf(
	        line,"%lf,%lf,%lf",
	        &H_drop_existing,
	        &T_HTF_in_des_existing,
	        &T_HTF_out_des_existing
	    );

		double deviation_H_drop = fabs(H_drop_existing - H_drop);
		double deviation_T_HTF_in_des = fabs(T_HTF_in_des_existing - T_HTF_in_des);
		double deviation_T_HTF_out_des = fabs(T_HTF_out_des_existing - T_HTF_out_des);
		deviation_of_configurations = deviation_H_drop + deviation_T_HTF_in_des + deviation_T_HTF_out_des;            
		
		if(deviation_of_configurations < 1e-3){
		    matching_index = file_index;
		    status = 0; //******changing status to 0 from -1000 s.t. we dont need to gather the data
		    fprintf(stderr,"Configuration match in: %s\n",config_file_path);
		}else{ 
		    fprintf(stderr,"Configuration doesn't match in: %s\n",config_file_path);
		}
		
		file_index++; //**********increasing the file index
	}

	//************** If no file is matching --> matching index is -1000, 
	//************** force the value of matching index = file_index for foldering purpose of the new training data
	if(matching_index == -1000){
		fprintf(stderr,"No match in the data base!\n");
		matching_index = file_index;
		status = 1;
	}

	/*If status == 1, then we have to gather the training data, if status-*/
	index_and_status[0] = matching_index; 
	index_and_status[1] = status;

	free(config_file_path);
	return;
}

void simReceiver(int numdata, double H_drop_design, double T_HTF_in_design
		, double T_HTF_out_des, char* trainingdir, char* SolarTherm_path
		, char* base_path, int status_config
){
	PyObject *pName, *pModule, *pFunc;
	PyObject *pArgs, *inputs;

	char* ppath = base_path;
	char* pname = "gen_receiver_off_design"; //gatherdata.py
	char* pfunc = "gendata"; //def processing_data(inputs)

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
		    PyDict_SetItemString(inputs, "numdata", PyLong_FromLong(numdata));
		    PyDict_SetItemString(inputs, "SolarTherm_path", PyUnicode_FromString((char *)SolarTherm_path));
		    PyDict_SetItemString(inputs, "trainingdir", PyUnicode_FromString((char *)trainingdir));

		    PyDict_SetItemString(inputs, "H_drop", PyFloat_FromDouble(H_drop_design));
		    PyDict_SetItemString(inputs, "T_HTF_in_des", PyFloat_FromDouble(T_HTF_in_design));
		    PyDict_SetItemString(inputs, "T_HTF_out_des", PyFloat_FromDouble(T_HTF_out_des));
		    PyDict_SetItemString(inputs, "status_config", PyLong_FromLong(status_config));

		    
		    PyTuple_SetItem(pArgs, 0, inputs);

		    PyObject_CallObject(pFunc, pArgs);

		    Py_DECREF(inputs);
		    Py_DECREF(pArgs);
		}else{
		    if (PyErr_Occurred()){
		        PyErr_Print();
		    }else{
		        fprintf(stderr, "Cannot find function \"%s\"\n", pfunc);
		        exit(EXIT_FAILURE);
		    }
		}
		Py_XDECREF(pFunc);
		Py_DECREF(pModule);
	}else{
		/*if python script does not exist*/
		PyErr_Print();
		fprintf(stderr, "Failed to load \"%s\"\n", pname);
		exit(EXIT_FAILURE);
	}
}

