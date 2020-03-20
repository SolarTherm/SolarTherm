//#ifndef ST_EXT_PY_FUNC
#define ST_EXT_PY_FUNC

#include <python2.7/Python.h>
#include <stdio.h>

double CO2PropertiesFunc(const char *ppath, const char *pname, const char *pfunc, int argc, const double var[]);

double CO2PropertiesFunc(const char *ppath, const char *pname, const char *pfunc, int argc, const double var[])
    // ppath: path of the Python script
    // pname: name of the Python script
{
    double T; //temperature as a result
    PyObject *pName, *pModule, *pFunc;
    PyObject *pArgs, *pValue, *inputs;
    int i;

    Py_Initialize(); /*  Initialize Interpreter  */


    // add the path of the Python function file to the system path
    PyObject *sys_path = PySys_GetObject("path");
    PyList_Append(sys_path, PyString_FromString((char *)ppath));
  
    // name of the Python file
    pName = PyString_FromString(pname);
    /* Error checking of pName left out */

    pModule = PyImport_Import(pName);
    Py_DECREF(pName);

    if (pModule != NULL) {
	pArgs =PyTuple_New(argc);

        for (i = 0; i < argc; ++i) {
    		pValue = PyFloat_FromDouble(var[i]);
		PyTuple_SetItem(pArgs, i, pValue);
            				}
        pFunc = PyObject_GetAttrString(pModule, pfunc);
        pValue = PyObject_CallObject(pFunc, pArgs);	
	T = PyFloat_AsDouble(pValue);	
        printf("%f", T);
        /* pFunc is a new reference */   
    }
   
    Py_DECREF(ppath);
    Py_DECREF(pname);
    Py_DECREF(pfunc);

    Py_Finalize();
    
    return T;
}	

