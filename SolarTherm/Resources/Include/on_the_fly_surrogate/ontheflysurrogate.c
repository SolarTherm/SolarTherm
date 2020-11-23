#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "tensorflow/c/c_api.h"
#include "SAM/sscapi.h"
#include <dirent.h>
#include "NRELPB.h"

#define limitSize 1000000

void NoOpDeallocator(void* data, size_t a, void* b)
{
    /* nothing here */
}

Kriging_struct* buildKriging(double P_net, double T_in_ref_blk,double p_high, double PR, 
double pinch_PHX, double dTemp_HTF_PHX,double load_base, double T_amb_base, 
double eta_gross_base, double eta_Q_base, char* base_path, char* SolarTherm_path, int match_index, 
char* traindir_base, char* config_base, int status_config, int inputsize, int outputsize, double tolerance, int PB_model,
int htf_choice, double dT_PHX_hot_approach, double dT_PHX_cold_approach, double eta_isen_mc, 
double eta_isen_rc, double eta_isen_t, double dT_mc_approach, char* HTF_name)
{
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

    while(stop == 0)
    {
        
        printf("Start gathering %d off-design data points\n",numdata);
        clock_t begin = clock();
        if(PB_model==0)
        {
            generateTrainingData(
                P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, match_index, numdata, base_path, status_config,
                SolarTherm_path);
        }
        else if(PB_model==1)
        {
            ssc_test();
            ssc_data_t NRELPBSimulationResult = runNRELPB(
                numdata, P_net, T_in_ref_blk, p_high,
                T_amb_base, dT_PHX_hot_approach, dT_PHX_cold_approach, 
                eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
                HTF_name, htf_choice, trainingdir, SolarTherm_path, base_path, status_config, match_index,1
            );
            ssc_data_free(NRELPBSimulationResult);
        }
        else
        {
            fprintf(stderr,"PB model choice is invalid. Choose 0 for CEA PB, 1 for NREL-SAM PB. Your choice is %d\n",PB_model);
            exit(EXIT_FAILURE);
        }
        
        status_config = 0;
        
        clock_t end = clock();
        double time_spent = (double)(end-begin) / CLOCKS_PER_SEC;

        fprintf(stderr,"Finish gathering %d points off-design data: it took %lf s\n",numdata,time_spent);
    
        /*Scaler - Read from txt file UB and LB*/
        FILE *fnmax = fopen(filepathmax,"r"); //instantiate pointer to the filepathmax
        if(fnmax==NULL)
        {
            printf("File path max data doesn't exist! Check your path %s\n",filepathmax);
        }

        double* UB = malloc(sizeof(double*)*5);
        size_t i = 0;
        fgets(line,limitSize,fnmax); //get the first line of fnmax, and store it in variable line
        while(!feof(fnmax))
        {
            sscanf(line,"%lf",&UB[i]);
            i++;
            fgets(line,limitSize,fnmax); //get the next line
        }

        fclose(fnmax);


        FILE *fnmin = fopen(filepathmin,"r"); //instantiate pointer to the filepathmin

        if(fnmin==NULL)
        {
            printf("File path min data doesn't exist! Check your path %s\n",filepathmin);
        }

        double* LB = malloc(sizeof(double*)*5);
        i = 0;
        fgets(line,limitSize,fnmin);
        while(!feof(fnmin))
        {
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
        if(fnkrigparam==NULL)
        {
            printf("File path Kriging Param for PB doesn't exist! Check your path %s\n",filepath_kriging_param_eta_PB);
        }
        double* krig_param_PB = malloc(sizeof(double*)*3);
        fgets(line,limitSize,fnkrigparam);
        sscanf(line,"%lf,%lf,%lf",&krig_param_PB[0],&krig_param_PB[1],&krig_param_PB[2]);
        fclose(fnkrigparam);

        double sill_PB = krig_param_PB[0];
        double Nugget_PB = krig_param_PB[1];
        double Spherical_PB = 1-Nugget_PB;
        double Range_PB = krig_param_PB[2];

        //***********************HX
        fnkrigparam = fopen(filepath_kriging_param_eta_Q,"r");
        if(fnkrigparam==NULL)
        {
            printf("File path Kriging Param for HX doesn't exist! Check your path %s\n",filepath_kriging_param_eta_Q);
        }
        double* krig_param_HX = malloc(sizeof(double*)*3);
        fgets(line,limitSize,fnkrigparam);
        sscanf(line,"%lf,%lf,%lf",&krig_param_HX[0],&krig_param_HX[1],&krig_param_HX[2]);
        fclose(fnkrigparam);

        double sill_HX = krig_param_HX[0];
        double Nugget_HX = krig_param_HX[1];
        double Spherical_HX = 1-Nugget_HX;
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

        while(!feof(testfile))
        {
            sscanf
            (
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

        for(size_t i=0;i<rows;i++)
        {
            sum_real_eta_PB += test_data[i].eta_gross;
            sum_real_eta_HX += test_data[i].eta_Q;
        }

        double mean_real_eta_PB = sum_real_eta_PB/rows;
        double mean_real_eta_HX = sum_real_eta_HX/rows;

        double variance_eta_PB=0;
        double variance_eta_HX=0;

        for(size_t i=0;i<rows;i++)
        {
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
        if(MAE_combination < tolerance)
        {
            printf("Model OK!\n");
            stop = 1;
        }
        else
        {
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

Session_Props* buildANN(double P_net, double T_in_ref_blk,double p_high, double PR, 
double pinch_PHX, double dTemp_HTF_PHX,double load_base, double T_amb_base, 
double eta_base, char* base_path, char* SolarTherm_path, int match_index, 
char* traindir_base, char* config_base, char* ANN_path, int which_ANN_model, int gen_data, int status_config,
int inputsize, int outputsize, double tolerance, int PB_model,
int htf_choice, double dT_PHX_hot_approach, double dT_PHX_cold_approach, double eta_isen_mc, 
double eta_isen_rc, double eta_isen_t, double dT_mc_approach, char* HTF_name)
{
    //*************** initial number of training data
    int numdata = 150;
    Session_Props* session; //****************** mallocing will be done in the load_session func

    printf("User choice of surrogate = ANN\n");
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
    if(which_ANN_model==0)
    {
        filepath = filepathtraining_eta_PB;
    }
    else if(which_ANN_model==1)
    {
        filepath = filepathtraining_eta_Q;
    }
    else 
    {
        fprintf(stderr,"Invalid choice of ANN model. Please choose either 0 for ANN power block, 1 for ANN HX. Your choice is %d\n",which_ANN_model);
        exit(EXIT_FAILURE);
    }

    int stop = 0;

    while(stop == 0)
    {
        if(gen_data == 1)
        {
            printf("Start gathering %d off-design data points\n",numdata);
            clock_t begin = clock();
            if(PB_model==0)
            {
                generateTrainingData(
                    P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, match_index, numdata, base_path, status_config,
                    SolarTherm_path);
            }
            else if(PB_model==1)
            {
                ssc_test();
                ssc_data_t NRELPBSimulationResult = runNRELPB(
                    numdata, P_net, T_in_ref_blk, p_high,
                    T_amb_base, dT_PHX_hot_approach, dT_PHX_cold_approach, 
                    eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach, 
                    HTF_name, htf_choice, trainingdir, SolarTherm_path, base_path, status_config, match_index,1
                );
                ssc_data_free(NRELPBSimulationResult);
            }
            else
            {
                fprintf(stderr,"PB model choice is invalid. Choose 0 for CEA PB, 1 for NREL-SAM PB. Your choice is %d\n",PB_model);
                exit(EXIT_FAILURE);
            }
                
            clock_t end = clock();
            double time_spent = (double)(end-begin) / CLOCKS_PER_SEC;
            printf("Finish gathering %d points off-design data: it took %lf s\n",numdata,time_spent);
        }

        status_config = 0;

        /*Training ANN for predicting eta*/
        int train_status_ANN = trainingANN(filepath,trainingdir,which_ANN_model, SolarTherm_path);  

        /*Start validating the ANN model*/
        //*************Reading scaler
        FILE *fnmax = fopen(filepathmax,"r"); //instantiate pointer to the filepathmax
        if(fnmax==NULL)
        {
            printf("File path max data doesn't exist! Check your path %s\n",filepathmax);
        }

        double* UB = malloc(sizeof(double*)*(inputsize+outputsize));
        size_t i = 0;
        fgets(line,limitSize,fnmax); //get the first line of fnmax, and store it in variable line
        while(!feof(fnmax))
        {
            sscanf(line,"%lf",&UB[i]);
            i++;
            fgets(line,limitSize,fnmax); //get the next line
        }

        fclose(fnmax);

        FILE *fnmin = fopen(filepathmin,"r"); //instantiate pointer to the filepathmin

        if(fnmin==NULL)
        {
            printf("File path min data doesn't exist! Check your path %s\n",filepathmin);
        }

        double* LB = malloc(sizeof(double*)*(inputsize+outputsize));
        i = 0;
        fgets(line,limitSize,fnmin);
        while(!feof(fnmin))
        {
            sscanf(line,"%lf",&LB[i]);
            i++;
            fgets(line,limitSize,fnmin);
        }
        
        fclose(fnmin);

        /*Load ANN session!*/
        double* X_max = malloc(sizeof(double*)*inputsize);
        double* X_min = malloc(sizeof(double*)*inputsize);
        double* y_max = malloc(sizeof(double*)*outputsize);
        double* y_min = malloc(sizeof(double*)*outputsize);

        for(size_t i=0;i<inputsize;i++)
        {
            X_max[i] = UB[i];
            X_min[i] = LB[i];
        }
        
        for(size_t i=0;i<outputsize;i++)
        {
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

        printf("MAX : %lf,%lf,%lf,%lf,%lf\n",
        session->X_max[0],session->X_max[1],session->X_max[2],session->y_max[0],session->y_max[1]
        );      
        
        printf("MIN : %lf,%lf,%lf,%lf,%lf\n",
        session->X_min[0],session->X_min[1],session->X_min[2],session->y_min[0],session->y_min[1]
        );

        FILE* dump = fopen(filepathpredictionvalidation,"a");
        fprintf(dump,"eta_gross_prediction,eta_Q_prediction\n");

        while(!feof(testfile))
        {
            sscanf
            (
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

            if(which_ANN_model==0)
            {
                delta_eta = estimate_eta - test_data[i].eta_gross; //************ deviation from the real model's value
            }
            else if(which_ANN_model==1)
            {
                delta_eta = estimate_eta - test_data[i].eta_Q; 
            }
            else
            {
                fprintf(stderr,"Invalid ANN choice. Valid choices are 0 for ANN PB, 1 for ANN HC. Your choice is %d\n",which_ANN_model);
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

        if(which_ANN_model==0)
        {
            for(size_t i=0;i<rows;i++)
            {
                sum_real_eta += test_data[i].eta_gross;
            }
        }
        else
        {
            for(size_t i=0;i<rows;i++)
            {
                sum_real_eta += test_data[i].eta_Q;
            }
        }
        
        double mean_real_eta = sum_real_eta/rows;

        double variance_eta = 0;
        
        if(which_ANN_model==0)
        {
            for(size_t i=0;i<rows;i++)
            {
                variance_eta = variance_eta + (test_data[i].eta_gross - mean_real_eta) * (test_data[i].eta_gross - mean_real_eta);
            }
        }
        else
        {
            for(size_t i=0;i<rows;i++)
            {
                variance_eta = variance_eta + (test_data[i].eta_Q - mean_real_eta) * (test_data[i].eta_Q - mean_real_eta);
            }
        }

        double R_squared_eta = 1 - (squared_error_eta / variance_eta);
        printf("%lf %lf\n",squared_error_eta,variance_eta);

        double MAE_eta = absolute_error_eta/rows;
        printf("%lf %d\n",absolute_error_eta,rows);

        printf("\n------------------------------------------------\n");
        printf("------------------------------------------------\n");
        printf("--------SURROGATE VALIDATION RESULT-------------\n");
        printf("------------------------------------------------\n");
        printf("------------------------------------------------\n\n");

        printf("Sum of square error eff: %lf\nR squared eff: %lf\nMAE eff: %lf\n",squared_error_eta,R_squared_eta, MAE_eta);

        /*Stop criterion*/
        if(MAE_eta < tolerance)
        {
            printf("Model OK!\n");
            stop = 1;
        }
        else
        {
            printf("Model is still not OK! Need more data!\n");
            numdata = 25;
            gen_data = 1; //*********** generating another data points
        }

        /*Dump evaluation result to a file*/
        FILE* fnRsquared = fopen(filepathRsquared,"a");
        fprintf(fnRsquared,"%lf,%lf\n",MAE_eta,R_squared_eta);
        fclose(fnRsquared);

        printf("\n------------------------------------------------\n");
        printf("------------------------------------------------\n");
        printf("------------------------------------------------\n");
        printf("------------------------------------------------\n");
        printf("------------------------------------------------\n\n");

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

int trainingANN(char* fn_data, char* prefixres, int count, char* SolarTherm_path)
{   
    int l = snprintf(NULL,0,"%d",count); // calculate the amount of memory to be allocated for index
    char* index = malloc(sizeof(char*)*l);    
    sprintf(index,"%d",count); //convert integer into string 

    l = strlen("python ") + strlen(SolarTherm_path) + strlen("/Resources/Include/trainANN.py ")+ 1;
    char* base_cmd = malloc(sizeof(char*)*l);
    strcpy(base_cmd,"python ");
    strcat(base_cmd,SolarTherm_path);
    strcat(base_cmd,"/Resources/Include/trainANN.py ");

    l = strlen(base_cmd) + strlen(fn_data) + strlen(" ") + strlen(prefixres) + strlen(" ") + strlen(index) + 1;
    char* cmd = malloc(sizeof(char*)*(l));
    
    strcpy(cmd,base_cmd);
    strcat(cmd,fn_data);
    strcat(cmd," ");
    strcat(cmd,prefixres);
    strcat(cmd," ");
    strcat(cmd,index);

    fprintf(stderr,"%s\n",cmd);
    
    int status_training = system(cmd);

    if (status_training==0)
    {
        fprintf(stderr,"Training ANN has been finished without any error\n");
        return 0;
    }
    else 
    {
        fprintf(stderr,"Training error with status %d\n",status_training);
        return -1;
    }
}

void getWeight(gsl_matrix* INVERSE_LSM, gsl_matrix* COVARIANCE, gsl_matrix* WEIGHTS, int rows)
{
    double val;
    double InverseVal;
    double CovarianceVal;
    for(size_t i=0;i<rows;i++)
    {
        val = 0;
        for(size_t j=0;j<rows;j++)
        {
            InverseVal = gsl_matrix_get(INVERSE_LSM,i,j);
            CovarianceVal = gsl_matrix_get(COVARIANCE,j,rows);
            val = val + (InverseVal*CovarianceVal);
        }
        gsl_matrix_set(WEIGHTS,i,0,val);
    }
}

void completeCovarianceMatrix(Kriging_struct* Kriging_variables, char* type, char* which_eta)
{
    double Range;
    double Nugget;
    double Spherical;

    int rows = Kriging_variables->rows;

    if(strcmp(which_eta,"eta_gross")==0)
    {
        Range = Kriging_variables->Range_PB;
        Nugget = Kriging_variables->Nugget_PB;
        Spherical = 1 - Kriging_variables->Nugget_PB;
    }
    else if(strcmp(which_eta,"eta_Q")==0)
    {
        Range = Kriging_variables->Range_HX;
        Nugget = Kriging_variables->Nugget_HX;
        Spherical = 1 - Kriging_variables->Nugget_HX;
    }
    else
    {
        fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q\n");
        exit(EXIT_FAILURE);
    }

    double sum = Nugget + Spherical;
    
    for(size_t i=0;i<rows;i++)
    {
        if(strcmp(which_eta,"eta_gross")==0)
        {
            gsl_matrix_set(
                Kriging_variables->COVARIANCE_PB,i,rows,
                sum - gsl_matrix_get(Kriging_variables->VARIOGRAM_PB,i,rows)
                );   
        }
        else if(strcmp(which_eta,"eta_Q")==0)
        {
            gsl_matrix_set(
                Kriging_variables->COVARIANCE_HX,i,rows,
                sum - gsl_matrix_get(Kriging_variables->VARIOGRAM_HX,i,rows)
                );   
        }
        else
        {
            fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q\n");
            exit(EXIT_FAILURE);
        }
           
    }
    
}

int trainingANNReceiver(char* fn_data, char* prefixres, int count, char* SolarTherm_path)
{   
    int l = snprintf(NULL,0,"%d",count); // calculate the amount of memory to be allocated for index
    char* index = malloc(sizeof(char*)*l);    
    sprintf(index,"%d",count); //convert integer into string 

    l = strlen("python ") + strlen(SolarTherm_path) + strlen("/Resources/Include/trainANNReceiver.py ")+ 1;
    char* base_cmd = malloc(sizeof(char*)*l);
    strcpy(base_cmd,"python ");
    strcat(base_cmd,SolarTherm_path);
    strcat(base_cmd,"/Resources/Include/trainANNReceiver.py ");

    l = strlen(base_cmd) + strlen(fn_data) + strlen(" ") + strlen(prefixres) + strlen(" ") + strlen(index) + 1;
    char* cmd = malloc(sizeof(char*)*(l));
    
    strcpy(cmd,base_cmd);
    strcat(cmd,fn_data);
    strcat(cmd," ");
    strcat(cmd,prefixres);
    strcat(cmd," ");
    strcat(cmd,index);

    fprintf(stderr,"%s\n",cmd);
    
    int status_training = system(cmd);

    if (status_training==0)
    {
        fprintf(stderr,"Training ANN has been finished without any error\n");
        return 0;
    }
    else 
    {
        fprintf(stderr,"Training error with status %d\n",status_training);
        return -1;
    }
}

void completeVariogramMatrix(Kriging_struct* Kriging_variables, char* type, char* which_eta)
{
    double var;
    double dist;
    double multiplier;
    double Range;
    double Nugget;
    double Spherical;

    int rows = Kriging_variables->rows;

    if(strcmp(which_eta,"eta_gross")==0)
    {
        Range = Kriging_variables->Range_PB;
        Nugget = Kriging_variables->Nugget_PB;
        Spherical = 1 - Kriging_variables->Nugget_PB;
    }
    else if(strcmp(which_eta,"eta_Q")==0)
    {
        Range = Kriging_variables->Range_HX;
        Nugget = Kriging_variables->Nugget_HX;
        Spherical = 1 - Kriging_variables->Nugget_HX;
    }
    else
    {
        fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q\n");
        exit(EXIT_FAILURE);
    }

    for(size_t i=0;i<rows;i++)
    {
        dist = gsl_matrix_get(Kriging_variables->DISTANCE,i,rows);

        if (strcmp(type,"spherical")==0)
        {
            if(fabs(dist)>Range)
            {
                multiplier = 1;
            }
            else
            {
                multiplier = 1.5 * (dist/Range) - 0.5 * pow(dist/Range,3);
            }
        }
        else if (strcmp(type,"gaussian")==0)
        {
            double dist_square = pow(dist,2);
            double range_square = pow(Range,2);
            multiplier = 1 - exp(-dist_square/range_square);
        }

        else if (strcmp(type,"exponential")==0)
        {
            multiplier = 1 - exp(-fabs(dist)/Range);
        }

        else if (strcmp(type,"nugget")==0)
        {
            multiplier = Range;
        }

        else if (strcmp(type,"power")==0)
        {
            multiplier = pow(Range,2);
        }

        else
        {
            printf("Variogram model is not valid\n");
            return;
        }                  
        
        if(strcmp(which_eta,"eta_gross")==0)
        {
            gsl_matrix_set(Kriging_variables->VARIOGRAM_PB,i,rows, Nugget + Spherical * multiplier);
        }
        else if(strcmp(which_eta,"eta_Q")==0)
        {
            gsl_matrix_set(Kriging_variables->VARIOGRAM_HX,i,rows, Nugget + Spherical * multiplier);
        }
        else
        {
            fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q\n");
            exit(EXIT_FAILURE);
        }
                        
    }
}

void completeDistanceMatrix(Kriging_struct* Kriging_variables, double* inputs, int inputsize)
{
    double square_difference;
    double delta;
    double dist;
    int rows = Kriging_variables->rows;

    for(size_t i=0;i<rows;i++)
    {
        square_difference = 0;

        for(size_t j=0;j<inputsize;j++)
        {
            delta = Kriging_variables->trainingData[i][j]- inputs[j];
            square_difference = square_difference + (delta*delta);
        }

        dist = pow(square_difference,0.5);
        gsl_matrix_set(Kriging_variables->DISTANCE,i,rows,dist);

    }
}

void eucledianDistance_2(Kriging_struct* Kriging_variables, int rows, int inputsize, gsl_matrix* DISTANCE)
{
    double square_difference;
    double delta;
    double dist;

    for(size_t i=0;i<rows;i++)
    {
        for(size_t j=0;j<rows;j++)
        {
            square_difference = 0;

            if(i==j) //Diagonal Matrix --> 0
            {
                gsl_matrix_set(DISTANCE,i,j,0.0);
            }

            else
            {
                for(size_t l=0;l<inputsize;l++) 
                {
                    delta = Kriging_variables->trainingData[i][l] - Kriging_variables->trainingData[j][l];
                    //printf("%lf - %lf = %lf\n",training_data[i][l],training_data[j][l],delta);
                    square_difference = square_difference + (delta*delta);
                }
                dist = pow(square_difference,0.5);
                //printf("SQUARE DIFFERENCE = %lf\n",square_difference);
                //printf("DISTANCE = %lf\n",dist);
                //printf("SET DISTANCE[%zu][%zu] = %lf\n",i,j,dist);
                gsl_matrix_set(DISTANCE,i,j,dist);
            }
        }
    }
}

double** create2Darray(int row, int col)
{
    int i;
    double** arr;
    arr = malloc(sizeof(double*)*row);
    for(i=0;i<row;i++)
    {
        arr[i] = malloc(sizeof(double*)*col);
    }
    return arr;
}

int getNumOfData(char* filepath)
{   
    /*Declare a variable to store the string from CSV*/
    char line[limitSize];
    int i = 0;

    /*Open the file*/
    FILE* training_file = fopen(filepath,"r");
    if (training_file==NULL)
    {
        printf("Your file doesn't exist! Check your address %s!\n",filepath);
        return -1;
    }

    /*Let's skip the header, shall we?!*/
    fgets(line,limitSize,training_file);

    /*Read the data!*/
    fgets(line,limitSize,training_file);
    while(!feof(training_file))
    {
        i++;
        fgets(line,limitSize,training_file);
    }
    fclose(training_file);

    return i;
}

void checkConfig(double P_net, double T_in_ref_blk, double p_high, double PR, double pinch_PHX, 
double dTemp_HTF_PHX, int* index_and_status, char* base_path, int PB_model,
double dT_PHX_hot_approach,  double dT_PHX_cold_approach,
double eta_isen_mc, double eta_isen_rc, double eta_isen_t,double dT_mc_approach,double T_amb_base)
{
    char line[limitSize];
    int matching_index = -1000;
    int status = -1000;

    /*Check if the design param is already existing*/
    char* configdir = "/configurations/";
    char* configbase;
    if(PB_model==0)
    {
        configbase = "config";  
    }  
    else if(PB_model==1)
    {
        configbase = "configNREL";
    }
    else
    {
        fprintf(stderr,"PB model choice is invalid. Choose 0 for CEA PB, 1 for NREL-SAM PB. Your choice is %d\n",PB_model);
        exit(EXIT_FAILURE);
    }

    char* file_extension = ".txt";
    int file_index = 0;
    int l = snprintf(NULL,0,"%d",file_index); // calculate the amount of memory to be allocated for index
    char* index_string = malloc(sizeof(char*)*l);    
    
    sprintf(index_string,"%d",file_index); //convert integer into string  

    //Unify index_string with configname
    l = strlen(base_path) + strlen(configbase) + strlen(index_string) + strlen(file_extension) + 1;
    char* config_file_path = malloc(sizeof(char*)*l);
    strcpy(config_file_path,base_path); //copy the basepath into configname
    strcat(config_file_path,configdir); //copy the "config" into configname
    strcat(config_file_path,configbase); //copy the "config" into configname
    strcat(config_file_path,index_string); //concatenate configname with indexstring e.g. result config0
    strcat(config_file_path,file_extension); //concatenate file extension e.g. config0.txt

    FILE* configfile = fopen(config_file_path,"r");

    //*******************start reading
    while(configfile != NULL)
    {
        //**************** get the 1st line
        fgets(line,limitSize,configfile);

        //**************** get the 2nd line where the information is
        fgets(line,limitSize,configfile);

        //**************** start scanning the information
        //Initialise CEA PB and NREL parameters that want to be compared
        double P_net_exisiting, T_in_ref_blk_existing, p_high_existing, 
        PR_existing, pinch_PHX_existing, dTemp_HTF_PHX_existing, 
        dT_PHX_hot_approach_existing, dT_PHX_cold_approach_existing, eta_isen_mc_existing, 
        eta_isen_rc_existing,eta_isen_t_existing, dT_mc_approach_existing, T_amb_base_existing;

        double deviation_of_configurations;

        if(PB_model==0)/*CEA PB config file template*/
        {
            sscanf
            (
                line,"%lf,%lf,%lf,%lf,%lf,%lf",
                &P_net_exisiting,
                &T_in_ref_blk_existing,
                &p_high_existing,
                &PR_existing,
                &pinch_PHX_existing,
                &dTemp_HTF_PHX_existing
            );
            double deviation_P_net = P_net_exisiting - P_net;
            double deviation_T_in_ref_blk = T_in_ref_blk_existing - T_in_ref_blk;
            double deviation_p_high = p_high_existing - p_high;
            double deviation_PR = PR_existing - PR;
            double deviation_pinch_PHX = pinch_PHX_existing - pinch_PHX;
            double deviation_dTemp_HTF_PHX = dTemp_HTF_PHX_existing - dTemp_HTF_PHX;
            deviation_of_configurations = fabs(deviation_P_net + deviation_T_in_ref_blk + 
                                             deviation_p_high + deviation_PR + deviation_pinch_PHX + 
                                             deviation_dTemp_HTF_PHX);
        }
        else
        {
            sscanf
            (
                line,"%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf",
                &P_net_exisiting,
                &T_in_ref_blk_existing,
                &p_high_existing,
                &dT_PHX_hot_approach_existing,
                &dT_PHX_cold_approach_existing,
                &eta_isen_mc_existing,
                &eta_isen_rc_existing,
                &eta_isen_t_existing,
                &dT_mc_approach_existing,
                &T_amb_base_existing
            );
            double deviation_P_net = P_net_exisiting - P_net;
            double deviation_T_in_ref_blk = T_in_ref_blk_existing - T_in_ref_blk;
            double deviation_p_high = p_high_existing - p_high;
            double deviation_dT_PHX_hot_approach = dT_PHX_hot_approach_existing - dT_PHX_hot_approach;
            double deviation_dT_PHX_cold_approach = dT_PHX_cold_approach_existing - dT_PHX_cold_approach;
            double deviation_eta_isen_mc = eta_isen_mc_existing - eta_isen_mc;
            double deviation_eta_isen_rc = eta_isen_rc_existing - eta_isen_rc;
            double deviation_eta_isen_t = eta_isen_t_existing - eta_isen_t;
            double deviation_dT_mc_approach = dT_mc_approach_existing - dT_mc_approach;
            double deviation_T_amb_base = T_amb_base_existing - T_amb_base;
            deviation_of_configurations = fabs(deviation_P_net + deviation_T_in_ref_blk + 
                                             deviation_p_high + deviation_dT_PHX_hot_approach + deviation_dT_PHX_cold_approach+
                                             deviation_eta_isen_mc + deviation_eta_isen_rc + deviation_eta_isen_t +
                                             deviation_dT_mc_approach+deviation_T_amb_base);            
        }
        
        
        
        if(deviation_of_configurations < 1e-3)
        {
            matching_index = file_index;
            status = 0; //******changing status to 0 from -1000 s.t. we dont need to gather the data
            fprintf(stderr,"Configuration match in: %s\n",config_file_path);
        }
        else
        { 
            fprintf(stderr,"Configuration doesn't match in: %s\n",config_file_path);
        }
        
        
        file_index++; //**********increasing the file index
        
        //*********** Try opening the next file
        l = snprintf(NULL,0,"%d",file_index);
        index_string = malloc(sizeof(char*)*l); 

        sprintf(index_string,"%d",file_index); //convert integer into string  

        //Unify index_string with configname
        l = strlen(base_path) + strlen(configbase) + strlen(index_string) + strlen(file_extension) + 1;
        config_file_path = malloc(sizeof(char*)*l);
        strcpy(config_file_path,base_path); //copy the basepath into configname
        strcat(config_file_path,configdir); //copy the "config" into configname
        strcat(config_file_path,configbase); //copy the "config" into configname
        strcat(config_file_path,index_string); //concatenate configname with indexstring e.g. result config0
        strcat(config_file_path,file_extension); //concatenate file extension e.g. config0.txt
        configfile = fopen(config_file_path,"r");
    }

    //************** If no file is matching --> matching index is -1000, 
    //************** force the value of matching index = file_index for foldering purpose of the new training data
    if(matching_index == -1000)
    {
        fprintf(stderr,"No match in the data base!\n");
        matching_index = file_index;
        status = 1;
    }

    /*If status == 1, then we have to gather the training data, if status-*/
    index_and_status[0] = matching_index; 
    index_and_status[1] = status;

    free(config_file_path);
    return;
}

void generateTrainingData(double P_net, double T_in_ref_blk, double p_high, 
    double PR, double pinch_PHX, double dTemp_HTF_PHX, int match_index, int numdata, char* base_path, int status_config, 
    char* SolarTherm_path)
{
    char* training_dir_name = "/training_data/";
    int l = strlen(base_path) + strlen(training_dir_name) + 1;
    char* training_dir = malloc(sizeof(char*)*l);
    strcpy(training_dir,base_path);
    strcat(training_dir,training_dir_name);

    char* configbase = "config";

    /*Convert matching_index from integer to string*/
    l = snprintf(NULL,0,"%d",match_index);
    char* index_string = malloc(sizeof(char*)*l); 
    sprintf(index_string,"%d",match_index); //convert integer into string  

    l = strlen(training_dir) + strlen(configbase) + strlen(index_string) + 1;
    char* dirname = malloc(sizeof(char*)*l);
    strcpy(dirname,training_dir); //copy training_dir and insert it in dirname memory space
    strcat(dirname,configbase); //concatenate configbase with dirname e.g. result /training_data-dummy/config
    strcat(dirname,index_string); //concatenate index e.g. result /training_data-dummy/config0

    /*Call python function here to gather data*/
    // ppath: path of the Python script
    // pname: name of the Python script
    // pfunc: name of the Python function
    // psave: directory of saving the results from mcrt

    PyObject *pName, *pModule, *pFunc;
    PyObject *pArgs, *inputs;


	char* ppath = base_path;
    char* pname = "gatherdata"; //gatherdata.py
    char* pfunc = "gather_data"; //def gather_data(inputs)

    Py_Initialize(); /*  Initialize Interpreter  */

    //Obtain the python path, append it with the ppath
    PyObject *sys_path = PySys_GetObject("path");
    PyList_Append(sys_path, PyString_FromString((char *) ppath));
  
    //Convert the pname into Python String
    pName = PyString_FromString(pname);

    //Import the script into C environment using PyImport_Import
    pModule = PyImport_Import(pName);
    Py_DECREF(pName);
    
    /*Check python script: exist or not!*/
    if (pModule != NULL) 
    {
        /*Obtain the function from the imported python script*/
        pFunc = PyObject_GetAttrString(pModule, pfunc);

        pArgs = PyTuple_New(1);

        /*if the function is callable*/
        if (pFunc && PyCallable_Check(pFunc)) 
        {
            /*Instantiate a python dictionary and assign it to inputs (pointer type)*/
            inputs = PyDict_New();

            /*Populate the python dictionary*/
            PyDict_SetItemString(inputs, "P_net", PyFloat_FromDouble(P_net));
            PyDict_SetItemString(inputs, "T_in_ref_blk", PyFloat_FromDouble(T_in_ref_blk));
            PyDict_SetItemString(inputs, "p_high", PyFloat_FromDouble(p_high));
            PyDict_SetItemString(inputs, "PR", PyFloat_FromDouble(PR));
            PyDict_SetItemString(inputs, "pinch_PHX", PyFloat_FromDouble(pinch_PHX));
            PyDict_SetItemString(inputs, "dTemp_HTF_PHX", PyFloat_FromDouble(dTemp_HTF_PHX));
            PyDict_SetItemString(inputs, "numdata", PyInt_FromLong(numdata));
            PyDict_SetItemString(inputs, "dirres", PyString_FromString((char *)dirname));
            PyDict_SetItemString(inputs, "status_config", PyInt_FromLong(status_config));
            PyDict_SetItemString(inputs, "SolarTherm_path",PyString_FromString((char*)SolarTherm_path));
            
            PyTuple_SetItem(pArgs, 0, inputs);

            PyObject_CallObject(pFunc, pArgs);
            Py_DECREF(inputs);
            Py_DECREF(pArgs);
        }
        else 
        {
            if (PyErr_Occurred())
            {
                PyErr_Print();
            }
            else
            {
                fprintf(stderr, "Cannot find function \"%s\"\n", pfunc);
            }
        }
        Py_XDECREF(pFunc);
        Py_DECREF(pModule);
    }

    /*if python script does not exist*/
    else 
    {
        PyErr_Print();
        fprintf(stderr, "Failed to load \"%s\"\n", pname);
    }

    
    /*Free the heap*/
    free(training_dir);
    free(index_string);
    free(dirname);

    //Py_DECREF(ppath);
    //Py_DECREF(pname);
    //Py_DECREF(pfunc);
    //Py_DECREF(sys_path);
    //Py_Finalize();

    return;
}

void* load_KrigingVariables(char* filepathtraining, int inputsize, int outputsize, double Nugget_PB, 
double Nugget_HX, double sill_PB, double sill_HX, double Range_PB, double Range_HX,
double load_base, double T_in_ref_blk,double T_amb_base, double deviation_load_max,
double deviation_T_in_max, double deviation_T_amb_max ,double deviation_eta_gross_max,
double deviation_eta_Q_max,double deviation_load_min,double deviation_T_in_min, double deviation_T_amb_min,
double deviation_eta_gross_min, double deviation_eta_Q_min, char* variogram_model)
{
    /*This function is for populating the Kriging_trianing_struct*/
    char line[limitSize];
    Kriging_struct* Kriging_variables = malloc(sizeof(Kriging_struct));

    /*Open the file*/
    FILE* training_file = fopen(filepathtraining,"r");
    if (training_file==NULL)
    {
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
    Kriging_variables->trainingData = malloc(sizeof(double*)*Kriging_variables->rows);
    for(size_t i=0;i<rows;i++)
    {
        Kriging_variables->trainingData[i] = malloc(sizeof(double*)*(inputsize+outputsize)); /*for each element in the memory address, create number of r of integer*/
    }

    /*Skip the header*/
    fgets(line,limitSize,training_file);

    /*Read the data!*/
    fgets(line,limitSize,training_file);
    size_t i = 0;
    while(!feof(training_file))
    {
        sscanf
        (
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

    for(size_t i=0;i<rows;i++)
    {
        for(size_t j=0;j<rows;j++)
        {
            square_difference = 0;

            if(i==j) //Diagonal Matrix --> 0
            {
                gsl_matrix_set(Kriging_variables->DISTANCE,i,j,0.0);
            }

            else
            {
                for(size_t l=0;l<inputsize;l++) 
                {
                    delta = Kriging_variables->trainingData[i][l] - Kriging_variables->trainingData[j][l];
                    //printf("%lf - %lf = %lf\n",training_data[i][l],training_data[j][l],delta);
                    square_difference = square_difference + (delta*delta);
                }
                dist = pow(square_difference,0.5);
                //printf("SQUARE DIFFERENCE = %lf\n",square_difference);
                //printf("DISTANCE = %lf\n",dist);
                //printf("SET DISTANCE[%zu][%zu] = %lf\n",i,j,dist);
                gsl_matrix_set(Kriging_variables->DISTANCE,i,j,dist);
            }
        }
    }
    
    //********************** LHS VARIOGRAM PB
    double var;
    double multiplier;
    double Range_variogram = Kriging_variables->Range_PB;
    double Nugget_variogram = Kriging_variables->Nugget_PB;
    double Spherical_variogram = 1 - Kriging_variables->Nugget_PB;
    for(size_t i=0;i<rows;i++)
    {
        for(size_t j=0;j<rows;j++)
        {
            if(i==j)
            {
                gsl_matrix_set(Kriging_variables->VARIOGRAM_PB,i,j,0.0);
            }
            else
            {
                dist = gsl_matrix_get(Kriging_variables->DISTANCE,i,j);

                if (strcmp(variogram_model,"spherical")==0)
                {
                    if(dist>Range_variogram)
                    {
                        multiplier = 1;
                    }
                    else
                    {
                        multiplier = 1.5 * (dist/Range_variogram) - 0.5 * pow(dist/Range_variogram,3);
                    }
                }
                else if (strcmp(variogram_model,"gaussian")==0)
                {
                    double dist_square = pow(dist,2);
                    double range_square = pow(Range_variogram,2);
                    multiplier = 1 - exp(-dist_square/range_square);
                }

                else if (strcmp(variogram_model,"exponential")==0)
                {
                    multiplier = 1 - exp(-fabs(dist)/Range_variogram);
                }

                else if (strcmp(variogram_model,"power")==0)
                {
                    multiplier = pow(Range_variogram,2);
                }

                else if (strcmp(variogram_model,"nugget")==0)
                {
                    multiplier = Range_variogram;
                }

                else
                {
                    fprintf(stderr,"Variogram model is not valid\n");
                    exit(EXIT_FAILURE);
                }
                                
                gsl_matrix_set(Kriging_variables->VARIOGRAM_PB,i,j, Nugget_variogram + Spherical_variogram * multiplier);
            }
            
        }
    }

    //********************** LHS COVARIANCE PB
    double sum_variogram = Nugget_variogram + Spherical_variogram;
    
    for(size_t i=0;i<rows;i++)
    {
        for(size_t j=0;j<rows;j++)
        {
            gsl_matrix_set(Kriging_variables->COVARIANCE_PB,i,j,sum_variogram - gsl_matrix_get(Kriging_variables->VARIOGRAM_PB,i,j));
        }
    }

    //********************** Inverse PB
    gsl_matrix* LSM_PB = gsl_matrix_alloc(rows,rows); 

    for(size_t i=0;i<rows;i++)
    {
        for(size_t j=0;j<rows;j++)
        {
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
    
    for(size_t i=0;i<rows;i++)
    {
        for(size_t j=0;j<rows;j++)
        {
            if(i==j)
            {
                gsl_matrix_set(Kriging_variables->VARIOGRAM_HX,i,j,0.0);
            }
            else
            {
                dist = gsl_matrix_get(Kriging_variables->DISTANCE,i,j);

                if (strcmp(variogram_model,"spherical")==0)
                {
                    if(dist>Range_variogram)
                    {
                        multiplier = 1;
                    }
                    else
                    {
                        multiplier = 1.5 * (dist/Range_variogram) - 0.5 * pow(dist/Range_variogram,3);
                    }
                }
                else if (strcmp(variogram_model,"gaussian")==0)
                {
                    double dist_square = pow(dist,2);
                    double range_square = pow(Range_variogram,2);
                    multiplier = 1 - exp(-dist_square/range_square);
                }

                else if (strcmp(variogram_model,"exponential")==0)
                {
                    multiplier = 1 - exp(-fabs(dist)/Range_variogram);
                }

                else if (strcmp(variogram_model,"power")==0)
                {
                    multiplier = pow(Range_variogram,2);
                }

                else if (strcmp(variogram_model,"nugget")==0)
                {
                    multiplier = Range_variogram;
                }

                else
                {
                    fprintf(stderr,"Variogram model is not valid\n");
                    exit(EXIT_FAILURE);
                }
                                
                gsl_matrix_set(Kriging_variables->VARIOGRAM_HX,i,j, Nugget_variogram + Spherical_variogram * multiplier);
            }
            
        }
    }

    //********************** LHS COVARIANCE HX
    sum_variogram = Nugget_variogram + Spherical_variogram;
    
    for(size_t i=0;i<rows;i++)
    {
        for(size_t j=0;j<rows;j++)
        {
            gsl_matrix_set(Kriging_variables->COVARIANCE_HX,i,j,sum_variogram - gsl_matrix_get(Kriging_variables->VARIOGRAM_HX,i,j));
        }
    }

    //********************** Inverse HX
    gsl_matrix* LSM_HX = gsl_matrix_alloc(rows,rows); 

    for(size_t i=0;i<rows;i++)
    {
        for(size_t j=0;j<rows;j++)
        {
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

char* build_trainingdir_path(char* base_path, char* traindir_base, char* config_base, int match_index)
{
    int l = snprintf(NULL,0,"%d",match_index); 
    char* index_string = malloc(sizeof(char*)*l);    
    
    sprintf(index_string,"%d",match_index); //convert integer into string  

    /*Build the file name for training, validation, min, max, kriging params*/           
    l = strlen(base_path) + strlen(traindir_base) + strlen(config_base) + strlen(index_string) + 1;
    char* trainingdir = malloc(sizeof(char*)*l);
    strcpy(trainingdir,base_path); //copy the basepath into traindir_base
    strcat(trainingdir,traindir_base); //concatenate traindir base with basepath e.g. result /home/philgun/Documents/codecodecode/codecodecode/GSL_Project/training_data-dummy/
    strcat(trainingdir,config_base); //concatenate trainingdir with config_base e.g. result /home/philgun/Documents/codecodecode/codecodecode/GSL_Project/training_data-dummy/config
    strcat(trainingdir,index_string); //concatenate match_index e.g. ./training_data-dummy/config4

    free(index_string);
    return trainingdir;
}

char* concat_training_dir(char* trainingdir, char* concat_string)
{
    int l = strlen(trainingdir) + strlen(concat_string) + 1;
    char* resultpath = malloc(sizeof(char*)*l);
    strcpy(resultpath,trainingdir);
    strcat(resultpath,concat_string);
    return resultpath;
}

void *load_session(char* saved_model_dir, double* X_max, double* X_min, double* y_max, double* y_min, int inputsize, 
int outputsize, double load_base, double T_in_ref_blk, double T_amb_base)
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
    
    //***************************Populate the member of the struct --- TensorFlow properties
    sess->Graph = Graph;
    sess->Session = Session;
    sess->Status = Status;
    sess->SessionOpts = SessionOpts;
    sess->RunOpts = RunOpts;

    //***************************Populate the member of the struct --- Scaler
    sess->X_max = malloc(sizeof(double*)*inputsize);
    sess->X_min = malloc(sizeof(double*)*inputsize);

    sess->y_max = malloc(sizeof(double*)*outputsize);
    sess->y_min = malloc(sizeof(double*)*outputsize);

    for(size_t i=0;i<inputsize;i++)
    {
        sess->X_max[i] = X_max[i];
        sess->X_min[i] = X_min[i];
    }
        
    for(size_t i=0;i<outputsize;i++)
    {
        sess->y_max[i] = y_max[i];
        sess->y_min[i] = y_min[i];
    }

    sess->inputsize = inputsize;

    sess->outputsize = outputsize;

    sess->base_values = malloc(sizeof(double*)*inputsize);

    sess->base_values[0] = load_base;

    sess->base_values[1] = T_in_ref_blk;

    sess->base_values[2] = T_amb_base;

    return sess;
}

/*=================================== STARTING FROM HERE IS FUNCTIONS TO CALL SAM PB ==============================*/
void ssc_test()
{
    printf("SSC version = %d\n", ssc_version());

    ssc_data_t data = ssc_data_create();

    ssc_data_set_string( data, "solar_resource_file", "aaa" );
    const char* text = ssc_data_get_string( data, "solar_resource_file" );
    assert(strcmp(text,"aaa")==0);

    double val = 0.3;
    ssc_data_set_number( data, "dens_mirror", val );

    ssc_number_t dens_mirror;
    ssc_bool_t nerr = ssc_data_get_number( data, "dens_mirror", &dens_mirror );\
    assert(nerr);
    assert(dens_mirror==val);
    ssc_data_free(data);
}

void generateOffDesignFile(double T_in_ref_blk, double load_des, double T_amb_des, 
char* trainingdir, char* base_path, int numinputs, int numdata, char* training_or_validation)
{   
    
    double UB_1 = T_in_ref_blk + 20; //*************** Maximum temperature of the HTF at off design case [C]
    double UB_2 = 1.5; //******************** maximum load
    double UB_3 = 50; //******************* maximum ambient temperature [C]

    double LB_1 = T_in_ref_blk - 50; //*************** Minimum temperature of the HTF at off design case [C]
    double LB_2 = 0.45; //******************** minimum part load
    double LB_3 = -20; //******************* minimum ambient temperature [C]


    PyObject *pName, *pModule, *pFunc;
    PyObject *pArgs, *inputs;

	char* ppath = base_path;
    char* pname = "gen_OD_matrix"; //gen_OD_matrix.py
    char* pfunc;
    if(strcmp(training_or_validation,"training")==0)
    {
        pfunc = "generate_matrix_factorial"; //training data matrix is full factorial
    }
    else if(strcmp(training_or_validation,"validation")==0)
    {
        pfunc = "generate_matrix_validation"; //validation data matrix is full factorial
    }
    else if(strcmp(training_or_validation,"LHS")==0)
    {
        pfunc = "generate_matrix"; //doesn't care which data it is, go with LHS
    }
    else
    {
        fprintf(stderr,"Function is invalid. Choose either validation or trianing. Your choice: %s\n",training_or_validation);
        exit(EXIT_FAILURE);
    }

    Py_Initialize(); /*  Initialize Interpreter  */

    //Obtain the python path, append it with the ppath
    PyObject *sys_path = PySys_GetObject("path");
    PyList_Append(sys_path, PyString_FromString((char *) ppath));
  
    //Convert the pname into Python String
    pName = PyString_FromString(pname);

    //Import the script into C environment using PyImport_Import
    pModule = PyImport_Import(pName);
    Py_DECREF(pName);
    
    
    /*Check python script: exist or not!*/
    if (pModule != NULL) 
    {
        /*Obtain the function from the imported python script*/
        pFunc = PyObject_GetAttrString(pModule, pfunc);

        pArgs = PyTuple_New(1);

        /*if the function is callable*/
        if (pFunc && PyCallable_Check(pFunc)) 
        {
            /*Instantiate a python dictionary and assign it to inputs (pointer type)*/
            inputs = PyDict_New();

            /*Populate the python dictionary*/
            PyDict_SetItemString(inputs, "UB_1", PyFloat_FromDouble(UB_1));
            PyDict_SetItemString(inputs, "UB_2", PyFloat_FromDouble(UB_2));
            PyDict_SetItemString(inputs, "UB_3", PyFloat_FromDouble(UB_3));

            PyDict_SetItemString(inputs, "LB_1", PyFloat_FromDouble(LB_1));
            PyDict_SetItemString(inputs, "LB_2", PyFloat_FromDouble(LB_2));
            PyDict_SetItemString(inputs, "LB_3", PyFloat_FromDouble(LB_3));

            PyDict_SetItemString(inputs, "T_HTF_des", PyFloat_FromDouble(T_in_ref_blk));
            PyDict_SetItemString(inputs, "load_des", PyFloat_FromDouble(load_des));
            PyDict_SetItemString(inputs, "T_amb_des", PyFloat_FromDouble(T_amb_des));
            
            PyDict_SetItemString(inputs, "num_inputs", PyInt_FromLong(numinputs));
            PyDict_SetItemString(inputs, "numdata", PyInt_FromLong(numdata));

            PyDict_SetItemString(inputs, "trainingdir", PyString_FromString((char *)trainingdir));
            
            PyTuple_SetItem(pArgs, 0, inputs);


            PyObject_CallObject(pFunc, pArgs);

            Py_DECREF(inputs);
            Py_DECREF(pArgs);
        }
        else 
        {
            if (PyErr_Occurred())
            {
                PyErr_Print();
            }
            else
            {
                fprintf(stderr, "Cannot find function \"%s\"\n", pfunc);
            }
        }
        Py_XDECREF(pFunc);
        Py_DECREF(pModule);
    }

    /*if python script does not exist*/
    else 
    {
        PyErr_Print();
        fprintf(stderr, "Failed to load \"%s\"\n", pname);
    }


    return;
}

void genPropsArray(char* fn_props, sim_struct* sim)
{
    char line[limitSize];
    
    FILE* fn = fopen(fn_props,"r");

    if(fn==NULL)
    {
        fprintf(stderr,"File doesn't exist. File path: %s\n",fn_props);
        exit(EXIT_FAILURE);
    }

    //************ Skip the 1st line of the CSV
    fgets(line,limitSize,fn); //************> Skip the 1st line

    //************ First get number of rows
    int rows = 0;
    fgets(line,limitSize,fn); //************> Start from the second line
    while(!feof(fn))
    {
        rows++;
        fgets(line,limitSize,fn); 
    }
    fclose(fn);

    sim->rows_props = rows;

    //************* Allocating memory space for array_props array
    sim->array_props = malloc(sizeof(ssc_number_t*)*(sim->rows_props*7));

    //************* Start reading the file and put the data into a flatten array
    fn = fopen(fn_props,"r");
    fgets(line,limitSize,fn); //************> Skip the 1st line

    fgets(line,limitSize,fn); //************> Start from the second line
    size_t i = 0;
    while(!feof(fn))
    {
        sscanf
        (
            line,"%lf,%lf,%lf,%lf,%lf,%lf,%lf",
            &sim->array_props[i],
            &sim->array_props[i+1], 
            &sim->array_props[i+2], 
            &sim->array_props[i+3], 
            &sim->array_props[i+4],
            &sim->array_props[i+5],
            &sim->array_props[i+6]
        );
        i = i + 7;
        fgets(line,limitSize,fn);
    }
    fclose(fn); 


    return;
    
}

void genOffDesignArray(char* fn_OD, sim_struct* sim)
{
    char line[limitSize];
    
    FILE* fn = fopen(fn_OD,"r");

    if(fn==NULL)
    {
        fprintf(stderr,"File doesn't exist. File path: %s\n",fn_OD);
        exit(EXIT_FAILURE);
    }


    //************ First get number of rows
    int rows = 0;
    fgets(line,limitSize,fn);
    while(!feof(fn))
    {
        rows++;
        fgets(line,limitSize,fn); 
    }
    fclose(fn);

    sim->rows_OD = rows;

    //************* Allocating memory space for array_props array
    sim->array_OD = malloc(sizeof(ssc_number_t*)*(sim->rows_OD*6));

    //************* Start reading the file and put the data into a flatten array
    fn = fopen(fn_OD,"r");
    fgets(line,limitSize,fn); 
    size_t i = 0;
    while(!feof(fn))
    {
        sscanf
        (
            line,"%lf,%lf,%lf,",
            &sim->array_OD[i],
            &sim->array_OD[i+1], 
            &sim->array_OD[i+2]
        );
        sim->array_OD[i+3] = 1;
        sim->array_OD[i+4] = 1;
        sim->array_OD[i+5] = 1;
        i = i + 6;
        fgets(line,limitSize,fn);
    }
    fclose(fn);

    /*
    for(size_t i=0;i<sim->rows_OD*6;i++)
    {
        printf("%lf\n",sim->array_OD[i]);
    }
    */

    return;
}

ssc_data_t runNRELPB(int numdata,double P_net, double T_in_ref_blk, double p_high,
    double T_amb_base, double dT_PHX_hot_approach, double dT_PHX_cold_approach, 
    double eta_isen_mc, double eta_isen_rc, double eta_isen_t, double dT_mc_approach,
    char* HTF_name, int HTF_choice, char* trainingdir, char* SolarTherm_path, char* base_path, int status_config, int match_index, 
    int is_OD_simulated)
{
    //******************************************** WRITE CONFIGURATIONS ******************************************************//
    int l = snprintf(NULL,0,"%d",match_index); 
    char* index_string = malloc(sizeof(char*)*l);    
    
    sprintf(index_string,"%d",match_index); //convert integer into string  

    if(status_config==1) //----------------> dump the configurations
    {
        char* path_config = malloc(sizeof(char*)*
            (strlen(base_path)+strlen("/configurations/configNREL")+strlen(index_string)+strlen(".txt")+1)
        );

        strcpy(path_config,base_path);
        strcat(path_config,"/configurations/configNREL");
        strcat(path_config,index_string);
        strcat(path_config,".txt");

        FILE* f = fopen(path_config,"w");
        fprintf(f,
            "P_net,T_in_ref_blk,p_high,dT_PHX_hot_approach,dT_PHX_cold_approach,eta_isen_mc,eta_isen_rc,eta_isen_t,dT_mc_approach,T_amb_base\n"
        );

        fprintf(f,
        "%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf",
            P_net,T_in_ref_blk,p_high,dT_PHX_hot_approach,dT_PHX_cold_approach,
            eta_isen_mc,eta_isen_rc,eta_isen_t,dT_mc_approach,T_amb_base
        );

        fclose(f);
        free(path_config);
    }

    //******************************************** LOAD FLUID PROPS *********************************************************//
    l = strlen(SolarTherm_path) + strlen("/Data/") + strlen(HTF_name) + strlen("/props_for_NREL_PB.csv") + 1;
    char* fn_props = malloc(sizeof(char)*l);
    strcpy(fn_props,SolarTherm_path);
    strcat(fn_props,"/Data/");
    strcat(fn_props,HTF_name);
    strcat(fn_props,"/props_for_NREL_PB.csv");

    sim_struct* sim = malloc(sizeof(sim_struct));
    genPropsArray(fn_props, sim);
    ssc_number_t* htf_props = malloc(sizeof(ssc_number_t)*(sim->rows_props*7));
    htf_props = sim->array_props;
    free(fn_props);

    /*Create SSC Data*/
    ssc_data_t data = ssc_data_create();
    ssc_data_set_number( data, "htf", HTF_choice);                      /*[-] Solar Salt ==> integer, 50 = for User Defined Props*/
    if(HTF_choice==50)
    {
        ssc_data_set_matrix( data, "htf_props", htf_props, sim->rows_props, 7 ); /*user defined HTF property data*/
    }
    if(is_OD_simulated==1)
    {
        //******************************************** LOAD OD MATRIX *********************************************************//
        /*Generate OD training data array*/
        generateOffDesignFile(T_in_ref_blk-273.15, 1, (T_amb_base-273.15),trainingdir, base_path, 3, numdata,"LHS");
        char* fn_OD = malloc(sizeof(char*)*(strlen(trainingdir) + strlen("/OD_matrix.csv") + 1));
        strcpy(fn_OD,trainingdir);
        strcat(fn_OD,"/OD_matrix.csv");
        
        genOffDesignArray(fn_OD, sim);
        ssc_number_t* OD_array = malloc(sizeof(ssc_number_t)*(sim->rows_OD*6));
        OD_array = sim->array_OD;


        //**************************************************************************************************************************//
        double eff_max = 1; 
        double deltaP_recup_HP = 0.0056;                            /*[-] 0.0056 = 0.14[MPa]/25[MPa]. Fraction of press. loss*/
        double deltaP_recup_LP = 0.0311;                            /*[-] 0.0311 = 0.28[MPa]/9[MPa]. Fraction of press. loss*/

        //************************************************ DESIGN POINT ***********************************************************//
        ssc_data_set_number( data, "T_htf_hot_des", (T_in_ref_blk-273.15));  /*[-] Hot tank target temperature*/
        ssc_data_set_number( data, "dT_PHX_hot_approach", dT_PHX_hot_approach);    /*[C/K] Temp. difference between hot HTF and TIT*/
        ssc_data_set_number( data, "dT_PHX_cold_approach", dT_PHX_cold_approach);   /*[C/K] Temp. difference between cold HTF and cold CO2 PHX inlet*/
        ssc_data_set_number( data, "T_amb_des", (T_amb_base-273.15));              /*[C] Ambient temperature at design point*/
        ssc_data_set_number( data, "dT_mc_approach", dT_mc_approach);          /*[C/K] Temp. difference between main compressor CO2 inlet and ambient*/
        ssc_data_set_number( data, "site_elevation", 588.0);        /*[m] Elevation of the site. 588 MASL is Dagget*/    
        ssc_data_set_number( data, "W_dot_net_des", (P_net/1e6));          /*[MWe] Design cle power output ~ no cooling and other parasitics*/ 
        
        /*Simulation configurations*/
        ssc_data_set_number( data, "design_method", 3);             /*[-] 1=specify efficiency ==> integer
                                                                        2=specify total Recup UA, 
                                                                        3=specify each recuperator design*/
        ssc_data_set_number( data, "eta_thermal_des", -1);          /*[-] Power cycle target thermal eff. at design point. Not used here*/
        ssc_data_set_number( data, "UA_recup_tot_des",-1);          /*[kW/K] total UA recuperators value - not used here*/

        ssc_data_set_number( data, "cycle_config",1);               /*[-] 1=Recompression cycle ==> integer
                                                                        2=Partial cooling cycle*/
        
        ssc_data_set_number( data, "is_recomp_ok", 1);              /*[-] 1=Recompression cycle ==> integer
                                                                        2=Partial cooling cycle*/
        ssc_data_set_number( data, "is_P_high_fixed", 1);           /*[-] 1 = Yes (=P_high_limit), 0 = No, optimized (default)
                                                                        ==> integer*/
        
        ssc_data_set_number( data, "is_PR_fixed", 0);               /*[-] 1=Yes, 0=no ==> integer*/

        ssc_data_set_number( data, "des_objective", 1);             /* 2 = hit min deltaT then max efficiency, 
                                                                    != 2 = max efficiency*/

        ssc_data_set_number( data, "min_phx_deltaT", 1000.0);       /*[C] Min allowable deltaT across PHX*/
        
        ssc_data_set_number( data, "rel_tol", 3);                   /*[-] Baseline solver and optimization relative 
                                                                    tolerance exponent (10^-rel_tol)*/

        ssc_data_set_number( data, "eta_isen_mc", eta_isen_mc);     /*isentropic eff. of the main comp.*/
        ssc_data_set_number( data, "eta_isen_pc", 0.85 );           /*isentropic eff. of the pre-comp. ==> not used*/
        ssc_data_set_number( data, "eta_isen_rc", eta_isen_rc);     /*isentropic eff. of the re-comp.*/


        ssc_data_set_number( data, "eta_isen_t", eta_isen_t);             /*Turbine isentropic eff. at design point*/
        ssc_data_set_number( data, "P_high_limit", (p_high/1e6));         /*Compressor pressure limit [MPa]*/
        
        /*LTR Design Parameters*/
        ssc_data_set_number( data, "LTR_design_code", 2);           /*[-] 1=UA, 2=min dT, 3=effectiveness ==> integer*/
        ssc_data_set_number( data, "LTR_UA_des_in", -1);            /*[kW/K] ((required if LTR_design_code == 1 and design_method == 3) 
                                                                    not used now*/
        ssc_data_set_number( data, "LTR_min_dT_des_in", 10.0);      /*[C/K]required if LTR_design_code == 2 and design_method == 3) 
                                                                    reasonable value" from Neises/Turchi*/
        ssc_data_set_number( data, "LTR_eff_des_in", -1);           /*required if LTR_design_code == 3 and design_method == 3*/
        ssc_data_set_number( data, "LT_recup_eff_max", eff_max);
        ssc_data_set_number( data, "LTR_LP_deltaP_des_in", deltaP_recup_LP);
        ssc_data_set_number( data, "LTR_HP_deltaP_des_in", deltaP_recup_HP);

        /*HTR Design Parameters*/
        ssc_data_set_number( data, "HTR_design_code", 2);           /*[-] 1=UA, 2=min dT, 3=effectiveness ==> integer*/
        ssc_data_set_number( data, "HTR_UA_des_in", -1);            /*[kW/K] ((required if HTR_design_code == 1 and design_method == 3) 
                                                                    not used now*/
        ssc_data_set_number( data, "HTR_min_dT_des_in", 10.0);      /*[C/K]required if LTR_design_code == 2 and design_method == 3) 
                                                                    reasonable value" from Neises/Turchi*/
        ssc_data_set_number( data, "HTR_eff_des_in", -1);           /*required if LTR_design_code == 3 and design_method == 3*/
        ssc_data_set_number( data, "HT_recup_eff_max", eff_max);    
        ssc_data_set_number( data, "HTR_LP_deltaP_des_in", deltaP_recup_LP);                                                           
        ssc_data_set_number( data, "HTR_HP_deltaP_des_in", deltaP_recup_HP);

        /*PHX Design Parameters*/
        ssc_data_set_number( data, "PHX_co2_deltaP_des_in",deltaP_recup_HP);  /*Pressure drop in heat exchanger*/

        /*Dry Cooler Parameters*/
        ssc_data_set_number( data, "deltaP_cooler_frac", 0.005);    /*[-] Fraction of CO2 inlet pressure that is design point 
                                                                        cooler CO2 pressure drop*/
        ssc_data_set_number( data, "fan_power_frac", 0.02);         /*[-] Fraction of net cycle power consumed by air cooler fan. 
                                                                        2% here per Turchi et al.*/                                                                     
        
        /*Default Parameters*/
        ssc_data_set_number( data, "deltaP_counterHX_frac",-1); /*[-] Fraction of CO2 inlet pressure that is design point counterflow HX 
                                                                    (recups & PHX) pressure drop*/


        /*Off-design Parameters*/
        ssc_data_set_number( data, "od_rel_tol", 3);            /*[-] Baseline off-design relative 
                                                                convergence tolerance exponent (10^-od_rel_tol)*/

        //************************************************ OFF DESIGN POINT ********************************************************//
        ssc_data_set_matrix( data, "od_cases", OD_array, sim->rows_OD, 6); /*user Off design cases*/

        printf("Rows properties: %d, Rows OD: %d \n",sim->rows_props,sim->rows_OD);

        
        /*Instantiate the sCO2 PB module in SAM*/
        ssc_module_t module = ssc_module_create("sco2_csp_system");

        if(ssc_module_exec(module,data)==0)
        {
            fprintf(stderr,"Error in simulation!\n");
            ssc_module_free(module);
            ssc_data_free(data);
            exit(EXIT_FAILURE);
        }

        ssc_number_t val;
        ssc_bool_t status_call = ssc_data_get_number(data,"eta_thermal_calc",&val); //address of the value is assigned to eta
        double eta_thermal_cycle_des = val; //************************retrieve eta cycle at design point

        ssc_number_t m;
        status_call = ssc_data_get_number(data, "m_dot_htf_des",&m);
        
        ssc_number_t p_low;
        status_call = ssc_data_get_number(data,"t_P_out_des",&p_low);

        ssc_number_t Q_dot_PHX_des;
        status_call = ssc_data_get_number(data,"q_dot_PHX",&Q_dot_PHX_des);

        ssc_number_t T_HTF_cold_des;
        status_call = ssc_data_get_number(data,"T_htf_cold_des",&T_HTF_cold_des);

        /*Get the off design result*/
        int len = sim->rows_OD;

        ssc_number_t* Q_dot_cycle = ssc_data_get_array(data, "Q_dot_od",&len);
        ssc_number_t* eta_cycle_OD = ssc_data_get_array(data,"eta_thermal_od",&len);
        ssc_number_t* W_cooler_OD = ssc_data_get_array(data,"cooler_tot_W_dot_fan_od",&len);
        ssc_number_t* W_net_OD = ssc_data_get_array(data,"W_dot_net_od",&len); //*********** Before cooling power

        /*Start writing the training data*/
        int length_fn = strlen(trainingdir) + strlen("/training_data.csv") + 1;
        char* fn = malloc(sizeof(char*)*length_fn);
        strcpy(fn,trainingdir);
        strcat(fn,"/training_data.csv");

        FILE* f = fopen(fn,"r");
        if(f==NULL) /*If file doesn't exist, create the file and write the header*/
        {
            f = fopen(fn,"w");
            fprintf(f,"P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,load,T_HTF_in,T_amb_input,eta_gross,eta_Q,\n");
            fclose(f);
        }
        
        f = fopen(fn,"a");
        
        for(size_t i=0;i<len;i++)
        {
            fprintf(
                f,
                "%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,\n",
                P_net,T_in_ref_blk,p_high,-1.0,-1.0,-1.0,
                sim->array_OD[i*6 + 1],                              /*Load*/
                sim->array_OD[i*6] + 273.15,                        /*T_HTF_in [K]*/                                               
                sim->array_OD[i*6 + 2] + 273.15,                    /*T_amb_in [K]*/
                (W_net_OD[i] - W_cooler_OD[i])/(Q_dot_cycle[i]),    /*eta_gross = (W cycle - W cooler) / Q_HX*/
                Q_dot_cycle[i]/Q_dot_PHX_des                        /*eta_Q = Q_HX/Q_HX_design*/
            );
        }
        
        fclose(f);

        /*Generate validation data array*/
        int rowval = 15;
        generateOffDesignFile(T_in_ref_blk-273.15, 1, (T_amb_base-273.15),trainingdir, base_path, 3, rowval,"LHS");
        genOffDesignArray(fn_OD, sim);
        free(fn_OD);
        len = sim->rows_OD;

        OD_array = malloc(sizeof(ssc_number_t)*(sim->rows_OD*6));
        OD_array = sim->array_OD;
        ssc_data_set_matrix( data, "od_cases", OD_array, sim->rows_OD, 6); /*user Off design cases*/
        if(ssc_module_exec(module,data)==0)
        {
            fprintf(stderr,"Error in simulation!\n");
            ssc_module_free(module);
            ssc_data_free(data);
            exit(EXIT_FAILURE);
        }

        ssc_number_t* Q_dot_cycle_val = ssc_data_get_array(data, "Q_dot_od",&rowval);
        ssc_number_t* W_cooler_OD_val = ssc_data_get_array(data,"cooler_tot_W_dot_fan_od",&rowval);
        ssc_number_t* W_net_OD_val = ssc_data_get_array(data,"W_dot_net_od",&rowval); //*********** Before cooling power

        /*Start writing the validation data*/    
        int length_fnval = strlen(trainingdir) + strlen("/validation_data.csv") + 1;
        char* fn_val = malloc(sizeof(char*)*length_fnval);
        strcpy(fn_val,trainingdir);
        strcat(fn_val,"/validation_data.csv");

        FILE* g = fopen(fn_val,"r");
        if(g==NULL) /*If file doesn't exist, create the file and write the header*/
        {
            g = fopen(fn_val,"w");
            fprintf(g,"P_net,T_in_ref_blk,p_high,PR,pinch_PHX,dTemp_HTF_PHX,load,T_HTF_in,T_amb_input,eta_gross,eta_Q,\n");
            fclose(g);
        }
        
        g = fopen(fn_val,"a");
        
        for(size_t i=0;i<rowval;i++)
        {
            fprintf(
                g,
                "%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,\n",
                P_net,T_in_ref_blk,p_high,-1.0,-1.0,-1.0,
                sim->array_OD[i*6 + 1],                              /*Load*/
                sim->array_OD[i*6] + 273.15,                        /*T_HTF_in [K]*/                                               
                sim->array_OD[i*6 + 2] + 273.15,                    /*T_amb_in [K]*/
                (W_net_OD_val[i] - W_cooler_OD_val[i])/(Q_dot_cycle_val[i]),    /*eta_gross = (W cycle - W cooler) / Q_HX*/
                Q_dot_cycle_val[i]/Q_dot_PHX_des                        /*eta_Q = Q_HX/Q_HX_design*/
            );
        }
        
        fclose(g);



        /*Data Processing*/
        dataProcessing(fn, trainingdir, base_path);
    
        ssc_module_free(module);
        
        free(OD_array);
        free(fn);
        free(fn_val);

    }
    else
    {   
        fprintf(stderr,"===========================SIMULATE NREL SAM PB ON DESIGN ONLY =================================\n");
        
        //**************************************************************************************************************************//
        double eff_max = 1; 
        double deltaP_recup_HP = 0.0056;                            /*[-] 0.0056 = 0.14[MPa]/25[MPa]. Fraction of press. loss*/
        double deltaP_recup_LP = 0.0311;                            /*[-] 0.0311 = 0.28[MPa]/9[MPa]. Fraction of press. loss*/

        //************************************************ DESIGN POINT ***********************************************************//
        ssc_data_set_number( data, "T_htf_hot_des", (T_in_ref_blk-273.15));  /*[-] Hot tank target temperature*/
        ssc_data_set_number( data, "dT_PHX_hot_approach", dT_PHX_hot_approach);    /*[C/K] Temp. difference between hot HTF and TIT*/
        ssc_data_set_number( data, "dT_PHX_cold_approach", dT_PHX_cold_approach);   /*[C/K] Temp. difference between cold HTF and cold CO2 PHX inlet*/
        ssc_data_set_number( data, "T_amb_des", (T_amb_base-273.15));              /*[C] Ambient temperature at design point*/
        ssc_data_set_number( data, "dT_mc_approach", dT_mc_approach);          /*[C/K] Temp. difference between main compressor CO2 inlet and ambient*/
        ssc_data_set_number( data, "site_elevation", 588.0);        /*[m] Elevation of the site. 588 MASL is Dagget*/    
        ssc_data_set_number( data, "W_dot_net_des", (P_net/1e6));          /*[MWe] Design cle power output ~ no cooling and other parasitics*/ 
        
        /*Simulation configurations*/
        ssc_data_set_number( data, "design_method", 3);             /*[-] 1=specify efficiency ==> integer
                                                                        2=specify total Recup UA, 
                                                                        3=specify each recuperator design*/
        ssc_data_set_number( data, "eta_thermal_des", -1);          /*[-] Power cycle target thermal eff. at design point. Not used here*/
        ssc_data_set_number( data, "UA_recup_tot_des",-1);          /*[kW/K] total UA recuperators value - not used here*/

        ssc_data_set_number( data, "cycle_config",1);               /*[-] 1=Recompression cycle ==> integer
                                                                        2=Partial cooling cycle*/
        
        ssc_data_set_number( data, "is_recomp_ok", 1);              /*[-] 1=Recompression cycle ==> integer
                                                                        2=Partial cooling cycle*/
        ssc_data_set_number( data, "is_P_high_fixed", 1);           /*[-] 1 = Yes (=P_high_limit), 0 = No, optimized (default)
                                                                        ==> integer*/
        
        ssc_data_set_number( data, "is_PR_fixed", 0);               /*[-] 1=Yes, 0=no ==> integer*/

        ssc_data_set_number( data, "des_objective", 1);             /* 2 = hit min deltaT then max efficiency, 
                                                                    != 2 = max efficiency*/

        ssc_data_set_number( data, "min_phx_deltaT", 1000.0);       /*[C] Min allowable deltaT across PHX*/
        
        ssc_data_set_number( data, "rel_tol", 3);                   /*[-] Baseline solver and optimization relative 
                                                                    tolerance exponent (10^-rel_tol)*/

        ssc_data_set_number( data, "eta_isen_mc", eta_isen_mc);     /*isentropic eff. of the main comp.*/
        ssc_data_set_number( data, "eta_isen_pc", 0.85 );           /*isentropic eff. of the pre-comp. ==> not used*/
        ssc_data_set_number( data, "eta_isen_rc", eta_isen_rc);     /*isentropic eff. of the re-comp.*/


        ssc_data_set_number( data, "eta_isen_t", eta_isen_t);             /*Turbine isentropic eff. at design point*/
        ssc_data_set_number( data, "P_high_limit", (p_high/1e6));         /*Compressor pressure limit [MPa]*/
        
        /*LTR Design Parameters*/
        ssc_data_set_number( data, "LTR_design_code", 2);           /*[-] 1=UA, 2=min dT, 3=effectiveness ==> integer*/
        ssc_data_set_number( data, "LTR_UA_des_in", -1);            /*[kW/K] ((required if LTR_design_code == 1 and design_method == 3) 
                                                                    not used now*/
        ssc_data_set_number( data, "LTR_min_dT_des_in", 10.0);      /*[C/K]required if LTR_design_code == 2 and design_method == 3) 
                                                                    reasonable value" from Neises/Turchi*/
        ssc_data_set_number( data, "LTR_eff_des_in", -1);           /*required if LTR_design_code == 3 and design_method == 3*/
        ssc_data_set_number( data, "LT_recup_eff_max", eff_max);
        ssc_data_set_number( data, "LTR_LP_deltaP_des_in", deltaP_recup_LP);
        ssc_data_set_number( data, "LTR_HP_deltaP_des_in", deltaP_recup_HP);

        /*HTR Design Parameters*/
        ssc_data_set_number( data, "HTR_design_code", 2);           /*[-] 1=UA, 2=min dT, 3=effectiveness ==> integer*/
        ssc_data_set_number( data, "HTR_UA_des_in", -1);            /*[kW/K] ((required if HTR_design_code == 1 and design_method == 3) 
                                                                    not used now*/
        ssc_data_set_number( data, "HTR_min_dT_des_in", 10.0);      /*[C/K]required if LTR_design_code == 2 and design_method == 3) 
                                                                    reasonable value" from Neises/Turchi*/
        ssc_data_set_number( data, "HTR_eff_des_in", -1);           /*required if LTR_design_code == 3 and design_method == 3*/
        ssc_data_set_number( data, "HT_recup_eff_max", eff_max);    
        ssc_data_set_number( data, "HTR_LP_deltaP_des_in", deltaP_recup_LP);                                                           
        ssc_data_set_number( data, "HTR_HP_deltaP_des_in", deltaP_recup_HP);

        /*PHX Design Parameters*/
        ssc_data_set_number( data, "PHX_co2_deltaP_des_in",deltaP_recup_HP);  /*Pressure drop in heat exchanger*/

        /*Dry Cooler Parameters*/
        ssc_data_set_number( data, "deltaP_cooler_frac", 0.005);    /*[-] Fraction of CO2 inlet pressure that is design point 
                                                                        cooler CO2 pressure drop*/
        ssc_data_set_number( data, "fan_power_frac", 0.02);         /*[-] Fraction of net cycle power consumed by air cooler fan. 
                                                                        2% here per Turchi et al.*/                                                                     
        
        /*Default Parameters*/
        ssc_data_set_number( data, "deltaP_counterHX_frac",0.005); /*[-] Fraction of CO2 inlet pressure that is design point counterflow HX 
                                                                    (recups & PHX) pressure drop*/


        /*Off-design Parameters*/
        ssc_data_set_number( data, "od_rel_tol", 3);            /*[-] Baseline off-design relative 
                                                                convergence tolerance exponent (10^-od_rel_tol)*/

        /*Instantiate the sCO2 PB module in SAM*/
        ssc_module_t module = ssc_module_create("sco2_csp_system");

        if(ssc_module_exec(module,data)==0)
        {
            fprintf(stderr,"Error in simulation!\n");
            ssc_module_free(module);
            ssc_data_free(data);
            exit(EXIT_FAILURE);
        }

    }

    free(htf_props);
    free(index_string);
    return data;
}

void dataProcessing(char* fntrain, char* trainingdir, char* base_path)
{
    PyObject *pName, *pModule, *pFunc;
    PyObject *pArgs, *inputs;

	char* ppath = base_path;
    char* pname = "gatherdata"; //gatherdata.py
    char* pfunc = "processing_data"; //def processing_data(inputs)

    Py_Initialize(); /*  Initialize Interpreter  */

    //Obtain the python path, append it with the ppath
    PyObject *sys_path = PySys_GetObject("path");
    PyList_Append(sys_path, PyString_FromString((char *) ppath));
  
    //Convert the pname into Python String
    pName = PyString_FromString(pname);

    //Import the script into C environment using PyImport_Import
    pModule = PyImport_Import(pName);
    Py_DECREF(pName);
    
    
    /*Check python script: exist or not!*/
    if (pModule != NULL) 
    {
        /*Obtain the function from the imported python script*/
        pFunc = PyObject_GetAttrString(pModule, pfunc);

        pArgs = PyTuple_New(1);

        /*if the function is callable*/
        if (pFunc && PyCallable_Check(pFunc)) 
        {
            /*Instantiate a python dictionary and assign it to inputs (pointer type)*/
            inputs = PyDict_New();

            /*Populate the python dictionary*/
            PyDict_SetItemString(inputs, "fntrain", PyString_FromString((char *)fntrain));

            PyDict_SetItemString(inputs, "resdir", PyString_FromString((char *)trainingdir));
            
            PyTuple_SetItem(pArgs, 0, inputs);

            PyObject_CallObject(pFunc, pArgs);

            Py_DECREF(inputs);
            Py_DECREF(pArgs);
        }
        else 
        {
            if (PyErr_Occurred())
            {
                PyErr_Print();
            }
            else
            {
                fprintf(stderr, "Cannot find function \"%s\"\n", pfunc);
                exit(EXIT_FAILURE);
            }
        }
        Py_XDECREF(pFunc);
        Py_DECREF(pModule);
    }

    /*if python script does not exist*/
    else 
    {
        PyErr_Print();
        fprintf(stderr, "Failed to load \"%s\"\n", pname);
        exit(EXIT_FAILURE);
    }
}

void checkConfigReceiver(double H_drop, double T_HTF_in_des, double T_HTF_out_des, char* base_path, int* index_and_status)
{
    char line[limitSize];
    int matching_index = -1000;
    int status = -1000;

    /*Check if the design param is already existing*/
    char* configdir = "/configurations/";
    char* configbase = "configParticleReceiver";

    char* file_extension = ".txt";
    int file_index = 0;
    int l = snprintf(NULL,0,"%d",file_index); // calculate the amount of memory to be allocated for index
    char* index_string = malloc(sizeof(char*)*l);    
    
    sprintf(index_string,"%d",file_index); //convert integer into string  

    //Unify index_string with configname
    l = strlen(base_path) + strlen(configbase) + strlen(index_string) + strlen(file_extension) + 1;
    char* config_file_path = malloc(sizeof(char*)*l);
    strcpy(config_file_path,base_path); //copy the basepath into configname
    strcat(config_file_path,configdir); //copy the "config" into configname
    strcat(config_file_path,configbase); //copy the "config" into configname
    strcat(config_file_path,index_string); //concatenate configname with indexstring e.g. result config0
    strcat(config_file_path,file_extension); //concatenate file extension e.g. config0.txt

    FILE* configfile = fopen(config_file_path,"r");

    //*******************start reading
    while(configfile != NULL)
    {
        //**************** get the 1st line
        fgets(line,limitSize,configfile);

        //**************** get the 2nd line where the information is
        fgets(line,limitSize,configfile);

        //**************** start scanning the information
        //Initialise CEA PB and NREL parameters that want to be compared
        double H_drop_existing, T_HTF_in_des_existing,T_HTF_out_des_existing;

        double deviation_of_configurations;
        {
            sscanf
            (
                line,"%lf,%lf,%lf",
                &H_drop_existing,
                &T_HTF_in_des_existing,
                &T_HTF_out_des_existing
            );
            double deviation_H_drop = fabs(H_drop_existing - H_drop);
            double deviation_T_HTF_in_des = fabs(T_HTF_in_des_existing - T_HTF_in_des);
            double deviation_T_HTF_out_des = fabs(T_HTF_out_des_existing - T_HTF_out_des);
            deviation_of_configurations = deviation_H_drop + deviation_T_HTF_in_des + deviation_T_HTF_out_des;            
        }
        
        
        
        if(deviation_of_configurations < 1e-3)
        {
            matching_index = file_index;
            status = 0; //******changing status to 0 from -1000 s.t. we dont need to gather the data
            fprintf(stderr,"Configuration match in: %s\n",config_file_path);
        }
        else
        { 
            fprintf(stderr,"Configuration doesn't match in: %s\n",config_file_path);
        }
        
        
        file_index++; //**********increasing the file index
        
        //*********** Try opening the next file
        l = snprintf(NULL,0,"%d",file_index);
        index_string = malloc(sizeof(char*)*l); 

        sprintf(index_string,"%d",file_index); //convert integer into string  

        //Unify index_string with configname
        l = strlen(base_path) + strlen(configbase) + strlen(index_string) + strlen(file_extension) + 1;
        config_file_path = malloc(sizeof(char*)*l);
        strcpy(config_file_path,base_path); //copy the basepath into configname
        strcat(config_file_path,configdir); //copy the "config" into configname
        strcat(config_file_path,configbase); //copy the "config" into configname
        strcat(config_file_path,index_string); //concatenate configname with indexstring e.g. result config0
        strcat(config_file_path,file_extension); //concatenate file extension e.g. config0.txt
        configfile = fopen(config_file_path,"r");
    }

    //************** If no file is matching --> matching index is -1000, 
    //************** force the value of matching index = file_index for foldering purpose of the new training data
    if(matching_index == -1000)
    {
        fprintf(stderr,"No match in the data base!\n");
        matching_index = file_index;
        status = 1;
    }

    /*If status == 1, then we have to gather the training data, if status-*/
    index_and_status[0] = matching_index; 
    index_and_status[1] = status;

    free(config_file_path);
    return;
}

void simReceiver(int numdata, double H_drop_design, 
double T_HTF_in_design, double T_HTF_out_des, char* trainingdir, char* SolarTherm_path, char* base_path, 
int status_config)
{
    PyObject *pName, *pModule, *pFunc;
    PyObject *pArgs, *inputs;

	char* ppath = base_path;
    char* pname = "gen_receiver_off_design"; //gatherdata.py
    char* pfunc = "gendata"; //def processing_data(inputs)

    Py_Initialize(); /*  Initialize Interpreter  */

    //Obtain the python path, append it with the ppath
    PyObject *sys_path = PySys_GetObject("path");
    PyList_Append(sys_path, PyString_FromString((char *) ppath));
  
    //Convert the pname into Python String
    pName = PyString_FromString(pname);

    //Import the script into C environment using PyImport_Import
    pModule = PyImport_Import(pName);
    Py_DECREF(pName);
    
    
    /*Check python script: exist or not!*/
    if (pModule != NULL) 
    {
        /*Obtain the function from the imported python script*/
        pFunc = PyObject_GetAttrString(pModule, pfunc);

        pArgs = PyTuple_New(1);

        /*if the function is callable*/
        if (pFunc && PyCallable_Check(pFunc)) 
        {
            /*Instantiate a python dictionary and assign it to inputs (pointer type)*/
            inputs = PyDict_New();

            /*Populate the python dictionary*/
            PyDict_SetItemString(inputs, "numdata", PyInt_FromLong(numdata));
            PyDict_SetItemString(inputs, "SolarTherm_path", PyString_FromString((char *)SolarTherm_path));
            PyDict_SetItemString(inputs, "trainingdir", PyString_FromString((char *)trainingdir));

            PyDict_SetItemString(inputs, "H_drop", PyFloat_FromDouble(H_drop_design));
            PyDict_SetItemString(inputs, "T_HTF_in_des", PyFloat_FromDouble(T_HTF_in_design));
            PyDict_SetItemString(inputs, "T_HTF_out_des", PyFloat_FromDouble(T_HTF_out_des));
            PyDict_SetItemString(inputs, "status_config", PyInt_FromLong(status_config));

            
            PyTuple_SetItem(pArgs, 0, inputs);

            PyObject_CallObject(pFunc, pArgs);

            Py_DECREF(inputs);
            Py_DECREF(pArgs);
        }
        else 
        {
            if (PyErr_Occurred())
            {
                PyErr_Print();
            }
            else
            {
                fprintf(stderr, "Cannot find function \"%s\"\n", pfunc);
                exit(EXIT_FAILURE);
            }
        }
        Py_XDECREF(pFunc);
        Py_DECREF(pModule);
    }

    /*if python script does not exist*/
    else 
    {
        PyErr_Print();
        fprintf(stderr, "Failed to load \"%s\"\n", pname);
        exit(EXIT_FAILURE);
    }
}
