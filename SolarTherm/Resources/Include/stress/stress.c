#include "stress.h"

/*
https://github.com/willietheboy/nashTubeStress/blob/master/se6413.py
 -- Solar Energy 160 (2018) 368-379
 -- https://doi.org/10.1016/j.solener.2017.12.003
=============== NPS Sch. 5S 1" S31609 at 450degC ===============
                      Nitrate Salt
                         T:  723.1500 (K)
                       rho:  1803.8000 (kg/m^3)
                        Cp:  1520.4000 (m^2/s^2/K)
                        mu:  1472.4232 (x1e6 kg/m/s)
                     kappa:  0.5285 (kg*m/s^3/K)
                        Pr:  4.2359 (-)
                         U:  3.8960 (m/s)
                      mdot:  5.0000 (kg/s)
                        Re:  143651.3945 (-)
                        Pe:  608492.6747 (-)
                    deltaP: -7589.5960 (Pa/m)
                       HCR:  7602.0000 (J/K/s)
                     h_int:  9613.0515 (W/m^2/K)
                        Bi:  0.7936 (-)
                Biharmonic coefficients:
                    Tbar_i:  749.6892 (K)
                      B'_1:  45.1191 (K)
                      D'_1: -0.0000 (K)
                    Tbar_o:  769.7119 (K)
                     B''_1:  79.4518 (K)
                     D''_1:  0.0000 (K)
              Stress at outside tube crown:
                   sigma_r:  0.0000 (MPa)
              sigma_rTheta:  0.0000 (MPa)
               sigma_theta: -101.0056 (MPa)
                   sigma_z: -389.5197 (MPa)
                  sigma_Eq:  350.1201 (MPa)
*/

// Fluid properties
double dynamicViscosity(double T, int coolant){
	double eta;
	if (coolant == 1){
		eta = 0.001 * (22.714 - 0.120 * (T - 273.15) + 2.281e-4 * pow((T - 273.15),2) - 1.474e-7 * pow((T - 273.15),3));
	}
	else{
		eta = exp(-6.4406 - 0.3958 * log(T) + 556.835/T);
	}
	return eta;
};

double thermalConductivity(double T, int coolant){
	double k;
	if (coolant == 1){
		k = 0.443 + 1.9e-4 * (T - 273.15);
	}
	else{
		k = 124.67 - 0.11381 * T + 5.5226e-5 * pow(T,2) - 1.1842e-8 * pow(T,3);
	}
	return k;
};

double specificHeatCapacityCp(double T, int coolant){
	double C;
	if (coolant == 1){
		C = 1396.0182 + 0.172 * T;
	}
	else{
		C = 1000 * (1.6582 - 8.4790e-4 * T + 4.4541e-7 * pow(T,2) - 2992.6 * pow(T,-2));
	}
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
	gsl_matrix_free(X);
	gsl_vector_free(y);
	gsl_vector_free(w);
	gsl_vector_free(c);
	gsl_matrix_free(cov);
	return 0;
}

void Temperature (int coolant, double Ri, double Ro, double m_flow, double Tf, double Tamb, double CG, int nt, double R_fouling, double ab, double em, double kp, 
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
	mu = dynamicViscosity(Tf, coolant);       // HTF dynamic viscosity (Pa-s)
	kf = thermalConductivity(Tf, coolant);    // HTF thermal conductivity (W/m-K)
	C = specificHeatCapacityCp(Tf, coolant);  // HTF specific heat capacity (J/kg-K)

	// HTF internal flow variables
	Re = m_flow * d / (area * mu);   // HTF Reynolds number
	Pr = mu * C / kf;                // HTF Prandtl number

	if (coolant == 1){
		Nu = 0.023 * pow(Re, 0.8) * pow(Pr, 0.4);
	}
	else{
		Nu = 5.6 + 0.0165 * pow(Re*Pr, 0.85) * pow(Pr, 0.01);
	}

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

// Fourier temperature
double gn(double rb, double n, double a, double Bi1){
	return pow(rb,n) + pow(a, 2*n)*(n-Bi1)/(n+Bi1)*1/pow(rb,n);
};

double gpn(double rb, double n, double a, double Bi1){
	return n*(pow(rb,n-1) - pow(a,2*n)*(n-Bi1)/(n+Bi1)*1/pow(rb,n+1));
};

void Tinit(double T1, double h1, double R1, double T2, double h2, double R2, double ab, double q0, double k, double r, double t, double tol, double itermax,
	double * T, double * C){
	double Bi1 = h1*R1/k;
	double Bi2 = h2*R2/k;
	double T2b = (T2 - T1)*k/(ab*q0*R2);
	double a = R1/R2;
	double rb = r/R2;
	double Tb;
	double n = 1.;
	int iter = 0;
	double err, Told;
	Tb = (1+pi*Bi2*T2b)/(pi*(Bi1+Bi2*(1-Bi1*log(a))))*(1+Bi1*log(rb/a))
		+0.5/(gpn(1,1,a,Bi1)+Bi2*gn(1,1,a,Bi1))*gn(rb,1,a,Bi1)*cos(t);
	do{
		Told = Tb;
		Tb += 2/pi*(pow(-1, n)*gn(rb,2*n,a,Bi1)*cos(2*n*t))/((1-4*pow(n,2))*(gpn(1,2*n,a,Bi1)+Bi2*gn(1,2*n,a,Bi1)));
		n += 1;
		err = fabs(Tb - Told);
		iter += 1;
	}while(err>tol && iter<itermax);
	C[0] = T1 + (1+pi*Bi2*T2b)/(pi*(Bi1+Bi2*(1-Bi1*log(a))))*(1+Bi1*log(rb/a))*(ab*q0*R2)/k;
	C[1] = 0.5/(gpn(1,1,a,Bi1)+Bi2*gn(1,1,a,Bi1))*gn(rb,1,a,Bi1)*(ab*q0*R2)/k;
	C[2] = 0;
	T[0] = T1 + Tb*(ab*q0*R2)/k;
	return;
}

void Temperature2 (int coolant, double Ri, double Ro, double m_flow, double Tf, double Tamb, double CG, int nt, double R_fouling, double ab, double em, double kp, 
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
	mu = dynamicViscosity(Tf, coolant);       // HTF dynamic viscosity (Pa-s)
	kf = thermalConductivity(Tf, coolant);    // HTF thermal conductivity (W/m-K)
	C = specificHeatCapacityCp(Tf, coolant);  // HTF specific heat capacity (J/kg-K)

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
	double tol = 1e-4;
	int iter = 0;
	int itermax = 10000;
	Tinit(Tf, hf, Ri, Tamb, h_ext, Ro, ab, CG, kp, Ri, 0., tol, itermax, Ti, BDp);
	Tinit(Tf, hf, Ri, Tamb, h_ext, Ro, ab, CG, kp, Ro, 0., tol, itermax, To, BDpp);
	return;
}

