#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <assert.h>

#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>

int main(int argc, char *argv[]){

	ERR_load_crypto_strings();
	OpenSSL_add_all_algorithms();
	OPENSSL_config(NULL);
	
	
	EVP_cleanup();
	CRYPTO_cleanup_all_ex_data();
	ERR_free_strings();





    assert(argc>=1);
    wchar_t *program = Py_DecodeLocale(argv[0], NULL);
    if (program == NULL) {
        fprintf(stderr, "Fatal error: cannot decode argv[0]\n");
        exit(1);
    }
    Py_SetProgramName(program);  /* optional but recommended */
    Py_Initialize();
    PyRun_SimpleString("import hashlib\n");
    PyRun_SimpleString("print(hashlib.sha224(b\"Nobody inspects the spammish repetition\").hexdigest());\n");    
    PyRun_SimpleString("import numpy as np;print(np.array([1,2]));\n");
    if (Py_FinalizeEx() < 0) {
        exit(120);
    }
    PyMem_RawFree(program);
    return 0;
}
