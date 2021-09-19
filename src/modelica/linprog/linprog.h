#ifndef LINPROG_H
# define LINPROG_H

#include "../st_motab.h"

/* Weather data -- the bits that we need, anyway */
typedef struct{
	double time;
	double DNI;
} WeatherDataRow;

typedef struct{
	WeatherDataRow *rows;
	unsigned nrows;
} WeatherData;

/* Price data */
typedef struct{
	double time;
	double price;
} PriceDataRow;

typedef struct{
	PriceDataRow *rows;
	unsigned nrows;
} PriceData;

PriceData *loadPriceMotabData(const char *filename);

WeatherData *loadDNIMotabData(const char *filename);

/**
	Lookup price data at time with offset, with wrapround to the start of the year if required.
	@param ti time index (0=first row, up to pd->nrows-1)
	@param offset number of rows of offset (0=same as ti, 1= next row, etc)
*/
#if 0
PriceDataRow getPriceWraparound(MotabData *pd,int ti,int offset);

WeatherDataRow getWeatherWraparound(MotabData *wd,int ti,int offset);
#endif

#if 0
void weatherdata_free(WeatherData *wd);
void pricedata_free(PriceData *pd);
#endif

#endif
