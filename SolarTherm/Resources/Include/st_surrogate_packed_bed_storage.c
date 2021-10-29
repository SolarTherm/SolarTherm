#include <python2.7/Python.h>
#include <string.h>
#include <stdio.h>

void storageRegression(const char *, const char *, const char *, const char *, const char *, double , double , double , double , double , double , double ,double* );

void storageRegression(const char *ppath, const char *pname, const char *pfunc, const char *wd, const char *fn_mo, double T_max, double T_min, double eta, double d_p, double E_max, double t_storage, double ar, double* regression_params)
{
    // ppath: path of the Python script
    // pname: name of the Python script
    // pfunc: name of the Python function

    PyObject *pName, *pModule, *pFunc, *pArgs, *pValue, *inputs;

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
        pFunc = PyObject_GetAttrString(pModule, pfunc);
        /* pFunc is a new reference */

        pArgs =PyTuple_New(1);

        if (pFunc && PyCallable_Check(pFunc)) {
            inputs = PyDict_New();

            //Populate the dictionary
            PyDict_SetItemString(inputs,"T_max",PyFloat_FromDouble(T_max));
            PyDict_SetItemString(inputs,"T_min",PyFloat_FromDouble(T_min));
            PyDict_SetItemString(inputs,"eta",PyFloat_FromDouble(eta));
            PyDict_SetItemString(inputs,"d_p",PyFloat_FromDouble(d_p));
            PyDict_SetItemString(inputs,"E_max",PyFloat_FromDouble(E_max));
            PyDict_SetItemString(inputs,"t_storage",PyFloat_FromDouble(t_storage));
            PyDict_SetItemString(inputs, "ar", PyFloat_FromDouble(ar));
            PyDict_SetItemString(inputs,"cwd",PyString_FromString(wd));
            PyDict_SetItemString(inputs,"fn_mo",PyString_FromString(fn_mo));
            PyTuple_SetItem(pArgs, 0, inputs);

            //*************** pValue will be Python Obj for list
            pValue = PyObject_CallObject(pFunc, pArgs);

            int lenlist = PyList_Size(pValue);

            for(size_t i=0; i<lenlist;i++)
            {
                //************* Populate sigmoidParams from the returned list. Since the return is still python object, we need to convert it
                regression_params[i] = PyFloat_AsDouble(
                    PyList_GetItem(pValue,i)
                );
            }
    
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
    fprintf(stderr, "\n\nStart annual simulation ................\n\n");
}
