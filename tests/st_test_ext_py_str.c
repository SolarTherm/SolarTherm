#include "st_test_ext_py_str.h"

#include <Python.h>

int myextfunc(const char *code){
  Py_Initialize();
  PyRun_SimpleString(code);
  Py_Finalize();
  return 15;
}

