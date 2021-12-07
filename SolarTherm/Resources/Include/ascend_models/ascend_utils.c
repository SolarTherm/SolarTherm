#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>
#include <libgen.h>
#include <python2.7/Python.h>
#include "ascend_utils.h"
#include <unistd.h>

/*
	Function to read number of segmentation
*/
#if 0
int read_num_segment(const char* solstice_wd){

	char* fn_names = NEW_ARRAY(char, MAXLEN);
	char str[MAXLEN];
	int num_segment;
	
	snprintf(fn_names, MAXLEN, "%s/receiver_1D_FluxMap_sunpos_1.csv",solstice_wd);
	FILE* f = fopen(fn_names ,"r");
	
	fgets(str, MAXLEN, f);
	sscanf(str,"%d",&num_segment);

	fclose(f);
	free(fn_names);

	return num_segment;
}
#endif

/*
    Function to read solar angles
*/
void read_solar_angles(double* angles, int file_index, const char* solstice_wd){
    
	char* fn_names = NEW_ARRAY(char, MAXLEN);
    char str[MAXLEN];

    snprintf(fn_names, MAXLEN, "%s/receiver_1D_FluxMap_sunpos_%d.csv", solstice_wd, file_index);

    if(fopen(fn_names,"r")==NULL){
        fprintf(stderr,"File can not be found. File path: %s\n", fn_names);
        exit(EXIT_FAILURE);
    }

    FILE* f = fopen(fn_names,"r");
    
    //Skip the 1st line
    fgets(str, MAXLEN, f);

    //Grab the 1st and 2nd angle from the 1st and 2nd row of the CSV
    fgets(str, MAXLEN, f);
    sscanf(str,"%lf",&angles[0]);

    fgets(str, MAXLEN, f);
    sscanf(str,"%lf",&angles[1]);

    fclose(f);
    free(fn_names);
}

/*
	Function to copy the content of fn_source to fn_destination
*/
/*
void write_flux_array(int file_index, const char* SolarTherm_path, const char* solstice_wd){
	char* fn_destination = NEW_ARRAY(char, MAXLEN);
	snprintf(fn_destination, MAXLEN, "%s/fluxmap.csv",solstice_wd);

	char* fn_source = NEW_ARRAY(char, MAXLEN);
	snprintf(fn_source,MAXLEN,"%s/receiver_1D_FluxMap_sunpos_%d.csv",solstice_wd, file_index); // e.g. {$solstice_wd}/flux_1.csv

	fprintf(stderr,"Copy flux array from : %s to %s\n",fn_source, fn_destination);

	//Start reading the file starting from line 1 of fn_flux
	FILE* f_source = fopen(fn_source, "r");
	FILE* f_dest = fopen(fn_destination, "w");
	char ch = fgetc(f_source);

	while(ch != EOF){
		fputc(ch, f_dest);
		ch = fgetc(f_source);
	}
	fclose(f_source);
	fclose(f_dest);
	free(fn_destination);
	free(fn_source);
};
*/

