#include <stdlib.h>
#include <stdio.h>
#include "tensorflow/c/c_api.h"
#include "neural-network/surrogate.h"

void *load_session(char* saved_model_dir)
{
    //*********************Adjust the logging of tensorflow by setting a variable 
    //*********************in the environment called TF_CPP_MIN_LOG_LEVEL
    char *var = "TF_CPP_MIN_LOG_LEVEL=0";
    int ret;
    ret = putenv(var);

    //*********************Allocate dynamic memory from the heap for Session_Props data struct 
    Session_Props *sess = malloc(sizeof(Session_Props));

    //*********************Instantiate Session Properties
    TF_Graph* Graph = TF_NewGraph();
    TF_Status* Status = TF_NewStatus();
    TF_SessionOptions* SessionOpts = TF_NewSessionOptions();
    TF_Buffer* RunOpts = NULL;

    const char* tags = "serve"; // default model serving tag
    int ntags = 1;

    TF_Session* Session = TF_LoadSessionFromSavedModel
    (
        SessionOpts, 
        RunOpts, 
        saved_model_dir, 
        &tags, 
        ntags, 
        Graph, 
        NULL, 
        Status
    );
    
    if(TF_GetCode(Status) == TF_OK)
    {
        printf("TF Loading Pre-Trained Model : Complete!\n");
    }
    else
    {
        printf("%s",TF_Message(Status));
    }
    
    //***************************Populate the struct
    sess->Graph = Graph;
    sess->Session = Session;
    sess->Status = Status;
    sess->SessionOpts = SessionOpts;
    sess->RunOpts = RunOpts;

    return sess;
}

double run_surrogate(const Session_Props *sess, const double raw_input[], int inputsize, 
                    double time, const double X_max[], const double X_min[], const double Y_max, const double Y_min)
{
    
    //*********************Read input struct
    TF_Session* Session = sess->Session;
    TF_Graph* Graph = sess->Graph;
    TF_SessionOptions* SessionOpts = sess->SessionOpts;
    TF_Status* Status = sess->Status;
    TF_Buffer* RunOpts = sess->RunOpts;
    
    //*********************Get input tensor
    int NumInputs = 1; // number of input tensor
    TF_Output* Input = malloc(sizeof(TF_Output*)*NumInputs); //allocate memory for input tensor (dType TF_Output)
    TF_Output t0 = {TF_GraphOperationByName(Graph,"serving_default_Input_input"),0}; //take the input tensor from loaded model

    if(t0.oper == NULL)
    {
        printf("ERROR: Failed TF_GraphOperationByName serving_default_Input_input\n");
    }

    Input[0] = t0; // assign to allocated memory Input

    //*********************Get output tensor
    int NumOutputs = 1;
    TF_Output* Output = malloc(sizeof(TF_Output) * NumOutputs); //allocate memory for output tensor (dType TF_Output)

    TF_Output t2 = {TF_GraphOperationByName(Graph,"StatefulPartitionedCall"),0}; //take the output tensor from loaded model

    if(t2.oper == NULL)
    {
        printf("ERROR: Failed TF_GraphOperationByName StatefulPartitionedCall\n");
    }
    
    Output[0] = t2; // assign to allocated memory Output

    //********* Allocate data for inputs & outputs
    TF_Tensor** InputValues = (TF_Tensor**)malloc(sizeof(TF_Tensor*)*NumInputs);
    TF_Tensor** OutputValues = malloc(sizeof(TF_Tensor*)*NumOutputs);

    //********* Creating input tensor ~ memory allocation and inserting input
    int numData = inputsize; //==> number of data input from Modelica
    int tensor_dimensionality = 2; //==> dimensionality of the input tensor (2 for 2D tensor,3 for 3D tensor. Regression usually use 2D)
    int64_t dims[] = {1,numData}; //==> size of the input (row x col) ~ i row x j column ~ from saved_model_cli

    //*********************Scaler ~ to scaledown the input
    //const float X_max[4] = {850e6, 318.15,833.15,45};
    //const float X_min[4] = {280e6, 268.15,803.15,23};

    //const float Y_max = 0.964303;
    //const float Y_min = 0.427611;

    //Allocate memory for scaled input
    float* input = malloc(sizeof(float*)*inputsize);

    //scaling down input and assign to the new allocated memory
    for(size_t i=0; i<inputsize; i++)
    {
        input[i] = (raw_input[i] - X_min[i]) / (X_max[i]-X_min[i]);
    }

    float* data = malloc(sizeof(float*)*numData); //==> where the input from modelica is gonna be inserted
    for(size_t i=0;i<numData;i++) /*populating the data*/
    {
        data[i] = input[i]; //inserting scaled input into data
    }

    int memdata = numData * sizeof(float); // memory allocation ~ numData * data_type. if we have 2by2 input, then we have 4 numdata

    TF_Tensor* int_tensor = TF_NewTensor(TF_FLOAT, dims, tensor_dimensionality, data, memdata, &NoOpDeallocator, 0);

    if (int_tensor == NULL)
    {
	    printf("ERROR: Failed TF_NewTensor\n");
    }

    InputValues[0] = int_tensor;

    //********* Run the session
    TF_SessionRun(Session, NULL, Input, InputValues, NumInputs, Output, OutputValues, NumOutputs, NULL, 0,NULL , Status);

    if(TF_GetCode(Status) != TF_OK)
    {
        printf("%s",TF_Message(Status));
    }
    void* buff = TF_TensorData(OutputValues[0]);
    float* offsets = buff;
    double res = offsets[0] * (Y_max-Y_min) + Y_min;
    
    free(InputValues);
    free(OutputValues);
    free(Output);
    free(Input);
    free(data);
    free(input);
    free(buff);
    return res; 
}

void free_surrogate(Session_Props *sess)
{
    free(sess);
}
    
