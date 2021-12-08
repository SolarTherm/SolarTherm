#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <stdio.h>

#define MALLOC 2048
 
int RunSolsticeFunc(const char* ppath, const char* pname 
	, const char *psave,  const char *field_type
	, const char *rcv_type, const char *wea_file, const char *sunshape, int num_args
	, const char *varnames[], const double var[]
){
	// ppath: path of the Python script
	// pname: name of the Python script
	// psave: directory to save the results 
	// varnames: a list of variable names
	// var: a list of variable values (all float numbers) corresponding to varnames
	
	
	int i;
	char* var_tmp =  malloc(sizeof(char)*MALLOC); // a temperary string
	
	// convert the list `varnames' to a string `var_names' 
	// to form one parts of the command        	       
	char* var_names = malloc(sizeof(char)*MALLOC); 	
	strcpy(var_names, "");
	for (i = 0; i < num_args; ++i) {
	   snprintf(var_tmp, MALLOC, 
		    "%s,", varnames[i]);
	   strcat(var_names, var_tmp);    
	}

	// convert the list `var' to a string `var_vals' 
	// to form one parts of the command   
	char* var_vals =   (char*)malloc(sizeof(char)*MALLOC);
	strcpy(var_vals, "");	
	for (i = 0; i < num_args; ++i) {
	   snprintf(var_tmp, MALLOC, 
		    "%lf,", var[i]);
	   strcat(var_vals, var_tmp);	 		    
	}
	fprintf(stderr,"%s\n\n",var_vals);	

	// shape the commands together
    char* cmd = (char*)malloc(sizeof(char)*MALLOC); 
    snprintf(cmd, MALLOC, 
        "python3 %s/%s.py --casedir %s --wea_file %s --field_type %s --rcv_type %s --sunshape %s --num_args %d --var_names %s --var_vals %s",
        ppath, pname, psave, wea_file, field_type, rcv_type, sunshape, num_args, var_names, var_vals);

    free(var_tmp);
    free(var_names);
    free(var_vals);
    
    // system call the command
    fprintf(stderr,"%s\n\n",cmd);    
    system(cmd);
    free(cmd);
    return 1;
}

// vim: ts=4:sw=4:tw=80:noet
