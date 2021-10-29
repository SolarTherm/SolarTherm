#include <stdlib.h>
#include <stdio.h>
#include "tensorflow/c/c_api.h"
#include "neural-network/surrogate2.h"
#include <assert.h>

void predict_wrap(const Session_Props_multi_output* , double* , const double [], const double [], const double [], const double [], int inputsize, int , int , double, double* );

void *load_session_multi_output(char* saved_model_dir)
{
    //*********************Adjust the logging of tensorflow by setting a variable 
    //*********************in the environment called TF_CPP_MIN_LOG_LEVEL
    char *var = "TF_CPP_MIN_LOG_LEVEL=0";
    int ret;
    ret = putenv(var);

    //*********************Allocate dynamic memory from the heap for Session_Props data struct 
    Session_Props_multi_output *sess = malloc(sizeof(Session_Props_multi_output));

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

void run_surrogate_multi_output(const Session_Props_multi_output *sess, const double raw_input[], int inputsize, int outputsize, const double X_max[], const double X_min[], const double Y_max[], const double Y_min[], double time_simul, int node, double* res)
{
    //*********************Read input struct
    TF_Session* Session = sess->Session;
    TF_Graph* Graph = sess->Graph;
    TF_SessionOptions* SessionOpts = sess->SessionOpts;
    TF_Status* Status = sess->Status;
    TF_Buffer* RunOpts = sess->RunOpts;
    
    //*********************Grab the input tensor graph from the loaded session
    int NumInputs = 1; // number of input tensor
    TF_Output* Input = malloc(sizeof(TF_Output*)*NumInputs); //allocate memory for input tensor (dType TF_Output)
    TF_Output t0 = {TF_GraphOperationByName(Graph,"serving_default_Input_input"),0}; 
    TF_Output t00 = {TF_GraphOperationByName(Graph,"serving_default_dense_input"),0}; //take the input tensor from loaded model
    TF_Output t000 = {TF_GraphOperationByName(Graph,"serving_default_input_1"),0}; //take the input tensor from loaded model

    if(t00.oper != NULL)
    {
        Input[0] = t00;
    }
    else if(t0.oper != NULL)
    {
        Input[0] = t0;
    }
    else if(t000.oper != NULL)
    {
        Input[0] = t000;
    }
    else
    {
        fprintf(stderr,"FAILED TO IDENTIFY INPUT TENSOR SIGNATURE NAME\nHAVE TRIED: serving_default_dense_input and serving_default_Input_input");
        exit(EXIT_FAILURE);
    }

    //*********************Grab the output tensor graph from the loaded session
    int NumOutputs = 1; // number of output tensor
    TF_Output* Output = malloc(sizeof(TF_Output*)*NumOutputs); //allocate memory for output tensor (dType TF_Output)
    TF_Output t2 = {TF_GraphOperationByName(Graph,"StatefulPartitionedCall"),0}; //take the output tensor from loaded model

    if(t2.oper == NULL)
    {
        printf("ERROR: Failed TF_GraphOperationByName StatefulPartitionedCall\n");
    }

    Output[0] = t2;

    
    //********* Initalisation of Tensors
    /*
    INPUT TENSOR
    */

    //TF_Tensor** InputValues = (TF_Tensor**)malloc(sizeof(TF_Tensor*)*NumInputs);

    TF_Tensor** InputValues = malloc(sizeof(TF_Tensor*)*NumInputs); //==>placeholder for the INPUT TENSOR
    //********* Populating input Tensor
    int numData = inputsize; //==> number of data input from Modelica
    int tensor_dimensionality = 2; //==> dimensionality of the input tensor (2 for 2D tensor,3 for 3D tensor. Regression usually use 2D)
    int64_t dims_in[] = {1,numData}; //==> size of the input Tensor (row x col) ~ i row x j column ~ from saved_model_cli

    //*********************Pre-processing the input - normalisation of the input using Min Max Scaler
    //Allocate memory for the input to the INPUT TENSOR
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
    int memdatain = numData * sizeof(float); // memory allocation ~ numData * data_type. if we have 2by2 input, then we have 4 numdata

    TF_Tensor* INPUT_TENSOR = TF_NewTensor(
        TF_FLOAT, dims_in, tensor_dimensionality, 
        data, memdatain, 
        &NoOpDeallocator_multi_output, 0
        );

    if (INPUT_TENSOR == NULL)
    {
	    printf("ERROR: Failed TF_NewTensor\n");
    }

    InputValues[0] = INPUT_TENSOR;

    /*
    OUTPUT TENSOR
    */

    TF_Tensor** OutputValues = malloc(sizeof(TF_Tensor*)*NumOutputs);
    //********* Populating input Tensor
    int64_t dims_out[] = {1,outputsize}; //==> size of the ouyput Tensor (row x col) ~ i row x j column ~ from saved_model_cli
	
	//Allocate memory for data inside the Input Tensor
    int memdataout = outputsize * sizeof(float); // memory allocation ~ numData * data_type. if we have 2by2 input, then we have 4 numdata

    TF_Tensor* OUTPUT_TENSOR = TF_NewTensor(
        TF_FLOAT, dims_out, tensor_dimensionality, 
        NULL, memdataout, 
        &NoOpDeallocator_multi_output, 0
        );

    if (OUTPUT_TENSOR == NULL)
    {
	    printf("ERROR: Failed TF_NewTensor\n");
    }

    OutputValues[0] = OUTPUT_TENSOR;

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
    //double* res = malloc(sizeof(double*)*NumOutputs);
    void* buff = TF_TensorData(OutputValues[0]);
    float* offsets;
    for(size_t i=0;i<outputsize;i++)
    { 
        offsets = buff;
        //scale back the output to the original value
        res[i] = offsets[i] * (Y_max[i]-Y_min[i]) + Y_min[i];

    }
	
	//printf("time= %f	node= %d\ndhf/dt = %f	dhp/dt = %f\n",time_simul,node,res[0],res[1]);
    
    free(InputValues);
    free(OutputValues);
    free(Output);
    free(Input);
    free(data);
    free(buff);
}

double run_surrogate_single_output(const Session_Props_multi_output *sess, const double raw_input[], int inputsize, int outIndex, const double X_max[], const double X_min[], const double Y_max, const double Y_min)
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
    TF_Output t000 = {TF_GraphOperationByName(Graph,"serving_default_input_1"),0}; //take the input tensor from loaded model

    if(t00.oper != NULL)
    {
        Input[0] = t00;
    }
    else if(t0.oper != NULL)
    {
        Input[0] = t0;
    }
    else if(t000.oper != NULL)
    {
        Input[0] = t000;
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
        fprintf(stderr,"ERROR: Failed TF_GraphOperationByName StatefulPartitionedCall\n");
    }
    
    Output[0] = t2;

    //********* Initalisation of Tensor to parse input and outputpredict
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

    TF_Tensor* int_tensor = TF_NewTensor(TF_FLOAT, dims, tensor_dimensionality, data, memdata, &NoOpDeallocator_multi_output, 0);

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
    double res = offsets[outIndex] * (Y_max-Y_min) + Y_min;
    
    free(InputValues);
    free(OutputValues);
    free(Output);
    free(Input);
    free(data);
    free(buff);

    return res; 
}

