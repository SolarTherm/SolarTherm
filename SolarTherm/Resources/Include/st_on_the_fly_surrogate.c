#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "tensorflow/c/c_api.h"
#include <dirent.h>
#include <unistd.h>

#include "on_the_fly_surrogate/ontheflysurrogate.h"
#include "on_the_fly_surrogate/ontheflysurrogate.c"

#define limitSize 1000000

void* constructKriging(double P_net, double T_in_ref_blk, double p_high, double PR, 
    double pinch_PHX, double dTemp_HTF_PHX, double load_base, 
    double T_amb_base, double eta_gross_base, double eta_Q_base, char* base_path, char* SolarTherm_path,
    int inputsize, int outputsize, double tolerance)
{

    fprintf(stderr,"User surrogate choice: Kriging..........................................\nChange working directory to: %s\n",base_path);
    
    /*Get current working directory*/
    char cwd[limitSize];
    getcwd(cwd,sizeof(cwd));

    /*Changing the path to where all C program is located*/
    int status_chdir = chdir(base_path);
    if(status_chdir!=0)
    {
        fprintf(stderr,"Change directory: FAILED!\n");
        exit(EXIT_FAILURE);
    }
    
    Kriging_properties* Kriging_variables;

    char line[limitSize];
   
    int* index_and_status = malloc(sizeof(int*)*2); 

    /*Check the configurations database whether the requested configuration exists or not in the database*/
    checkConfig(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX,index_and_status, base_path);

    int match_index = index_and_status[0];
    int status_config = index_and_status[1];

    char* traindir_base = "/training_data/";
    char* config_base = "config";
    
    if(status_config == 1) /*Generate new config txt*/
    {
        /*Construct Kriging including validation*/
        Kriging_variables = buildKriging(
            P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, 
            T_amb_base, eta_gross_base, eta_Q_base, base_path, SolarTherm_path, match_index,traindir_base, config_base, status_config,
            inputsize, outputsize, tolerance
            );
    }   
    
    else /*If a configuration exists in the data bank*/
    {   
        char* name_training = "/scaled_Kriging_training_data_deviation.csv";
        char* trainingdir = build_trainingdir_path(base_path,traindir_base,config_base,match_index);
        char* filepathtraining  = concat_training_dir(trainingdir,name_training);

        FILE* check_path = fopen(filepathtraining,"r");
        
        if(check_path == NULL) //********* if filepath training doesn't exist
        {
            /*Construct Kriging including validation*/
            Kriging_variables = buildKriging(
                P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, 
                T_amb_base, eta_gross_base, eta_Q_base, base_path, SolarTherm_path, match_index,traindir_base, config_base, 
                status_config, inputsize , outputsize, tolerance
            );
        }
        else
        {
            fprintf(stderr,"Training data exists. Start constructing Kriging..............\n");
                        
            char* name_prediction_validation_dump = "/validation_prediction.csv";
            char* name_R_squared = "/R_Squared.txt";
            char* name_validation = "/validation_data.csv";
            char* name_min = "/min.txt";
            char* name_max = "/max.txt";
            char* name_krig_param_eta_PB = "/Kriging_Param_eta_PB.txt";
            char* name_krig_param_eta_Q = "/Kriging_Param_eta_Q.txt";

            //Start building file name
            char* filepathpredictionvalidation = concat_training_dir(trainingdir,name_prediction_validation_dump);
            char* filepathRsquared = concat_training_dir(trainingdir,name_R_squared);
            char* filepathvalidation = concat_training_dir(trainingdir,name_validation);
            char* filepathmin = concat_training_dir(trainingdir,name_min);
            char* filepathmax = concat_training_dir(trainingdir,name_max);
            char* filepath_kriging_param_eta_PB = concat_training_dir(trainingdir,name_krig_param_eta_PB);
            char* filepath_kriging_param_eta_Q = concat_training_dir(trainingdir,name_krig_param_eta_Q);
            /*End building the file name*/

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

            //*************************** input and outputsize
            int inputsize = 3;
            int outputsize = 2;

            //************************** Scaler
            FILE *fnmax = fopen(filepathmax,"r"); //instantiate pointer to the filepathmax
            if(fnmax==NULL)
            {
                fprintf(stderr,"File path max data doesn't exist! Check your path %s\n",filepathmax);
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

            Kriging_variables = load_KrigingVariables(filepathtraining, inputsize, outputsize, Nugget_PB, 
                Nugget_HX, sill_PB, sill_HX, Range_PB, Range_HX,
                load_base, T_in_ref_blk, T_amb_base,  deviation_load_max,deviation_T_in_max, deviation_T_amb_max ,
                deviation_eta_gross_max, deviation_eta_Q_max, deviation_load_min, deviation_T_in_min,  
                deviation_T_amb_min, deviation_eta_gross_min,  deviation_eta_Q_min, "spherical"
            );

            free(filepathpredictionvalidation);
            free(filepathRsquared);
            free(filepathvalidation);
            free(filepathmin);
            free(filepathmax);
            free(filepath_kriging_param_eta_PB);
            free(filepath_kriging_param_eta_Q);
        }
        free(filepathtraining);
    }
    
    free(index_and_status);
    
    /*Changing back to the current working directory*/
    status_chdir = chdir(cwd);
    if(status_chdir!=0)
    {
        fprintf(stderr,"Change directory: FAILED!\n");
        exit(EXIT_FAILURE);
    }
    
    fprintf(stderr,"Done constructing Kriging..............\n");
    return Kriging_variables;
}

void* constructANN(double P_net, double T_in_ref_blk, double p_high, double PR, 
    double pinch_PHX, double dTemp_HTF_PHX, double load_base, 
    double T_amb_base, double eta_gross_base, double eta_Q_base, int which_ANN_model, char* base_path, char* SolarTherm_path,
    int inputsize, int outputsize, double tolerance)
{
    
    fprintf(stderr,"User surrogate choice: ANN..........................................\nChange working directory to: %s\n",base_path);
    fprintf(stderr,"eta_gross base = %lf, eta_Q_base=%lf\n",eta_gross_base,eta_Q_base);
    /*Get cwd*/
    char cwd[limitSize];
    getcwd(cwd,sizeof(cwd));

    /*Changing the path to where all C program is located*/
    int status_chdir = chdir(base_path);
    if(status_chdir!=0)
    {
        fprintf(stderr,"Change directory: FAILED!\n");
        exit(EXIT_FAILURE);
    }

    char line[limitSize];
    ANN_properties* sess;
   
    int* index_and_status = malloc(sizeof(int*)*2); 

    /*Check the configurations database whether the requested configuration exists or not in the database*/
    checkConfig(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX,index_and_status, base_path);
    
    int match_index = index_and_status[0];
    int status_config = index_and_status[1];

    char* traindir_base = "/training_data/";
    char* config_base = "config";

    if(status_config == 1) /*Generate new config txt since no config found in the database*/
    {

        fprintf(stderr,"Configuration doesn't exist, generating the training data and surrogate model!\n");
        int gen_data = 1;

        /*Building path to ANN PB and ANN HX*/
        char* ANN_PB_model_name = "/surrogate_model_0";
        char* ANN_HX_model_name = "/surrogate_model_1";

        char* trainingdir = build_trainingdir_path(base_path,traindir_base,config_base,match_index);
        char* ANN_PB_path = concat_training_dir(trainingdir,ANN_PB_model_name);
        char* ANN_HX_path = concat_training_dir(trainingdir,ANN_HX_model_name);

        fprintf(stderr,"%s\n",ANN_PB_path);
        fprintf(stderr,"%s\n",ANN_HX_path);

        /*Construct ANN including validation*/
        if(which_ANN_model==0) //***************** Load ANN PB model
        {
            sess = buildANN(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, 
                    dTemp_HTF_PHX, load_base, T_amb_base, eta_gross_base, 
                    base_path, SolarTherm_path, match_index, traindir_base, config_base, 
                    ANN_PB_path, which_ANN_model,gen_data, status_config, inputsize, outputsize, tolerance
                    );
            
            fprintf(stderr,"Training and Validation of ANN eta PB: Done!\n");   
        }
        else if(which_ANN_model==1) //***************** Load ANN HX model
        {
            sess = buildANN(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, 
                    dTemp_HTF_PHX, load_base, T_amb_base, eta_Q_base, 
                    base_path, SolarTherm_path, match_index, traindir_base, config_base, 
                    ANN_HX_path, which_ANN_model,gen_data, status_config, inputsize, outputsize, tolerance
                    );
            
            fprintf(stderr,"Training and Validation of ANN eta HX: Done!\n");
            
        }
        else
        {
            fprintf(stderr,"ANN model choice is invalid. Your choice = %d. Available choice is 0 for loading ANN PB, 2 for ANN HX\n",which_ANN_model);
            exit(EXIT_FAILURE);
        }
        free(ANN_PB_path);
        free(ANN_HX_path);
        free(trainingdir);
    }
    
    else /*If a configuration exists in the data bank*/
    {   
        /*Building filepath to ANN PB and ANN HX and filepathtrianing*/
        char* name_training = "/training_data.csv";
        char* ANN_PB_model_name = "/surrogate_model_0";
        char* ANN_HX_model_name = "/surrogate_model_1"; 

        char* trainingdir = build_trainingdir_path(base_path,traindir_base,config_base,match_index);
        char* filepathtraining = concat_training_dir(trainingdir,name_training);
        char* ANN_PB_path = concat_training_dir(trainingdir,ANN_PB_model_name);
        char* ANN_HX_path = concat_training_dir(trainingdir,ANN_HX_model_name);
        
        /*End the filepath building*/

        FILE* check_path = fopen(filepathtraining,"r");
        
        if(check_path == NULL) //********* if filepath training doesn't exist
        {
            fprintf(stderr,"Training data doesn't exist even though configuration exists.......Start gathering data.............\n");
            clock_t begin = clock();

            generateTrainingData(
                P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, 
                match_index, 400, base_path, status_config, SolarTherm_path
            );
        
            clock_t end = clock();
            double time_spent = (double)(end-begin) / CLOCKS_PER_SEC;
            
            fprintf(stderr,"Finish gathering data in %lf s\n",time_spent);
        }
        
        else
        {
            fprintf(stderr,"Training data exists. Start constructing ANN..............\n");
        }

        //************* Need not to generate another data points otherwise specified in build ANN func, (tolerance not stasified)
        int gen_data = 0; 
        
        DIR* check_dir;
        
        if(which_ANN_model == 0) //***************** Load ANN PB model
        {
            if ((check_dir = opendir(ANN_PB_path)) == NULL)
            {   
                fprintf(stderr,"No ANN model for PB exists: Building the ANN!\n");

                sess = buildANN(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, 
                    dTemp_HTF_PHX, load_base, T_amb_base, eta_gross_base, 
                    base_path, SolarTherm_path, match_index, traindir_base, config_base, 
                    ANN_PB_path, which_ANN_model, gen_data, status_config, inputsize, outputsize, tolerance
                );
                fprintf(stderr,"Training and Validation of ANN eta PB: Done!\n");
            }
            
            else 
            {
                fprintf(stderr,"ANN model for PB exists\n");
                closedir(check_dir);
                fprintf(stderr,"loading ANN PB model = %s\n",ANN_PB_path);

                char* name_min = "/min.txt";
                char* name_max = "/max.txt";

                /*Build the file name for min, max -> ANN scaler*/           
                char* filepathmin = concat_training_dir(trainingdir,name_min);
                char* filepathmax = concat_training_dir(trainingdir,name_max);
                /*End building the file name*/

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

                sess = load_ANN_properties(ANN_PB_path,X_max,X_min,y_max,y_min,inputsize,outputsize, load_base,T_in_ref_blk,T_amb_base); 


                free(UB);
                free(LB);

            }
            
        }

        else if(which_ANN_model==1) //***************** Load ANN HX model
        {
            if ((check_dir = opendir(ANN_HX_path)) == NULL)
            {   
                fprintf(stderr,"No ANN model for HX exists: Building the ANN!\n");
                
                sess = buildANN(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, 
                    dTemp_HTF_PHX, load_base, T_amb_base, eta_Q_base, 
                    base_path, SolarTherm_path, match_index, traindir_base, config_base, 
                    ANN_HX_path, which_ANN_model, gen_data, status_config, inputsize, outputsize, tolerance
                    );
                fprintf(stderr,"Training and Validation of ANN eta HX: Done!\n");
            }
            else 
            {
                fprintf(stderr,"ANN model for HX exists\n");
                closedir(check_dir);
                fprintf(stderr,"loading ANN HX model = %s\n",ANN_HX_path);

                char* name_min = "/min.txt";
                char* name_max = "/max.txt";

                /*Build the file name for min, max -> ANN scaler*/           
                char* filepathmin = concat_training_dir(trainingdir,name_min);
                char* filepathmax = concat_training_dir(trainingdir,name_max);
                /*End building the file name*/

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

                sess = load_ANN_properties(ANN_HX_path,X_max,X_min,y_max,y_min,inputsize,outputsize, load_base,T_in_ref_blk,T_amb_base); 


                free(UB);
                free(LB);

            }
        }
        
        else
        {
            fprintf(stderr,"ANN model choice is invalid. Your choice = %d. Available choice is 0 for loading ANN PB, 2 for ANN HX\n",which_ANN_model);
            exit(EXIT_FAILURE);
        }        
        

        free(ANN_HX_path);
        free(ANN_PB_path);
        free(filepathtraining);
        free(trainingdir);
    }

    free(index_and_status);

    /*Changing back to the previous working directory*/
    status_chdir = chdir(cwd);
    if(status_chdir!=0)
    {
        fprintf(stderr,"Change directory: FAILED!\n");
        exit(EXIT_FAILURE);
    }
    return sess;
}    

void destructANN(ANN_properties* sess) //******* destructor for ANN session
{

    TF_DeleteSession(sess->Session,sess->Status);
    TF_DeleteGraph(sess->Graph);
    TF_DeleteStatus(sess->Status);
    TF_DeleteSessionOptions(sess->SessionOpts);
    TF_DeleteBuffer(sess->RunOpts);

    free(sess->X_max);
    free(sess->X_min);
    free(sess->y_max);
    free(sess->y_min);

    free(sess);
}

void destructKriging(Kriging_properties* Kriging_variables) //******** destructor for Kriging
{
    for(size_t i=0; i<Kriging_variables->rows;i++)
    {
        free(Kriging_variables->trainingData[i]);
    }

    gsl_matrix_free(Kriging_variables->DISTANCE);
    gsl_matrix_free(Kriging_variables->VARIOGRAM_PB);
    gsl_matrix_free(Kriging_variables->COVARIANCE_PB);
    gsl_matrix_free(Kriging_variables->INVERSE_LSM_PB);

    gsl_matrix_free(Kriging_variables->VARIOGRAM_HX);
    gsl_matrix_free(Kriging_variables->COVARIANCE_HX);
    gsl_matrix_free(Kriging_variables->INVERSE_LSM_HX);

    free(Kriging_variables);
}

double predict_Kriging(Kriging_properties* Kriging_variables, double raw_inputs[], char* which_eta, char* variogram_model)
{   
    clock_t begin = clock();
    double deviation_load = Kriging_variables->load_base - raw_inputs[0];
    double deviation_T_in = Kriging_variables->T_in_ref_blk - raw_inputs[1];
    double deviation_T_amb = Kriging_variables->T_amb_base - raw_inputs[2];

    /*Scale the input*/
    double scaled_load = (deviation_load - Kriging_variables->deviation_load_min) / (Kriging_variables->deviation_load_max - Kriging_variables->deviation_load_min);
    double scaled_T_HTF_in = (deviation_T_in - Kriging_variables->deviation_T_in_min) / (Kriging_variables->deviation_T_in_max - Kriging_variables->deviation_T_in_min);
    double scaled_T_amb_input = (deviation_T_amb - Kriging_variables->deviation_T_amb_min) / (Kriging_variables->deviation_T_amb_max - Kriging_variables->deviation_T_amb_min);

    double* inputs = malloc(sizeof(double*)*3);
    inputs[0] = scaled_load;
    inputs[1] = scaled_T_HTF_in;
    inputs[2] = scaled_T_amb_input;

    int rows = Kriging_variables->rows;
    int inputsize = Kriging_variables->inputsize;
    int outputsize = Kriging_variables->outputsize;

    double Nugget, Spherical, Range;
    int index_var;

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

    /*Find the mean value of the value we want to Krig*/
    double sum_eff = 0;
    for (size_t i=0;i<rows;i++)
    {
        sum_eff = sum_eff + Kriging_variables->trainingData[i][index_var];
    }

    double avg_eff = sum_eff / rows;

    /*Substract the mean from the value*/
    double* RESIDUAL_VAL = malloc(sizeof(double*)*rows);
    for (size_t i=0;i<rows;i++)
    {
        RESIDUAL_VAL[i] =  Kriging_variables->trainingData[i][index_var] - avg_eff;
    }

    /*Instantiate matrix to contains distance*/
    //gsl_matrix* DISTANCE = gsl_matrix_alloc(rows,rows+1);

    /*Complete the distance matrix in a struct*/
    completeEucledianDistance(Kriging_variables, inputs);
    
    /*Calculates the distance between known values to each other*/
    //eucledianDistance_2(Kriging_variables,  rows,  inputsize,  DISTANCE);

    /*Complete the variogram matrix in a struct*/
    //gsl_matrix* VARIOGRAM = gsl_matrix_alloc(rows,rows+1);
    completeVariogramMatrix(Kriging_variables, variogram_model, which_eta);

    /*Complete the Covariance Matrix*/
    //gsl_matrix* COVARIANCE = gsl_matrix_alloc(rows,rows+1);
    completeCoVarianceMatrix(Kriging_variables,which_eta);

    /*Left Side Matrix --> Populate*/
    //gsl_matrix* LSM = gsl_matrix_alloc(rows,rows); 
    //gsl_matrix* INVERSE_LSM = gsl_matrix_alloc(rows,rows);

    //for(size_t i=0;i<rows;i++)
    //{
        //for(size_t j=0;j<rows;j++)
        //{
            //gsl_matrix_set(LSM,i,j, gsl_matrix_get(COVARIANCE,i,j));
        //}
    //}

    /*Inverse the LSM*/
    //gsl_permutation* perm = gsl_permutation_alloc(rows);
    //int s;
    //gsl_linalg_LU_decomp (LSM, perm, &s);    
    //gsl_linalg_LU_invert (LSM, perm, INVERSE_LSM);

    /*Find the weights*/
    gsl_matrix* WEIGHT = gsl_matrix_alloc(rows,1);
    if (strcmp(which_eta,"eta_gross")==0)
    {
        gsl_matrix* COVARIANCE_RSM = gsl_matrix_alloc(Kriging_variables->rows,1);
        for(size_t i=0;i<Kriging_variables->rows;i++)
        {
            gsl_matrix_set(COVARIANCE_RSM,i,0,gsl_matrix_get(Kriging_variables->COVARIANCE_PB,i,Kriging_variables->rows));
        }
        gsl_blas_dgemm(
            CblasNoTrans,CblasNoTrans,
            1.0,
            Kriging_variables->INVERSE_LSM_PB,COVARIANCE_RSM,
            0.0, WEIGHT
            );

        gsl_matrix_free(COVARIANCE_RSM);
    }
    else if (strcmp(which_eta,"eta_Q")==0)
    {
        gsl_matrix* COVARIANCE_RSM = gsl_matrix_alloc(Kriging_variables->rows,1);
        for(size_t i=0;i<Kriging_variables->rows;i++)
        {
            gsl_matrix_set(COVARIANCE_RSM,i,0,gsl_matrix_get(Kriging_variables->COVARIANCE_HX,i,Kriging_variables->rows));
        }
        gsl_blas_dgemm(
            CblasNoTrans,CblasNoTrans,
            1.0,
            Kriging_variables->INVERSE_LSM_HX,COVARIANCE_RSM,
            0.0, WEIGHT
            );
            
        gsl_matrix_free(COVARIANCE_RSM);
    }
    else
    {
        fprintf(stderr,"Choice of eta is not available. Your choice is %s, the available ones are eta_gross or eta_Q\n",which_eta);
        exit(EXIT_FAILURE);
    }
    
    //getWeight(Kriging_variables,WEIGHT,which_eta);

    /*Find the sum of weight*/
    double sum_weight = 0;
    double residual_weight = 0;

    for(size_t i=0;i<rows;i++)
    {
        sum_weight = sum_weight + gsl_matrix_get(WEIGHT,i,0);
    }

    residual_weight = 1 - sum_weight;

    /*Calculate Kriging Estimate*/
    double estimate = 0;

    for(size_t i=0;i<rows;i++)
    {
        estimate = estimate + RESIDUAL_VAL[i] * gsl_matrix_get(WEIGHT,i,0);
    }


    /*Find kriging variance (uncertainty)??*/
    double vars = 0;
    for(size_t i = 0; i<rows;i++)
    {
        if (strcmp(which_eta,"eta_gross")==0)
        {
            vars = vars + (gsl_matrix_get(Kriging_variables->COVARIANCE_PB,i,rows)*gsl_matrix_get(WEIGHT,i,0));
        }
        else if (strcmp(which_eta,"eta_Q")==0)
        {
            vars = vars + (gsl_matrix_get(Kriging_variables->COVARIANCE_HX,i,rows)*gsl_matrix_get(WEIGHT,i,0));
        }
        else
        {
            fprintf(stderr,"Choice of eta is not available. Your choice is %s, the available ones are eta_gross or eta_Q\n",which_eta);
            exit(EXIT_FAILURE);
        }
    }
    vars = Nugget+Spherical - vars;
    estimate = estimate + avg_eff; //**************** scaled
    double real_deviation_estimate;

    if (strcmp(which_eta,"eta_gross")==0)
    {
        real_deviation_estimate = estimate * (Kriging_variables->deviation_eta_gross_max-Kriging_variables->deviation_eta_gross_min) + Kriging_variables->deviation_eta_gross_min;
    }
    else if(strcmp(which_eta,"eta_Q")==0)
    {
        real_deviation_estimate = estimate * (Kriging_variables->deviation_eta_Q_max-Kriging_variables->deviation_eta_Q_min) + Kriging_variables->deviation_eta_Q_min;

    }
    clock_t end = clock();
    double time_spent = (double)(end-begin) / CLOCKS_PER_SEC;
    fprintf(stderr,"Time spent for this calculation using Kriging : %lf s\n",time_spent);

    /*Free resources*/
    free(RESIDUAL_VAL);
    free(inputs);

    /*Free GSL object*/
    gsl_matrix_free(WEIGHT);

    return real_deviation_estimate;
}

double predict_ANN(const ANN_properties *sess, const double raw_input[], int which_ANN_model)
{
    clock_t begin = clock();
    double* inputs = malloc(sizeof(double*)*(sess->inputsize));

    for(size_t i=0;i<sess->inputsize;i++)
    {
        inputs[i] = sess->base_values[i] - raw_input[i];
    }

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

    if(t0.oper == NULL)
    {
        fprintf(stderr,"ERROR: Failed TF_GraphOperationByName serving_default_Input_input\n");
    }

    Input[0] = t0;

    //*********************Output Holder Initialisation
    int NumOutputs = 1;
    TF_Output* Output = malloc(sizeof(TF_Output) * NumOutputs); //allocate memory for output tensor (dType TF_Output)

    TF_Output t2 = {TF_GraphOperationByName(Graph,"StatefulPartitionedCall"),0}; //take the output tensor from loaded model

    if(t2.oper == NULL)
    {
        fprintf(stderr,"ERROR: Failed TF_GraphOperationByName StatefulPartitionedCall\n");
    }
    
    Output[0] = t2;

    //********* Initalisation of Tensor to parse input and output
    TF_Tensor** InputValues = (TF_Tensor**)malloc(sizeof(TF_Tensor*)*NumInputs);
    TF_Tensor** OutputValues = malloc(sizeof(TF_Tensor*)*NumOutputs);

    //********* Populating input Tensor
    int numData = sess->inputsize; //==> number of data input from Modelica
    int tensor_dimensionality = 2; //==> dimensionality of the input tensor (2 for 2D tensor,3 for 3D tensor. Regression usually use 2D)
    int64_t dims[] = {1,numData}; //==> size of the input Tensor (row x col) ~ i row x j column ~ from saved_model_cli

    //*********************Pre-processing the input - normalisation of the input using Min Max Scaler
    //Allocate memory for scaled input
    float* data = malloc(sizeof(float*)*numData); //==> where the input from modelica is gonna be inserted
    for(size_t i=0; i<sess->inputsize; i++)
    {
        data[i] = (inputs[i] - sess->X_min[i]) / (sess->X_max[i]-sess->X_min[i]);
    }
	
	//Allocate memory for data inside the Input Tensor
    size_t memdata = numData * sizeof(float); // memory allocation ~ numData * data_type. if we have 2by2 input, then we have 4 numdata

    TF_Tensor* TensorIn = TF_NewTensor(TF_FLOAT, dims, tensor_dimensionality, data, memdata, &NoOpDeallocator, 0);

    if (TensorIn == NULL)
    {
	    fprintf(stderr,"ERROR: Failed TF_NewTensor\n");
    }

    InputValues[0] = TensorIn;

    //********* Run the session
    TF_SessionRun(
		Session, 
		NULL, 
		Input, InputValues, NumInputs, 
		Output, OutputValues, NumOutputs, 
		NULL, 0,NULL , Status);

    if(TF_GetCode(Status) != TF_OK)
    {
        fprintf(stderr,"%s",TF_Message(Status));
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
    
    clock_t end = clock();
    double time_spent = (double)(end-begin) / CLOCKS_PER_SEC;
    fprintf(stderr,"Time spent for this calculation using ANN: %lf s\n",time_spent);

    return res; 
}
