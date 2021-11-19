
/*
	Function protoypes
*/
void initNRELPB(double P_net,double T_in_ref_blk, double p_high, double dT_PHX_cold_approach
		,double eta_isen_mc,double eta_isen_rc,double eta_isen_t,double dT_mc_approach
		,double T_amb_base, char* HTF_name, int HTF_choice
		,char* SolarTherm_path, double T_HTF_cold_des, double* res
);

void* constructKriging(double P_net, double T_in_ref_blk, double p_high, double PR, 
		double pinch_PHX, double dTemp_HTF_PHX, double load_base,  double T_amb_base, 
		double eta_gross_base, double eta_Q_base, char* base_path,  char* SolarTherm_path,
		int inputsize, int outputsize, double tolerance, int PB_model, 
		int htf_choice, double dT_PHX_hot_approach,  double dT_PHX_cold_approach,
		double eta_isen_mc, double eta_isen_rc, double eta_isen_t,double dT_mc_approach, 
		char* HTF_name
);

void* constructANN(double P_net, double T_in_ref_blk, double p_high, double PR, 
		double pinch_PHX, double dTemp_HTF_PHX, double load_base, double T_amb_base, 
		double eta_gross_base, double eta_Q_base, int which_ANN_model, char* base_path, char* SolarTherm_path, 
		int inputsize, int outputsize, double tolerance, int PB_model,
		int htf_choice, double dT_PHX_hot_approach,  double dT_PHX_cold_approach,
		double eta_isen_mc, double eta_isen_rc, double eta_isen_t,double dT_mc_approach,
		char* HTF_name
);

void destructANN(void* sess);

void destructKriging(void* Kriging_variables);

