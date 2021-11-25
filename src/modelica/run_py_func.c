#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <stdio.h>

#define RUNPYFUNC_DEBUG
#ifdef RUNPYFUNC_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif
#define ERR(FMT,...) fprintf(stderr,"%s:%d: ERROR: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)


const char* RunSolsticeFunc(const char *ppath, const char *pname
	, const char *pfunc, const char *psave,  const char *field_type
	, const char *rcv_type, const char *wea_file, int argc
	, const char *varnames[], const double var[]
){
	// ppath: path of the Python script
	// pname: name of the Python script
	// pfunc: name of the Python function
	// psave: directory of saving the results from mcrt

	const char *tablefile = NULL; //the file of the lookup table
	PyObject *pFunc;
	PyObject *pArgs, *pValue, *inputs;
	int i;

	MSG("Running python module '%s' from path '%s'...",pname,ppath);
	MSG("psave = %s\n",psave);
	MSG("rcv_type = %s\n",rcv_type);
	MSG("wea_file = %s\n",wea_file);
	MSG("field_type = %s\n",field_type);

	wchar_t *progname = Py_DecodeLocale("run_py_func.c", NULL);
	Py_SetProgramName(progname);
	Py_Initialize(); /*  Initialize Interpreter  */
	PyRun_SimpleString("import numpy\n");

	// add the path of the Python function file to the system path
	PyObject *sys_path = PySys_GetObject("path");

	MSG("Append '%s' to sys path...\n",ppath);

	PyList_Append(sys_path, PyUnicode_FromString((char *)ppath));

	MSG("Import '%s'....\n",pname);

	// name of the Python file
	//pName = PyUnicode_FromString(pname);
	/* Error checking of pName left out */
	//MSG("Import '%s'....\n",pname);

	PyObject *pModule = PyImport_ImportModule(pname);
	if(pModule == NULL){
		ERR("Failed to import '%s'\n",pname);
		return NULL;
	}

	//Py_DECREF(pName);

	MSG("eee\n");

	if(pModule != NULL){
		pFunc = PyObject_GetAttrString(pModule, pfunc);
		/* pFunc is a new reference */

		pArgs =PyTuple_New(1);

		if (pFunc && PyCallable_Check(pFunc)){

			MSG("Creating dict to pass...\n");

			inputs = PyDict_New();
			PyDict_SetItemString(inputs, "casedir", PyUnicode_FromString((char *)psave));
			PyDict_SetItemString(inputs, "field_type", PyUnicode_FromString((char *)field_type));
			PyDict_SetItemString(inputs, "rcv_type", PyUnicode_FromString((char *)rcv_type));
			PyDict_SetItemString(inputs, "wea_file", PyUnicode_FromString((char *)wea_file));
			for (i = 0; i < argc; ++i) {

				pValue = PyFloat_FromDouble(var[i]);

				if(!pValue){
					Py_DECREF(pArgs);
					Py_DECREF(pModule);
					ERR( "Cannot convert argument\n");
				}
				/* pValue reference stolen here: */
				PyDict_SetItemString(inputs, varnames[i], pValue);
			}

			PyTuple_SetItem(pArgs, 0, inputs);

			MSG("Heading into PyObject_CallObject...\n");

			pValue = PyObject_CallObject(pFunc, pArgs);

			MSG("Got back from PyObject_CallObject...\n");

			tablefile=PyBytes_AsString(pValue);


			Py_DECREF(pArgs);
			Py_DECREF(inputs);
			if(pValue != NULL) {
				Py_DECREF(pValue);
			}else{
				Py_DECREF(pFunc);
				Py_DECREF(pModule);
				PyErr_Print();
				ERR("Call failed\n");
			}
		}else{
			if(PyErr_Occurred())PyErr_Print();
			ERR( "Cannot find function \"%s\"\n", pfunc);
		}
		Py_XDECREF(pFunc);
		Py_DECREF(pModule);
	}else{
		PyErr_Print();
		ERR( "Failed to load \"%s\"\n", pname);
	}
	
	return tablefile;
	if(Py_FinalizeEx() != 0){
		ERR("ERROR: Errors during Python finalisation.\n");
	}
	
	PyMem_RawFree(progname);
}


// vim: ts=4:sw=4:tw=80:noet
