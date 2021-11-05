#include "kriging.h"
#include "sscpb.h"

#include <gsl/gsl_permutation.h>
#include <gsl/gsl_blas.h>
#include <gsl/gsl_linalg.h>

#include <math.h>
#include <time.h>
#include <string.h>

#define limitSize 1000000


//******************** SEQUENCE 3
/*
After returning Kriging_variables* (from SEQ. 2.1) or sess* (from SEQ 2.2.), SolarTHerm use the pointer to predict the performance of the power block.
The surrogate models predict the DEVIATION of eta_Q and eta_gross based on the deviation of inputs which are:
	1. load 
	2. HTF inlet temp.
	3. ambient temp.
*/

//********************* SEQUENCE 3.1
double predict_Kriging(Kriging_struct* Kriging_variables
		, const double raw_inputs[], char* which_eta, char* variogram_model
){  
	//*************** Calculate deviation in inputs
	double deviation_load = Kriging_variables->load_base - raw_inputs[0];
	double deviation_T_in = Kriging_variables->T_in_ref_blk - raw_inputs[1];
	double deviation_T_amb = Kriging_variables->T_amb_base - raw_inputs[2];

	/*Scale the input*/
	double scaled_load = (deviation_load - Kriging_variables->deviation_load_min) / (Kriging_variables->deviation_load_max - Kriging_variables->deviation_load_min);
	double scaled_T_HTF_in = (deviation_T_in - Kriging_variables->deviation_T_in_min) / (Kriging_variables->deviation_T_in_max - Kriging_variables->deviation_T_in_min);
	double scaled_T_amb_input = (deviation_T_amb - Kriging_variables->deviation_T_amb_min) / (Kriging_variables->deviation_T_amb_max - Kriging_variables->deviation_T_amb_min);

	double* inputs = NEW_ARRAY(double,3);
	inputs[0] = scaled_load;
	inputs[1] = scaled_T_HTF_in;
	inputs[2] = scaled_T_amb_input;

	int rows = Kriging_variables->rows;
	int inputsize = Kriging_variables->inputsize;
	//int outputsize = Kriging_variables->outputsize;

	//double Nugget, Spherical, Range;
	int index_var;

	if (strcmp(which_eta,"eta_gross")==0){
		//Nugget = Kriging_variables->Nugget_PB;
		//Spherical = 1 - (Kriging_variables->Nugget_PB);
		//Range = Kriging_variables->Range_PB;
		index_var = 3;
	}else if (strcmp(which_eta,"eta_Q")==0){
		//Nugget = Kriging_variables->Nugget_HX;
		//Spherical = 1 - (Kriging_variables->Nugget_HX);
		//Range = Kriging_variables->Range_HX;
		index_var = 4;
	}else{
		fprintf(stderr,"Choice of eta is not available. Your choice is %s, the avilable ones are eta_gross or eta_Q\n",which_eta);
		exit(EXIT_FAILURE);
	}

	/*Find the mean value of the value we want to Krig*/
	double sum_eff = 0;
	for(int i=0;i<rows;i++){
		sum_eff = sum_eff + Kriging_variables->trainingData[i][index_var];
	}

	double avg_eff = sum_eff / rows;

	/*Substract the mean from the value*/
	double* RESIDUAL_VAL = NEW_ARRAY(double,rows);
	for (int i=0;i<rows;i++){
		RESIDUAL_VAL[i] =  Kriging_variables->trainingData[i][index_var] - avg_eff;
	}

	/*Complete the DISTANCE matrix contained in the Kriging_variables struck, given the raw inputs*/
	completeDistanceMatrix(Kriging_variables, inputs, inputsize);

	/*Complete variogram matrix contained in the Kriging_variables struck*/
	completeVariogramMatrix(Kriging_variables, variogram_model, which_eta);

	/*Build Covariance Matrix*/
	completeCovarianceMatrix(Kriging_variables, variogram_model, which_eta);

	/*Find the weights*/
	gsl_matrix* WEIGHT = gsl_matrix_alloc(rows,1);
	gsl_matrix* RHS = gsl_matrix_alloc(rows,1);

	/*Take only the most right of the covariance matrix*/
	for(int i=0;i<rows;i++){
		if(strcmp(which_eta,"eta_gross")==0){
		    gsl_matrix_set(
		        RHS,i,0,
		        gsl_matrix_get(Kriging_variables->COVARIANCE_PB,i,rows)
		        );
		}else if(strcmp(which_eta,"eta_Q")==0){
		    gsl_matrix_set(
		        RHS,i,0,
		        gsl_matrix_get(Kriging_variables->COVARIANCE_HX,i,rows)
		        );  
		}else{
		    fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q. Your value is %s\n",which_eta);
		    exit(EXIT_FAILURE);
		}
	}

	if(strcmp(which_eta,"eta_gross")==0){
		gsl_blas_dgemm(CblasNoTrans,CblasNoTrans,1.0,Kriging_variables->INVERSE_PB,RHS,0.0,WEIGHT);
	}else if(strcmp(which_eta,"eta_Q")==0){
		gsl_blas_dgemm(CblasNoTrans,CblasNoTrans,1.0,Kriging_variables->INVERSE_HX,RHS,0.0,WEIGHT);
	}else{
		fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q\n");
		exit(EXIT_FAILURE);
	}

	/*Find the sum of weight*/
	double sum_weight = 0;
	//double residual_weight = 0;

	for(int i=0;i<rows;i++){
		sum_weight = sum_weight + gsl_matrix_get(WEIGHT,i,0);
	}

	//residual_weight = 1 - sum_weight;

	/*Calculate Kriging Estimate*/
	double estimate = 0;

	for(int i=0;i<rows;i++){
		estimate = estimate + RESIDUAL_VAL[i] * gsl_matrix_get(WEIGHT,i,0);
	}


	/*Find kriging variance (uncertainty)??*/
	double vars = 0;
	for(int i = 0; i<rows;i++){
		if(strcmp(which_eta,"eta_gross")==0){
		    vars = vars + (gsl_matrix_get(Kriging_variables->COVARIANCE_PB,i,rows)*gsl_matrix_get(WEIGHT,i,0));
		}else if(strcmp(which_eta,"eta_Q")==0){
		    vars = vars + (gsl_matrix_get(Kriging_variables->COVARIANCE_HX,i,rows)*gsl_matrix_get(WEIGHT,i,0));
		}else{
		    fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q\n");
		    exit(EXIT_FAILURE);
		}
		
	}

	estimate = estimate + avg_eff; //**************** scaled
	double real_deviation_estimate;

	if (strcmp(which_eta,"eta_gross")==0){
		real_deviation_estimate = estimate * (Kriging_variables->deviation_eta_gross_max-Kriging_variables->deviation_eta_gross_min) + Kriging_variables->deviation_eta_gross_min;
	}else if(strcmp(which_eta,"eta_Q")==0){
		real_deviation_estimate = estimate * (Kriging_variables->deviation_eta_Q_max-Kriging_variables->deviation_eta_Q_min) + Kriging_variables->deviation_eta_Q_min;
	}

	/*Free resources*/
	free(RESIDUAL_VAL);
	free(inputs);

	/*Free GSL object*/
	gsl_matrix_free(RHS);
	gsl_matrix_free(WEIGHT);

	Kriging_variables->count = Kriging_variables->count+1;

	return real_deviation_estimate;
}




