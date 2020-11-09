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

typedef struct Kriging_properties
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

    gsl_matrix* DISTANCE;

    gsl_matrix* VARIOGRAM_PB;
    gsl_matrix* COVARIANCE_PB;
    gsl_matrix* INVERSE_LSM_PB;

    gsl_matrix* VARIOGRAM_HX;
    gsl_matrix* COVARIANCE_HX;
    gsl_matrix* INVERSE_LSM_HX;
}Kriging_properties;

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

}ANN_properties;

//void NoOpDeallocator(void* data, size_t a, void* b); //==> THIS IS COMMENTED SINCE ANOTHER C PROGRAM (st_surrogate.c) ALREADY HAS THIS FUNCTION;

void *load_ANN_properties(char*, double* , double* , double* , double* , int, int, double, double, double );

double predict_ANN(const ANN_properties*, const double [], int);

void* constructKriging(double , double , double , double , double , double , double , double , double , double , char*, char*, int , int, double );

void* constructANN(double , double ,double ,double , double ,double ,double ,double , double , double , int , char*, char*, int ,int, double );

void destructANN(ANN_properties* );

void destructKriging(Kriging_properties* );

void checkConfig(double , double , double , double , double , double, int* ,char*);

double predict_Kriging(Kriging_properties* , double [] , char* , char*);

void getWeight(Kriging_properties* , gsl_matrix* , char* );

void completeCoVarianceMatrix(Kriging_properties* , char* );

void eucledianDistance_2(Kriging_properties*, int , int , gsl_matrix*);

void completeEucledianDistance(Kriging_properties* , double*);

void completeVariogramMatrix(Kriging_properties* , char*, char*);

double** create2Darray(int , int);

void getTrainingDataPoints(int , double**, Kriging_properties* );

int getNumOfData(char* );

void generateTrainingData(double , double , double , double , double , double , int , int, char* ,int, char*);

void* load_KrigingVariables(char* , int , int , double , double , double , double , double , double ,double , 
double ,double , double ,double , double  ,double ,double ,double ,double , double ,double , double, char* );

Kriging_properties* buildKriging(double , double ,double , double , double , double ,double , double , double , double , char*, char*, int ,char*, char*, int, int ,int, double);

ANN_properties* buildANN(double , double ,double , double , double , double ,double , double , double , char* , char*, int ,char*, char* ,char* ,int ,int, int, int, int, double );

int trainingANN(char* , char* , int );

char* build_trainingdir_path(char* , char* , char* , int );

char* concat_training_dir(char* , char* );



