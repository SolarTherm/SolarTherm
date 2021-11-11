#include "ann.h"
#include "util.h"
#include "sscpb.h"

#include <stdio.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>

//#define ST_SSCPB_DEBUG
#ifdef ST_ANN_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif
#define ERR(FMT,...) fprintf(stderr,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)

//********************* SEQUENCE 3.2
double predict_ANN(Session_Props *sess, const double raw_input[], int which_ANN_model){
	double* inputs = NEW_ARRAY(double,sess->inputsize);

	for(int i=0;i<sess->inputsize;i++){
		inputs[i] = sess->base_values[i] - raw_input[i];
	}

	//*********************Read input struct
	TF_Session* Session = sess->Session;
	TF_Graph* Graph = sess->Graph;
	//TF_SessionOptions* SessionOpts = sess->SessionOpts;
	TF_Status* Status = sess->Status;
	//TF_Buffer* RunOpts = sess->RunOpts;

	//*********************Input Holder Initialisation
	int NumInputs = 1; // number of input tensor
	TF_Output* Input = NEW_ARRAY(TF_Output,NumInputs); //allocate memory for input tensor (dType TF_Output)
	TF_Output t0 = {TF_GraphOperationByName(Graph,"serving_default_Input_input"),0}; //take the input tensor from loaded model

	if(t0.oper == NULL){
		ERR("Failed TF_GraphOperationByName serving_default_Input_input");
	}

	Input[0] = t0;

	//*********************Output Holder Initialisation
	int NumOutputs = 1;
	TF_Output* Output = NEW_ARRAY(TF_Output,NumOutputs); //allocate memory for output tensor (dType TF_Output)

	TF_Output t2 = {TF_GraphOperationByName(Graph,"StatefulPartitionedCall"),0}; //take the output tensor from loaded model

	if(t2.oper == NULL){
		ERR("Failed TF_GraphOperationByName StatefulPartitionedCall");
	}

	Output[0] = t2;

	//********* Initalisation of Tensor to parse input and output
	TF_Tensor** InputValues = NEW_ARRAY(TF_Tensor*,NumInputs);
	TF_Tensor** OutputValues = NEW_ARRAY(TF_Tensor*,NumOutputs);

	//********* Populating input Tensor
	int numData = sess->inputsize; //==> number of data input from Modelica
	int tensor_dimensionality = 2; //==> dimensionality of the input tensor (2 for 2D tensor,3 for 3D tensor. Regression usually use 2D)
	int64_t dims[] = {1,numData}; //==> size of the input Tensor (row x col) ~ i row x j column ~ from saved_model_cli

	//*********************Pre-processing the input - normalisation of the input using Min Max Scaler
	//Allocate memory for scaled input
	float* data = NEW_ARRAY(float,numData); //==> where the input from modelica is gonna be inserted
	for(int i=0; i<sess->inputsize; i++){
		data[i] = (inputs[i] - sess->X_min[i]) / (sess->X_max[i]-sess->X_min[i]);
	}

	//Allocate memory for data inside the Input Tensor
	size_t memdata = numData * sizeof(float); // memory allocation ~ numData * data_type. if we have 2by2 input, then we have 4 numdata

	TF_Tensor* TensorIn = TF_NewTensor(TF_FLOAT, dims, tensor_dimensionality, data, memdata, &NoOpDeallocator, 0);

	if (TensorIn == NULL){
		ERR("Failed TF_NewTensor");
	}

	InputValues[0] = TensorIn;

	//********* Run the session
	TF_SessionRun(
		Session, 
		NULL, 
		Input, InputValues, NumInputs, 
		Output, OutputValues, NumOutputs, 
		NULL, 0,NULL , Status);

	if(TF_GetCode(Status) != TF_OK){
		ERR("Not-OK status from TF_SessionRun: %s",TF_Message(Status));
	}

	//Extracting output
	void* buff = TF_TensorData(OutputValues[0]);
	float* offsets = buff;

	//scale back the output to the original value
	double res = offsets[0] * (sess->y_max[which_ANN_model]-sess->y_min[which_ANN_model]) + sess->y_min[which_ANN_model];

	/*Free the resources - TensorFlow*/
	TF_DeleteTensor(TensorIn);

	/*Free memory*/
	free(InputValues);
	free(OutputValues);
	free(Output);
	free(Input);
	free(data);
	free(buff);

	sess->count = sess->count + 1;

	return res; 
}