/*=================================== STARTING FROM HERE IS KRIGING UTILITIES FUNCS ==============================*/
Kriging_struct* buildKriging(double P_net, double T_in_ref_blk,double p_high, double PR, 
		double pinch_PHX, double dTemp_HTF_PHX,double load_base, double T_amb_base, 
		double eta_gross_base, double eta_Q_base, char* base_path, char* SolarTherm_path, int match_index, 
		char* traindir_base, char* config_base, int status_config, int inputsize, int outputsize, double tolerance, int PB_model,
		int htf_choice, double dT_PHX_hot_approach, double dT_PHX_cold_approach, double eta_isen_mc, 
		double eta_isen_rc, double eta_isen_t, double dT_mc_approach, char* HTF_name
){
	char line[limitSize];

	Kriging_struct* Kriging_variables; //**************** mallocing is done in the load_KrigingVariables function

	//*************** initial number of training data
	int numdata = 150;

	/*Name of files that will be created under trianingdir*/
	char* name_prediction_validation_dump = "/validation_prediction.csv";
	char* name_R_squared = "/R_Squared.txt";
	char* name_training = "/scaled_Kriging_training_data_deviation.csv";
	char* name_validation = "/validation_data.csv";
	char* name_min = "/min.txt";
	char* name_max = "/max.txt";
	char* name_krig_param_eta_PB = "/Kriging_Param_eta_PB.txt";
	char* name_krig_param_eta_Q = "/Kriging_Param_eta_Q.txt";

	char* trainingdir = build_trainingdir_path(base_path,traindir_base,config_base,match_index);
	char* filepathpredictionvalidation = concat_training_dir(trainingdir,name_prediction_validation_dump);
	char* filepathRsquared = concat_training_dir(trainingdir,name_R_squared);
	char* filepathtraining = concat_training_dir(trainingdir,name_training);
	char* filepathvalidation = concat_training_dir(trainingdir,name_validation);
	char* filepathmin = concat_training_dir(trainingdir,name_min);
	char* filepathmax = concat_training_dir(trainingdir,name_max);
	char* filepath_kriging_param_eta_PB = concat_training_dir(trainingdir,name_krig_param_eta_PB);
	char* filepath_kriging_param_eta_Q = concat_training_dir(trainingdir,name_krig_param_eta_Q);
	/*End building the file name*/

	int stop = 0;

	while(stop == 0){
		printf("Start gathering %d off-design data points\n",numdata);
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
		        HTF_name, htf_choice, trainingdir, SolarTherm_path, base_path, status_config, match_index,1
		    );
		    ssc_data_free(NRELPBSimulationResult);
		}else{
		    fprintf(stderr,"PB model choice is invalid. Choose 0 for CEA PB, 1 for NREL-SAM PB. Your choice is %d\n",PB_model);
		    exit(EXIT_FAILURE);
		}
		
		status_config = 0;
		
		clock_t end = clock();
		double time_spent = (double)(end-begin) / CLOCKS_PER_SEC;

		fprintf(stderr,"Finish gathering %d points off-design data: it took %lf s\n",numdata,time_spent);

		/*Scaler - Read from txt file UB and LB*/
		FILE *fnmax = fopen(filepathmax,"r"); //instantiate pointer to the filepathmax
		if(fnmax==NULL){
		    printf("File path max data doesn't exist! Check your path %s\n",filepathmax);
		}

		double* UB = NEW_ARRAY(double,5);
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
		    printf("File path min data doesn't exist! Check your path %s\n",filepathmin);
		}

		double* LB = NEW_ARRAY(double,5);
		i = 0;
		fgets(line,limitSize,fnmin);
		while(!feof(fnmin)){
		    sscanf(line,"%lf",&LB[i]);
		    i++;
		    fgets(line,limitSize,fnmin);
		}
		
		fclose(fnmin);
		
		double deviation_load_max = UB[0];    
		double deviation_T_in_max = UB[1];    
		double deviation_T_amb_max = UB[2];   
		double deviation_eta_gross_max = UB[3];   
		double deviation_eta_Q_max = UB[4];   
		
		double deviation_load_min = LB[0];    
		double deviation_T_in_min = LB[1];   
		double deviation_T_amb_min = LB[2];   
		double deviation_eta_gross_min = LB[3];
		double deviation_eta_Q_min = LB[4];
		/*End scaler*/
		
		/*Reading Kriging Parameters*/
		//***********************PB
		FILE* fnkrigparam = fopen(filepath_kriging_param_eta_PB,"r");
		if(fnkrigparam==NULL){
		    printf("File path Kriging Param for PB doesn't exist! Check your path %s\n",filepath_kriging_param_eta_PB);
		}
		double* krig_param_PB = NEW_ARRAY(double,3);
		fgets(line,limitSize,fnkrigparam);
		sscanf(line,"%lf,%lf,%lf",&krig_param_PB[0],&krig_param_PB[1],&krig_param_PB[2]);
		fclose(fnkrigparam);

		double sill_PB = krig_param_PB[0];
		double Nugget_PB = krig_param_PB[1];
		//double Spherical_PB = 1-Nugget_PB;
		double Range_PB = krig_param_PB[2];

		//***********************HX
		fnkrigparam = fopen(filepath_kriging_param_eta_Q,"r");
		if(fnkrigparam==NULL){
		    printf("File path Kriging Param for HX doesn't exist! Check your path %s\n",filepath_kriging_param_eta_Q);
		}
		double* krig_param_HX = NEW_ARRAY(double,3);
		fgets(line,limitSize,fnkrigparam);
		sscanf(line,"%lf,%lf,%lf",&krig_param_HX[0],&krig_param_HX[1],&krig_param_HX[2]);
		fclose(fnkrigparam);

		double sill_HX = krig_param_HX[0];
		double Nugget_HX = krig_param_HX[1];
		//double Spherical_HX = 1-Nugget_HX;
		double Range_HX = krig_param_HX[2];
		/*End reading Kriging Parameters*/

		/*Start reading the training data and validation data*/
		int rows = getNumOfData(filepathvalidation);
		printf("ROWS: %d\n",rows);
		
		PB_validation_data_point test_data[rows];

		/*Loop through all the test file*/
		FILE* testfile = fopen(filepathvalidation,"r");
		fgets(line,limitSize,testfile); //====> skip the first line
		fgets(line,limitSize,testfile);
		i = 0;

		double squared_error_eta_PB = 0;
		double squared_error_eta_HX = 0;

		double absolute_error_eta_PB = 0;
		double absolute_error_eta_Q = 0;

		printf("SIL PB: %lf, NUGGET PB: %lf, RANGE PB: %lf\n",sill_PB,Nugget_PB,Range_PB);
		printf("SIL HX: %lf, NUGGET HX: %lf, RANGE HX: %lf\n",sill_HX,Nugget_HX,Range_HX);      

		printf("MAX : %lf,%lf,%lf,%lf,%lf\n",deviation_load_max,deviation_T_in_max,deviation_T_amb_max,deviation_eta_gross_max,deviation_eta_Q_max);      
		
		printf("MIN : %lf,%lf,%lf,%lf,%lf\n",deviation_load_min,deviation_T_in_min,deviation_T_amb_min,deviation_eta_gross_min,deviation_eta_Q_min);

		FILE* dump = fopen(filepathpredictionvalidation,"a");
		fprintf(dump,"eta_gross_prediction,eta_Q_prediction\n");

		/*Construct Kriging variables*/
		Kriging_variables = load_KrigingVariables(
		    filepathtraining, inputsize, outputsize, Nugget_PB, Nugget_HX, sill_PB, sill_HX, Range_PB, Range_HX,
		    load_base, T_in_ref_blk, T_amb_base,  deviation_load_max,deviation_T_in_max, deviation_T_amb_max ,
		    deviation_eta_gross_max, deviation_eta_Q_max, deviation_load_min, deviation_T_in_min,  deviation_T_amb_min,
		    deviation_eta_gross_min,  deviation_eta_Q_min, "spherical"
		    );

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
		    double raw_inputs[] = {test_data[i].load, test_data[i].T_HTF_in, test_data[i].T_amb_input};
		    
		    /*ESTIMATE PB EFFICIENCY*/
		    char* which_eta = "eta_gross"; 
		    double deviation_estimate_eta_gross = predict_Kriging(Kriging_variables, raw_inputs, which_eta, "spherical");
		    double estimate_eta_gross = eta_gross_base - deviation_estimate_eta_gross;
		    fprintf(stderr,"estimate eta gross = %lf - %lf\n",eta_gross_base,deviation_estimate_eta_gross);

		    /*ESTIMATE HX EFFICIENCY*/   
		    which_eta = "eta_Q";
		    double deviation_estimate_eta_Q = predict_Kriging(Kriging_variables, raw_inputs, which_eta, "spherical");
		    double estimate_eta_Q = eta_Q_base - deviation_estimate_eta_Q;  
		    fprintf(stderr,"estimate eta Q = %lf - %lf\n",eta_Q_base,deviation_estimate_eta_Q);

		    //Error calculation - Sum of mean square
		    double delta_eta_PB = estimate_eta_gross - test_data[i].eta_gross;
		    fprintf(stderr,"%lf - %lf = %lf\n",estimate_eta_gross,test_data[i].eta_gross, delta_eta_PB);

		    double delta_eta_HX = estimate_eta_Q - test_data[i].eta_Q;
		    fprintf(stderr,"%lf - %lf = %lf\n",estimate_eta_Q,test_data[i].eta_Q, delta_eta_HX);

		    squared_error_eta_PB = squared_error_eta_PB + (delta_eta_PB*delta_eta_PB);
		    squared_error_eta_HX = squared_error_eta_HX + (delta_eta_HX*delta_eta_HX);

		    absolute_error_eta_PB += fabs(delta_eta_PB);
		    absolute_error_eta_Q += fabs(delta_eta_HX);
		    
		    /*Read next line*/
		    fgets(line,limitSize,testfile);
		    i++;
		}

		//Coefficient of determination (R squared)
		double sum_real_eta_PB = 0;
		double sum_real_eta_HX = 0;

		for(int i=0;i<rows;i++){
		    sum_real_eta_PB += test_data[i].eta_gross;
		    sum_real_eta_HX += test_data[i].eta_Q;
		}

		double mean_real_eta_PB = sum_real_eta_PB/rows;
		double mean_real_eta_HX = sum_real_eta_HX/rows;

		double variance_eta_PB=0;
		double variance_eta_HX=0;

		for(int i=0;i<rows;i++){
		    variance_eta_PB = variance_eta_PB + (test_data[i].eta_gross - mean_real_eta_PB) * (test_data[i].eta_gross - mean_real_eta_PB);
		    variance_eta_HX = variance_eta_HX + (test_data[i].eta_Q - mean_real_eta_HX) * (test_data[i].eta_Q - mean_real_eta_HX);
		}

		double R_squared_eta_PB = 1 - (squared_error_eta_PB / variance_eta_PB);
		double R_squared_eta_HX = 1 - (squared_error_eta_HX / variance_eta_HX);
		double R_combination = (R_squared_eta_HX+R_squared_eta_PB)/2;

		double MAE_eta_PB = absolute_error_eta_PB/rows;
		double MAE_eta_HX = absolute_error_eta_Q/rows;
		double MAE_combination = (MAE_eta_HX + MAE_eta_PB)/2;

		printf("\n------------------------------------------------\n");
		printf("------------------------------------------------\n");
		printf("--------SURROGATE VALIDATION RESULT-------------\n");
		printf("------------------------------------------------\n");
		printf("------------------------------------------------\n\n");

		printf("Sum of square error PB eff: %lf\nR squared PB eff: %lf\nMAE eta PB eff: %lf\n",squared_error_eta_PB,R_squared_eta_PB, MAE_eta_PB);
		printf("Sum of square error HX eff: %lf\nR squared HX eff: %lf\nMAE eta HX eff: %lf\n",squared_error_eta_HX,R_squared_eta_HX, MAE_eta_HX);
		printf("MAE combination: %lf\n",MAE_combination);
		printf("R squared combination: %lf\n",R_combination);

		/*Stop criterion*/
		if(MAE_combination < tolerance){
		    printf("Model OK!\n");
		    stop = 1;
		}else{
		    printf("Model is still not OK! Need more data!\n");
		    numdata = 25;
		}

		/*Dump evaluation result to a file*/
		FILE* fnRsquared = fopen(filepathRsquared,"a");
		fprintf(fnRsquared,"%lf,%lf\n",MAE_combination,R_combination);
		fclose(fnRsquared);

		printf("\n------------------------------------------------\n");
		printf("------------------------------------------------\n");
		printf("------------------------------------------------\n");
		printf("------------------------------------------------\n");
		printf("------------------------------------------------\n\n");

		fclose(testfile); 
		fclose(dump);
		free(UB);
		free(LB);
	}

	free(trainingdir);    
	free(filepathpredictionvalidation);
	free(filepathRsquared);
	free(filepathtraining);
	free(filepathvalidation);
	free(filepathmin);
	free(filepathmax);
	free(filepath_kriging_param_eta_PB);
	free(filepath_kriging_param_eta_Q);

	return Kriging_variables;
}

