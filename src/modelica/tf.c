#include <stdlib.h>
#include <stdio.h>
#include <tensorflow/c/c_api.h>

#define NEW(TYPE) (TYPE*)malloc(sizeof(TYPE))
#define NEW_ARRAY(TYPE,SIZE) (TYPE*)malloc(sizeof(TYPE)*(SIZE))

typedef struct  /*Struct to store neccesary session properties*/
{
    TF_Session* session;
    TF_Graph* graph;
    TF_Status* status;
    //TF_SessionOptions* SessionOpts;
    //TF_Buffer* RunOpts;
}Session_Props_multi_output;

void NoOpDeallocator_multi_output(void* data, size_t a, void* b) {}

void *load_session_multi_output(char* saved_model_dir){
	/* Adjust the logging of tensorflow by setting a variable 
	in the environment called TF_CPP_MIN_LOG_LEVEL */
	char *var = "TF_CPP_MIN_LOG_LEVEL=0";
	putenv(var);

	// Allocate dynamic memory from the heap for Session_Props data struct 
	Session_Props_multi_output *sess = NEW(Session_Props_multi_output);

	// Instantiate Session Properties
	sess->graph = TF_NewGraph();
	sess->status = TF_NewStatus();
	
	TF_SessionOptions* options = TF_NewSessionOptions();
	TF_Buffer* runopts = NULL;

	const char* tags = "serve"; // default model serving tag
	int ntags = 1;

	sess->session = TF_LoadSessionFromSavedModel(
			options, runopts, saved_model_dir, &tags, ntags, sess->graph, NULL, sess->status
		);

	if(TF_GetCode(sess->status) == TF_OK){
		printf("TF Loading Pre-Trained Model : Complete!\n");
	}else{
		printf("%s",TF_Message(sess->status));
	}

	return sess;
}

void run_surrogate_multi_output(const Session_Props_multi_output *sess
	,const double raw_input[], int inputsize, int outputsize
	,const double X_max[], const double X_min[], const double Y_max[]
	,const double Y_min[], double* res
){
	// Grab the input tensor graph from the loaded session
	int NumInputs = 1; // number of input tensor
	TF_Output* Input = NEW_ARRAY(TF_Output,NumInputs); //allocate memory for input tensor (dType TF_Output)
	TF_Output t0 = {TF_GraphOperationByName(sess->graph,"serving_default_Input_input"),0}; //take the input tensor from loaded model

	if(t0.oper == NULL){
		printf("ERROR: Failed TF_GraphOperationByName serving_default_Input_input\n");
	}

	Input[0] = t0;

	// Grab the output tensor graph from the loaded session
	int NumOutputs = 1; // number of output tensor
	TF_Output* Output = NEW_ARRAY(TF_Output,NumOutputs); //allocate memory for output tensor (dType TF_Output)
	TF_Output t2 = {TF_GraphOperationByName(sess->graph,"StatefulPartitionedCall"),0}; //take the output tensor from loaded model

	if(t2.oper == NULL){
		printf("ERROR: Failed TF_GraphOperationByName StatefulPartitionedCall\n");
	}

	Output[0] = t2;

	// Initalisation of Tensors

	/*
	INPUT TENSOR
	*/

	TF_Tensor** InputValues = NEW_ARRAY(TF_Tensor*,NumInputs); //==>placeholder for the INPUT TENSOR
	int numData = inputsize; //==> number of data input from Modelica
	int tensor_dimensionality = 2; //==> dimensionality of the input tensor (2 for 2D tensor,3 for 3D tensor. Regression usually use 2D)
	int64_t dims_in[] = {1,numData}; //==> size of the input Tensor (row x col) ~ i row x j column ~ from saved_model_cli

	// Pre-processing the input - normalisation of the input using Min Max Scaler
	//Allocate memory for the input to the INPUT TENSOR
	float* data = NEW_ARRAY(float,numData); //==> where the input from modelica is gonna be inserted
	for(size_t i=0; i<inputsize; i++){
		data[i] = (raw_input[i] - X_min[i]) / (X_max[i]-X_min[i]);
	}

	//Allocate memory for data inside the Input Tensor
	int memdatain = numData * sizeof(float); // memory allocation ~ numData * data_type. if we have 2by2 input, then we have 4 numdata

	TF_Tensor* INPUT_TENSOR = TF_NewTensor(
			TF_FLOAT, dims_in, tensor_dimensionality, 
			data, memdatain, &NoOpDeallocator_multi_output, 0
		);

	if (INPUT_TENSOR == NULL){
		printf("ERROR: Failed TF_NewTensor\n");
	}

	InputValues[0] = INPUT_TENSOR;

	/* OUTPUT TENSOR */

	TF_Tensor** OutputValues = NEW_ARRAY(TF_Tensor*,NumOutputs);
	// Populating input Tensor
	int64_t dims_out[] = {1,outputsize}; //==> size of the ouyput Tensor (row x col) ~ i row x j column ~ from saved_model_cli

	// Allocate memory for data inside the Input Tensor
	int memdataout = outputsize * sizeof(float); // memory allocation ~ numData * data_type. if we have 2by2 input, then we have 4 numdata

	TF_Tensor* OUTPUT_TENSOR = TF_NewTensor(
			TF_FLOAT, dims_out, tensor_dimensionality, 
			NULL, memdataout, &NoOpDeallocator_multi_output, 0
		);

	if (OUTPUT_TENSOR == NULL){
		printf("ERROR: Failed TF_NewTensor\n");
	}

	OutputValues[0] = OUTPUT_TENSOR;

	//********* Run the session
	TF_SessionRun(sess->session, NULL, Input, InputValues
			,NumInputs, Output, OutputValues, NumOutputs, NULL, 0,NULL, sess->status
		);

	if(TF_GetCode(sess->status) != TF_OK){
		printf("%s",TF_Message(sess->status));
	}

	// Extracting output
	void* buff = TF_TensorData(OutputValues[0]);
	float* offsets;
	for(size_t i=0;i<outputsize;i++){ 
		offsets = buff;
		//scale back the output to the original value
		res[i] = offsets[i] * (Y_max[i]-Y_min[i]) + Y_min[i];
	}

	free(InputValues);
	free(OutputValues);
	free(Output);
	free(Input);
	free(data);
	free(buff);
}

void free_surrogate_multi_output(Session_Props_multi_output *sess){
	free(sess);
}

// vim: ts=4:sw=4:noet