/*=================================== STARTING FROM HERE IS ANN UTILITIES FUNCS ==============================*/
void NoOpDeallocator(void* data, size_t a, void* b){
    /* nothing here */
}

Session_Props* buildANN(double P_net, double T_in_ref_blk,double p_high, double PR, 
		double pinch_PHX, double dTemp_HTF_PHX,double load_base, double T_amb_base, 
		double eta_base, char* base_path, char* SolarTherm_path, int match_index, 
		char* traindir_base, char* config_base, char* ANN_path, int which_ANN_model, int gen_data, int status_config,
		int inputsize, int outputsize, double tolerance, int PB_model,
		int htf_choice, double dT_PHX_hot_approach, double dT_PHX_cold_approach, double eta_isen_mc, 
		double eta_isen_rc, double eta_isen_t, double dT_mc_approach, char* HTF_name
){
	//*************** initial number of training data
	int numdata = 150;
	Session_Props* session; //****************** mallocing will be done in the load_session func

	MSG("User choice of surrogate = ANN\n");
	char line[limitSize];

	/*List of file or directory that will be created under trainingdir*/
	char* name_prediction_validation_dump = "/validation_prediction.csv";
	char* name_R_squared = "/R_Squared.txt";
	char* name_training_eta_PB = "/deviation_eta_gross.csv";
	char* name_training_eta_Q = "/deviation_eta_Q.csv";
	char* name_validation = "/validation_data.csv";
	char* name_min = "/min.txt";
	char* name_max = "/max.txt";

	/*Build the file name for training, validation, min, max, kriging params*/           
	char* trainingdir = build_trainingdir_path(base_path,traindir_base,config_base,match_index);
	char* filepathpredictionvalidation = concat_training_dir(trainingdir,name_prediction_validation_dump);
	char* filepathRsquared = concat_training_dir(trainingdir,name_R_squared);
	char* filepathtraining_eta_PB = concat_training_dir(trainingdir,name_training_eta_PB);
	char* filepathtraining_eta_Q = concat_training_dir(trainingdir,name_training_eta_Q);
	char* filepathvalidation = concat_training_dir(trainingdir,name_validation);
	char* filepathmin = concat_training_dir(trainingdir,name_min);
	char* filepathmax = concat_training_dir(trainingdir,name_max);
	/*End building the file name*/

	/*Which model?*/
	char* filepath;
	if(which_ANN_model==0){
		filepath = filepathtraining_eta_PB;
	}else if(which_ANN_model==1){
		filepath = filepathtraining_eta_Q;
	}else{
		ERR("Invalid choice of ANN model. Please choose either 0 for ANN power block, 1 for ANN HX. Your choice is %d",which_ANN_model);
		exit(EXIT_FAILURE);
	}

	int stop = 0;

	while(stop == 0){
		if(gen_data == 1){
		    MSG("Start gathering %d off-design data points\n",numdata);
		    clock_t begin = clock();
		    if(PB_model==0){
		        generateTrainingData(
		            P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, match_index, numdata, base_path, status_config,
		            SolarTherm_path);
		    }else if(PB_model==1){
		        ssc_test();
		        ssc_data_t NRELPBSimulationResult = runNRELPB(
		            numdata, P_net, T_in_ref_blk, p_high,
		            T_amb_base, dT_PHX_hot_approach, dT_PHX_cold_approach, 
		            eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach, 
		            HTF_name, htf_choice, trainingdir, SolarTherm_path, base_path, status_config, match_index, 
					1, /*OD is simulated if this is one*/ 
					0 /*Add this s.t. when test run is triggered, only three data points to run */
		        );
		        ssc_data_free(NRELPBSimulationResult);
		    }else{
		        ERR("PB model choice is invalid. Choose 0 for CEA PB, 1 for NREL-SAM PB. Your choice is %d",PB_model);
		        exit(EXIT_FAILURE);
		    }
		        
		    clock_t end = clock();
		    double time_spent = (double)(end-begin) / CLOCKS_PER_SEC;
		    MSG("Finish gathering %d points off-design data: it took %lf s\n",numdata,time_spent);
		}

		status_config = 0;

		/*Training ANN for predicting eta*/
		/*int train_status_ANN = */trainingANN(filepath,trainingdir,which_ANN_model, SolarTherm_path);  

		/*Start validating the ANN model*/
		//*************Reading scaler
		FILE *fnmax = fopen(filepathmax,"r"); //instantiate pointer to the filepathmax
		if(fnmax==NULL){
		    ERR("File path max data doesn't exist! Check your path %s",filepathmax);
		}

		double* UB = NEW_ARRAY(double,inputsize+outputsize);
		size_t i = 0;
		fgets(line,limitSize,fnmax); //get the first line of fnmax, and store it in variable line
		while(!feof(fnmax)){
		    sscanf(line,"%lf",&UB[i]);
		    i++;
		    fgets(line,limitSize,fnmax); //get the next line
		}

		fclose(fnmax);

		FILE *fnmin = fopen(filepathmin,"r"); //instantiate pointer to the filepathmin

		if(fnmin==NULL){
		    ERR("File path min data doesn't exist! Check your path '%s'",filepathmin);
		}

		double* LB = NEW_ARRAY(double,inputsize+outputsize);
		i = 0;
		fgets(line,limitSize,fnmin);
		while(!feof(fnmin)){
		    sscanf(line,"%lf",&LB[i]);
		    i++;
		    fgets(line,limitSize,fnmin);
		}
		
		fclose(fnmin);

		/*Load ANN session!*/
		double* X_max = NEW_ARRAY(double,inputsize);
		double* X_min = NEW_ARRAY(double,inputsize);
		double* y_max = NEW_ARRAY(double,outputsize);
		double* y_min = NEW_ARRAY(double,outputsize);

		for(int i=0;i<inputsize;i++){
		    X_max[i] = UB[i];
		    X_min[i] = LB[i];
		}
		
		for(int i=0;i<outputsize;i++){
		    y_max[i] = UB[i+inputsize];
		    y_min[i] = LB[i+inputsize];
		}

		free(UB);
		free(LB);
		/*End reading scaler*/

		session = load_session(
		    ANN_path,X_max,X_min,y_max,y_min,inputsize,outputsize, 
		    load_base, T_in_ref_blk, T_amb_base
		);  
		
		free(X_max); free(X_min); free(y_max); free(y_min);

		/*Start reading the training data and validation data*/
		int rows = getNumOfData(filepathvalidation);

		PB_validation_data_point test_data[rows];

		/*Loop through all the test file*/
		FILE* testfile = fopen(filepathvalidation,"r");
		fgets(line,limitSize,testfile); //====> skip the first line
		fgets(line,limitSize,testfile);
		i = 0;

		double squared_error_eta = 0;

		double absolute_error_eta = 0;

		MSG("MAX : %lf,%lf,%lf,%lf,%lf\n",
		session->X_max[0],session->X_max[1],session->X_max[2],session->y_max[0],session->y_max[1]
		);      
		
		MSG("MIN : %lf,%lf,%lf,%lf,%lf\n",
		session->X_min[0],session->X_min[1],session->X_min[2],session->y_min[0],session->y_min[1]
		);

		FILE* dump = fopen(filepathpredictionvalidation,"a");
		fprintf(dump,"eta_gross_prediction,eta_Q_prediction\n");

		while(!feof(testfile)){
		    sscanf(
		        line,"%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf",
		        &test_data[i].P_net,
		        &test_data[i].T_in_ref_blk,
		        &test_data[i].p_high,
		        &test_data[i].PR,
		        &test_data[i].pinch_PHX,
		        &test_data[i].dTemp_HTF_PHX,
		        &test_data[i].load,
		        &test_data[i].T_HTF_in,
		        &test_data[i].T_amb_input,
		        &test_data[i].eta_gross,
		        &test_data[i].eta_Q
		    );

		    /*Calculate the deviation from the on design parameter*/
		    double raw_inputs[] = {test_data[i].load,test_data[i].T_HTF_in, test_data[i].T_amb_input};

		    /*ESTIMATE EFFICIENCY*/          
		    double deviation_estimate_eta = predict_ANN(
		            session, raw_inputs, which_ANN_model);

		    double estimate_eta = eta_base - deviation_estimate_eta;

		    double delta_eta; 

		    if(which_ANN_model==0){
		        delta_eta = estimate_eta - test_data[i].eta_gross; //************ deviation from the real model's value
		    }else if(which_ANN_model==1){
		        delta_eta = estimate_eta - test_data[i].eta_Q; 
		    }else{
		        ERR("Invalid ANN choice. Valid choices are 0 for ANN PB, 1 for ANN HC. Your choice is %d",which_ANN_model);
		        exit(EXIT_FAILURE);
		    }            
		
		    squared_error_eta = squared_error_eta + (delta_eta*delta_eta);

		    absolute_error_eta += fabs(delta_eta);
		    
		    /*Read next line*/
		    fgets(line,limitSize,testfile);
		    i++;
		}

		//Coefficient of determination (R squared)
		double sum_real_eta = 0;

		if(which_ANN_model==0){
		    for(int i=0;i<rows;i++){
		        sum_real_eta += test_data[i].eta_gross;
		    }
		}else{
		    for(int i=0;i<rows;i++){
		        sum_real_eta += test_data[i].eta_Q;
		    }
		}
		
		double mean_real_eta = sum_real_eta/rows;

		double variance_eta = 0;
		
		if(which_ANN_model==0){
		    for(int i=0;i<rows;i++){
		        variance_eta = variance_eta + (test_data[i].eta_gross - mean_real_eta) * (test_data[i].eta_gross - mean_real_eta);
		    }
		}else{
		    for(int i=0;i<rows;i++){
		        variance_eta = variance_eta + (test_data[i].eta_Q - mean_real_eta) * (test_data[i].eta_Q - mean_real_eta);
		    }
		}

		double R_squared_eta = 1 - (squared_error_eta / variance_eta);
		MSG("%lf %lf\n",squared_error_eta,variance_eta);

		double MAE_eta = absolute_error_eta/rows;
		MSG("%lf %d\n",absolute_error_eta,rows);

		MSG("\n------------------------------------------------\n");
		MSG("------------------------------------------------\n");
		MSG("--------SURROGATE VALIDATION RESULT-------------\n");
		MSG("------------------------------------------------\n");
		MSG("------------------------------------------------\n\n");

		MSG("Sum of square error eff: %lf\nR squared eff: %lf\nMAE eff: %lf\n",squared_error_eta,R_squared_eta, MAE_eta);

		/*Stop criterion*/
		if(MAE_eta < tolerance){
		    MSG("Model OK!\n");
		    stop = 1;
		}else{
		    MSG("Model is still not OK! Need more data!\n");
		    numdata = 25;
		    gen_data = 1; //*********** generating another data points
		}

		/*Dump evaluation result to a file*/
		FILE* fnRsquared = fopen(filepathRsquared,"a");
		fprintf(fnRsquared,"%lf,%lf\n",MAE_eta,R_squared_eta);
		fclose(fnRsquared);

		MSG("\n------------------------------------------------\n");
		MSG("------------------------------------------------\n");
		MSG("------------------------------------------------\n");
		MSG("------------------------------------------------\n");
		MSG("------------------------------------------------\n\n");

		fclose(testfile); 
		fclose(dump);
	}

	free(trainingdir);
	free(filepathpredictionvalidation);
	free(filepathRsquared);
	free(filepathtraining_eta_PB);
	free(filepathtraining_eta_Q);
	free(filepathvalidation);
	free(filepathmax);
	free(filepathmin);

	return session;
}

