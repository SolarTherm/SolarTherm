#include <Python.h>
#include <stdio.h>
#include <stdlib.h>

#define MSG(FMT, ...) \
	fprintf(stderr,"%s:%d(%s) " FMT "\n",__FILE__,__LINE__,__func__,##__VA_ARGS__);

typedef enum{
	RP2_INT
	,RP2_STR
	,RP2_REAL
} RP2ParamType;

typedef struct{
	const char *name;
	RP2ParamType type;
	union{
		char *strval;
		int intval;
		double realval;
	} value;
} RP2Param;

/**
	`pyfile`: full path to Python script, including .py suffix
	`pyfunc`: function to be run
	`params`: a list, length `argc`, of parameters that will be passed by name
		to the python function. The parameters can be string, integer or double.
		
	In Modelica, we will define Param, and then StrParam, IntParam and RealParam
	such that we can write 
	
	result := ExternalFunction("/path/to/myscript.py","loadcsv",IntParam("col",3),StrParam("name","data.csv"))
	
	and it would translate effectively to
	
	import myscript
	myscript.loadcsv(col=3,name="data.csv")
	
	Fingers crossed...
	
	TODO address case of pathsep / vs \ especially MSYS2.
	TODO consider case of running within a virtualenv, with poetry etc.
*/
char *RunPy2Func(char *filepath, char *funcname, RP2Param *params, int argc){

	MSG("RUNPY2FUNC...");
	MSG("FILEPATH IS: %s",filepath);
	
	// check that filepath exists (could also use 'stat'...)
	FILE *fp = fopen(filepath,"r");
	if(!fp){
		MSG("COULD NOT OPEN '%s'",filepath);
		return NULL;
	}
	fclose(fp);

	// copy the filepath (we will truncate it to a directory)
	int len = strlen(filepath);
	char *importdir = (char *)malloc(len+1);
	char *pyfile = NULL;
	if(!importdir){MSG("FAILED MALLOC");return NULL;}
	
	// interpret the path: search backwards from the end to find a pathsep
#define PATHSEP '/'
	char *c = filepath + len - 1;
	int found = 0;
	while(c >= filepath){
		if(*c == PATHSEP){
			*c = '\0'; // replace the last pathsep by \0.
			found = 1;
			break;
		}
		--c;
	}
	if(!found){
		MSG("UNABLE TO PARSE FILEPATH");
		return NULL;
	}
	MSG("DIRECTORY: %s", filepath);
	// copy the tail to a new string
	char *import = c+1;
	len = strlen(import);
	MSG("TAIL OF STRING: %s",import);
	if(len>3 && strcmp(import + len - 3,".py")==0){
		import[len - 3] = '\0';
	}
	MSG("IMPORT: %s",import);
	
	// proceed with setting up Python...	

	return "NOTHING";
#if 0	
	PyStatus status;
	PyConfig config;

	if(Py_IsInitialized()){
		MSG("Python is already initialised. Failing.");
		return NULL;
	}
	
	PyConfig_InitPythonConfig(&config);
	// hardwired for now (what if we want to use a virtualenv?)
	config.program_name = L"c:\\msys64\\mingw64\\bin\\python3.exe";
	if(Py_InitializeFromConfig(&config) < 0){
		PyConfig_Clear(&config);
		MSG("INITIALISATION ERROR");
		return NULL;
	}
	PyConfig_Clear(&config);
    // Now, we can start working with Python.
    PyObject *pName = PyUnicode_DecodeFSDefault("sample_script");
    PyObject *pModule = PyImport_Import(pName);
    Py_XDECREF(pName);

    if (pModule != NULL) {
        PyObject *pFunc = PyObject_GetAttrString(pModule, "greet");
        if (PyCallable_Check(pFunc)) {
            PyObject *pArgs = PyTuple_Pack(1, PyUnicode_FromString("John"));
            PyObject *pValue = PyObject_CallObject(pFunc, pArgs);
            if (pValue != NULL) {
                printf("%s\n", PyUnicode_AsUTF8(pValue));
                Py_DECREF(pValue);
            }
            Py_XDECREF(pArgs);
            Py_XDECREF(pFunc);
        }
        Py_DECREF(pModule);
    }

    // Finalize the Python interpreter
    Py_Finalize();
    return 0;
#endif
}


// vim: ts=4:sw=4:tw=80:noet
