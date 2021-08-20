#ifndef ST_TEST_EXT_PY_STR
#define ST_TEST_EXT_PY_STR

#include <Python.h>

int TestExternalPy_string(const char *code);


int TestExternalPy_string(const char *code)
{
  Py_Initialize();
  PyRun_SimpleString(code);
  Py_Finalize();
  return 15;
}

#endif