void getWeight(gsl_matrix* INVERSE_LSM, gsl_matrix* COVARIANCE, gsl_matrix* WEIGHTS, int rows){
	double val;
	double InverseVal;
	double CovarianceVal;
	for(int i=0;i<rows;i++){
		val = 0;
		for(int j=0;j<rows;j++){
		    InverseVal = gsl_matrix_get(INVERSE_LSM,i,j);
		    CovarianceVal = gsl_matrix_get(COVARIANCE,j,rows);
		    val = val + (InverseVal*CovarianceVal);
		}
		gsl_matrix_set(WEIGHTS,i,0,val);
	}
}

void completeCovarianceMatrix(Kriging_struct* Kriging_variables, char* type, char* which_eta){
	//double Range;
	double Nugget;
	double Spherical;

	int rows = Kriging_variables->rows;

	if(strcmp(which_eta,"eta_gross")==0){
		//Range = Kriging_variables->Range_PB;
		Nugget = Kriging_variables->Nugget_PB;
		Spherical = 1 - Kriging_variables->Nugget_PB;
	}else if(strcmp(which_eta,"eta_Q")==0){
		//Range = Kriging_variables->Range_HX;
		Nugget = Kriging_variables->Nugget_HX;
		Spherical = 1 - Kriging_variables->Nugget_HX;
	}else{
		fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q\n");
		exit(EXIT_FAILURE);
	}

	double sum = Nugget + Spherical;

	for(int i=0;i<rows;i++){
		if(strcmp(which_eta,"eta_gross")==0){
		    gsl_matrix_set(
		        Kriging_variables->COVARIANCE_PB,i,rows,
		        sum - gsl_matrix_get(Kriging_variables->VARIOGRAM_PB,i,rows)
		        );   
		}else if(strcmp(which_eta,"eta_Q")==0){
		    gsl_matrix_set(
		        Kriging_variables->COVARIANCE_HX,i,rows,
		        sum - gsl_matrix_get(Kriging_variables->VARIOGRAM_HX,i,rows)
		        );   
		}else{
		    fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q\n");
		    exit(EXIT_FAILURE);
		}
	}
}

