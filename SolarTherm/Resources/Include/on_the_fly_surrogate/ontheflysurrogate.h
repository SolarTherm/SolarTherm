#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_linalg.h>
#include <gsl/gsl_cblas.h>
#include <gsl/gsl_blas.h>
#include <python2.7/Python.h>
#include "tensorflow/c/c_api.h"
#include "SAM/sscapi.h"

#define limitSize 1000000

typedef struct
{
    double P_net;
    double T_in_ref_blk;
    double p_high;
    double PR;
    double pinch_PHX;
    double dTemp_HTF_PHX;
    double load;
    double T_HTF_in;
    double T_amb_input;
    double eta_gross;
    double eta_Q;

}PB_validation_data_point;

typedef struct Kriging_struct
{
    int rows;
    int inputsize;
    int outputsize;
    double Nugget_PB;
    double Nugget_HX;
    double sill_PB;
    double sill_HX;
    double Range_PB;
    double Range_HX;
    double** trainingData;
    double load_base;
    double T_in_ref_blk;
    double T_amb_base;
    double deviation_load_max;
    double deviation_T_in_max;
    double deviation_T_amb_max;
    double deviation_eta_gross_max;
    double deviation_eta_Q_max;
    double deviation_load_min;
    double deviation_T_in_min;
    double deviation_T_amb_min;
    double deviation_eta_gross_min;
    double deviation_eta_Q_min;
}Kriging_struct;

typedef struct  /*Struct to store neccesary session properties*/
{
    //************** TensorFlow properties
    TF_Session* Session;
    TF_Graph* Graph;
    TF_Status* Status;
    TF_SessionOptions* SessionOpts;
    TF_Buffer* RunOpts;

    //************ Base values
    double* base_values;

    //************** Scaler properties
    double* X_max;
    double* X_min;
    double* y_max;
    double* y_min;

    int inputsize;
    int outputsize;

}Session_Props;

void NoOpDeallocator(void* data, size_t a, void* b);

void *load_session(char*, double* , double* , double* , double* , int, int, double, double, double );

double predict_ANN(const Session_Props*, const double [], int);

void* constructKriging(double , double , double , double , double , double , double , double , double , double , char*, char*
, int , int, double, int, int , double , double ,double , double , double ,double, char*  );

void* constructANN(double , double ,double ,double , double ,double ,double ,double , double , double , int , char*, char*,
int ,int, double, int, int , double , double ,double , double , double ,double, char* );

void destructANN(Session_Props* );

void destructKriging(Kriging_struct* );

void checkConfig(double , double , double , double , double , double, int* ,char*, int,
double ,double ,double ,double ,double ,double, double );

double predict_Kriging(Kriging_struct* , double [] , char* , char* );

void getWeight(gsl_matrix*, gsl_matrix* , gsl_matrix* , int );

void getCoVarianceMatrix(gsl_matrix* , gsl_matrix* , double , double , int );

void eucledianDistance_2(Kriging_struct*, int , int , gsl_matrix*);

void eucledianDistance(Kriging_struct* , double* , int , int , gsl_matrix*);

void getVariogramMatrix(gsl_matrix* , gsl_matrix* , double , double , double , int , char*);

double** create2Darray(int , int);

void getTrainingDataPoints(int , double**, Kriging_struct* );

int getNumOfData(char* );

void generateTrainingData(double , double , double , double , double , double , int , int, char* ,int, char*);

void* load_KrigingVariables(char* , int , int , double , double , double , double , double , double ,double , 
double ,double , double ,double , double  ,double ,double ,double ,double , double ,double , double );

Kriging_struct* buildKriging(double , double ,double , double , 
double , double ,double , double , 
double , double , char* , char* , int , 
char* , char* , int , int , int , double , int ,
int , double , double , double , 
double , double , double, char*  );

Session_Props* buildANN(double , double ,double , double , 
double , double ,double , double , 
double , char* , char* , int , 
char* , char* , char* , int , int , int ,
int , int , double , int ,
int , double , double , double , 
double , double , double, char* );

int trainingANN(char* , char* , int );

char* build_trainingdir_path(char* , char* , char* , int );

char* concat_training_dir(char* , char* );

void dataProcessing(char* , char*, char* );

void initNRELPB(double ,double , double , double ,double ,
double ,double ,double ,double ,double ,char* ,char* ,double* );



