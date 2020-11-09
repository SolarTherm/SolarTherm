#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_linalg.h>
#include <gsl/gsl_cblas.h>
#include <gsl/gsl_blas.h>
#include <dirent.h>
#include <python2.7/Python.h>
#include <unistd.h>
#include <limits.h>

#include "./lib/kriging.c"
#include "./lib/kriging.h"

/*How to invert a matrix http://www.macapp.net/MyWikiThings/invertmatrix.c*/
//gcc test_kriging.c -lm -lgsl -lgslcblas -lpython2.7 -o kriging.out

int main()
{   
    char line[2000];

    char* filepath_test_algorithm = "./test_data/test_algorithm.csv";
    int status_program = test_program(filepath_test_algorithm);
    if(status_program < 0)
    {
        printf("%s\n","Kriging is invalid. Check your algorithm!\n");
        return -1;
    }

    /*This is modelica program*/    
    double P_net = 2e7;
	double T_in_ref_blk = 1243.27;
	double p_high = 22707266.48;
	double PR = 2.98;
	double pinch_PHX = 23.67;
	double dTemp_HTF_PHX = 238.45;
    double load_base = 1;
    double T_amb_base = 39 + 273.15;
    double eta_gross_base = 0.49991927091306; 
    double eta_Q_base = 0.9998537337387947;
    int user_choice = 1; //-----------------------> 1 is kriging, 2 is ANN
    /*End of Modelica Program*/

    char cwd[limitSize];
    getcwd(cwd, sizeof(cwd));
    printf("Current working dir: %s\n", cwd);

    /*Check if the design configuration of the PB model exists or not in the data bank*/
    /*
    status = 1 ~> gather new data since no design parameter match with params parsed by Modelica 
    status = 0 ~> need not to gather new data

    index = index to which trianing folder the surrogate model should look into, if status == 1 then C program will generate
    new training data and save it under a folder which is indexed with index
    */
    int* index_and_status = malloc(sizeof(int*)*2); 
    checkConfig(P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX,index_and_status);

    int match_index = index_and_status[0];
    int status = index_and_status[1];
    
    if(status==1)
    {
        printf("Start gathering new off-design data\n");
        clock_t begin = clock();

        int numdata = 2; //initial number of training data
        generateTrainingData(
            P_net, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, match_index, numdata
            );
        
        clock_t end = clock();
        double time_spent = (double)(end-begin) / CLOCKS_PER_SEC;

        printf("Finish gathering new off-design data: it took %lf s\n",time_spent);
    }
    

    /*Reading training data and test data*/
    char* trainingdir = "./training_data-dummy/";
    char* config_base = "config";
    char* testdir = "./test_data/20_Oct_2020/";
    
    char* filenametraining = "scaled_Kriging_training_data_deviation.csv";
    char* filenametesting = "test_data_OAT.csv";
    char* fnres = "./result_kriging100.csv";

    //************* Create a file to dump result
    FILE* resfile = fopen(fnres,"w");

    char* minname = "min.txt";
    char* maxname = "max.txt";
   
    /*Scaler - Read from txt file UB and LB*/
    int lenmax = strlen(trainingdir) + strlen(maxname) + 1;
    char* filepathmax = malloc(sizeof(char*)*lenmax);
    strcpy(filepathmax,trainingdir);
    strcat(filepathmax,maxname);

    FILE *fnmax = fopen(filepathmax,"r"); //instantiate pointer to the filepathmax
    if(fnmax==NULL)
    {
        printf("File path max data doesn't exist! Check your path\n");
        return -1;
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

    int lenmin = strlen(trainingdir) + strlen(minname) + 1;
    char* filepathmin = malloc(sizeof(char*)*lenmin);
    strcpy(filepathmin,trainingdir);
    strcat(filepathmin,minname);

    FILE *fnmin = fopen(filepathmin,"r"); //instantiate pointer to the filepathmin

    if(fnmin==NULL)
    {
        printf("File path min data doesn't exist! Check your path\n");
        return -1;
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
    
    double load_max = UB[0];    //5.300000000000000266e-01; 
    double T_in_max = UB[1];    //1.915000000000009095e+01; 
    double T_amb_max = UB[2];   //6.057999999999998408e+01; 
    double eta_gross_max = UB[3];   //9.359049161743987488e-02;
    double eta_Q_max = UB[4];   //7.702379808750736689e-02;
    
    double load_min = LB[0];    //-2.399999999999999911e-01; 
    double T_in_min = LB[1];    //-1.630999999999994543e+01; 
    double T_amb_min = LB[2];   //-1.023000000000001819e+01; 
    double eta_gross_min = LB[3];   //-2.123774512318776786e-02;
    double eta_Q_min = LB[4];   //-2.263297768272809485e-02;
    
    /*Reading Kriging Parameters*/
    //***********************PB
    char* name_krig_param = "Kriging_Param_eta_PB.txt";
    int len = strlen(name_krig_param) + strlen(trainingdir) + 1;
    char* filepath_kriging_param = malloc(sizeof(char*)*len);
    strcpy(filepath_kriging_param,trainingdir);
    strcat(filepath_kriging_param,name_krig_param);
    FILE* fnkrigparam = fopen(filepath_kriging_param,"r");
    double* krig_param_PB = malloc(sizeof(double*)*3);
    fgets(line,limitSize,fnkrigparam);
    sscanf(line,"%lf,%lf,%lf",&krig_param_PB[0],&krig_param_PB[1],&krig_param_PB[2]);
    fclose(fnkrigparam);
    double sill_PB = krig_param_PB[0];
    double Nugget_PB = krig_param_PB[1];
    double Spherical_PB = 1-sill_PB;
    double Range_PB = krig_param_PB[2];

    //***********************HX
    name_krig_param = "Kriging_Param_eta_Q.txt";
    len = strlen(name_krig_param) + strlen(trainingdir) + 1;
    filepath_kriging_param = malloc(sizeof(char*)*len);
    strcpy(filepath_kriging_param,trainingdir);
    strcat(filepath_kriging_param,name_krig_param);
    fnkrigparam = fopen(filepath_kriging_param,"r");
    double* krig_param_HX = malloc(sizeof(double*)*3);
    fgets(line,limitSize,fnkrigparam);
    sscanf(line,"%lf,%lf,%lf",&krig_param_HX[0],&krig_param_HX[1],&krig_param_HX[2]);
    fclose(fnkrigparam);

    double sill_HX = krig_param_HX[0];
    double Nugget_HX = krig_param_HX[1];
    double Spherical_HX = 1-sill_HX;
    double Range_HX = krig_param_HX[2];
    /*End reading Kriging Parameters*/

    /*Start reading the training data and testing data*/
    int lengthtraining = strlen(filenametraining) + strlen(trainingdir) + 1;
    char* filepathtraining = malloc(sizeof(char*)*lengthtraining);
    strcpy(filepathtraining,trainingdir);
    strcat(filepathtraining,filenametraining);

    int lengthtest = strlen(filenametesting) + strlen(testdir) + 1;
    char* filepathtestdata = malloc(sizeof(char*)*lengthtest);
    strcpy(filepathtestdata,testdir);
    strcat(filepathtestdata,filenametesting);

    int rows = getNumOfData(filepathtestdata);
    
    struct PB_data_point test_data[rows];  
    int inputsize = 3;
    int outputsize = 2;
    double* inputs = malloc(sizeof(double*)*inputsize);

    /*Loop through all the test file*/
    FILE* testfile = fopen(filepathtestdata,"r");
    fgets(line,limitSize,testfile); //====> skip the first line
    fgets(line,limitSize,testfile);
    i = 0;

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
        double deviation_load = load_base - test_data[i].load;
        double deviation_T_in = T_in_ref_blk - test_data[i].T_HTF_in;
        double deviation_T_amb = T_amb_base - test_data[i].T_amb_input;

        /*Scale the input*/
        double load = (deviation_load - load_min) / (load_max - load_min);
        double T_HTF_in = (deviation_T_in - T_in_min) / (T_in_max - T_in_min);
        double T_amb_input = (deviation_T_amb - T_amb_min) / (T_amb_max - T_amb_min);

        inputs[0] = load; 
        inputs[1] = T_HTF_in; 
        inputs[2] = T_amb_input;

        /*ESTIMATE PB EFFICIENCY*/
        int index_eta_gross_in_training_data = 3; 
        double deviation_estimate_eta_gross_scaled = kriging(
            filepathtraining,Nugget_PB,Spherical_PB,Range_PB,inputs,inputsize,outputsize,index_eta_gross_in_training_data,"spherical"
            );

        double deviation_estimate_eta_gross = deviation_estimate_eta_gross_scaled * (eta_gross_max-eta_gross_min) + eta_gross_min;
        double estimate_eta_gross = eta_gross_base - deviation_estimate_eta_gross;

        /*ESTIMATE HX EFFICIENCY*/   
        int index_eta_Q_in_training_data = 4;
        double deviation_estimate_eta_Q_scaled = kriging(
            filepathtraining,Nugget_HX,Spherical_HX,Range_HX,inputs,inputsize,outputsize,index_eta_Q_in_training_data,"spherical"
            );
        
        double deviation_estimate_eta_Q = deviation_estimate_eta_Q_scaled * (eta_Q_max-eta_Q_min) + eta_Q_min;
        double estimate_eta_Q = eta_Q_base - deviation_estimate_eta_Q;  
        
        /*Dump to resfile*/
        fprintf(resfile,"%lf,%lf\n",estimate_eta_gross,estimate_eta_Q);
        fgets(line,limitSize,testfile);
        i++;
    }

    fclose(testfile); 
    fclose(resfile);
    
    ///char cmd[100];
    //strcpy(cmd,"python3 plot_kriging.py");
    //system(cmd);
     
    free(filepathtraining);
    free(filepathtestdata);
    free(filepathmax);
    free(filepathmin);
    free(UB);
    free(LB);

    return 0;
}