void completeVariogramMatrix(Kriging_struct* Kriging_variables, char* type, char* which_eta){
	//double var;
	double dist;
	double multiplier;
	double Range;
	double Nugget;
	double Spherical;

	int rows = Kriging_variables->rows;

	if(strcmp(which_eta,"eta_gross")==0){
		Range = Kriging_variables->Range_PB;
		Nugget = Kriging_variables->Nugget_PB;
		Spherical = 1 - Kriging_variables->Nugget_PB;
	}else if(strcmp(which_eta,"eta_Q")==0){
		Range = Kriging_variables->Range_HX;
		Nugget = Kriging_variables->Nugget_HX;
		Spherical = 1 - Kriging_variables->Nugget_HX;
	}else{
		fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q\n");
		exit(EXIT_FAILURE);
	}

	for(int i=0;i<rows;i++){
		dist = gsl_matrix_get(Kriging_variables->DISTANCE,i,rows);

		if(strcmp(type,"spherical")==0){
		    if(fabs(dist)>Range){
		        multiplier = 1;
		    }else{
		        multiplier = 1.5 * (dist/Range) - 0.5 * pow(dist/Range,3);
		    }
		}else if (strcmp(type,"gaussian")==0){
		    double dist_square = pow(dist,2);
		    double range_square = pow(Range,2);
		    multiplier = 1 - exp(-dist_square/range_square);
		}else if(strcmp(type,"exponential")==0){
		    multiplier = 1 - exp(-fabs(dist)/Range);
		}else if(strcmp(type,"nugget")==0){
		    multiplier = Range;
		}else if(strcmp(type,"power")==0){
		    multiplier = pow(Range,2);
		}else{
		    printf("Variogram model is not valid\n");
		    return;
		}                  
		
		if(strcmp(which_eta,"eta_gross")==0){
		    gsl_matrix_set(Kriging_variables->VARIOGRAM_PB,i,rows, Nugget + Spherical * multiplier);
		}else if(strcmp(which_eta,"eta_Q")==0){
		    gsl_matrix_set(Kriging_variables->VARIOGRAM_HX,i,rows, Nugget + Spherical * multiplier);
		}else{
		    fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q\n");
		    exit(EXIT_FAILURE);
		}
	}
}

