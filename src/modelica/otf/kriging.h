#ifndef ST_OTF_KRIGING_H
#define ST_OTF_KRIGING_H

#include "util.h"

#include <gsl/gsl_matrix.h>

typedef struct{
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

    /*This section is for all the pre-calculated Matrix*/
    gsl_matrix* DISTANCE;

    gsl_matrix* VARIOGRAM_HX;
    gsl_matrix* COVARIANCE_HX;
    gsl_matrix* INVERSE_HX;

    gsl_matrix* VARIOGRAM_PB;
    gsl_matrix* COVARIANCE_PB;
    gsl_matrix* INVERSE_PB;

    int count;

} Kriging_struct;


Kriging_struct* buildKriging(double P_net, double T_in_ref_blk,double p_high, double PR, 
		double pinch_PHX, double dTemp_HTF_PHX,double load_base, double T_amb_base, 
		double eta_gross_base, double eta_Q_base, char* base_path, char* SolarTherm_path, int match_index, 
		char* traindir_base, char* config_base, int status_config, int inputsize, int outputsize, double tolerance, int PB_model,
		int htf_choice, double dT_PHX_hot_approach, double dT_PHX_cold_approach, double eta_isen_mc, 
		double eta_isen_rc, double eta_isen_t, double dT_mc_approach, char* HTF_name
);

void getWeight(gsl_matrix* INVERSE_LSM, gsl_matrix* COVARIANCE, gsl_matrix* WEIGHTS, int rows);

void completeCovarianceMatrix(Kriging_struct* Kriging_variables, char* type, char* which_eta);

int trainingANNReceiver(char* fn_data, char* prefixres, int count, char* SolarTherm_path);

void completeVariogramMatrix(Kriging_struct* Kriging_variables, char* type, char* which_eta);

void completeDistanceMatrix(Kriging_struct* Kriging_variables, double* inputs, int inputsize);

void eucledianDistance_2(Kriging_struct* Kriging_variables
		, int rows, int inputsize, gsl_matrix* DISTANCE
);

double** create2Darray(int row, int col);

void* load_KrigingVariables(char* filepathtraining, int inputsize, int outputsize
	,double Nugget_PB, double Nugget_HX, double sill_PB, double sill_HX
	,double Range_PB, double Range_HX, double load_base, double T_in_ref_blk
	,double T_amb_base, double deviation_load_max,double deviation_T_in_max
	,double deviation_T_amb_max ,double deviation_eta_gross_max
	,double deviation_eta_Q_max,double deviation_load_min,double deviation_T_in_min
	,double deviation_T_amb_min,double deviation_eta_gross_min
	,double deviation_eta_Q_min, char* variogram_model
);

double predict_Kriging(Kriging_struct* Kriging_variables
		, const double raw_inputs[], char* which_eta, char* variogram_model
);

#endif
