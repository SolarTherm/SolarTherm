#ifndef ST_EXT_PY_FUNC
#define ST_EXT_PY_FUNC

#include <python2.7/Python.h>
#include <string.h>
#include <stdio.h>

void sigmoidRegression(const char* , const char* , const char* , int, const double[], double, double*);

void sigmoidRegression(const char *ppath, const char *pname, const char *pfunc, int N, const double T[], double u_flow, double* sigmoidParams)
{
    // ppath: path of the Python script
    // pname: name of the Python script
    // pfunc: name of the Python function

    PyObject *pName, *pModule, *pFunc, *pArgs, *pValue, *inputs;
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

    //************ Convert the temperature list into Python Object
    PyObject* T_list = PyList_New(N);

    for(size_t i=0; i < N; i++)
    {
        PyList_SetItem(T_list,i,PyFloat_FromDouble(T[i]));
    }

    if (pModule != NULL) {
        pFunc = PyObject_GetAttrString(pModule, pfunc);
        /* pFunc is a new reference */

        pArgs =PyTuple_New(1);

        if (pFunc && PyCallable_Check(pFunc)) {
            inputs = PyDict_New();
            PyDict_SetItemString(inputs,"u_flow",PyFloat_FromDouble(u_flow));
            PyDict_SetItemString(inputs, "Temperatures", T_list);
            PyDict_SetItemString(inputs,"num_discretisation",PyInt_FromLong(N));
            PyTuple_SetItem(pArgs, 0, inputs);

            //*************** pValue will be Python Obj for list
            pValue = PyObject_CallObject(pFunc, pArgs);

            int lenlist = PyList_Size(pValue);

            for(size_t i=0; i<lenlist;i++)
            {
                //************* Populate sigmoidParams from the returned list. Since the return is still python object, we need to convert it
                sigmoidParams[i] = PyFloat_AsDouble(
                    PyList_GetItem(pValue,i)
                );
            }

			fprintf(stderr,"%f,%f,%f,%f\n",sigmoidParams[0],sigmoidParams[1],sigmoidParams[2],sigmoidParams[3]);
    
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

    //Py_DECREF(ppath);
    //Py_DECREF(pname);
    //Py_DECREF(pfunc);
    //Py_DECREF(sys_path);
    //Py_Finalize();
}

#endif
