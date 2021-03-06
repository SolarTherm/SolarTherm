#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void getPriceMotabData(const char* filepath, double* price, double* time, int length)
{
    struct price_data pri[length];
    char line[limitSize];
    size_t i = 0;

    FILE* pri_file;
    pri_file = fopen(filepath,"r");  
    fprintf(stderr,"price file: %s\n",filepath);  
    if (pri_file == NULL)
    {   
        fprintf(stderr,"Price file doesn't exist in the directory. Please check the file name\n");
        exit(EXIT_FAILURE);
    }
	else
	{
		printf("Price file: %s\n",filepath);
	}

    // Skipping the first 2 lines
    fgets(line,limitSize,pri_file);
    fgets(line,limitSize,pri_file);

    //Start reading the file starting from line 3
    fgets(line,limitSize,pri_file);
    
    while(!feof(pri_file))
    {
      sscanf(line,"%lf,%lf",
      &pri[i].time,
      &pri[i].price) ;
      i++;
      fgets(line,limitSize,pri_file); 
    }
    fclose(pri_file);
    
    for(i=0;i<sizeof(pri)/sizeof(pri[0]);i++)
    {
        price[i] = pri[i].price;
        time[i] = pri[i].time;
    }
}

void getDNIMotabData(const char* filepath, double* DNI, double* time, int length)
{
    struct weather_data wea[length];
    char line[limitSize];
    size_t i = 0;

    FILE* DNI_file;
    DNI_file = fopen(filepath,"r");  
    fprintf(stderr,"weather file: %s\n",filepath);   
    if (DNI_file == NULL)
    {   
        fprintf(stderr,"Weather file doesn't exist in the directory. Please check the file name\n");
        exit(EXIT_FAILURE);
    }
	else
	{
		printf("Weather file: %s\n",filepath);
	}

    // Skipping the first 2 lines
    fgets(line,limitSize,DNI_file);
    fgets(line,limitSize,DNI_file);

    //Start reading the file starting from line 3
    fgets(line,limitSize,DNI_file);
    
    while(!feof(DNI_file))
    {
      sscanf(line,"%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf",
      &wea[i].time,
      &wea[i].GHI,
      &wea[i].DNI,
      &wea[i].DHI,
      &wea[i].Tdry,
      &wea[i].Tdew,
      &wea[i].relHum,
      &wea[i].press,
      &wea[i].wdir,
      &wea[i].wspd,
      &wea[i].albedo) ;
      i++;
      fgets(line,limitSize,DNI_file); 
    }
    fclose(DNI_file);
    
    for(i=0;i<sizeof(wea)/sizeof(wea[0]);i++)
    {
        DNI[i] = wea[i].DNI;
        time[i] = wea[i].time;
    }
}

void printSpace()
{
    printf("\n");
}

