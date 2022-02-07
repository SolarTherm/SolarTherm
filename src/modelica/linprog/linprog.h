#ifndef LINPROG_H
# define LINPROG_H

#define limitSize 1000000

typedef struct weather_data
{
    double time;
    double GHI; 
    double DNI;
    double DHI;
    double Tdry;
    double Tdew;
    double relHum;
    double press;
    double wdir;
    double wspd;
    double albedo;

}weather_data;

typedef struct price_data
{
    double time;
    double price;
}price_data;

void getPriceMotabData(const char* , double* , double* , int );
void getDNIMotabData(const char* , double* , double* , int );

#endif
