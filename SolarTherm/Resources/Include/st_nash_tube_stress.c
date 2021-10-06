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

// Fluid properties
double dynamicViscosity(double T){
	double eta;
	eta = 0.001 * (22.714 - 0.120 * (T - 273.15) + 2.281e-4 * pow((T - 273.15),2) - 1.474e-7 * pow((T - 273.15),3));
	return eta;
};

double thermalConductivity(double T){
	double k;
	k = 0.443 + 1.9e-4 * (T - 273.15);
	return k;
};

double specificHeatCapacityCp(double T){
	double C;
	C = 1396.0182 + 0.172 * T;
	return C;
};

// Least-square curve-fit
int curve_fit(int cols, double dt, double mat[cols], double * C){
	int j, pos, ndata;
	double chisq, theta;
	gsl_matrix *X, *cov;
	gsl_vector *y, *w, *c;
	ndata = 2*cols - 1;
	X = gsl_matrix_alloc (ndata, 3);
	y = gsl_vector_alloc (ndata);
	w = gsl_vector_alloc (ndata);
	c = gsl_vector_alloc (3);
	cov = gsl_matrix_alloc (3, 3);
	for(j=0;j<ndata;j++){
		if(j<cols-1){
			pos = cols-1-j;
			theta = -pos*dt;
		}
		else{
			pos = j-(cols-1);
			theta = pos*dt;
		}
		gsl_matrix_set (X, j, 0, 1);
		gsl_matrix_set (X, j, 1, cos(theta));
		gsl_matrix_set (X, j, 2, sin(theta));
		gsl_vector_set (y, j, mat[pos]);
		gsl_vector_set (w, j, 1.0);
	}
	{
		gsl_multifit_linear_workspace * work = gsl_multifit_linear_alloc (ndata, 3);
		gsl_multifit_linear (X, y, c, cov, &chisq, work);
		gsl_multifit_linear_free (work);
	}
	C[0] = gsl_vector_get(c,0);
	C[1] = gsl_vector_get(c,1);
	C[2] = gsl_vector_get(c,2);
	#define COV(i,j) (gsl_matrix_get(cov,(i),(j)))
	bool verbose = false;
	if(verbose){
		printf("\nLeast-square curve-fit\n");
		printf("# best fit: Y = %f + %f cos(theta) + %f sin(theta)\n",C[0], C[1], C[2]);
		printf("# covariance matrix:\n");
		printf("[ %+.5e, %+.5e, %+.5e  \n", COV(0,0), COV(0,1), COV(0,2));
		printf("  %+.5e, %+.5e, %+.5e  \n", COV(1,0), COV(1,1), COV(1,2));
		printf("  %+.5e, %+.5e, %+.5e ]\n", COV(2,0), COV(2,1), COV(2,2));
		printf("# chisq = %g\n", chisq);
	}
	return 0;
}

void Temperature (double Ri, double Ro, double m_flow, double Tf, double Tamb, double CG, int nt, double R_fouling, double ab, double em, double kp, 
				  double h_ext, double * BDp, double * BDpp, double * Ti, double * To){
	// Flow and thermal variables
	double hf;                          // Heat transfer coefficient due to internal forced-convection
	double mu;                          // HTF dynamic viscosity (Pa-s)
	double kf;                          // HTF thermal conductivity (W/m-K)
	double C;                           // HTF specific heat capacity (J/kg-K)
	double Re;                          // HTF Reynolds number
	double Pr;                          // HTF Prandtl number
	double Nu;                          // Nusselt number due to internal forced convection
	double ln = log(Ro/Ri);             // Log of Ro/Ri simplification

	// Discretisation parameters
	int j;
	double a, b, c1, c2, qabs;
	double dt = pi/(nt-1);

	// Tube section diameter and area
	double d = 2.*Ri;                    // Tube inner diameter (m)
	double area = 0.25 * pi * pow(d,2.); // Tube flow area (m2)


	// HTF thermo-physical properties
	mu = dynamicViscosity(Tf);       // HTF dynamic viscosity (Pa-s)
	kf = thermalConductivity(Tf);    // HTF thermal conductivity (W/m-K)
	C = specificHeatCapacityCp(Tf);  // HTF specific heat capacity (J/kg-K)

	// HTF internal flow variables
	Re = m_flow * d / (area * mu);   // HTF Reynolds number
	Pr = mu * C / kf;                // HTF Prandtl number

	Nu = 0.023 * pow(Re, 0.8) * pow(Pr, 0.4);

	// HTF internal heat transfer coefficient
	if(R_fouling==0){
		hf = Nu * kf / d;
	}
	else{
		hf = Nu * kf / d / (1. + Nu * kf / d * R_fouling);
	}

	// Calculating heat flux at circumferential nodes
	for(j=0;j<nt;j++){
		qabs = fmax(CG*cos(j*dt),0);
			a = -((em*(kp + hf*ln*Ri)*Ro*sigma)/((kp + hf*ln*Ri)*Ro*(ab*qabs + em*sigma*pow(Tamb,4)) + hf*kp*Ri*Tf + (kp + hf*ln*Ri)*Ro*Tamb*(h_ext)));
			b = -((hf*kp*Ri + (kp + hf*ln*Ri)*Ro*(h_ext))/((kp + hf*ln*Ri)*Ro*(ab*qabs + em*sigma*pow(Tamb,4)) + hf*kp*Ri*Tf + (kp + hf*ln*Ri)*Ro*Tamb*(h_ext)));
			c1 = 9.*a*pow(b,2.) + sqrt(3.)*sqrt(-256.*pow(a,3.) + 27.*pow(a,2)*pow(b,4));
			c2 = (4.*pow(2./3.,1./3.))/pow(c1,1./3.) + pow(c1,1./3.)/(pow(2.,1./3.)*pow(3.,2./3.)*a);
			To[j] = -0.5*sqrt(c2) + 0.5*sqrt((2.*b)/(a*sqrt(c2)) - c2);
		Ti[j] = (To[j] + hf*Ri*log(Ro/Ri)/kp*Tf)/(1 + hf*Ri*log(Ro/Ri)/kp);
	}

	// Least-square curve-fit
	curve_fit(nt, dt, Ti, BDp);
	curve_fit(nt, dt, To, BDpp);
	return;
}