void predict_wrap(const Session_Props_multi_output* sess, double* X, const double X_max[], const double X_min[], const double y_max[], const double y_min[], int inputsize, int discretisation, int outputsize, double time, double* out)
{
    /*Initialise array to contain X_raw and output of the ANN*/
    double* X_raw = malloc(sizeof(double*)*inputsize);
    double* out_temp = malloc(sizeof(double*)*outputsize);	

	for(size_t i=0; i<discretisation;i++)
    {
		for(size_t j=0; j<inputsize; j++)
        {
			/*Take the raw value from the given input matrix X*/
            //Remember that X is pointer to the base address of the array as such it must be dereferenced using * at the front
			X_raw[j] = *((X+i*inputsize)+j);
            
		}
        
        /*Call NN multi out*/
        run_surrogate_multi_output(
            sess, X_raw, inputsize, outputsize, X_max, X_min, y_max, y_min, 0.0, 0.0, out_temp
        );	
        
        /*Assign the NN results to out matrix Nf x outputsize*/
        //Remember that the out is the base address of the array
        out[i*outputsize+0] = out_temp[0];
        out[i*outputsize+1] = out_temp[1];
	}  
    
    /*Printing the out matrix*/    
    //fprintf(stderr,"Time simul: %f\n",time);
    free(X_raw); 
    free(out_temp);
    	
}

void free_surrogate_multi_output(Session_Props_multi_output *sess)
{
    free(sess);
}
    
