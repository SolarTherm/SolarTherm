#include <stdlib.h>
#include <stdio.h>
#include "tensorflow/c/c_api.h"

typedef struct  /*Struct to store neccesary session properties*/
{
    TF_Session* Session;
    TF_Graph* Graph;
    TF_Status* Status;
    TF_SessionOptions* SessionOpts;
    TF_Buffer* RunOpts;
}Session_Props;

void NoOpDeallocator(void* data, size_t a, void* b) {}

void *load_session(char*);

double run_surrogate(const Session_Props*, const double [], int, 
                     const double [], const double [], const double , const double );

void free_surrogate(Session_Props*);





   /*
    API TensorFlow - C to call pre-trained model produced by Python using Tensorflow.Keras

    As it is written, no official documentation has been released by TensorFlow. This code is based on:
    https://github.com/AmirulOm/tensorflow_capi_sample
    
    > More on tensor dimension: https://stackoverflow.com/questions/50370966/tensorflow-c-api-how-to-modify-the-value-in-tensor

    > HOW TO GET INPUT TENSOR NAME AND INPUT-OUPUT TENSOR DIMENSION? USE SAVED_MODEL_CLI more on: 
    https://medium.com/@yuu.ishikawa/how-to-show-signatures-of-tensorflow-saved-model-5ac56cf1960f
   */