void Thermoelastic(double T, double r, double theta, double b, double a, double l, double E, double nu, double * BDp, double * BDpp, gsl_matrix* invprop, double* stress, double* strain){
	double Tbar_i = BDp[0], BP = BDp[1], DP = BDp[2];
	double Tbar_o = BDpp[0], BPP = BDpp[1], DPP = BDpp[2];
	double a2 = a*a, b2 = b*b, r2 = r*r, r4 = pow(r,4);

	gsl_matrix *Stress = gsl_matrix_alloc(3, 1);
	gsl_matrix *Strain = gsl_matrix_alloc(3, 1);

	double C = l*E/(2.*(1. - nu));
	double D = 1./(2.*(1. + nu));
	double kappa = (Tbar_i - Tbar_o)/log(b/a);
	double kappa_theta = r*a*b/(b2 - a2)*((BP*b - BPP*a)/(b2 + a2)*cos(theta) + (DP*b - DPP*a)/(b2 + a2)*sin(theta));
	double kappa_tau   = r*a*b/(b2 - a2)*((BP*b - BPP*a)/(b2 + a2)*sin(theta) - (DP*b - DPP*a)/(b2 + a2)*cos(theta));

	double T_theta = T - ((Tbar_i - Tbar_o) * log(b/r)/log(b/a)) - Tbar_o;

	double Qr = kappa*C*(0 -log(b/r) -a2/(b2 - a2)*(1 -b2/r2)*log(b/a) ) 
				+ kappa_theta*C*(1 - a2/r2)*(1 - b2/r2);
	double Qtheta = kappa*C*(1 -log(b/r) -a2/(b2 - a2)*(1 +b2/r2)*log(b/a) ) 
				+ kappa_theta*C*(3 -(a2 +b2)/r2 -a2*b2/r4);
	double Qz = kappa*nu*C*(1 -2*log(b/r) -2*a2/(b2 - a2)*log(b/a) ) 
				+ kappa_theta*2*nu*C*(2 -(a2 + b2)/r2) -l*E*T_theta;
	double Qrtheta = kappa_tau*C*(1 -a2/r2)*(1 -b2/r2);

	gsl_matrix_set(Stress, 0, 0, Qr);
	gsl_matrix_set(Stress, 1, 0, Qtheta);
	gsl_matrix_set(Stress, 2, 0, Qz);
	gsl_blas_dgemm (CblasNoTrans, CblasNoTrans, 1.0, invprop, Stress, 0.0, Strain);

	double Er = gsl_matrix_get(Strain,0,0);
	double Etheta = gsl_matrix_get(Strain,1,0);
	double Ez = gsl_matrix_get(Strain,2,0);

	stress[0] = Qr;
	stress[1] = Qrtheta;
	stress[2] = Qtheta;
	stress[3] = Qz;
	stress[4] = sqrt(0.5*(pow(Qr -Qtheta,2) + pow(Qr -Qz,2) + pow(Qz -Qtheta,2)) + 6*pow(Qrtheta,2));

	strain[0] = sqrt(2.)*D*sqrt(pow(Er -Etheta,2) + pow(Er -Ez,2) + pow(Ez -Etheta,2));

	return;
};

void stress(
	double Ri,
	double Ro,
	double m_flow,
	double Tf,
	double Tamb,
	double CG,
	int nt,
	double R_fouling,
	double ab,
	double em,
	double kp,
	double h_ext,
	double alpha,
	double E,
	double nu,
	double * Tci,
	double * Tco,
	double * stress_eq,
	double * strain) {

	double BDp[3], BDpp[3], Ti[nt], To[nt];

	Temperature (Ri, Ro, m_flow, Tf, Tamb, CG, nt, R_fouling, ab, em, kp, h_ext, BDp, BDpp, Ti, To);

	double l = E*nu/((1+nu)*(1-2*nu));
	double m = 0.5*E/(1+nu);
	gsl_matrix *props = gsl_matrix_alloc(3, 3);         // Elasticity tensor
	gsl_matrix *invprop = gsl_matrix_alloc(3, 3);       // Inverse of elasticity tensor
	int row, col;
	for (row = 0; row < 3; ++row) {
		for (col = 0; col < 3; ++col) {
			if(row == col){
				gsl_matrix_set(props, row, col, l + 2*m);
			}
			else{
				gsl_matrix_set(props, row, col, l);
			}
		}
	}
	gsl_permutation *p = gsl_permutation_alloc(3);      // GSL parameter
	int s;                                              // GSL parameter
	gsl_linalg_LU_decomp(props, p, &s);
	gsl_linalg_LU_invert(props, p, invprop);
	gsl_permutation_free(p);
	double stress[5];                                    // Thermo-elastic stress at tube crown
	Thermoelastic(To[0], Ro, 0., Ro, Ri, alpha, E, nu, BDp, BDpp, invprop, stress, strain);
	Tci[0] = Ti[0];
	Tco[0] = To[0];
	stress_eq[0] = stress[4];
	return;
}
