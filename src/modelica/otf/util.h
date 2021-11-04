#ifndef ST_OTF_UTIL_H
#define ST_OTF_UTIL_H

#define NEW(TYPE) (TYPE*)malloc(sizeof(TYPE))
#define NEW_ARRAY(TYPE,SIZE) (TYPE*)malloc(sizeof(TYPE)*(SIZE))

#define MAXLEN 1024

#define limitSize 1000000

int getNumOfData(char* filepath);

void checkConfig(double P_net, double T_in_ref_blk, double p_high, double PR, double pinch_PHX, 
		double dTemp_HTF_PHX, int* index_and_status, char* base_path, int PB_model,
		double dT_PHX_hot_approach,  double dT_PHX_cold_approach,
		double eta_isen_mc, double eta_isen_rc, double eta_isen_t,double dT_mc_approach,double T_amb_base
);

void generateTrainingData(double P_net, double T_in_ref_blk, double p_high
		,double PR, double pinch_PHX, double dTemp_HTF_PHX, int match_index
		,int numdata, char* base_path, int status_config
		,char* SolarTherm_path
);

char* build_trainingdir_path(
		char* base_path, char* traindir_base, char* config_base, int match_index
);

char* concat_training_dir(char* trainingdir, char* concat_string);

#endif
