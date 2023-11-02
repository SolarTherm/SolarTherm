#include <Python.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef WIN32
# include <windows.h>
#endif
#include <ModelicaUtilities.h>

//#define RUNPY_DEBUG
#ifdef RUNPY_DEBUG
# define MSG(FMT, ...) \
	fprintf(stderr,"%s:%d(%s) " FMT "\n",__FILE__,__LINE__,__func__,##__VA_ARGS__);
#else
# define MSG(...)
#endif

// FIXME if there are errors (even syntax errors) in run_solstice.py, we need
// a way of reporting them to the user. TODO!

/**
	`ppath`: path of the Python script
	`pname`: name of the Python script
	`pfunc`: name of the Python function
	`psave`: directory of saving the results from mcrt
	
	@return a string containing the filename of the written lookup table.
	Note that the string should be allocated using Modelica's allocation
	routine, so that it can deallocate it when no longer needed.
*/	
const char* RunSolsticeFunc(const char *ppath, const char *pname
	, const char *pfunc, const char *psave,  const char *field_type
	, const char *rcv_type, const char *wea_file, int argc
	, const char *varnames[], const double var[]
){
	char *retstring = NULL;
	
	PyObject *pName = NULL, *pModule = NULL, *pFunc = NULL;
	PyObject *pArgs = NULL, *pValue = NULL, *inputs = NULL;

	/*
	Final approach:
	1. if SOLARTHERM_PYTHONHOME is set, we use that. This allows us to distribute
		a binary package that accommodate's a users's setup at install time,
		without depending on MSYSTEM env vars.
	2. next, we will use a hard-wired compile time value ST_PYTHONHOME, if set.
		This will be robust for users who are compiling their own tool, and will
		also help us to support the case of direct calls from the OpenModelica
		GUI without need for explicit env vars.
	3. finally, if that is not set, we will use $MSYSTEM_PREFIX if present. 
		This is not foolproof because MSYS2 provides multiple MSYSTEM configs
		such as UCRT64, MINGW64, each of which has a different directory tree.
		If the user switches from one to the other, it will point Python to 
		potentially/probably incompatible DLLS.
	4. as a final fallback, we hardcode a probable default path, namely
		C:\msys64\mingw64.
	*/
#ifdef __MINGW32__
	PyConfig config;
	PyConfig_InitIsolatedConfig(&config);
	const char *source = "$SOLARTHERM_PYTHONHOME";
	wchar_t *prefix = _wgetenv(L"SOLARTHERM_PYTHONHOME");
#ifdef ST_PYTHONHOME
	if(!prefix){
		source = "compiled-time ST_PYTHONHOME setting";
		prefix = ST_PYTHONHOME;
	}
#endif
	if(!prefix){
		source = "$MSYSTEM_PREFIX";
		prefix = _wgetenv(L"MSYSTEM_PREFIX");
	}
	if(!prefix){
		source = "fallback default";
		prefix = L"c:\\msys64\\mingw64";
	}
	MSG("SETTING config.home TO '%ls' FROM %s",prefix,source);
	config.home = prefix;
	
#else
	// on Linux, we don't use an isolated config
	// (it is doubtful that we should be doing it on Windows too)
	PyConfig config;
	PyConfig_InitPythonConfig(&config);
#endif

	PyStatus status = Py_InitializeFromConfig(&config);
	if (PyStatus_Exception(status)) {
		Py_ExitStatusException(status);
		exit(1);
	}	

#ifdef __MINGW32__
	/*
		In MSYS2, we need to call os.add_dll_directory on the folder containing the
		Python DLL, which is c:\msys64\mingw64\bin. We create this path by 
		combining the value of `prefix` above with `bin`.
	*/
	MSG("CALCULATING DLL DIRECTORY");
    wchar_t bindir[] = L"bin";
    wchar_t binpath[MAX_PATH];
    
    // Check if the last character of baseDir is a backslash
    wchar_t *separator = (prefix[wcslen(prefix) - 1] == L'/') ? L"" : L"/";

    _snwprintf(binpath, sizeof(binpath)/sizeof(wchar_t), L"%ls%ls%ls", prefix, separator, bindir);

	//wprintf(L"Full Path: %ls\n", binpath);
	
	MSG("ADDING THE DLL DIRECTORY %ls",binpath);
	
    // Import the os module
    PyObject* os_module = PyImport_ImportModule("os");
    if (!os_module) {
        PyErr_Print();
        return NULL;
    }

    // Get the add_dll_directory function
    PyObject* func = PyObject_GetAttrString(os_module, "add_dll_directory");
    if (!func || !PyCallable_Check(func)) {
        PyErr_Print();
        return NULL;
    }

    // Call the function with the path you want to add
    PyObject* args = PyTuple_Pack(1, PyUnicode_FromWideChar(binpath,-1));
    PyObject* result = PyObject_CallObject(func, args);

    // Check for errors
    if (!result) {
        PyErr_Print();
        return NULL;
    }else{
    	MSG("SUCCESS: ADDED DLL PATH\n");
	}
	
    // Clean up
    Py_DECREF(result);
    Py_DECREF(args);
    Py_DECREF(func);
    Py_DECREF(os_module);
#endif

	// add the path of the Python function file to the system path
	PyObject *sys_path2 = PySys_GetObject("path");
	MSG("Adding to Python's sys.path: %s",ppath);
	//MSG("Current env PATH: %s",getenv("PATH"));
	//char *dylib = "c:\\msys64\\mingw64\\lib\\python3.11\\lib-dynaload
	PyList_Append(sys_path2, PyUnicode_FromString((char *)ppath));

#ifdef RUNPY_DEBUG
#define PY_SSIZE_T_CLEAN
    // Get sys.path directly
    PyObject *sys_path1 = PySys_GetObject("path");
    if(!sys_path1) {
    	MSG("FAILED TO READ SYSTEM PATH")
        PyErr_Print();
        return NULL;
    }

    // Ensure it's a list
    if (PyList_Check(sys_path1)) {
        Py_ssize_t len = PyList_Size(sys_path1);
        for (Py_ssize_t i = 0; i < len; i++) {
            PyObject *item = PyList_GetItem(sys_path1, i);
            if (PyUnicode_Check(item)) {
                MSG("SYS.PATH[%zd]: %s",i,PyUnicode_AsUTF8(item));
            }
        }
    }
    
    MSG("ENV PATH = %s",getenv("PATH"));
#endif

#if 0
#ifdef WIN32
    // Path to the .pyd file
    const char* libraryPath = "C:\\msys64\\mingw64\\lib\\python3.11\\lib-dynload\\binascii.cp311-mingw_x86_64.pyd";
	MSG("TESTING LOADLIBRARY '%s'...",libraryPath);

    // Attempt to load the library
    HMODULE hLib = LoadLibrary(libraryPath);
    if (!hLib) {
        DWORD dwError = GetLastError();
        MSG("FAILED TO LOAD LIBRARY. ERROR CODE: %lu\n", dwError);

        // Optionally, for a more descriptive error, you can use FormatMessage:
        LPVOID lpMsgBuf;
        FormatMessage(
            FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
            NULL,
            dwError,
            0, // Default language
            (LPSTR)&lpMsgBuf,
            0,
            NULL
        );
        MSG("ERROR MESSAGE: %s", (LPSTR)lpMsgBuf);
        LocalFree(lpMsgBuf);
    } else {
        MSG("LOADED SUCCESSFULLY.");
        FreeLibrary(hLib);  // Don't forget to free the loaded library
    }
#endif
#endif

#if 0
	char *testimport = "numpy";
	MSG("ATTEMPTING TO IMPORT %s", testimport);
	pName = PyUnicode_FromString(testimport);
	pModule = PyImport_Import(pName);
	if(!pModule){
		PyErr_Print();
		MSG("FAILED TO LOAD %s",testimport);
	}else{
		MSG("LOADED %s",testimport);
	}
	
	MSG("PYTHONHOME = %s",getenv("PYTHONHOME"));
	MSG("PYTHONPATH = %s",getenv("PYTHONPATH"));
#endif
	
	// ok, now import our python script...

	// name of the Python file
	pName = PyUnicode_FromString(pname);
	/* Error checking of pName left out */

	pModule = PyImport_Import(pName);
	Py_DECREF(pName);

	if(pModule != NULL){
		pFunc = PyObject_GetAttrString(pModule, pfunc);
		/* pFunc is a new reference */

		pArgs =PyTuple_New(1);

		if (pFunc && PyCallable_Check(pFunc)){
			inputs = PyDict_New();
			PyDict_SetItemString(inputs, "casedir", PyUnicode_FromString((char *)psave));
			PyDict_SetItemString(inputs, "field_type", PyUnicode_FromString((char *)field_type));
			PyDict_SetItemString(inputs, "rcv_type", PyUnicode_FromString((char *)rcv_type));
			PyDict_SetItemString(inputs, "wea_file", PyUnicode_FromString((char *)wea_file));
			for (int i = 0; i < argc; ++i) {

				pValue = PyFloat_FromDouble(var[i]);

				if(!pValue){
					fprintf(stderr, "Cannot convert argument\n");
				}
				/* pValue reference stolen here: */
				PyDict_SetItemString(inputs, varnames[i], pValue);
			}

			PyTuple_SetItem(pArgs, 0, inputs);

			pValue = PyObject_CallObject(pFunc, pArgs);

			if(pValue){
				char *tablenamestr; //the file of the lookup table
				size_t tablenamelen;			
				PyBytes_AsStringAndSize(pValue,&tablenamestr,&tablenamelen);
				retstring = ModelicaAllocateString(tablenamelen);
				strcpy(retstring,tablenamestr);
				Py_DECREF(pValue);
			}else{
				PyErr_Print();
				MSG("Call failed: NULL value returned from PyObject_CallObject");
			}			

			Py_DECREF(inputs);
		}else{
			if(PyErr_Occurred())PyErr_Print();
			fprintf(stderr, "Cannot find function \"%s\"\n", pfunc);
		}
	}else{
		PyErr_Print();
		fprintf(stderr, "Failed to load \"%s\"\n", pname);
	}
	
	Py_XDECREF(pArgs);
	Py_XDECREF(pFunc);
	Py_XDECREF(pModule);
	Py_Finalize();
	return retstring;
}

// vim: ts=4:sw=4:tw=80:noet
