#ifndef ST_OTF_ANN_H
#define ST_OTF_ANN_H

// FIXME can we move this to ann.c?
#include <tensorflow/c/c_api.h>

/*Struct to store neccesary session properties*/
typedef struct{
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

    int count;
} Session_Props;

void NoOpDeallocator(void* data, size_t a, void* b);

Session_Props* buildANN(double P_net, double T_in_ref_blk,double p_high, double PR, 
		double pinch_PHX, double dTemp_HTF_PHX,double load_base, double T_amb_base, 
		double eta_base, char* base_path, char* SolarTherm_path, int match_index, 
		char* traindir_base, char* config_base, char* ANN_path, int which_ANN_model, int gen_data, int status_config,
		int inputsize, int outputsize, double tolerance, int PB_model,
		int htf_choice, double dT_PHX_hot_approach, double dT_PHX_cold_approach, double eta_isen_mc, 
		double eta_isen_rc, double eta_isen_t, double dT_mc_approach, char* HTF_name
);

void *load_session(char* saved_model_dir, double* X_max
		,double* X_min, double* y_max, double* y_min, int inputsize
		,int outputsize, double load_base, double T_in_ref_blk, double T_amb_base
);

int trainingANN(char* fn_data, char* prefixres, int count, char* SolarTherm_path);

double predict_ANN(Session_Props *sess, const double raw_input[], int which_ANN_model);

#endif
