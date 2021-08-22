#include <Python.h>
#include <stdio.h>

#define MSG(FMT,...)\
	fprintf(stderr,("%s:%d: " FMT "\n"),__FILE__,__LINE__,##__VA_ARGS__)

double myextfunc1(int argc, const char *argv[]){
	double output;
	PyObject *pName, *pModule, *pFunc;
	PyObject *pArgs, *pValue;
	int i;

	if(argc < 3){
		fprintf(stderr,"Usage: call pythonfile funcname [args]\n");
		return 1;
	}

	Py_Initialize(); /*  Initialize Interpreter  */

	//PySys_SetPath((char *)argv[0]);  // absolute path to the module (function file) to import

	// add the path of the Python function file to the system path
	PyObject *sys_path = PySys_GetObject("path");
	PyList_Append(sys_path, PyUnicode_FromString((char *)argv[0]));

	pName = PyUnicode_FromString(argv[1]);
	/* Error checking of pName left out */

	pModule = PyImport_Import(pName);
	Py_DECREF(pName);

	if (pModule != NULL) {
		pFunc = PyObject_GetAttrString(pModule, argv[2]);
		/* pFunc is a new reference */

		if (pFunc && PyCallable_Check(pFunc)) {
			pArgs = PyTuple_New(argc - 3);
			for (i = 0; i < argc - 3; ++i) {
				//printf("aaa %f\n", atof(argv[i + 3]));
				//pValue = PyInt_FromLong(atoi(argv[i + 3]));
				pValue = PyFloat_FromDouble(atof(argv[i + 3]));
				if (!pValue) {
					Py_DECREF(pArgs);
					Py_DECREF(pModule);
					MSG("Cannot convert argument\n");
					return 1;
				}
				/* pValue reference stolen here: */
				PyTuple_SetItem(pArgs, i, pValue);
			}
			pValue = PyObject_CallObject(pFunc, pArgs);
			output = PyFloat_AsDouble(pValue);
			Py_DECREF(pArgs);
			if (pValue != NULL) {
				//printf("Result of call: %ld\n", PyInt_AsLong(pValue));
				Py_DECREF(pValue);
			}
			else {
				Py_DECREF(pFunc);
				Py_DECREF(pModule);
				PyErr_Print();
				MSG("Call failed\n");
				return 1;
			}
		}
		else {
			if (PyErr_Occurred())
				PyErr_Print();
			MSG("Cannot find function \"%s\"", argv[2]);
		}
		Py_XDECREF(pFunc);
		Py_DECREF(pModule);
	}
	else {
		PyErr_Print();
		MSG("Failed to load \"%s\"", argv[1]);
		return 1;
	}
	Py_Finalize();
	return output;
}

/* vim: ts=4:sw=4:noet */
