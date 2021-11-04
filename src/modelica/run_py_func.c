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

	const char *tablefile = NULL; //the file of the lookup table
	PyObject *pModule, *pFunc;
	PyObject *pArgs, *pValue, *inputs;
	int i;

	fprintf(stderr,"Running python module '%s' from path '%s'...\n",pname,ppath);
	fprintf(stderr,"psave = %s\n",psave);
	fprintf(stderr,"rcv_type = %s\n",rcv_type);
	fprintf(stderr,"wea_file = %s\n",wea_file);
	fprintf(stderr,"field_type = %s\n",field_type);

	Py_Initialize(); /*  Initialize Interpreter  */

	// add the path of the Python function file to the system path
	PyObject *sys_path = PySys_GetObject("path");

	fprintf(stderr,"Append '%s' to sys path...\n",ppath);

	PyList_Append(sys_path, PyUnicode_FromString((char *)ppath));

	fprintf(stderr,"Import '%s'....\n",pname);

	// name of the Python file
	//pName = PyUnicode_FromString(pname);
	/* Error checking of pName left out */
	//fprintf(stderr,"Import '%s'....\n",pname);

	pModule = PyImport_ImportModule(pname);
	//Py_DECREF(pName);

	fprintf(stderr,"eee\n");

	if(pModule != NULL){
		pFunc = PyObject_GetAttrString(pModule, pfunc);
		/* pFunc is a new reference */

		pArgs =PyTuple_New(1);

		if (pFunc && PyCallable_Check(pFunc)){

			fprintf(stderr,"Creating dict to pass...\n");

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
					fprintf(stderr, "Cannot convert argument\n");
				}
				/* pValue reference stolen here: */
				PyDict_SetItemString(inputs, varnames[i], pValue);
			}

			PyTuple_SetItem(pArgs, 0, inputs);

			fprintf(stderr,"Heading into PyObject_CallObject...\n");

			pValue = PyObject_CallObject(pFunc, pArgs);

			fprintf(stderr,"Got back from PyObject_CallObject...\n");

			tablefile=PyBytes_AsString(pValue);


			Py_DECREF(pArgs);
			Py_DECREF(inputs);
			if(pValue != NULL) {
				Py_DECREF(pValue);
			}else{
				Py_DECREF(pFunc);
				Py_DECREF(pModule);
				PyErr_Print();
				fprintf(stderr,"Call failed\n");
			}
		}else{
			if(PyErr_Occurred())PyErr_Print();
			fprintf(stderr, "Cannot find function \"%s\"\n", pfunc);
		}
		Py_XDECREF(pFunc);
		Py_DECREF(pModule);
	}else{
		PyErr_Print();
		fprintf(stderr, "Failed to load \"%s\"\n", pname);
	}
	
	return tablefile;
	Py_Finalize();
}

// vim: ts=4:sw=4:tw=80:noet
