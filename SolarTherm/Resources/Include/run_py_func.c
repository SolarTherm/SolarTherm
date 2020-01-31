#ifndef RUN_PY_FUNC
#define RUN_PY_FUNC

#include <python2.7/Python.h>
#include <stdio.h>

double TestExternalPy_func(const char *ppath, const char *pname, const char *pfunc, int argc, const char *varnames[], const double var[] );

double TestExternalPy_func(const char *ppath, const char *pname, const char *pfunc, int argc, const char *varnames[], const double var[])
{
    // ppath: path of the Python script
    // pname: name of the Python script
    // pfunc: name of the Python function

    int output;
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
        pFunc = PyObject_GetAttrString(pModule, pfunc);
        /* pFunc is a new reference */

        pArgs =PyTuple_New(1);

        if (pFunc && PyCallable_Check(pFunc)) {
            inputs = PyDict_New();
            PyDict_SetItemString(inputs, "casedir", PyString_FromString((char *)psave));
            for (i = 0; i < argc; ++i) {
                //fprintf(stderr,"*************\n");                
                //printf("variable: %1f\n", var[i]);

                pValue = PyFloat_FromDouble(var[i]);

                if (!pValue) {
                    Py_DECREF(pArgs);
                    Py_DECREF(pModule);
                    fprintf(stderr, "Cannot convert argument\n");
                    return 1;
                }
                /* pValue reference stolen here: */
                PyDict_SetItemString(inputs, varnames[i], pValue);
            }

            PyTuple_SetItem(pArgs, 0, inputs);

            pValue = PyObject_CallObject(pFunc, pArgs);

            output = PyFloat_AsDouble(pValue);

            fprintf(stderr,"*************\n");
            fprintf(stderr,"Solstice\n");
            printf("The result is: %d\n", output);

            Py_DECREF(pArgs);
            if (pValue != NULL) {
                //printf("Result of call: %ld\n", PyInt_AsLong(pValue));
                Py_DECREF(pValue);
            }
            else {
                Py_DECREF(pFunc);
                Py_DECREF(pModule);
                PyErr_Print();
                fprintf(stderr,"Call failed\n");
                return 1;
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
        return 1;
    }
    Py_Finalize();

    return output;
}

#endif
