#include <stdlib.h>
#include <stdio.h>
#include <tensorflow/c/c_api.h>


typedef struct  /*Struct to store neccesary session properties*/
{
    TF_Session* Session;
    TF_Graph* Graph;
    TF_Status* Status;
    TF_SessionOptions* SessionOpts;
    TF_Buffer* RunOpts;
}Session_Props_multi_output;

void NoOpDeallocator_multi_output(void* data, size_t a, void* b) {}

void *load_session_multi_output(char*);

void run_surrogate_multi_output(const Session_Props_multi_output*, const double [], int, int, 
                     const double [], const double [], const double[], const double[], double*);

void free_surrogate_multi_output(Session_Props_multi_output*);

// vim: ts=4:sw=4:et
