#include <stdlib.h>
#include <stdio.h>
#include "tensorflow/c/c_api.h"
#include "neural-network/surrogate.h"

void NoOpDeallocatorStaticANN(void* data, size_t a, void* b)
{
	/*Nothing here*/
}

void *load_session_static_ANN(char* saved_model_dir)
{
    //*********************Adjust the logging of tensorflow by setting a variable 
    //*********************in the environment called TF_CPP_MIN_LOG_LEVEL
    char *var = "TF_CPP_MIN_LOG_LEVEL=0";
    int ret;
    ret = putenv(var);

    //*********************Allocate dynamic memory from the heap for Session_Props data struct 
    Session_Props_Static_ANN *sess = malloc(sizeof(Session_Props_Static_ANN));

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

double run_surrogate(const Session_Props_Static_ANN *sess, const double raw_input[], int inputsize, const double X_max[], const double X_min[], const double Y_max, const double Y_min)
{
    
    //*********************Read input struct
    TF_Session* Session = sess->Session;
    TF_Graph* Graph = sess->Graph;
    TF_SessionOptions* SessionOpts = sess->SessionOpts;
    TF_Status* Status = sess->Status;
    TF_Buffer* RunOpts = sess->RunOpts;
    
    //*********************Input Holder Initialisation
    int NumInputs = 1; // number of input tensor
    TF_Output* Input = malloc(sizeof(TF_Output*)*NumInputs); //allocate memory for input tensor (dType TF_Output)
    TF_Output t0 = {TF_GraphOperationByName(Graph,"serving_default_Input_input"),0}; //take the input tensor from loaded model
    TF_Output t00 = {TF_GraphOperationByName(Graph,"serving_default_dense_input"),0}; //take the input tensor from loaded model

    if(t0.oper == NULL & t00.oper != NULL)
    {
        Input[0] = t00;
    }
    else if(t00.oper == NULL & t0.oper != NULL)
    {
        Input[0] = t0;
    }
    else
    {
        fprintf(stderr,"FAILED TO IDENTIFY INPUT TENSOR SIGNATURE NAME\nHAVE TRIED: serving_default_dense_input and serving_default_Input_input");
        exit(EXIT_FAILURE);
    }

    //*********************Output Holder Initialisation
    int NumOutputs = 1;
    TF_Output* Output = malloc(sizeof(TF_Output) * NumOutputs); //allocate memory for output tensor (dType TF_Output)

    TF_Output t2 = {TF_GraphOperationByName(Graph,"StatefulPartitionedCall"),0}; //take the output tensor from loaded model

    if(t2.oper == NULL)
    {
        printf("ERROR: Failed TF_GraphOperationByName StatefulPartitionedCall\n");
    }
    
    Output[0] = t2;

    //********* Initalisation of Tensor to parse input and output
    TF_Tensor** InputValues = (TF_Tensor**)malloc(sizeof(TF_Tensor*)*NumInputs);
    TF_Tensor** OutputValues = malloc(sizeof(TF_Tensor*)*NumOutputs);

    //********* Populating input Tensor
    int numData = inputsize; //==> number of data input from Modelica
    int tensor_dimensionality = 2; //==> dimensionality of the input tensor (2 for 2D tensor,3 for 3D tensor. Regression usually use 2D)
    int64_t dims[] = {1,numData}; //==> size of the input Tensor (row x col) ~ i row x j column ~ from saved_model_cli

    //*********************Pre-processing the input - normalisation of the input using Min Max Scaler
    //Allocate memory for scaled input
    float* data = malloc(sizeof(float*)*numData); //==> where the input from modelica is gonna be inserted
    for(size_t i=0; i<inputsize; i++)
    {
        if(X_max[i]==X_min[i])
        {
            data[i] = 0;
        }
        else
        {
            data[i] = (raw_input[i] - X_min[i]) / (X_max[i]-X_min[i]);
        }
        
    }
	
	//Allocate memory for data inside the Input Tensor
    int memdata = numData * sizeof(float); // memory allocation ~ numData * data_type. if we have 2by2 input, then we have 4 numdata

    TF_Tensor* int_tensor = TF_NewTensor(TF_FLOAT, dims, tensor_dimensionality, data, memdata, &NoOpDeallocatorStaticANN, 0);

    if (int_tensor == NULL)
    {
	    printf("ERROR: Failed TF_NewTensor\n");
    }

    InputValues[0] = int_tensor;

    //********* Run the session
    TF_SessionRun(
		Session, 
		NULL, 
		Input, InputValues, NumInputs, 
		Output, OutputValues, NumOutputs, 
		NULL, 0,NULL , Status);

    if(TF_GetCode(Status) != TF_OK)
    {
        printf("%s",TF_Message(Status));
    }

	//Extracting output
    void* buff = TF_TensorData(OutputValues[0]);
    float* offsets = buff;
	//scale back the output to the original value
    double res = offsets[0] * (Y_max-Y_min) + Y_min;
    
    free(InputValues);
    free(OutputValues);
    free(Output);
    free(Input);
    free(data);
    free(buff);
    return res; 
}

void free_surrogate(Session_Props_Static_ANN *sess)
{

	TF_DeleteSession(sess->Session,sess->Status);
    TF_DeleteGraph(sess->Graph);
    TF_DeleteStatus(sess->Status);
    TF_DeleteSessionOptions(sess->SessionOpts);
    TF_DeleteBuffer(sess->RunOpts);
    free(sess);
}
    
