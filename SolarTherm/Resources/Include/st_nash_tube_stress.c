#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include <string.h>
#include <gsl/gsl_matrix_double.h>
#include <gsl/gsl_blas.h>
#include <gsl/gsl_linalg.h>
#define pi 3.141592653589793
#define g_n 9.81
#define sigma 5.670374419e-8

double g(double r, double n, double a, double Bi){
	double gn;
	gn = pow(r,n) + pow(a, 2*n) * (n - Bi) / (n + Bi) * 1/pow(r,n);
	return gn;
};

double gp(double r, double n, double a, double Bi){
	double gpn;
	gpn = n * (pow(r, n-1) - pow(a, 2*n) * (n - Bi) / (n + Bi) * 1/pow(r, n+1));
	return gpn;
};

double dynamicViscosity(double T){
	double eta;
	eta = exp(-6.4406 - 0.3958 * log(T) + 556.835 / T); // Dynamic viscosity of liquid sodium as a function of temperature
	return eta;
};

double thermalConductivity(double T){
	double k;
	k = 124.67 - 0.11381 * T + 5.5226e-5 * pow(T,2) - 1.1842e-8 * pow(T,3); // Thermal conductivity of liquid sodium as a function of temperature
	return k;
};

double specificHeatCapacityCp(double T){
	double C;
	C = 1000 * (1.6582 - 8.4790e-4 * T + 4.4541e-7 * pow(T,2) - 2992.6 * pow(T,-2)); // Specific heat capacity of liquid sodium as a function of temperature
	return C;
};


double CoefficientOfThermalExpansion_740H(double x) {
	double terms[] = {
		2.9282018923562061e-004,
		-3.9222870772359022e-006,
		2.2527926096734661e-008,
		-6.9655535727519161e-011,
		1.2604995996397333e-013,
		-1.3322889154367677e-016,
		7.3545948617143154e-020,
		-1.0256407833688800e-023,
		-8.3405270257880875e-027,
		3.0053751429700429e-030
};
	size_t csz = sizeof terms / sizeof *terms;
	double t = 1;
	double r = 0;
	for (int i = 0; i < csz;i++) {
		r += terms[i] * t;
		t *= x;
	}
	return r;
}

double YoungModulus_740H(double x) {
	double terms[] = {
		2.3214214803678214e+005,
		-2.9232998572078650e+001,
		-2.7438886318694695e-002
};
	size_t csz = sizeof terms / sizeof *terms;
	double t = 1;
	double r = 0;
	for (int i = 0; i < csz;i++) {
		r += terms[i] * t;
		t *= x;
	}
	r *= 1e6;
	return r;
}

double thermalConductivity_740H(double x) {
	double terms[] = {
		6.9705539053005342e-003,
		1.1209070285509342e-005,
		2.5800834469559111e-009
};
	size_t csz = sizeof terms / sizeof *terms;
	double t = 1;
	double r = 0;
	for (int i = 0; i < csz;i++) {
		r += terms[i] * t;
		t *= x;
	}
	r *= 1000;
	return r;
}

double TpromFourier(double Ro, double Ri, double Bi, double qrad, double Tamb, double Tf, double ab, double em, double k, double h_ext, double q, double* A0){
	double Tprom;

	A0[0] = -((-ab * q * Ro) + pi * qrad * Ro - h_ext * pi * Ro * Tamb - Bi * k * pi * Tf + ab * Bi * q * Ro * log(Ri) - Bi * pi * qrad * Ro * log(Ri) + Bi * h_ext * pi * Ro * Tamb * log(Ri) - Bi * h_ext * pi * Ro * Tf * log(Ro)) / (pi * (Bi * k + h_ext * Ro - Bi * h_ext * Ro * log(Ri) + Bi * h_ext * Ro * log(Ro)));
	A0[1] = Bi * (A0[0] - Tf) / (1 - Bi * log(Ri));

	if(Bi > 0){
		Tprom = A0[0] + A0[1] * log(Ro);
	}
	else{
		Tprom = Tf;
	}
	return Tprom;
};

