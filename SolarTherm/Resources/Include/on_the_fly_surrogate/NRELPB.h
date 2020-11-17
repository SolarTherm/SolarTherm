#include <stdio.h>
#include <stdlib.h>

typedef struct sim_struct
{
    ssc_number_t* array_props;
    ssc_number_t* array_OD;
    int rows_props;
    int rows_OD;
}sim_struct;

ssc_data_t runNRELPB(int ,double , double , double ,
    double , double , double , 
    double , double , double , double ,
    char* , int, char* , char* , char* , int , int , 
    int );

void generateOffDesignFile(double , double , double , char* , char*, int , int, char*);

void genPropsArray(char* , sim_struct* );

void genOffDesignArray(char* , sim_struct* );

void ssc_test();
