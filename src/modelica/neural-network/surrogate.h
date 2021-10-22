#include <stdlib.h>
#include <stdio.h>
#include "c_api.h" //tensorflow c api header files located in /usr/include/tensorflow/c/

typedef struct  /*Struct to store neccesary session properties*/
{
    TF_Session* Session;
    TF_Graph* Graph;												
    TF_Status* Status;																
    TF_SessionOptions* SessionOpts;
    TF_Buffer* RunOpts;
}Session_Props_Static_ANN; 

void NoOpDeallocatorStaticANN(void* data, size_t a, void* b);

void *load_session_static_ANN(char*);

double run_surrogate(const Session_Props_Static_ANN*, const double [], int, 
                     const double [], const double [], const double , const double );

void free_surrogate(Session_Props_Static_ANN*);





   /*
    API TensorFlow - C to call pre-trained model produced by Python using Tensorflow.Keras

    As it is written, no official documentation has been released by TensorFlow. This code is based on:
    https://github.com/AmirulOm/tensorflow_capi_sample
    
    > More on tensor dimension: https://stackoverflow.com/questions/50370966/tensorflow-c-api-how-to-modify-the-value-in-tensor

    > HOW TO GET INPUT TENSOR NAME AND INPUT-OUPUT TENSOR DIMENSION? USE SAVED_MODEL_CLI more on: 
    https://medium.com/@yuu.ishikawa/how-to-show-signatures-of-tensorflow-saved-model-5ac56cf1960f

	/home/philgun/.local/lib/python2.7/site-packages/bin/saved_model_cli show --dir surrogate_receiver --all
   */
