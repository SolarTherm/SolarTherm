#ifndef ST_OTF_SSCPB_H
#define ST_OTF_SSCPB_H

#include <sscapi.h>

typedef struct{
    ssc_number_t* array_props;
    ssc_number_t* array_OD;
    int rows_props;
    int rows_OD;
} sim_struct;

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


void generateOffDesignFile(double T_in_ref_blk, double load_des, double T_amb_des
		,char* trainingdir, char* base_path, int numinputs, int numdata
		,char* training_or_validation
);

void loadPropsArray(char* fn_props, sim_struct* sim);

void loadOffDesignArray(char* fn_OD, sim_struct* sim);

ssc_data_t runNRELPB(int numdata,double P_net, double T_in_ref_blk, double p_high
		,double T_amb_base, double dT_PHX_hot_approach, double dT_PHX_cold_approach
		,double eta_isen_mc, double eta_isen_rc, double eta_isen_t
		,double dT_mc_approach, char* HTF_name, int HTF_choice, char* trainingdir
		,char* SolarTherm_path, char* base_path, int status_config, int match_index
		,int is_OD_simulated, int is_run_test_func
);

void ssc_test();

void dataProcessing(char* fntrain, char* trainingdir, char* base_path);

#endif