void completeDistanceMatrix(Kriging_struct* Kriging_variables, double* inputs, int inputsize){
	double square_difference;
	double delta;
	double dist;
	int rows = Kriging_variables->rows;

	for(int i=0;i<rows;i++){
		square_difference = 0;

		for(int j=0;j<inputsize;j++){
			delta = Kriging_variables->trainingData[i][j]- inputs[j];
			square_difference = square_difference + (delta*delta);
		}

		dist = pow(square_difference,0.5);
		gsl_matrix_set(Kriging_variables->DISTANCE,i,rows,dist);

	}
}

void eucledianDistance_2(Kriging_struct* Kriging_variables
		, int rows, int inputsize, gsl_matrix* DISTANCE
){
	double square_difference;
	double delta;
	double dist;

	for(int i=0;i<rows;i++){
		for(int j=0;j<rows;j++){
		    square_difference = 0;

		    if(i==j){ //Diagonal Matrix --> 0
		        gsl_matrix_set(DISTANCE,i,j,0.0);
		    }else{
		        for(int l=0;l<inputsize;l++){
		            delta = Kriging_variables->trainingData[i][l] - Kriging_variables->trainingData[j][l];
		            //printf("%lf - %lf = %lf\n",training_data[i][l],training_data[j][l],delta);
		            square_difference = square_difference + (delta*delta);
		        }
		        dist = pow(square_difference,0.5);
		        gsl_matrix_set(DISTANCE,i,j,dist);
		    }
		}
	}
}

