#include <Python.h>
#include <stdio.h>

const char* RunSolsticeFunc(const char *ppath, const char *pname
	, const char *pfunc, const char *psave,  const char *field_type
	, const char *rcv_type, const char *wea_file, int argc
	, const char *varnames[], const double var[]
){
    // ppath: path of the Python script
    // pname: name of the Python script
    // pfunc: name of the Python function
    // psave: directory of saving the results from mcrt

    const char *tablefile; //the file of the lookup table
    PyObject *pName, *pModule, *pFunc;
    PyObject *pArgs, *pValue, *inputs;
    int i;

    Py_Initialize(); /*  Initialize Interpreter  */

    // add the path of the Python function file to the system path
    PyObject *sys_path = PySys_GetObject("path");
    PyList_Append(sys_path, PyUnicode_FromString((char *)ppath));
  
    // name of the Python file
    pName = PyUnicode_FromString(pname);
    /* Error checking of pName left out */

    pModule = PyImport_Import(pName);
    Py_DECREF(pName);

    if (pModule != NULL) {
        pFunc = PyObject_GetAttrString(pModule, pfunc);
        /* pFunc is a new reference */

        pArgs =PyTuple_New(1);

        if (pFunc && PyCallable_Check(pFunc)) {
            inputs = PyDict_New();
            PyDict_SetItemString(inputs, "casedir", PyUnicode_FromString((char *)psave));
            PyDict_SetItemString(inputs, "field_type", PyUnicode_FromString((char *)field_type));
            PyDict_SetItemString(inputs, "rcv_type", PyUnicode_FromString((char *)rcv_type));
            PyDict_SetItemString(inputs, "wea_file", PyUnicode_FromString((char *)wea_file));
            for (i = 0; i < argc; ++i) {

                pValue = PyFloat_FromDouble(var[i]);

                if (!pValue) {
                    Py_DECREF(pArgs);
                    Py_DECREF(pModule);
                    fprintf(stderr, "Cannot convert argument\n");
                }
                /* pValue reference stolen here: */
                PyDict_SetItemString(inputs, varnames[i], pValue);
            }

            PyTuple_SetItem(pArgs, 0, inputs);

            pValue = PyObject_CallObject(pFunc, pArgs);

            tablefile=PyBytes_AsString(pValue);


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


    return tablefile;
    Py_Finalize();
}

