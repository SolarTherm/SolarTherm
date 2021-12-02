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

double dynamicViscosity(double T);
double thermalConductivity(double T);
double specificHeatCapacityCp(double T);
int curve_fit(int cols, double dt, double mat[cols], double * C);

void Temperature (double Ri,double Ro, double m_flow, double Tf, double Tamb, double CG, int nt, double R_fouling, double ab, double em, double kp, double h_ext, 
						double * BDp, double * BDpp, double * Ti, double * To);
void Thermoelastic (double T, double r, double theta, double b, double a, double l, double E, double nu, double * BDp, double * BDpp, gsl_matrix* invprop, 
						double* stress, double* strain);
double gn (double rb, double n, double a, double Bi1);
double gpn (double rb, double n, double a, double Bi1);
void Tinit (double T1, double h1, double R1, double T2, double h2, double R2, double ab, double q0, double k, double r, double t, double tol, double itermax,
				double * C, double * T);
void Temperature2 (double Ri, double Ro, double m_flow, double Tf, double Tamb, double CG, int nt, double R_fouling, double ab, double em, double kp, 
						double h_ext, double * BDp, double * BDpp, double * Ti, double * To);
#endif
