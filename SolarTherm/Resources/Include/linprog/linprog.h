#ifndef LINPROG_H
#define LINPROG_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define limitSize 1000000

typedef struct weather_data
{
    float time;
    float GHI; 
    float DNI;
    float DHI;
    float Tdry;
    float Tdew;
    float relHum;
    float press;
    float wdir;
    float wspd;
    float albedo;

}weather_data;

typedef struct price_data
{
    float time;
    float price;
}price_data;

void getPriceMotabData(char* filepath, double* price, double* time, int length);
void getDNIMotabData(char* filepath, double* DNI, double* time, int length);
void printSpace();

#endif