int run_ascend_sintering_model_CLI(const double var[], const char* solstice_wd, const char* SolarTherm_path, char* iron_sample, const char* which_run, const char* fmfile){
    /*python run_sintering_thermal_model.py --T_sky 40.0 --k_s 6.5 --alpha 0.95 --eps_r 0.9 --h_ext 20.0 --eps 0.4 --T_i_s_HX1 25 --T_o_s_HX1 1140 --T_i_g_HX1 1250 --d_p_HX1 0.0075 --H_HX1 0.05 --W_HX1 8.0 --t_wall_HX1 0.01 --T_i_s_HX2 1350 --T_o_s_HX2 200.0 --T_i_g_HX2 25.0 --W_HX2 8.0 --d_p_HX2 0.04 --flux_multiple_off 1 --seg 40 --dir_save /tmp/OpenModelica_philgun/OMEdit --SolarTherm_path /home/philgun/solartherm-sintering/SolarTherm --angle1 22.5 --angle2 30.0*/
    char* cmd = NEW_ARRAY(char, MAXLEN);

	if(strcmp(which_run,"on_design")==0){
		snprintf(
			cmd,MAXLEN,
			"python %s/Resources/Include/run_sintering_thermal_model.py --T_sky %lf --k_s %lf --alpha %lf --eps_r %lf --h_ext %lf --eps %lf --T_i_s_HX1 %lf --T_o_s_HX1 %lf --T_i_g_HX1 %lf --d_p_HX1 %lf --H_HX1 %lf --W_HX1 %lf --t_wall_HX1 %lf --T_i_s_HX2 %lf --T_o_s_HX2 %lf --T_i_g_HX2 %lf --W_HX2 %lf --d_p_HX2 %lf --solstice_wd %s --fmfile %s --SolarTherm_path %s --iron_sample %s --which_run on_design",
		    SolarTherm_path,
		    var[0],var[1], var[2],
		    var[3],var[4], var[5],
		    var[6],var[7], var[8],
		    var[9],var[10],var[11],
		    var[12],var[13],var[14],
		    var[15], var[16], var[17],
		    solstice_wd, fmfile, SolarTherm_path, iron_sample
		);

	}else if(strcmp(which_run,"off_design")==0){
		snprintf(
		    cmd, 
		    MAXLEN, 
		    "python %s/Resources/Include/run_sintering_thermal_model.py --T_sky %lf --k_s %lf --alpha %lf --eps_r %lf --h_ext %lf --eps %lf --T_i_s_HX1 %lf --T_o_s_HX1 %lf --T_i_g_HX1 %lf --d_p_HX1 %lf --H_HX1 %lf --W_HX1 %lf --t_wall_HX1 %lf --T_i_s_HX2 %lf --T_o_s_HX2 %lf --T_i_g_HX2 %lf --W_HX2 %lf --d_p_HX2 %lf --solstice_wd %s --fmfile %s --SolarTherm_path %s --iron_sample %s --which_run off_design",
		    SolarTherm_path,
		    var[0],var[1], var[2],
		    var[3],var[4], var[5],
		    var[6],var[7], var[8],
		    var[9],var[10],var[11],
		    var[12],var[13],var[14],
		    var[15], var[16], var[17],
		    solstice_wd, fmfile, SolarTherm_path, iron_sample
		);
	}

    fprintf(stderr,"%s\n\n",cmd);

    system(cmd);

    free(cmd);

    return 0;

}

/*
    Function to interpolate
*/
double run_interpolation(const char *ppath, const char *pname, const char *pfunc, const char* solstice_wd, double declination, double sun_hour_angle, double flux_multiple_off){
	double mdot_ore;
	int i;

	PyObject *pName, *pModule, *pFunc;
	PyObject *pArgs, *pValue, *inputs;

    Py_Initialize(); /*  Initialize Interpreter  */

    // add the path of the Python function file to the system path
    PyObject *sys_path = PySys_GetObject("path");
    PyList_Append(sys_path, PyString_FromString((char *)ppath));
  
    // name of the Python file
    pName = PyString_FromString(pname);
    /* Error checking of pName left out */

    pModule = PyImport_Import(pName);
    //fprintf(stderr,"ppath = %s\npame = %s\npfunc=%s\n",ppath, pname, pfunc);
    Py_DECREF(pName);

    if (pModule != NULL) {
        pFunc = PyObject_GetAttrString(pModule, pfunc);
        /* pFunc is a new reference */

        pArgs =PyTuple_New(1);

        if (pFunc && PyCallable_Check(pFunc)) {
            inputs = PyDict_New();

			/*Populate dictionary inputs*/
            PyDict_SetItemString(inputs, "dir_save", PyString_FromString((char *)solstice_wd));
            PyDict_SetItemString(inputs, "declination", PyFloat_FromDouble(declination));
            PyDict_SetItemString(inputs, "sunhour", PyFloat_FromDouble(sun_hour_angle));
            PyDict_SetItemString(inputs, "flux", PyFloat_FromDouble(flux_multiple_off));
            PyTuple_SetItem(pArgs, 0, inputs);

            pValue = PyObject_CallObject(pFunc, pArgs);

            mdot_ore = PyFloat_AsDouble(pValue);
			
            Py_DECREF(pArgs);
            Py_DECREF(inputs);
            if (pValue != NULL) {
                Py_DECREF(pValue);
            }
            else {
                Py_DECREF(pFunc);
                Py_DECREF(pModule);
                PyErr_Print();
                fprintf(stderr,"Call failed\n");
            }
        }
        else {
            if (PyErr_Occurred())
                PyErr_Print();
            fprintf(stderr, "Cannot find function \"%s\"\n", pfunc);
        }
        Py_XDECREF(pFunc);
        Py_DECREF(pModule);
    }
    else {
        PyErr_Print();
        fprintf(stderr, "Failed to load \"%s\"\n", pname);
    }

	return mdot_ore;
}

