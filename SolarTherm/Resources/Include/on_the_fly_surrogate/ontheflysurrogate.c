#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "tensorflow/c/c_api.h"
#include <dirent.h>

#define limitSize 1000000
/*
void NoOpDeallocator(void* data, size_t a, void* b) 
{
   //nothing here
}
*/
Kriging_properties* buildKriging(double P_net, double T_in_ref_blk,double p_high, double PR, 
double pinch_PHX, double dTemp_HTF_PHX,double load_base, double T_amb_base, 
double eta_gross_base, double eta_Q_base, char* base_path, char* SolarTherm_path, int match_index, 
char* traindir_base, char* config_base, int status_config, int inputsize, int outputsize, double tolerance)
{
    char line[limitSize];

    Kriging_properties* Kriging_variables; //**************** mallocing is done in the load_KrigingVariables function

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
        fprintf(stderr,"Start gathering %d off-design data points\n",numdata);
        clock_t begin = clock();

        generateTrainingData(
            P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, match_index, numdata, base_path, status_config, SolarTherm_path
            );
        
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
            fprintf(stderr,"File path min data doesn't exist! Check your path %s\n",filepathmin);
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
            fprintf(stderr,"File path Kriging Param for PB doesn't exist! Check your path %s\n",filepath_kriging_param_eta_PB);
        }
        double* krig_param_PB = malloc(sizeof(double*)*3);
        fgets(line,limitSize,fnkrigparam);
        sscanf(line,"%lf,%lf,%lf",&krig_param_PB[0],&krig_param_PB[1],&krig_param_PB[2]);
        fclose(fnkrigparam);

        double sill_PB = krig_param_PB[0];
        double Nugget_PB = krig_param_PB[1];
        double Spherical_PB = 1-sill_PB;
        double Range_PB = krig_param_PB[2];

        //***********************HX
        fnkrigparam = fopen(filepath_kriging_param_eta_Q,"r");
        if(fnkrigparam==NULL)
        {
            fprintf(stderr,"File path Kriging Param for HX doesn't exist! Check your path %s\n",filepath_kriging_param_eta_Q);
        }
        double* krig_param_HX = malloc(sizeof(double*)*3);
        fgets(line,limitSize,fnkrigparam);
        sscanf(line,"%lf,%lf,%lf",&krig_param_HX[0],&krig_param_HX[1],&krig_param_HX[2]);
        fclose(fnkrigparam);

        double sill_HX = krig_param_HX[0];
        double Nugget_HX = krig_param_HX[1];
        double Spherical_HX = 1-sill_HX;
        double Range_HX = krig_param_HX[2];
        /*End reading Kriging Parameters*/

        /*Start reading the training data and validation data*/
        int rows = getNumOfData(filepathvalidation);
        fprintf(stderr,"ROWS: %d\n",rows);
        
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

        fprintf(stderr,"SIL PB: %lf, NUGGET PB: %lf, RANGE PB: %lf\n",sill_PB,Nugget_PB,Range_PB);
        fprintf(stderr,"SIL HX: %lf, NUGGET HX: %lf, RANGE HX: %lf\n",sill_HX,Nugget_HX,Range_HX);      

        fprintf(stderr,"MAX : %lf,%lf,%lf,%lf,%lf\n",deviation_load_max,deviation_T_in_max,deviation_T_amb_max,deviation_eta_gross_max,deviation_eta_Q_max);      
        
        fprintf(stderr,"MIN : %lf,%lf,%lf,%lf,%lf\n",deviation_load_min,deviation_T_in_min,deviation_T_amb_min,deviation_eta_gross_min,deviation_eta_Q_min);

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

            /*ESTIMATE HX EFFICIENCY*/   
            which_eta = "eta_Q";
            double deviation_estimate_eta_Q = predict_Kriging(Kriging_variables, raw_inputs, which_eta, "spherical");
            double estimate_eta_Q = eta_Q_base - deviation_estimate_eta_Q;  

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

        fprintf(stderr,"\n------------------------------------------------\n");
        fprintf(stderr,"------------------------------------------------\n");
        fprintf(stderr,"--------SURROGATE VALIDATION RESULT-------------\n");
        fprintf(stderr,"------------------------------------------------\n");
        fprintf(stderr,"------------------------------------------------\n\n");

        fprintf(stderr,"Sum of square error PB eff: %lf\nR squared PB eff: %lf\nMAE eta PB eff: %lf\n",squared_error_eta_PB,R_squared_eta_PB, MAE_eta_PB);
        fprintf(stderr,"Sum of square error HX eff: %lf\nR squared HX eff: %lf\nMAE eta HX eff: %lf\n",squared_error_eta_HX,R_squared_eta_HX, MAE_eta_HX);
        fprintf(stderr,"MAE combination: %lf\n",MAE_combination);
        fprintf(stderr,"R squared combination: %lf\n",R_combination);

        /*Stop criterion*/
        if(MAE_combination < tolerance)
        {
            fprintf(stderr,"Model OK!\n");
            stop = 1;
        }
        else
        {
            fprintf(stderr,"Model is still not OK! Need more data!\n");
            numdata = 25;
        }

        /*Dump evaluation result to a file*/
        FILE* fnRsquared = fopen(filepathRsquared,"a");
        fprintf(fnRsquared,"%lf,%lf\n",MAE_combination,R_combination);
        fclose(fnRsquared);

        fprintf(stderr,"\n------------------------------------------------\n");
        fprintf(stderr,"------------------------------------------------\n");
        fprintf(stderr,"------------------------------------------------\n");
        fprintf(stderr,"------------------------------------------------\n");
        fprintf(stderr,"------------------------------------------------\n\n");

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

