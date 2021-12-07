#define NEW(TYPE) (TYPE*)malloc(sizeof(TYPE))
#define NEW_ARRAY(TYPE,SIZE) (TYPE*)malloc(sizeof(TYPE) * SIZE)
#define MAXLEN 2048

//int read_num_segment(const char* modelica_wd);
//void write_flux_array(int file_index, const char* SolarTherm_path, const char* modelica_wd);
void run_ascend_sintering_model(const char *ppath, const char *pname, const char *pfunc, int argc, int num_segment, const char *varnames[], 
			const double var[], const char *modelica_wd, const char* SolarTherm_path, double* angles, double* returns, const char* iron_sample);
void read_solar_angles(double* angles, int file_index, const char* modelica_wd);
int run_ascend_sintering_model_CLI(const double var[], const char* solstice_wd, const char* SolarTherm_path, char* iron_sample, const char* which_run, const char* fmfile);
double run_interpolation(const char *ppath, const char *pname, const char *pfunc, const char* modelica_wd, double declination, double sun_hour_angle, double flux_multiple_off);