/*
	Function to call Python code that execute ASCEND model for sintering process

    ON DESIGN.
*/
/*
void run_ascend_sintering_model(const char *fmfile, const char *ppath, const char *pname, const char *pfunc, int argc, int num_segment, const char *varnames[], 
			const double var[], const char *solstice_wd, const char* SolarTherm_path, double* returns, const char* iron_sample){
					
	double mdot_ore;
	int i;
	char str[MAXLEN];

	// FIXME pass fmfile to Python

	PyObject *pName, *pModule, *pFunc;
	PyObject *pArgs, *pValue, *inputs;

    Py_Initialize();

    // add the path of the Python function file to the system path
    PyObject *sys_path = PySys_GetObject("path");
    PyList_Append(sys_path, PyString_FromString((char *)ppath));
  
    // name of the Python file
    pName = PyString_FromString(pname);

    pModule = PyImport_Import(pName);
    Py_DECREF(pName);

    if (pModule != NULL) {
        pFunc = PyObject_GetAttrString(pModule, pfunc);

        pArgs =PyTuple_New(1);

        if (pFunc && PyCallable_Check(pFunc)) {
            inputs = PyDict_New();

			//Populate dictionary inputs
#if 0
#define ITEM(NAME) PyDict_SetItemString(inputs, #NAME, PyString_FromString((char *)NAME));
	ITEM(solstice_wd)
	ITEM(fmfile)
	ITEM(SolarTherm_path)
	ITEM(iron_sample)
#endif

            PyDict_SetItemString(inputs, "solstice_wd", PyString_FromString((char *)solstice_wd));
            PyDict_SetItemString(inputs, "fmfile", PyString_FromString((char *)fmfile));
            PyDict_SetItemString(inputs, "SolarTherm_path", PyString_FromString((char *)SolarTherm_path));
            PyDict_SetItemString(inputs, "iron_sample", PyString_FromString((char *)iron_sample));

            for (i = 0; i < argc; ++i) {
                pValue = PyFloat_FromDouble(var[i]);

                if (!pValue) {
                    Py_DECREF(pArgs);
                    Py_DECREF(pModule);
                    fprintf(stderr, "Cannot convert argument\n");
                }
                PyDict_SetItemString(inputs, varnames[i], pValue);
            }

            PyTuple_SetItem(pArgs, 0, inputs);

            PyObject* result = PyObject_CallObject(pFunc, pArgs);

			fprintf(stderr,"Done calling python function to design the thermal model..................\n\n\n");
			
			char* fn_res_py = NEW_ARRAY(char, MAXLEN);
			snprintf(fn_res_py, MAXLEN,"%s/des_point_calc.csv",solstice_wd);
			FILE* f = fopen(fn_res_py,"r");
			if(f != NULL){
				fgets(str, MAXLEN, f);
    			sscanf(str,"%lf,%lf,%lf",&returns[0],&returns[1],&returns[2]);
			}
			else{
				fprintf(stderr,"%s/des_point_calc.csv can not be found..........................\n",solstice_wd);
				EXIT(EXIT_FAILURE);
			}
			fclose(f);

			fprintf(stderr,"MDOT ORE AT DP: %lf kg/s\nVOL. HX1: %lf m3\nVOL. HX2: %lf m3................................\n\n",returns[0], returns[1], returns[2]);
            //mdot_ore = PyFloat_AsDouble(pValue);

            char cwd[2000];
            getcwd(cwd, sizeof(cwd));
            fprintf(stderr,"Current working dir: %s\n", cwd);
            

            Py_DECREF(pArgs);
            Py_DECREF(inputs);
            if (pValue != NULL) {
                Py_DECREF(pValue);
            }
            else {
                Py_DECREF(pFunc);
                Py_DECREF(pModule);
                PyErr_Print();
                fprintf(stderr,"Call failed\n");
            }
        }
        else {
            if (PyErr_Occurred())
                PyErr_Print();
            fprintf(stderr, "Cannot find function \"%s\"\n", pfunc);
        }
        Py_XDECREF(pFunc);
        Py_DECREF(pModule);
    }
    else {
        PyErr_Print();
        fprintf(stderr, "Failed to load \"%s\"\n", pname);
    }
	//return mdot_ore;
}
*/