double** create2Darray(int row, int col){
	int i;
	double** arr;
	arr = NEW_ARRAY(double*,row);
	for(i=0;i<row;i++){
		arr[i] = NEW_ARRAY(double,col);
	}
	return arr;
}

void* load_KrigingVariables(char* filepathtraining, int inputsize, int outputsize
	,double Nugget_PB, double Nugget_HX, double sill_PB, double sill_HX
	,double Range_PB, double Range_HX, double load_base, double T_in_ref_blk
	,double T_amb_base, double deviation_load_max,double deviation_T_in_max
	,double deviation_T_amb_max ,double deviation_eta_gross_max
	,double deviation_eta_Q_max,double deviation_load_min,double deviation_T_in_min
	,double deviation_T_amb_min,double deviation_eta_gross_min
	,double deviation_eta_Q_min, char* variogram_model
){
	/*This function is for populating the Kriging_trianing_struct*/
	char line[limitSize];
	Kriging_struct* Kriging_variables = NEW(Kriging_struct);

	/*Open the file*/
	FILE* training_file = fopen(filepathtraining,"r");
	if (training_file==NULL){
		printf("Your file doesn't exist mate! Check your address %s!\n",filepathtraining);
	}

	int rows = getNumOfData(filepathtraining);    

	/*Populating Kriging struct*/
	Kriging_variables->rows = rows;
	Kriging_variables->inputsize = inputsize;
	Kriging_variables->outputsize = outputsize;

	Kriging_variables->Nugget_PB = Nugget_PB;
	Kriging_variables->Nugget_HX = Nugget_HX;
	Kriging_variables->sill_PB = sill_PB;
	Kriging_variables->sill_HX = sill_HX;
	Kriging_variables->Range_PB = Range_PB;
	Kriging_variables->Range_HX = Range_HX;

	Kriging_variables->load_base = load_base;
	Kriging_variables->T_in_ref_blk = T_in_ref_blk;
	Kriging_variables->T_amb_base = T_amb_base;

	Kriging_variables->deviation_load_max = deviation_load_max;
	Kriging_variables->deviation_T_in_max = deviation_T_in_max;
	Kriging_variables->deviation_T_amb_max = deviation_T_amb_max;
	Kriging_variables->deviation_eta_gross_max = deviation_eta_gross_max;
	Kriging_variables->deviation_eta_Q_max = deviation_eta_Q_max;

	Kriging_variables->deviation_load_min = deviation_load_min;
	Kriging_variables->deviation_T_in_min = deviation_T_in_min;
	Kriging_variables->deviation_T_amb_min = deviation_T_amb_min;
	Kriging_variables->deviation_eta_gross_min = deviation_eta_gross_min;
	Kriging_variables->deviation_eta_Q_min = deviation_eta_Q_min;

	/*Allocate memory to store 2D array*/
	Kriging_variables->trainingData = NEW_ARRAY(double*,Kriging_variables->rows);
	for(int i=0;i<rows;i++){
		Kriging_variables->trainingData[i] = NEW_ARRAY(double,inputsize+outputsize); /*for each element in the memory address, create number of r of integer*/
	}

	/*Skip the header*/
	fgets(line,limitSize,training_file);

	/*Read the data!*/
	fgets(line,limitSize,training_file);
	size_t i = 0;
	while(!feof(training_file)){
		sscanf(
		    line,"%lf,%lf,%lf,%lf,%lf",
		    &Kriging_variables->trainingData[i][0],
		    &Kriging_variables->trainingData[i][1], 
		    &Kriging_variables->trainingData[i][2], 
		    &Kriging_variables->trainingData[i][3], 
		    &Kriging_variables->trainingData[i][4]
		);
		i++;
		fgets(line,limitSize,training_file);
	}
	fclose(training_file);

	/*Populate all the LHS Matrix*/
	Kriging_variables->DISTANCE = gsl_matrix_alloc(rows,rows+1);

	Kriging_variables->VARIOGRAM_HX = gsl_matrix_alloc(rows,rows+1);
	Kriging_variables->COVARIANCE_HX = gsl_matrix_alloc(rows,rows+1);
	Kriging_variables->INVERSE_HX = gsl_matrix_alloc(rows,rows);

	Kriging_variables->VARIOGRAM_PB = gsl_matrix_alloc(rows,rows+1);
	Kriging_variables->COVARIANCE_PB = gsl_matrix_alloc(rows,rows+1);
	Kriging_variables->INVERSE_PB = gsl_matrix_alloc(rows,rows);

	//********************** LHS DISTANCE MATRIX
	double square_difference;
	double delta;
	double dist;

	for(int i=0;i<rows;i++){
		for(int j=0;j<rows;j++){
		    square_difference = 0;

		    if(i==j){
		    	//Diagonal Matrix --> 0
		        gsl_matrix_set(Kriging_variables->DISTANCE,i,j,0.0);
		    }else{
		        for(int l=0;l<inputsize;l++){
		            delta = Kriging_variables->trainingData[i][l] - Kriging_variables->trainingData[j][l];
		            //printf("%lf - %lf = %lf\n",training_data[i][l],training_data[j][l],delta);
		            square_difference = square_difference + (delta*delta);
		        }
		        dist = pow(square_difference,0.5);
		        gsl_matrix_set(Kriging_variables->DISTANCE,i,j,dist);
		    }
		}
	}

	//********************** LHS VARIOGRAM PB
	//double var;
	double multiplier;
	double Range_variogram = Kriging_variables->Range_PB;
	double Nugget_variogram = Kriging_variables->Nugget_PB;
	double Spherical_variogram = 1 - Kriging_variables->Nugget_PB;
	for(int i=0;i<rows;i++){
		for(int j=0;j<rows;j++){
		    if(i==j){
		        gsl_matrix_set(Kriging_variables->VARIOGRAM_PB,i,j,0.0);
		    }else{
		        dist = gsl_matrix_get(Kriging_variables->DISTANCE,i,j);

		        if (strcmp(variogram_model,"spherical")==0){
		            if(dist>Range_variogram){
		                multiplier = 1;
		            }else{
		                multiplier = 1.5 * (dist/Range_variogram) - 0.5 * pow(dist/Range_variogram,3);
		            }
		        }else if (strcmp(variogram_model,"gaussian")==0){
		            double dist_square = pow(dist,2);
		            double range_square = pow(Range_variogram,2);
		            multiplier = 1 - exp(-dist_square/range_square);
		        }else if (strcmp(variogram_model,"exponential")==0) {
		            multiplier = 1 - exp(-fabs(dist)/Range_variogram);
		        }else if (strcmp(variogram_model,"power")==0){
		            multiplier = pow(Range_variogram,2);
		        }else if (strcmp(variogram_model,"nugget")==0){
		            multiplier = Range_variogram;
		        }else{
		            fprintf(stderr,"Variogram model is not valid\n");
		            exit(EXIT_FAILURE);
		        }

		        gsl_matrix_set(Kriging_variables->VARIOGRAM_PB,i,j, Nugget_variogram + Spherical_variogram * multiplier);
		    }
		    
		}
	}

	//********************** LHS COVARIANCE PB
	double sum_variogram = Nugget_variogram + Spherical_variogram;

	for(int i=0;i<rows;i++){
		for(int j=0;j<rows;j++){
		    gsl_matrix_set(Kriging_variables->COVARIANCE_PB,i,j,sum_variogram - gsl_matrix_get(Kriging_variables->VARIOGRAM_PB,i,j));
		}
	}

	//********************** Inverse PB
	gsl_matrix* LSM_PB = gsl_matrix_alloc(rows,rows); 

	for(int i=0;i<rows;i++){
		for(int j=0;j<rows;j++){
		    gsl_matrix_set(LSM_PB,i,j, gsl_matrix_get(Kriging_variables->COVARIANCE_PB,i,j));
		}
	}

	/*Inverse the LSM*/
	gsl_permutation* perm_PB = gsl_permutation_alloc(rows);
	int s;
	gsl_linalg_LU_decomp (LSM_PB, perm_PB, &s);    
	gsl_linalg_LU_invert (LSM_PB, perm_PB, Kriging_variables->INVERSE_PB);

	//********************** LHS VARIOGRAM HX
	Range_variogram = Kriging_variables->Range_HX;
	Nugget_variogram = Kriging_variables->Nugget_HX;
	Spherical_variogram = 1 - Kriging_variables->Nugget_HX;

	for(int i=0;i<rows;i++){
		for(int j=0;j<rows;j++){
		    if(i==j){
		        gsl_matrix_set(Kriging_variables->VARIOGRAM_HX,i,j,0.0);
		    }else{
		        dist = gsl_matrix_get(Kriging_variables->DISTANCE,i,j);

		        if (strcmp(variogram_model,"spherical")==0){
		            if(dist>Range_variogram){
		                multiplier = 1;
		            }else{
		                multiplier = 1.5 * (dist/Range_variogram) - 0.5 * pow(dist/Range_variogram,3);
		            }
		        }else if (strcmp(variogram_model,"gaussian")==0){
		            double dist_square = pow(dist,2);
		            double range_square = pow(Range_variogram,2);
		            multiplier = 1 - exp(-dist_square/range_square);
		        }else if (strcmp(variogram_model,"exponential")==0){
		            multiplier = 1 - exp(-fabs(dist)/Range_variogram);
		        }else if (strcmp(variogram_model,"power")==0){
		            multiplier = pow(Range_variogram,2);
		        }else if (strcmp(variogram_model,"nugget")==0){
		            multiplier = Range_variogram;
		        }else{
		            fprintf(stderr,"Variogram model is not valid\n");
		            exit(EXIT_FAILURE);
		        }
		                        
		        gsl_matrix_set(Kriging_variables->VARIOGRAM_HX,i,j, Nugget_variogram + Spherical_variogram * multiplier);
		    }
		    
		}
	}

	//********************** LHS COVARIANCE HX
	sum_variogram = Nugget_variogram + Spherical_variogram;

	for(int i=0;i<rows;i++){
		for(int j=0;j<rows;j++){
		    gsl_matrix_set(Kriging_variables->COVARIANCE_HX,i,j,sum_variogram - gsl_matrix_get(Kriging_variables->VARIOGRAM_HX,i,j));
		}
	}

	//********************** Inverse HX
	gsl_matrix* LSM_HX = gsl_matrix_alloc(rows,rows); 

	for(int i=0;i<rows;i++){
		for(int j=0;j<rows;j++){
		    gsl_matrix_set(LSM_HX,i,j, gsl_matrix_get(Kriging_variables->COVARIANCE_HX,i,j));
		}
	}

	/*Inverse the LSM*/
	gsl_permutation* perm_HX = gsl_permutation_alloc(rows);
	gsl_linalg_LU_decomp (LSM_HX, perm_HX, &s);    
	gsl_linalg_LU_invert (LSM_HX, perm_HX, Kriging_variables->INVERSE_HX); 

	/*Free resources*/
	gsl_matrix_free(LSM_HX);
	gsl_permutation_free(perm_HX);
	gsl_matrix_free(LSM_PB);
	gsl_permutation_free(perm_PB);

	return Kriging_variables;
}

/*=================================== END OF IS KRIGING UTILITIES FUNCS ==============================*/

// vim: ts=4:sw=4:noet