ANN_properties* buildANN(double P_net, double T_in_ref_blk,double p_high, double PR, 
double pinch_PHX, double dTemp_HTF_PHX,double load_base, double T_amb_base, 
double eta_base, char* base_path, char* SolarTherm_path, int match_index, 
char* traindir_base, char* config_base, char* ANN_path, int which_ANN_model, int gen_data, int status_config,
int inputsize, int outputsize, double tolerance)
{
    //*************** initial number of training data
    int numdata = 400;
    ANN_properties* session; //****************** mallocing will be done in the load_session func

    fprintf(stderr,"User choice of surrogate = ANN\n");
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
            fprintf(stderr,"Start gathering %d off-design data points\n",numdata);
            clock_t begin = clock();

            generateTrainingData(
                P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, 
                match_index, numdata, base_path, status_config, SolarTherm_path
            );
            
            clock_t end = clock();
            double time_spent = (double)(end-begin) / CLOCKS_PER_SEC;
            fprintf(stderr,"Finish gathering %d points off-design data: it took %lf s\n",numdata,time_spent);
        }

        status_config = 0;

        /*Training ANN for predicting eta*/
        int train_status_ANN = trainingANN(filepath,trainingdir,which_ANN_model);  

        /*Start validating the ANN model*/
        //*************Reading scaler
        FILE *fnmax = fopen(filepathmax,"r"); //instantiate pointer to the filepathmax
        if(fnmax==NULL)
        {
            fprintf(stderr,"File path max data doesn't exist! Check your path %s\n",filepathmax);
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
            fprintf(stderr,"File path min data doesn't exist! Check your path %s\n",filepathmin);
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

        session = load_ANN_properties(
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

        fprintf(stderr,"MAX : %lf,%lf,%lf,%lf,%lf\n",
            session->X_max[0],session->X_max[1],session->X_max[2],session->y_max[0],session->y_max[1]
        );      
        
        fprintf(stderr,"MIN : %lf,%lf,%lf,%lf,%lf\n",
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
        fprintf(stderr,"%lf %lf\n",squared_error_eta,variance_eta);

        double MAE_eta = absolute_error_eta/rows;
        fprintf(stderr,"%lf %d\n",absolute_error_eta,rows);

        fprintf(stderr,"\n------------------------------------------------\n");
        fprintf(stderr,"------------------------------------------------\n");
        fprintf(stderr,"--------SURROGATE VALIDATION RESULT-------------\n");
        fprintf(stderr,"------------------------------------------------\n");
        fprintf(stderr,"------------------------------------------------\n\n");

        fprintf(stderr,"Sum of square error eff: %lf\nR squared eff: %lf\nMAE eff: %lf\n",squared_error_eta,R_squared_eta, MAE_eta);

        /*Stop criterion*/
        if(MAE_eta < tolerance)
        {
            fprintf(stderr,"Model OK!\n");
            stop = 1;
        }
        else
        {
            fprintf(stderr,"Model is still not OK! Need more data!\n");
            numdata = 100;
            gen_data = 1; //*********** generating another data points
        }

        /*Dump evaluation result to a file*/
        FILE* fnRsquared = fopen(filepathRsquared,"a");
        fprintf(fnRsquared,"%lf,%lf\n",MAE_eta,R_squared_eta);
        fclose(fnRsquared);

        fprintf(stderr,"\n------------------------------------------------\n");
        fprintf(stderr,"------------------------------------------------\n");
        fprintf(stderr,"------------------------------------------------\n");
        fprintf(stderr,"------------------------------------------------\n");
        fprintf(stderr,"------------------------------------------------\n\n");

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

int trainingANN(char* fn_data, char* prefixres, int count)
{   
    int l = snprintf(NULL,0,"%d",count); // calculate the amount of memory to be allocated for index
    char* index = malloc(sizeof(char*)*l);    
    sprintf(index,"%d",count); //convert integer into string 

    char* base_cmd = "python trainANN.py ";

    l = strlen(base_cmd) + strlen(fn_data) + strlen(" ") + strlen(prefixres) + strlen(" ") + strlen(index);
    char* cmd = malloc(sizeof(char*)*(l+1));
    
    strcpy(cmd,base_cmd);
    strcat(cmd,fn_data);
    strcat(cmd," ");
    strcat(cmd,prefixres);
    strcat(cmd," ");
    strcat(cmd,index);

    printf("%s\n",cmd);
    
    int status_training = system(cmd);

    if (status_training==0)
    {
        fprintf(stderr,"Training ANN has been finished without any error\n");
        return 0;
    }
    else 
    {
        fprintf(stderr,"Training error with staus %d\n",status_training);
        return -1;
    }
}

void getWeight(Kriging_properties* Kriging_variables, gsl_matrix* WEIGHTS, char* which_eta)
{
    double val;
    double InverseVal;
    double CovarianceVal;

    for(size_t i=0;i<Kriging_variables->rows;i++)
    {
        val = 0;
        for(size_t j=0;j<Kriging_variables->rows;j++)
        {   
            if (strcmp(which_eta,"eta_gross")==0)
            {
                InverseVal = gsl_matrix_get(Kriging_variables->INVERSE_LSM_PB,i,j);
                CovarianceVal = gsl_matrix_get(Kriging_variables->COVARIANCE_PB,j,Kriging_variables->rows);
            }
            else if (strcmp(which_eta,"eta_Q")==0)
            {
                InverseVal = gsl_matrix_get(Kriging_variables->INVERSE_LSM_HX,i,j);
                CovarianceVal = gsl_matrix_get(Kriging_variables->COVARIANCE_HX,j,Kriging_variables->rows);
            }
             else
            {
                fprintf(stderr,"Choice of eta is not available. Your choice is %s, the available ones are eta_gross or eta_Q\n",which_eta);
                exit(EXIT_FAILURE);
            }
            
            val = val + (InverseVal*CovarianceVal);
        }
        gsl_matrix_set(WEIGHTS,i,0,val);
    }
}

void completeCoVarianceMatrix(Kriging_properties* Kriging_variables, char* which_eta)
{
    double sum;
    
    if (strcmp(which_eta,"eta_gross")==0)
    {
        sum = Kriging_variables->Nugget_PB + (1-Kriging_variables->sill_PB);
    }
    else if (strcmp(which_eta,"eta_Q")==0)
    {
        sum = Kriging_variables->Nugget_PB + (1-Kriging_variables->sill_HX);
    }
    else
    {
        fprintf(stderr,"Choice of eta is not available. Your choice is %s, the avilable ones are eta_gross or eta_Q\n",which_eta);
        exit(EXIT_FAILURE);
    }

    
    for(size_t i=0;i<Kriging_variables->rows;i++)
    {
        if (strcmp(which_eta,"eta_gross")==0)
        {
            gsl_matrix_set(Kriging_variables->COVARIANCE_PB,i,Kriging_variables->rows,sum - gsl_matrix_get(Kriging_variables->VARIOGRAM_PB,i,Kriging_variables->rows));
        }
        else if (strcmp(which_eta,"eta_Q")==0)
        {
            gsl_matrix_set(Kriging_variables->COVARIANCE_HX,i,Kriging_variables->rows,sum - gsl_matrix_get(Kriging_variables->VARIOGRAM_HX,i,Kriging_variables->rows));
        }
        else
        {
            fprintf(stderr,"Choice of eta is not available. Your choice is %s, the available ones are eta_gross or eta_Q\n",which_eta);
            exit(EXIT_FAILURE);
        }
        
    }
    
}

void completeVariogramMatrix(Kriging_properties* Kriging_variables, char* type, char* which_eta)
{   
    double Nugget;
    double Spherical;
    double Range;
    int index_var;
    double var;
    double dist;
    double multiplier;

    if (strcmp(which_eta,"eta_gross")==0)
    {
        Nugget = Kriging_variables->Nugget_PB;
        Spherical = 1 - (Kriging_variables->sill_PB);
        Range = Kriging_variables->Range_PB;
        index_var = 3;
    }
    else if (strcmp(which_eta,"eta_Q")==0)
    {
        Nugget = Kriging_variables->Nugget_HX;
        Spherical = 1 - (Kriging_variables->sill_HX);
        Range = Kriging_variables->Range_HX;
        index_var = 4;
    }
    else
    {
        fprintf(stderr,"Choice of eta is not available. Your choice is %s, the avilable ones are eta_gross or eta_Q\n",which_eta);
        exit(EXIT_FAILURE);
    }


    for(size_t i=0;i<Kriging_variables->rows;i++)
    {
        dist = gsl_matrix_get(Kriging_variables->DISTANCE,i,Kriging_variables->rows);

        if (strcmp(type,"spherical")==0)
        {
            if(dist>Range)
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
            multiplier = 1 - exp(-(pow(dist,2)/pow(Range,2)));
        }
        else if (strcmp(type,"exponential")==0)
        {
            multiplier = 1 - 0.5 * (-dist/Range);
        }
        else if (strcmp(type,"nugget")==0)
        {
            if(dist==0)
            {
                multiplier = 0;
            }
            else
            {
                multiplier = 1;
            }
        }
        else
        {
            printf("Variogram model is not valid\n");
            return;
        }
                        
        if(strcmp(which_eta,"eta_gross")==0)
        {
            gsl_matrix_set(Kriging_variables->VARIOGRAM_PB,i,Kriging_variables->rows, Nugget + Spherical * multiplier);
        }
        else if(strcmp(which_eta,"eta_Q")==0)
        {
            gsl_matrix_set(Kriging_variables->VARIOGRAM_HX,i,Kriging_variables->rows, Nugget + Spherical * multiplier);
        }
        else
        {
            fprintf(stderr,"Choice of eta is not available. Your choice is %s, the avilable ones are eta_gross or eta_Q\n",which_eta);
            exit(EXIT_FAILURE);
        }
            
    }
}

void completeEucledianDistance(Kriging_properties* Kriging_variables, double* inputs)
{
    double square_difference;
    double delta;
    double dist;

    for(size_t i=0;i<Kriging_variables->rows;i++)
    {
        square_difference = 0;

        for(size_t j=0;j<Kriging_variables->inputsize;j++)
        {
            delta = Kriging_variables->trainingData[i][j]- inputs[j];
            square_difference = square_difference + (delta*delta);
        }

        dist = pow(square_difference,0.5);
        gsl_matrix_set(Kriging_variables->DISTANCE,i,Kriging_variables->rows,dist);

    }
}

void eucledianDistance_2(Kriging_properties* Kriging_variables, int rows, int inputsize, gsl_matrix* DISTANCE)
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
                    square_difference = square_difference + (delta*delta);
                }
                dist = pow(square_difference,0.5);
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
        printf("Your file doesn't exist mate! Check your address %s!\n",filepath);
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

void checkConfig(double P_net, double T_in_ref_blk, double p_high, double PR, double pinch_PHX, double dTemp_HTF_PHX, int* index_and_status, char* basepath)
{

    char line[limitSize];
    int matching_index = -1000;
    int status = -1000;

    /*Check if the design param is already existing*/
    char* configdir = "/configurations/";
    char* configbase = "config";    
    char* file_extension = ".txt";
    int file_index = 0;
    int l = snprintf(NULL,0,"%d",file_index); // calculate the amount of memory to be allocated for index
    char* index_string = malloc(sizeof(char*)*l);    
    
    sprintf(index_string,"%d",file_index); //convert integer into string  

    //Unify index_string with configname
    l = strlen(basepath) + strlen(configbase) + strlen(index_string) + strlen(file_extension) + 1;
    char* config_file_path = malloc(sizeof(char*)*l);
    strcpy(config_file_path,basepath); //copy the basepath into configname
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
        double P_net_exisiting, T_in_ref_blk_existing, p_high_existing, PR_existing, pinch_PHX_existing, dTemp_HTF_PHX_existing;

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
        
        if(abs(deviation_P_net + deviation_T_in_ref_blk + deviation_p_high + deviation_PR + deviation_pinch_PHX + deviation_dTemp_HTF_PHX) < 1e-3)
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
        l = strlen(basepath) + strlen(configbase) + strlen(index_string) + strlen(file_extension) + 1;
        config_file_path = malloc(sizeof(char*)*l);
        strcpy(config_file_path,basepath); //copy the basepath into configname
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
    double PR, double pinch_PHX, double dTemp_HTF_PHX, int match_index, int numdata, char* basepath, int status_config, char* SolarTherm_path)
{
    char* training_dir_name = "/training_data/";
    int l = strlen(basepath) + strlen(training_dir_name) + 1;
    char* training_dir = malloc(sizeof(char*)*l);
    strcpy(training_dir,basepath);
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
	
	int lenppath = strlen(SolarTherm_path) + strlen("/Resources/Include") + 1;
	char* ppath = malloc(sizeof(char*)*lenppath);
	strcpy(ppath,SolarTherm_path);
	strcat(ppath,"/Resources/Include");

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
    Kriging_properties* Kriging_variables = malloc(sizeof(Kriging_properties));

    /*Open the file*/
    FILE* training_file = fopen(filepathtraining,"r");
    if (training_file==NULL)
    {
        fprintf(stderr,"Your file doesn't exist! Check your address %s!\n",filepathtraining);
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

    /*Populate all the GSL members PB in the struct*/
    Kriging_variables->DISTANCE = gsl_matrix_alloc(rows,rows+1);
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
                    square_difference = square_difference + (delta*delta);
                }
                dist = pow(square_difference,0.5);
                gsl_matrix_set(Kriging_variables->DISTANCE,i,j,dist);
            }
        }
    }

    /*Populate the LSM VARIOGRAM for PB calculation*/
    Kriging_variables->VARIOGRAM_PB = gsl_matrix_alloc(rows,rows+1);

    double var;
    double multiplier;

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
                    if(dist>Kriging_variables->Range_PB)
                    {
                        multiplier = 1;
                    }
                    else
                    {
                        multiplier = 1.5 * (dist/Kriging_variables->Range_PB) - 0.5 * pow(dist/Kriging_variables->Range_PB,3);
                    }
                }
                else if (strcmp(variogram_model,"gaussian")==0)
                {
                    multiplier = 1 - exp(-(pow(dist,2)/pow(Kriging_variables->Range_PB,2)));
                }
                else if (strcmp(variogram_model,"exponential")==0)
                {
                    multiplier = 1 - 0.5 * (-dist/Kriging_variables->Range_PB);
                }
                else if (strcmp(variogram_model,"nugget")==0)
                {
                    if(dist==0)
                    {
                        multiplier = 0;
                    }
                    else
                    {
                        multiplier = 1;
                    }
                }
                else
                {
                    fprintf(stderr,"Variogram model is not valid\n");
                    exit(EXIT_FAILURE);
                }
                                
                gsl_matrix_set(
                    Kriging_variables->VARIOGRAM_PB,i,j, 
                    Kriging_variables->Nugget_PB + (1-Kriging_variables->sill_PB) * multiplier
                    );
            }
            
        }
    }

    /*Populate the LSM COVARIANCE for PB calculation*/
    Kriging_variables->COVARIANCE_PB = gsl_matrix_alloc(rows,rows+1);

    double sum = Kriging_variables->Nugget_PB + (1-Kriging_variables->sill_PB);
    
    for(size_t i=0;i<rows;i++)
    {
        for(size_t j=0;j<rows;j++)
        {
            gsl_matrix_set(Kriging_variables->COVARIANCE_PB,i,j,sum - gsl_matrix_get(Kriging_variables->VARIOGRAM_PB,i,j));
        }
    }

    /*Populate the LSM INVERSE for PB calculation*/
    Kriging_variables->INVERSE_LSM_PB = gsl_matrix_alloc(rows,rows);
    gsl_matrix* LSM_PB = gsl_matrix_alloc(rows,rows); //========> slice the matrix

    for(size_t i=0;i<rows;i++)
    {
        for(size_t j=0;j<rows;j++)
        {
            gsl_matrix_set(LSM_PB,i,j, gsl_matrix_get(Kriging_variables->COVARIANCE_PB,i,j));
        }
    }

    /*Inverse the LSM PB*/
    gsl_permutation* perm_PB = gsl_permutation_alloc(rows);
    int s;
    clock_t begin = clock();

    gsl_linalg_LU_decomp (LSM_PB, perm_PB, &s);    
    gsl_linalg_LU_invert (LSM_PB, perm_PB, Kriging_variables->INVERSE_LSM_PB);

    gsl_matrix_free(LSM_PB);
    gsl_permutation_free(perm_PB);
    /*Done calculating the PB GSL members*/

    /*Start calculating the member GSL HX*/
    /*Populate the LSM VARIOGRAM for HX calculation*/
    Kriging_variables->VARIOGRAM_HX = gsl_matrix_alloc(rows,rows+1);

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
                    if(dist>Kriging_variables->Range_HX)
                    {
                        multiplier = 1;
                    }
                    else
                    {
                        multiplier = 1.5 * (dist/Kriging_variables->Range_HX) - 0.5 * pow(dist/Kriging_variables->Range_HX,3);
                    }
                }
                else if (strcmp(variogram_model,"gaussian")==0)
                {
                    multiplier = 1 - exp(-(pow(dist,2)/pow(Kriging_variables->Range_HX,2)));
                }
                else if (strcmp(variogram_model,"exponential")==0)
                {
                    multiplier = 1 - 0.5 * (-dist/Kriging_variables->Range_HX);
                }
                else if (strcmp(variogram_model,"nugget")==0)
                {
                    if(dist==0)
                    {
                        multiplier = 0;
                    }
                    else
                    {
                        multiplier = 1;
                    }
                }
                else
                {
                    fprintf(stderr,"Variogram model is not valid\n");
                    exit(EXIT_FAILURE);
                }
                                

                gsl_matrix_set(
                    Kriging_variables->VARIOGRAM_HX,i,j, 
                    Kriging_variables->Nugget_HX + (1-Kriging_variables->sill_HX) * multiplier
                    );
            }
            
        }
    }

    /*Populate the LSM COVARIANCE for HX calculation*/
    Kriging_variables->COVARIANCE_HX = gsl_matrix_alloc(rows,rows+1);

    sum = Kriging_variables->Nugget_HX + (1-Kriging_variables->sill_HX);
    
    for(size_t i=0;i<rows;i++)
    {
        for(size_t j=0;j<rows;j++)
        {
            gsl_matrix_set(Kriging_variables->COVARIANCE_HX,i,j,sum - gsl_matrix_get(Kriging_variables->VARIOGRAM_HX,i,j));
        }
    }

    /*Populate the LSM INVERSE for HX calculation*/
    Kriging_variables->INVERSE_LSM_HX = gsl_matrix_alloc(rows,rows);
    gsl_matrix* LSM_HX = gsl_matrix_alloc(rows,rows); //========> slice the matrix

    for(size_t i=0;i<rows;i++)
    {
        for(size_t j=0;j<rows;j++)
        {
            gsl_matrix_set(LSM_HX,i,j, gsl_matrix_get(Kriging_variables->COVARIANCE_HX,i,j));
        }
    }

    /*Inverse the LSM*/
    gsl_permutation* perm_HX = gsl_permutation_alloc(rows);
    begin = clock();

    gsl_linalg_LU_decomp (LSM_HX, perm_HX, &s);    
    gsl_linalg_LU_invert (LSM_HX, perm_HX, Kriging_variables->INVERSE_LSM_HX);

    gsl_matrix_free(LSM_HX);
    gsl_permutation_free(perm_HX);
    /*Done populating the struct GSL HX*/

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

void *load_ANN_properties(char* saved_model_dir, double* X_max, double* X_min, double* y_max, double* y_min, int inputsize, 
int outputsize, double load_base, double T_in_ref_blk, double T_amb_base)
{
    //*********************Adjust the logging of tensorflow by setting a variable 
    //*********************in the environment called TF_CPP_MIN_LOG_LEVEL

    char *var = "TF_CPP_MIN_LOG_LEVEL=0";
    int ret;
    ret = putenv(var);

    //*********************Allocate dynamic memory from the heap for ANN_properties data struct 
    ANN_properties *sess = malloc(sizeof(ANN_properties));

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
        fprintf(stderr,"TF Loading Pre-Trained Model : Complete!\n");
    }
    else
    {
        fprintf(stderr,"%s",TF_Message(Status));
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





































/*
    for(size_t i=0;i<rows;i++)
    {
        printf("%lf,%lf,%lf,%lf,%lf\n",
        Kriging_variables->trainingData[i][0],
        Kriging_variables->trainingData[i][1], 
        Kriging_variables->trainingData[i][2], 
        Kriging_variables->trainingData[i][3], 
        Kriging_variables->trainingData[i][4]
        );
    }
    */
