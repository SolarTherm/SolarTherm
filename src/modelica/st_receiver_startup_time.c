#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>

double energy(const double* dni, const double* eta_op, double A_h, double dt, int nsteps, double Q_min) {
	int i;
	double t = 0;
	if (eta_op[0]*dni[0]*A_h > Q_min)
	{
		t = t + dt;
		i = 1;
	}
	else
	{
		t = t + 0;
		i = nsteps + 1;
	}		
	while(eta_op[i]*dni[i]*A_h > Q_min && i <= nsteps)
	{
		t = t + dt;
		i = i + 1;
	}
	return t;
}