void Thermoelastic(double Ro, double Ri, double Bi, double qrad, double Tamb, double Tf, double ab, double em, double k, double h_ext, double q, double lambda, double E, double poisson, double* Ts, gsl_matrix* invprop, double* stress_eq, double* strain_eq, bool verbose){
	int j;
	int N = 2;
	double gn[N], gpn[N], An[N], K_r, K_theta, T_theta;
	gsl_matrix *Stress = gsl_matrix_alloc(3, 1);
	gsl_matrix *Strain = gsl_matrix_alloc(3, 1);

	for(j=1; j<=N; j++){
		gn[j] = g(Ro, (double)(j), Ri, Bi);
		gpn[j] = gp(Ro, (double)(j), Ri, Bi);
	}

	double A0 = -((-ab * q * Ro) + pi * qrad * Ro - h_ext * pi * Ro * Tamb - Bi * k * pi * Tf + ab * Bi * q * Ro * log(Ri) - Bi * pi * qrad * Ro * log(Ri) + Bi * h_ext * pi * Ro * Tamb * log(Ri) - Bi * h_ext * pi * Ro * Tf * log(Ro)) / (pi * (Bi * k + h_ext * Ro - Bi * h_ext * Ro * log(Ri) + Bi * h_ext * Ro * log(Ro)));
	double B0 = Bi * (A0 - Tf) / (1 - Bi * log(Ri));

	An[1] = ab * q / (2 * (h_ext * gn[1] + k * gpn[1]));
	An[2] = 2 * ab * q / (3 * pi * (h_ext * gn[2] + k * gpn[2]));

	Ts[0] = A0 + B0 * log(Ro) + An[1] * gn[1] + An[2] * gn[2];
	
	K_r = (0.5 * An[1] * gn[1] + 0.5 * An[1] * g(Ri, 1, Ri, Bi)) / log(Ro / Ri);
	K_theta = An[1] * pow(Ri,2) * (1 - Bi) / (1 + Bi) * Ro / (pow(Ri,2) + pow(Ro,2));
	T_theta = An[1] * gn[1] + An[2] * gn[2];

	gsl_matrix_set(Stress, 0, 0, 0);
	gsl_matrix_set(Stress, 1, 0, lambda * E / (2 * (1 - poisson)) * (K_r * (1 - 2 * pow(Ri,2) / (pow(Ro,2) - pow(Ri,2)) * log(Ro / Ri)) + K_theta * (2 - 2 * pow(Ri,2) / pow(Ro,2))));
	gsl_matrix_set(Stress, 2, 0, poisson * (lambda * E / (2 * (1 - poisson)) * (K_r * (1 - 2 * pow(Ri,2) / (pow(Ro,2) - pow(Ri,2)) * log(Ro / Ri)) + K_theta * (2 - 2 * pow(Ri,2) / pow(Ro,2)))) + lambda * E * T_theta);
	gsl_blas_dgemm (CblasNoTrans, CblasNoTrans, 1.0, invprop, Stress, 0.0, Strain);

	stress_eq[0] = pow((pow(gsl_matrix_get(Stress,0,0) - gsl_matrix_get(Stress,1,0),2) + pow(gsl_matrix_get(Stress,0,0) - gsl_matrix_get(Stress,2,0),2) + pow(gsl_matrix_get(Stress,2,0) - gsl_matrix_get(Stress,1,0),2))/2,0.5);

	strain_eq[0] = pow(2,0.5)/(2*(1+poisson))*pow(pow(gsl_matrix_get(Strain,0,0) - gsl_matrix_get(Strain,1,0),2) + pow(gsl_matrix_get(Strain,0,0) - gsl_matrix_get(Strain,2,0),2) + pow(gsl_matrix_get(Strain,2,0) - gsl_matrix_get(Strain,1,0),2),0.5);

	if(verbose){
		printf("-------------\n");
		printf("Stress (MPa): [%4.2f,%4.2f,%4.2f]\n",gsl_matrix_get(Stress,0,0)/1e6,gsl_matrix_get(Stress,1,0)/1e6,gsl_matrix_get(Stress,2,0)/1e6);
		printf("-------------\n");
		printf("Strain   (%%): [%4.3f,%4.3f,%4.3f]\n",gsl_matrix_get(Strain,0,0)*100,gsl_matrix_get(Strain,1,0)*100,gsl_matrix_get(Strain,2,0)*100);
		printf("-------------\n");
		printf("Equiv. stress (MPa): %4.2f\n",stress_eq[0]/1e6);
		printf("Equiv. strain   (%%): %4.3f\n",strain_eq[0]*100);
	}
	
	return;
};