/*Function to load ANN model in C*/
void *load_session(char* saved_model_dir, double* X_max
		,double* X_min, double* y_max, double* y_min, int inputsize
		,int outputsize, double load_base, double T_in_ref_blk, double T_amb_base
){
	//*********************Adjust the logging of tensorflow by setting a variable 
	//*********************in the environment called TF_CPP_MIN_LOG_LEVEL

	char *var = "TF_CPP_MIN_LOG_LEVEL=0";
	putenv(var);

	//*********************Allocate dynamic memory from the heap for Session_Props data struct 
	Session_Props *sess = NEW(Session_Props);

	//*********************Instantiate Session Properties
	TF_Graph* Graph = TF_NewGraph();
	TF_Status* Status = TF_NewStatus();
	TF_SessionOptions* SessionOpts = TF_NewSessionOptions();
	TF_Buffer* RunOpts = NULL;

	const char* tags = "serve"; // default model serving tag
	int ntags = 1;

	TF_Session* Session = TF_LoadSessionFromSavedModel(SessionOpts, RunOpts
			,saved_model_dir, &tags, ntags, Graph, NULL, Status
		);

	if(TF_GetCode(Status) == TF_OK){
		MSG("TF Loading Pre-Trained Model : Complete!\n");
	}else{
		ERR("Not-OK TF_LoadSessionFromSavedModel status: %s.",TF_Message(Status));
	}

	//***************************Populate the member of the struct --- TensorFlow properties
	sess->Graph = Graph;
	sess->Session = Session;
	sess->Status = Status;
	sess->SessionOpts = SessionOpts;
	sess->RunOpts = RunOpts;

	//***************************Populate the member of the struct --- Scaler
	sess->X_max = NEW_ARRAY(double,inputsize);
	sess->X_min = NEW_ARRAY(double,inputsize);

	sess->y_max = NEW_ARRAY(double,outputsize);
	sess->y_min = NEW_ARRAY(double,outputsize);

	for(int i=0;i<inputsize;i++){
		sess->X_max[i] = X_max[i];
		sess->X_min[i] = X_min[i];
	}
		
	for(int i=0;i<outputsize;i++){
		sess->y_max[i] = y_max[i];
		sess->y_min[i] = y_min[i];
	}

	sess->inputsize = inputsize;
	sess->outputsize = outputsize;
	sess->base_values = NEW_ARRAY(double,inputsize);
	sess->base_values[0] = load_base;
	sess->base_values[1] = T_in_ref_blk;
	sess->base_values[2] = T_amb_base;
	return sess;
}

/*
	Function to train new ANN by executing python script
*/
int trainingANN(char* fn_data, char* prefixres, int count, char* SolarTherm_path){  

	//Command to execute the python script
	char* cmd = NEW_ARRAY(char, MAXLEN);

	//Build the command e.g. python SolarTherm_path/Resources/Library/trainANN.py fn_data prefixres 0
	snprintf(cmd, MAXLEN, "python %s/Resources/Library/trainANN.py %s %s %d", SolarTherm_path, fn_data, prefixres , count);

	MSG("Running %s\n",cmd);

	int status_training = system(cmd);

	if (status_training==0){
		MSG("Training ANN has been finished without any error\n");
		return 0;
	}else{
		ERR("Training error with status %d.",status_training);
		return -1;
	}
}

/*=================================== END OF ANN UTILITIES FUNCS ==============================*/


// vim: ts=4:sw=4:noet
