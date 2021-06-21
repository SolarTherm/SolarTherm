#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#define pi 3.141592653589793
#define g_n 9.81
#define sigma 5.670374419e-8

double receiver(double ab, double em, double dni, double eta_op, double Tamb, double Wspd, const double* CL, const double* C4L, const double* CH, double A_h, double H_rcv, double D_rcv){
	
	double Q_inc = eta_op*dni*A_h;                                                                     // Incident power
	double T_ext_linear = CL[1] + CL[2]*Q_inc/1e6 + CL[3]*Tamb + CL[4]*Wspd;                           // Space average temperature for convective loss
	double T_ext_4_linear = C4L[1] + C4L[2]*Q_inc/1e6 + C4L[3]*Tamb + C4L[4]*Wspd;                     // Fourth degree space average temperature for radiative loss
	double Q_ref = (1-ab)*Q_inc;                                                                       // Reflection losses
	double Q_emi = em*sigma*H_rcv*D_rcv*pi*(pow(T_ext_4_linear,4) - pow(Tamb,4));                      // Emmission losses
	double h_conv = CH[5] + CH[4]*Wspd + CH[3]*pow(Wspd,2) + CH[2]*pow(Wspd,3) + CH[1]*pow(Wspd,4);    // Heat transfer coefficient due to forced convection
	double Q_conv = h_conv*H_rcv*D_rcv*pi*(T_ext_linear-Tamb);                                         // Convective losses
	double Q_abs;                                                                                      // Absorbed power
	if(Q_inc > 0){
	Q_abs = Q_inc - Q_ref - Q_emi - Q_conv;
	}
	else{
	Q_abs = 0;
	}

	return Q_abs;
}

double energy(double H_rcv, double D_rcv, double ab, double em, const double* dni, const double* eta_op, const double* Tamb, const double* Wspd, const double* CL, const double* C4L, const double* CH, double A_h, double dt, int nsteps) {
	int i;
	double E = 0;                                                                                       // Accumulated incident energy over receiver surface
	for (size_t i = 1; i < nsteps; i++)
	{
		E = E + 0.5*(receiver(ab, em, dni[i], eta_op[i], Tamb[i], Wspd[i], CL, C4L, CH, A_h, H_rcv, D_rcv) + receiver(ab, em, dni[i-1], eta_op[i-1], Tamb[i-1], Wspd[i-1], CL, C4L, CH, A_h, H_rcv, D_rcv))*A_h*dt;
	}
	return E;
}