void damage_crown(double m_flow, double Ri, double Ro, double Tf, double Tamb, const double* q0, int Nz, double* Tcrown, double* t_rupture, double* n_failure, double* stress_vm, double* strain_vm, bool verbose) {

	// Flow and thermal variables
	double h_ext;                       // External heat transfer coefficient due to forced and natural convection (W/m2-K)
	double f;                           // Darcy friction factor
	double Nu;                          // Nusselt number due to internal forced convection
	double Nu_fc;                       // Nusselt number due to external forced convection
	double h_fc;                        // Heat transfer coefficient due to external forced convection (W/m2-K)
	double Tprom;                       // Average tube external wall temperature (K)
	double Gr_H;                        // Grashof number for external natural convection
	double Nu_nc;                       // Nusselt number due to external natural convection
	double h_nc;                        // Heat transfer coefficient due to external natural convection(W/m2-K)
	double kp;                          // Thermal conductivity of tube metal (W/m-K)
	double q_emi;                       // External emission losses (W)
	double Tprom_prev;                  // Average tube external wall temperature at previous iteration (K)
	double A0[2];                       // Fourier coefficient

	// Damage variables
	double tr;                          // Time to rupture (h)
	double LMP;                         // Larson-Miller parameter
	double log10tr;                     // LOG10 of time to rupture
	double Nf;                          // Number of cycles to failure

	// Receiver geometry
	double D_rcv = 14;                  // Receiver diameter (m)
	double H_rcv = 14.5;                // Receiver height (m)

	// Internal flow parameters
	double Re2 = 4000;                  // Turbulent flow limit
	double R_fouling = 8.808e-5;        // Fouling resistance

	// Coating properties
	double ab = 0.98;                   // Coating absorptivity
	double em = 0.91;                   // Coating emissivity

	// Atmospheric air thermo-physical properties
	double cp_a = 1006;                 // Specific heat capacity of atmospheric air (J/kg-K)
	double k_a = 0.026;                 // Thermal conductivity of atmospheric air (W/m-K)
	double rho_a = 1.184;               // Density of atmospheric air (kg/m3)
	double mu_a = 1.845e-5;             // Dynamic viscosity of atmospheric air (Pa-s)
	double beta_a = 0.003363;           // Linear coefficient of thermal expansion for atmospheric air (1/K)
	double v_wind = 4.87;               // Design wind velocity (m/s)
	double Tsky = 303.15;               // Temperature of the sky (K)
	double em_sky = 0.895;              // Emmisivity of the sky
	double em_gr = 0.955;               // Emissivity of the ground

	// Mechanical properties for tube metal
	double lambda;                      // Linear coefficient of thermal expansion for tube metal (1/K)
	double E;                           // Young's Modulus of elasticity (Pa)
	double poisson = 0.31;              // Poisson ratio

	// Tube section diameter and area
	double d = 2*Ri;                    // Tube inner diameter (m)
	double area = 0.25 * pi * pow(d,2); // Tube flow area (m2)

	// HTF thermo-physical properties
	double mu = dynamicViscosity(Tf);     // HTF dynamic viscosity (Pa-s)
	double kf = thermalConductivity(Tf);  // HTF thermal conductivity (W/m-K)
	double C = specificHeatCapacityCp(Tf);// HTF specific heat capacity (J/kg-K)

	// HTF internal flow variables
	double Re = m_flow / (area * mu);     // HTF Reynolds number
	double Pr = mu * C / kf;              // HTF Prandtl number

	double hf;                                                                               // Heat transfer coefficient due to internal forced-convection
	double Bi;                                                                               // Biot number at tube inner surface

	double Pr_a = cp_a * mu_a / k_a;                                                         // Prandtl number for atmospheric air
	double nu_a = mu_a / rho_a;                                                              // Kinematic viscosity for atmospheric air
	double Ta = pow((em_sky * pow(Tsky,4) + em_gr * pow(Tamb,4)) / (em_gr + em_sky),0.25);   // Average sky-air temperature (K)

	double Re_a = rho_a * v_wind * D_rcv / mu_a;                                             // Reynolds number for external flow

	if(v_wind > 0){
		// Forced and natural convection
		Nu_fc = 0.3 + 0.62 * pow(Re_a,0.5) * pow(Pr_a,0.33) / pow(1 + pow(0.4 / Pr_a, 2/3),1/4) * pow(1 + pow(Re_a / 282000, 5/8), 4/5);
		h_fc = Nu_fc * k_a / D_rcv;
	}
	else{
		// Natural convection only
		Nu_fc = 0;
		h_fc = 0;
	}

	double residual;                                        // Residual for iteration of average tube external wall temperature
	double tol = 1e-1;                                      // Tolerance for iteration of average tube external wall temperature
	int it_max = 100;                                       // Maximum allowed iterations for average tube external wall temperature
	int i;                                                  // Iteration counter
	double dz = 2*H_rcv/((double)(Nz));                     // Tube section height (m)
	double Tfj = Tf;                                        // HTF temperature of section j
	double Stress_eq[1];                                    // Thermo-elastic stress at tube crown
	double Strain_eq[1];                                    // Strain at tube crown
	double Ts[1];                                           // Temperature at tube crown

	// Lame and shear modulus
	double l;                                               // Lame modulus
	double m;                                               // Shear modulus

	// Larson-Miller parameters for creep life (740H)
	double C_lm = 18.520243321642944;
	double a[3] = {-2333.22776603, 5099.88095659, 23399.79024925};
	double dt = 0.017;
	
	// Larson-Miller parameters for fatigue life (740H)
	double T_f1 = 973;
	double T_f2 = 1123.15;
	double a_f1[3] = {-1.675084965947688964, -13.36549425105300593, -15.91458437096616763};
	double a_f2[3] = {-0.9799638105989135761, -9.130930944943729699, -10.95030455398071645};
	double e_cut_off1 = 2e-3;
	double e_cut_off2 = 1e-3;

	// Computation of damage for each section
	int j;
	for(j=0; j<Nz; j++){

		Tprom = Tfj;
		// HTF thermo-physical properties
		mu = dynamicViscosity(Tfj);                         // HTF dynamic viscosity (Pa-s)
		kf = thermalConductivity(Tfj);                      // HTF thermal conductivity (W/m-K)
		C = specificHeatCapacityCp(Tfj);                    // HTF specific heat capacity (J/kg-K)

		// HTF internal flow variables
		Re = m_flow / (area * mu);     // HTF Reynolds number
		Pr = mu * C / kf;              // HTF Prandtl number

		if(Re > Re2){
		// Turbulent flow
			f = pow(0.790 * log10(Re) - 1.640,-2);
			Nu = f / 8 * (Re - 1000) * Pr / (1 + 12.7 * sqrt(f / 8) * (pow(Pr,0.66) - 1));
		}
		else if(Re > 10){
			// Laminar flow
			f = 64/Re;
			Nu = f / 8 * (Re - 1000) * Pr / (1 + 12.7 * sqrt(f / 8) * (pow(Pr,0.66) - 1));
		}
		else{
			// No flow
			f = 0;
			Nu = 0;
		}
		hf = Nu * kf / d / (1 + Nu * kf / d * R_fouling);
		i = 0;
		residual = 1e6;

		// Iteration of average external wall temperature
		while(residual > tol && i < it_max){
			Gr_H = g_n * beta_a * (Tprom - Tamb) * H_rcv / pow(nu_a,2);
			Nu_nc = 0.098 * pi / 2 * pow(Gr_H, 1/3) * pow(Tprom / Tamb, -0.14);
			kp = thermalConductivity_740H(Tprom);
			h_nc = Nu_nc * k_a / H_rcv;

			if(v_wind > 0){
				// External forced and natural convection
				h_ext = pow(pow(h_nc,3.2) + pow(h_fc,3.2), 1 / 3.2);
			}
			else{
				// External natural convection
				h_ext = h_nc;
			}
			q_emi = em * sigma * (pow(Tprom,4) - pow(Ta,4));
			Bi = hf * Ri / kp;
			
			Tprom_prev = Tprom;
			Tprom = TpromFourier(Ro, Ri, Bi, q_emi, Tamb, Tfj, ab, em, kp, h_ext, q0[j], A0);
			residual = fabs(Tprom_prev - Tprom);
			i = i + 1;
		}

		// Updating HTF temperature next section
		Tfj = Tfj + 2 * pi * kp * A0[1] * dz/m_flow/C;
		// Computation of thermo-elastic stress
		lambda = CoefficientOfThermalExpansion_740H(Tprom);
		E = YoungModulus_740H(Tprom);
		l = E*poisson/((1+poisson)*(1-2*poisson));
		m = 0.5*E/(1+poisson);
		gsl_matrix *props = gsl_matrix_alloc(3, 3);         // Elasticity tensor
		gsl_matrix *invprop = gsl_matrix_alloc(3, 3);       // Inverse of elasticity tensor
		int row;
		int col;
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
		Thermoelastic(Ro, Ri, Bi, q_emi, Tamb, Tfj, ab, em, kp, h_ext, q0[j], lambda, E, poisson, Ts, invprop, Stress_eq, Strain_eq, verbose);

		// Time to rupture
		if(Stress_eq[0] > 0){
			LMP = a[0]*pow(log10(Stress_eq[0]/1e6),2) + a[1]*log10(Stress_eq[0]/1e6) + a[2];
			log10tr = LMP/Ts[0] - C_lm;
			tr = fmin(pow(10,log10tr),3e5);
		}
		else{
			LMP = 0;
			log10tr = 0;
			tr = 3e5;
		}

		// Cycles to failure
		if (Ts[0] <= T_f1)
		{
			if (Strain_eq[0] < e_cut_off1)
			{
				LMP = a_f1[0]*pow(log10(e_cut_off1),2) + a_f1[1]*log10(e_cut_off1) + a_f1[2];
			}
			else
			{
				LMP = a_f1[0]*pow(log10(Strain_eq[0]),2) + a_f1[1]*log10(Strain_eq[0]) + a_f1[2];
			}
			Nf = pow(10,LMP);
		}
		else if (Ts[0] <= T_f2 && Ts[0] > T_f1)
		{
			if (Strain_eq[0] < e_cut_off2)
			{
				LMP = a_f2[0]*pow(log10(e_cut_off2),2) + a_f2[1]*log10(e_cut_off2) + a_f2[2];
			}
			else
			{
				LMP = a_f2[0]*pow(log10(Strain_eq[0]),2) + a_f2[1]*log10(Strain_eq[0]) + a_f2[2];
			}
			Nf = pow(10,LMP);
		}
		else
		{
			Nf = 1;
		}

		Tcrown[j] = Tfj;
		stress_vm[j] = Stress_eq[0];
		strain_vm[j] = Strain_eq[0];
		t_rupture[j] = tr;
		n_failure[j] = Nf;
	}
	return;
}
