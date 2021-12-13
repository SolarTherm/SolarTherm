#ifndef STRESS
#define STRESS

#include <stdio.h>
#include <stdbool.h>
#include <math.h>
#include <gsl/gsl_multifit.h>
#include <gsl/gsl_matrix_double.h>
#include <gsl/gsl_blas.h>
#include <gsl/gsl_linalg.h>
#define pi 3.141592653589793
#define g_n 9.81
#define sigma 5.670374419e-8

double dynamicViscosity(double T, int coolant);

double thermalConductivity(double T, int coolant);

double specificHeatCapacityCp(double T, int coolant);

int curve_fit(int cols, double dt, double mat[cols], double * C);

int curve_fit_net_heat(int cols, double dt, double mat[cols], double * C);

void Temperature (int coolant, double Ri,double Ro, double m_flow, double Tf, double Tamb, double CG, int nt, double R_fouling, double ab, double em, double kp, double h_ext, 
						double * BDp, double * BDpp, double * Ti, double * To, double * Qnet);

void Thermoelastic (double T, double r, double theta, double b, double a, double l, double E, double nu, double * BDp, double * BDpp, gsl_matrix* invprop, 
						double* stress, double* strain);

#endif
