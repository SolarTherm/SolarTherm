#include <stdlib.h>
#include <stdio.h>
#include "tensorflow/c/c_api.h"

/*UNIT MEASUREMENT OF THE INPUTS
q = W
tamb = K
tin = K
output:
mdot = kg/s
                    	q         tamb    tin
float raw_input[3] = {288550000, 268.15, 798.15}
*/


void NoOpDeallocator(void* data, size_t a, void* b) {}
double st_surrogate(double [], int , char*);

double st_surrogate(double raw_input[], int inputsize, char* saved_model_dir)
{
    /*
    API TensorFlow - C to call pre-trained model produced by Python using Tensorflow.Keras

    As it is written, no official documentation has been released by TensorFlow. This code is based on:
    https://github.com/AmirulOm/tensorflow_capi_sample
    
    > More on tensor dimension: https://stackoverflow.com/questions/50370966/tensorflow-c-api-how-to-modify-the-value-in-tensor

    > HOW TO GET INPUT TENSOR NAME AND INPUT-OUPUT TENSOR DIMENSION? USE SAVED_MODEL_CLI more on: 
    https://medium.com/@yuu.ishikawa/how-to-show-signatures-of-tensorflow-saved-model-5ac56cf1960f
    */

    //*********************Scaler ~ to scaledown the input
    const float X_max[3] = {850000000, 318.15,833.15};
    const float X_min[3] = {280000000, 268.15,798.15};

    const float Y_max = 1957.150628;
    const float Y_min = 31.976643;

    //Allocate memory for scaled input
    float* input = malloc(sizeof(float*)*inputsize);

    //scaling down input and assign to the new allocated memory
    for(size_t i=0; i<inputsize; i++)
    {
        input[i] = (raw_input[i] - X_min[i]) / (X_max[i]-X_min[i]);
    }

    //*********************Read Model
    TF_Graph* Graph = TF_NewGraph();
    TF_Status* Status = TF_NewStatus();

    TF_SessionOptions* SessionOpts = TF_NewSessionOptions();
    TF_Buffer* RunOpts = NULL;

    const char* tags = "serve"; // default model serving tag
    int ntags =1;

    TF_Session* Session = TF_LoadSessionFromSavedModel(SessionOpts, RunOpts, saved_model_dir, &tags,ntags, Graph, NULL, Status);

    //*********************Get input tensor
    int NumInputs = 1; // number of input tensor
    TF_Output* Input = malloc(sizeof(TF_Output*)*NumInputs); //allocate memory for input tensor (dType TF_Output)

    TF_Output t0 = {TF_GraphOperationByName(Graph,"serving_default_Input_input"),0}; //take the input tensor from loaded model

    Input[0] = t0; // assign to allocated memory Input

    //*********************Get output tensor
    int NumOutputs = 1;
    TF_Output* Output = malloc(sizeof(TF_Output) * NumOutputs); //allocate memory for output tensor (dType TF_Output)

    TF_Output t2 = {TF_GraphOperationByName(Graph,"StatefulPartitionedCall"),0}; //take the output tensor from loaded model
    
    Output[0] = t2; // assign to allocated memory Output

    //********* Allocate data for inputs & outputs
    TF_Tensor** InputValues = (TF_Tensor**)malloc(sizeof(TF_Tensor*)*NumInputs);
    TF_Tensor** OutputValues = malloc(sizeof(TF_Tensor*)*NumOutputs);

    //********* Creating inpur tensor ~ memory allocation and inserting input
    int numData = inputsize; //==> number of data input from Modelica
    int tensor_dimensionality = 2; //==> dimensionality of the input tensor (2 for 2D tensor,3 for 3D tensor. Regression usually use 2D)
    int64_t dims[] = {1,numData}; //==> size of the input (row x col) ~ i row x j column ~ from saved_model_cli

    float* data = malloc(sizeof(float*)*numData); //==> where the input from modelica is gonna be inserted
    for(size_t i=0;i<numData;i++) /*populating the data*/
    {
        data[i] = input[i]; //inserting scaled input into data
    }

    int memdata = numData * sizeof(float); // memory allocation ~ numData * data_type. if we have 2by2 input, then we have 4 numdata

    TF_Tensor* int_tensor = TF_NewTensor(TF_FLOAT, dims, tensor_dimensionality, data, memdata, &NoOpDeallocator, 0);

    InputValues[0] = int_tensor;

    //********* Run the session
    TF_SessionRun(Session, NULL, Input, InputValues, NumInputs, Output, OutputValues, NumOutputs, NULL, 0,NULL , Status);

    //********* Free memory
    TF_DeleteGraph(Graph);
    TF_DeleteSession(Session, Status);
    TF_DeleteSessionOptions(SessionOpts);
    TF_DeleteStatus(Status);

    void* buff = TF_TensorData(OutputValues[0]);
    float* offsets = buff;
    double res = offsets[0] * (Y_max-Y_min) + Y_min;
    printf("Y_predicted: %f [kg/s]\n",res);

    free(InputValues);
    free(OutputValues);
    free(Output);
    free(Input);
    free(data);
    free(input);
    free(buff);
    return res; 
}

