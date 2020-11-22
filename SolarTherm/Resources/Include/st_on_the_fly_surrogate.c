#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "tensorflow/c/c_api.h"
#include <dirent.h>

#include "on_the_fly_surrogate/ontheflysurrogate.h"
#include "on_the_fly_surrogate/ontheflysurrogate.c"

#define limitSize 1000000


void* constructKriging(double P_net, double T_in_ref_blk, double p_high, double PR, 
    double pinch_PHX, double dTemp_HTF_PHX, double load_base,  double T_amb_base, 
    double eta_gross_base, double eta_Q_base, char* base_path,  char* SolarTherm_path,
    int inputsize, int outputsize, double tolerance, int PB_model, 
    int htf_choice, double dT_PHX_hot_approach,  double dT_PHX_cold_approach,
    double eta_isen_mc, double eta_isen_rc, double eta_isen_t,double dT_mc_approach, 
    char* HTF_name)
{

    fprintf(stderr,"User surrogate choice: Kriging..........................................\n");
    
    Kriging_struct* Kriging_variables;

    char line[limitSize];
   
    int* index_and_status = malloc(sizeof(int*)*2); 

    /*Check the configurations database whether the requested configuration exists or not in the database*/
    checkConfig(
        P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX,index_and_status, base_path, PB_model,
        dT_PHX_hot_approach, dT_PHX_cold_approach, eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach, T_amb_base
        );

    int match_index = index_and_status[0];
    int status_config = index_and_status[1];

    char* traindir_base = "/training_data/";
    char* config_base;
    if(PB_model==0)/*CEA PB*/
    {
        config_base = "config";
    }
    else if(PB_model==1)
    {   
        config_base = "configNREL";
    }
    else
    {
        fprintf(stderr,"PB model choice is invalid. Choose 0 for CEA PB, 1 for NREL-SAM PB. Your choice is %d\n",PB_model);
        exit(EXIT_FAILURE);
    }
    
    if(status_config == 1) /*Generate new config txt*/
    {
        /*Construct Kriging including validation*/
        Kriging_variables = buildKriging(
            P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, 
            T_amb_base, eta_gross_base, eta_Q_base, base_path, SolarTherm_path, match_index,traindir_base, config_base, status_config,
            inputsize, outputsize, tolerance, PB_model, 
            htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
            HTF_name
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
            fprintf(stderr,"Configuration exists, but training data for Kriging doesn't\n");
            /*Construct Kriging including validation*/
            Kriging_variables = buildKriging(
                P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, 
                T_amb_base, eta_gross_base, eta_Q_base, base_path, SolarTherm_path, match_index,traindir_base, config_base, 
                status_config, inputsize , outputsize, tolerance, PB_model,
                htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
                HTF_name
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

            fprintf(stderr,"Done constructing Kriging..............\n");

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

    Kriging_variables->count = 0;
    return Kriging_variables;
}

void* constructANN(double P_net, double T_in_ref_blk, double p_high, double PR, 
    double pinch_PHX, double dTemp_HTF_PHX, double load_base, double T_amb_base, 
    double eta_gross_base, double eta_Q_base, int which_ANN_model, char* base_path, char* SolarTherm_path, 
    int inputsize, int outputsize, double tolerance, int PB_model,
    int htf_choice, double dT_PHX_hot_approach,  double dT_PHX_cold_approach,
    double eta_isen_mc, double eta_isen_rc, double eta_isen_t,double dT_mc_approach,
    char* HTF_name)
{
    
    fprintf(stderr,"User surrogate choice: ANN..........................................\n");
    char line[limitSize];
    Session_Props* sess;
   
    int* index_and_status = malloc(sizeof(int*)*2); 

    /*Check the configurations database whether the requested configuration exists or not in the database*/
    checkConfig(
        P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX,index_and_status, base_path, PB_model,
        dT_PHX_hot_approach, dT_PHX_cold_approach, eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
        T_amb_base
        );
    
    int match_index = index_and_status[0];
    int status_config = index_and_status[1];

    char* traindir_base = "/training_data/";
    char* config_base;
    if(PB_model==0)/*CEA PB*/
    {
        config_base = "config";
    }
    else if(PB_model==1)
    {   
        config_base = "configNREL";
    }
    else
    {
        fprintf(stderr,"PB model choice is invalid. Choose 0 for CEA PB, 1 for NREL-SAM PB. Your choice is %d\n",PB_model);
        exit(EXIT_FAILURE);
    }

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
                    ANN_PB_path, which_ANN_model,gen_data, status_config, inputsize, outputsize, tolerance, PB_model,
                    htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
                    HTF_name
                    );
            
            fprintf(stderr,"Training and Validation of ANN eta PB: Done!\n");   
        }
        else if(which_ANN_model==1) //***************** Load ANN HX model
        {
            sess = buildANN(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, 
                    dTemp_HTF_PHX, load_base, T_amb_base, eta_Q_base, 
                    base_path, SolarTherm_path, match_index, traindir_base, config_base, 
                    ANN_HX_path, which_ANN_model,gen_data, status_config, inputsize, outputsize, tolerance, PB_model,
                    htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
                    HTF_name
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
        char* name_training = "/deviation_eta_Q.csv";
        char* ANN_PB_model_name = "/surrogate_model_0";
        char* ANN_HX_model_name = "/surrogate_model_1"; 

        char* trainingdir = build_trainingdir_path(base_path,traindir_base,config_base,match_index);
        char* filepathtraining = concat_training_dir(trainingdir,name_training);
        char* ANN_PB_path = concat_training_dir(trainingdir,ANN_PB_model_name);
        char* ANN_HX_path = concat_training_dir(trainingdir,ANN_HX_model_name);
        
        /*End the filepath building*/

        FILE* check_path = fopen(filepathtraining,"r");
        fprintf(stderr,"%s\n",filepathtraining);
        
        if(check_path == NULL) //********* if filepath training doesn't exist
        {
            fprintf(stderr,"Training data doesn't exist even though configuration exists.......Start gathering data.............\n");
            clock_t begin = clock();

            int initialnumdata = 150;

            if(PB_model==0)
            {
                generateTrainingData(
                    P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, match_index, initialnumdata, base_path, status_config,
                    SolarTherm_path);
            }
            else if(PB_model==1)
            {
                ssc_data_t NRELPBSimulationResult = runNRELPB(
                    initialnumdata, P_net, T_in_ref_blk, p_high,
                    T_amb_base, dT_PHX_hot_approach, dT_PHX_cold_approach, 
                    eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
                    HTF_name, htf_choice, trainingdir,SolarTherm_path, base_path, status_config, match_index,1
                );
            }
            else
            {
                fprintf(stderr,"PB model choice is invalid. Choose 0 for CEA PB, 1 for NREL-SAM PB. Your choice is %d\n",PB_model);
                exit(EXIT_FAILURE);
            }
        
            clock_t end = clock();
            double time_spent = (double)(end-begin) / CLOCKS_PER_SEC;
            
            fprintf(stderr, "It took %lf seconds to generate %d data points\n",time_spent,initialnumdata);
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
                    ANN_PB_path, which_ANN_model, gen_data, status_config, inputsize, outputsize, tolerance, PB_model,
                    htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
                    HTF_name
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

                sess = load_session(ANN_PB_path,X_max,X_min,y_max,y_min,inputsize,outputsize, load_base,T_in_ref_blk,T_amb_base); 


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
                    ANN_HX_path, which_ANN_model, gen_data, status_config, inputsize, outputsize, tolerance, PB_model,
                    htf_choice, dT_PHX_hot_approach,  dT_PHX_cold_approach,eta_isen_mc, eta_isen_rc, eta_isen_t, dT_mc_approach,
                    HTF_name
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

                sess = load_session(ANN_HX_path,X_max,X_min,y_max,y_min,inputsize,outputsize, load_base,T_in_ref_blk,T_amb_base); 


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

    sess->count=0;

    return sess;
}    

double predict_Kriging(Kriging_struct* Kriging_variables, const double raw_inputs[], char* which_eta, char* variogram_model)
{   
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
        Spherical = 1 - (Kriging_variables->Nugget_PB);
        Range = Kriging_variables->Range_PB;
        index_var = 3;
    }
    else if (strcmp(which_eta,"eta_Q")==0)
    {
        Nugget = Kriging_variables->Nugget_HX;
        Spherical = 1 - (Kriging_variables->Nugget_HX);
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
    for(size_t i=0;i<rows;i++) 
    {
        if(strcmp(which_eta,"eta_gross")==0)
        {
            gsl_matrix_set(
                RHS,i,0,
                gsl_matrix_get(Kriging_variables->COVARIANCE_PB,i,rows)
                );
        }
        else if(strcmp(which_eta,"eta_Q")==0)
        {
            gsl_matrix_set(
                RHS,i,0,
                gsl_matrix_get(Kriging_variables->COVARIANCE_HX,i,rows)
                );  
        }
        else
        {
            fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q. Your value is %s\n",which_eta);
            exit(EXIT_FAILURE);
        }
    }

    if(strcmp(which_eta,"eta_gross")==0)
    {
        gsl_blas_dgemm(CblasNoTrans,CblasNoTrans,1.0,Kriging_variables->INVERSE_PB,RHS,0.0,WEIGHT);
    }
    else if(strcmp(which_eta,"eta_Q")==0)
    {
        gsl_blas_dgemm(CblasNoTrans,CblasNoTrans,1.0,Kriging_variables->INVERSE_HX,RHS,0.0,WEIGHT);
    }
    else
    {
        fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q\n");
        exit(EXIT_FAILURE);
    }

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
        if(strcmp(which_eta,"eta_gross")==0)
        {
            vars = vars + (gsl_matrix_get(Kriging_variables->COVARIANCE_PB,i,rows)*gsl_matrix_get(WEIGHT,i,0));
        }
        else if(strcmp(which_eta,"eta_Q")==0)
        {
            vars = vars + (gsl_matrix_get(Kriging_variables->COVARIANCE_HX,i,rows)*gsl_matrix_get(WEIGHT,i,0));
        }
        else
        {
            fprintf(stderr,"Invalid eta! Choose between eta_gross or eta_Q\n");
            exit(EXIT_FAILURE);
        }
        
    }

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
    

    /*Free resources*/
    free(RESIDUAL_VAL);
    free(inputs);

    /*Free GSL object*/
    gsl_matrix_free(RHS);
    gsl_matrix_free(WEIGHT);

    Kriging_variables->count = Kriging_variables->count+1;

    return real_deviation_estimate;
}

double predict_ANN(Session_Props *sess, const double raw_input[], int which_ANN_model)
{

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
        printf("%s",TF_Message(Status));
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

void initNRELPB(double P_net,double T_in_ref_blk, double p_high, double dT_PHX_cold_approach,
double eta_isen_mc,double eta_isen_rc,double eta_isen_t,double dT_mc_approach,double T_amb_base, char* HTF_name, int HTF_choice, 
char* SolarTherm_path, double T_HTF_cold_des, double* res)
{

    /*************************************************************
    **************************************************************  
    *            Result indexing:                                *
    *            res[0] = HTR_UA;                    [W/K]       *                  
    *            res[1] = LTR_UA;                    [W/K]       *                  
    *            res[2] = W_turb_des;                [W]         *                 
    *            res[3] = W_maincomp_des;            [W]         *
    *            res[4] = W_recomp_des;              [W]         *
    *            res[5] = Cooler_UA;                 [W/K]       *    
    *            res[6] = PHX_UA;                    [W/K]       *    
    *            res[7] = m_dot_CO2_des;             [kg/s]      *
    *            res[8] = m_dot_HTF_des;             [kg/s]      *
    *            res[9] = Q_dot_PHX_des;             [W]         *                       
    *            res[10] = eta_gross_base;           [-]         *    
    *            res[11] = eta_Q_base;               [-]         *
    *            res[12] = dT_PHX_hot_approach;      [-]         *
    **************************************************************
    *************************************************************/

    fprintf(stderr,"======================Initialising NREL Power Block  based on //doi.org/10.1016/j.solener.2019.01.078====================\n");

    double delta = 100;
    ssc_data_t simulation_result;
    double guess_val = 5;
    while(delta>0.5)
    {
        simulation_result = runNRELPB(
        10,
        P_net,
        T_in_ref_blk,
        p_high,
        T_amb_base,
        guess_val,  /**********************************************dT_PHX_hot_approach ==> iterated value*/
        dT_PHX_cold_approach,                  
        eta_isen_mc,
        eta_isen_rc,
        eta_isen_t,
        dT_mc_approach,
        HTF_name,
        HTF_choice,
        ".",
        SolarTherm_path,
        ".",
        0,
        0,
        0);

        double T_HTF_cold_calculated;
        ssc_data_get_number(simulation_result,"T_htf_cold_des",&T_HTF_cold_calculated);
        fprintf(stderr,"HTF outlet temperature at design point: %lf C\n",T_HTF_cold_calculated);

        delta = fabs(T_HTF_cold_des - (T_HTF_cold_calculated+273.15));
        fprintf(stderr,"dT_PHX_hot_approach iteration: %lf C\n",guess_val);
        
        if(delta>0.5)
        {
            guess_val = guess_val + (delta-0.5);
        }
    }
    
    double dT_PHX_hot_approach = guess_val;
    fprintf(stderr,"dT_PHX_hot_approach at design point: %lf C\n",dT_PHX_hot_approach);

    double HTR_UA;
    ssc_data_get_number(simulation_result, "HTR_UA_calculated", &HTR_UA);
    fprintf(stderr,"HTR_UA at design point = %lf [MW/K]\n",HTR_UA);

    double LTR_UA;
    ssc_data_get_number(simulation_result,"LTR_UA_calculated",&LTR_UA);
    fprintf(stderr,"LTR_UA at design point = %lf [MW/K]\n",LTR_UA);

    double W_turb_des;
    ssc_data_get_number(simulation_result,"t_W_dot",&W_turb_des);
    fprintf(stderr,"Turbine power at design point = %lf [MW]\n",W_turb_des);

    double W_maincomp_des;
    ssc_data_get_number(simulation_result,"mc_W_dot",&W_maincomp_des);
    fprintf(stderr,"Main compressor power at design point = %lf [MW]\n",W_maincomp_des);

    double W_recomp_des;
    ssc_data_get_number(simulation_result,"rc_W_dot",&W_recomp_des);
    fprintf(stderr,"Re-compressor power at design point = %lf [MW]\n",W_recomp_des);

    double Cooler_UA;
    ssc_data_get_number(simulation_result,"LP_cooler_UA",&Cooler_UA);
    fprintf(stderr,"Cooler UA value design point = %lf [MW/K]\n",Cooler_UA);

    double PHX_UA;
    ssc_data_get_number(simulation_result,"UA_PHX",&PHX_UA);
    fprintf(stderr,"HX UA value design point = %lf [MW/K]\n",PHX_UA);

    double m_dot_CO2_des;
    ssc_data_get_number(simulation_result,"m_dot_co2_full",&m_dot_CO2_des);
    fprintf(stderr,"Mass flow rate of CO2 at design point = %lf [kg/s]\n",m_dot_CO2_des);

    double m_dot_HTF_des;
    ssc_data_get_number(simulation_result,"m_dot_htf_des",&m_dot_HTF_des);
    fprintf(stderr,"Mass flow rate of HTF at design point = %lf [kg/s]\n",m_dot_HTF_des);

    double Q_dot_PHX_des;
    ssc_data_get_number(simulation_result,"q_dot_PHX",&Q_dot_PHX_des);
    fprintf(stderr,"PHX heat transfer at design point: %lf MWth\n",Q_dot_PHX_des);

    double W_dot_cooler_des;
    ssc_data_get_number(simulation_result,"cooler_tot_W_dot_fan",&W_dot_cooler_des);
    fprintf(stderr,"Cooler fan power at design point: %lf MW\n",W_dot_cooler_des);

    double eta_gross_base = (P_net-(W_dot_cooler_des*1e6))/(Q_dot_PHX_des*1e6);
    fprintf(stderr,"PB cycle thermal efficiency (cooler fan has been included) = %lf \n",eta_gross_base);

    /*Assigning values*/
    res[0] = HTR_UA * 1e6;                              /*Converting from MW/K to W/K*/
    res[1] = LTR_UA * 1e6;                              /*Converting from MW/K to W/K*/
    res[2] = W_turb_des *1e6;                           /*Converting from MW to W*/
    res[3] = W_maincomp_des * 1e6;
    res[4] = W_recomp_des * 1e6;                        /*Converting from MW to W*/
    res[5] = Cooler_UA * 1e6;                           /*Converting from MW/K to W/K*/
    res[6] = PHX_UA  * 1e6;                             /*Converting from MW/K to W/K*/
    res[7] = m_dot_CO2_des;
    res[8] = m_dot_HTF_des;
    res[9] = Q_dot_PHX_des * 1e6;                       /*Heat exchanger thermal power rate [W]*/

    res[10] = eta_gross_base;
    res[11] = 1;                                        /*ratio of Q_PHX / Q_PHX at design point will always be 1
                                                          since there's no deviation from the on design 
                                                          in the operating condition*/
    res[12] = dT_PHX_hot_approach;                      /*Approach temperature*/
    
    ssc_data_free(simulation_result);
    fprintf(stderr,"====================== Done initialising NREL PB ====================\n");

    return;
}

void destructANN(Session_Props* sess) //******* destructor for ANN session
{
    fprintf(stderr,"ANN is called %d times to predict 1 eta during the simulation\n",sess->count);

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

void destructKriging(Kriging_struct* Kriging_variables) //******** destructor for Kriging
{

    fprintf(stderr,"Kriging is called %d times to predict 1 eta during the simulation\n",Kriging_variables->count/2);

    for(size_t i=0; i<Kriging_variables->rows;i++)
    {
        free(Kriging_variables->trainingData[i]);
    }

    gsl_matrix_free(Kriging_variables->DISTANCE);

    gsl_matrix_free(Kriging_variables->VARIOGRAM_HX);
    gsl_matrix_free(Kriging_variables->COVARIANCE_HX);
    gsl_matrix_free(Kriging_variables-> INVERSE_HX);

    gsl_matrix_free(Kriging_variables->VARIOGRAM_PB);
    gsl_matrix_free(Kriging_variables->COVARIANCE_PB);
    gsl_matrix_free(Kriging_variables->INVERSE_PB);


    free(Kriging_variables);
}

/*
void* constructOnTheFlyReceiver(double H_drop, double T_HTF_in_des, double T_HTF_out_des, char* base_path)
{
    char line[limitSize];
   
    int* index_and_status = malloc(sizeof(int*)*2); 

    checkConfigReceiver(H_drop,T_HTF_in_des,T_HTF_out_des,base_path, index_and_status);

    int match_index = index_and_status[0];
    int status_config = index_and_status[1];

    if(match_index==-1000) 
    {

    }


}*/
