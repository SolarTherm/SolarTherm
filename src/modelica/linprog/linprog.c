#include "linprog.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define LINPROG_DEBUG
#ifdef LINPROG_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif

#define ERR(FMT,...) fprintf(stderr,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)

#define NEW(TYPE) (TYPE *)malloc(sizeof(TYPE))
#define NEW_ARRAY(TYPE,N) (TYPE *)malloc(N*sizeof(TYPE))

#define MAXCHARS 1000000

#define MAXROWS (8760*60/5+10) /* allowing for up to 5-min weather data file */
/**
	Load electricity selling price timeseries data from a modelica table 
	(.motab) text file.

	FIXME this function is loading a price file at every timestep. A better
	technique wouldload the file into RAM once, then interpolate from it as 
	needed.
	
*/
#if 0
PriceData *loadPriceMotabData(const char *filepath){

	FILE* fp;
	fp = fopen(filepath,"r");  
	MSG("Reading price file '%s'",filepath);  
	if (fp == NULL){   
		ERR("Unable to read price file '%s'. Please check the file name.",filepath);
		return NULL;
	}

	// Skipping the first 2 lines
	char line[MAXCHARS];
	fgets(line,MAXCHARS,fp);
	fgets(line,MAXCHARS,fp);
	/* TODO read, check the metadata, including expected nrows! */

	PriceData *pd = NEW(PriceData);
	pd->rows = NEW_ARRAY(PriceDataRow,MAXROWS);

	ERR("Hello!");
	
	//Start reading the data starting from line 3
	unsigned i = 0;
	while(i < MAXROWS && fgets(line,MAXCHARS,fp)){
		sscanf(line,"%lf,%lf", &(pd->rows[i].time), &(pd->rows[i].price));
		i++;
		// FIXME if i > length...
	}
	fclose(fp);
	if(i >= MAXROWS){
		MSG("ERROR: File '%s' contained more rows than allowed!",filepath);
		free(pd->rows);
		free(pd);
		return NULL;
	}
	pd->nrows = i;
	
	/* free up the excess memory. FIXME better to read the file metadata instead if possibe */
	PriceDataRow *rows1 = NEW_ARRAY(PriceDataRow,pd->nrows);
	memcpy(rows1,pd->rows,pd->nrows*sizeof(PriceDataRow));
	free(pd->rows);
	pd->rows = rows1;
	MSG("Read %u rows from price file '%s'",pd->nrows,filepath);
	
	return pd;
}
#endif

#if 0
/**
	Selectively read just the time and DNI from a weather data file.
	
	FIXME transition to using Modelica's external functions for loading data and interpolating.
*/
WeatherData *loadDNIMotabData(const char *filepath){
	char line[MAXCHARS];
	unsigned i = 0;

	FILE* fp;
	fp = fopen(filepath,"r");  
	MSG("Reading weather file '%s'",filepath);   
	if (fp == NULL){
		ERR("Unable open weather file '%s'. Please check the file name",filepath);
		return NULL;
	}

	/* read the two header rows */
	fgets(line,MAXCHARS,fp);
	assert(strcmp(line,"#1\n") == 0);
	fgets(line,MAXCHARS,fp);
	assert(strcmp(line,"double weather(8760,9)\n") == 0);

	/* read the metadata line */

	WeatherData *wd = NEW(WeatherData);if(!wd)return NULL;
	wd->rows = NEW_ARRAY(WeatherDataRow,MAXROWS);if(!wd->rows)return NULL;

	//Start reading the file starting from line 3
	fgets(line,MAXCHARS,fp);

	double ghi,dhi,Tdry,Tdew,rh,press,wdir,wspd,albedo;
	int nvals = 0;
	while(i < MAXROWS && fgets(line,MAXCHARS,fp)){
		nvals = sscanf(line,"%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf"
				,&(wd->rows[i].time), &ghi, &(wd->rows[i].DNI),&dhi,&Tdry
				,&Tdew,&rh,&press,&wdir,&wspd
				,&albedo
		);
		if(nvals != 11){
			ERR("Unexpected format reading data row %u", i);
			break;
		}
		i++;
	}
	wd->nrows = i;
	if(wd->nrows >= MAXROWS){
		ERR("Too many rows found in weather file '%s'",filepath);
		motab_free(wd);
		return NULL;
	}
	fclose(fp);

	/* save uneeded memory */
	WeatherDataRow *rows1;
	rows1 = NEW_ARRAY(WeatherDataRow,wd->nrows);if(!rows1)return NULL;
	memcpy(rows1,wd->rows,wd->nrows*sizeof(WeatherDataRow));
	free(wd->rows);
	wd->rows = rows1;

	return wd;
}
#endif

#if 0
PriceDataRow getPriceWraparound(PriceData *pd,int ti,int offset){
	unsigned i = ti + offset;
	assert(i >= 0);
	assert(ti < pd->nrows);
	assert(offset < pd->nrows);
	if(i >= pd->nrows){
		i = i - pd->nrows;
	}
	return pd->rows[i];
}

WeatherDataRow getWeatherWraparound(WeatherData *wd,int ti,int offset){
	unsigned i = ti + offset;
	assert(offset < wd->nrows);
	if(i >= wd->nrows){
		i = i - wd->nrows;
	}
	return wd->rows[i];
}

void pricedata_free(PriceData *pd){
	if(pd){
		if(pd->rows){
			free(pd->rows);
		}
		free(pd);
	}
}

void weatherdata_free(WeatherData *wd){
	if(wd){
		if(wd->rows){
			free(wd->rows);
		}
		free(wd);
	}
}
#endif

// vim: ts=4:sw=4:noet:tw=80
