#include "stress/stress.h"
#include "stress/stress.c"

void stress(
	int coolant,
	double Ri,
	double Ro,
	double dz,
	double m_flow,
	double T_htf_in,
	double Tamb,
	double * CG,
	int nt,
	int nz,
	double R_fouling,
	double ab,
	double em,
	double kp,
	double h_ext,
	double alpha,
	double E,
	double nu,
	double * Tcrown_o,
	double * T_fluid,
	double * stress
	)
	{

	double BDp[3], BDpp[3], Ti[nt], To[nt], Tf[nz+1];
	double Tcrown_i[nz];
	double theta = 0.;
	double C;

	// Mechanical params
	double l = E*nu/((1+nu)*(1-2*nu));
	double m = 0.5*E/(1+nu);

	// Variables
	int k;
	double Q;
	double stress_sec[5];
	double strain_sec[1];

	// GSL matrix inverse
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

	Tf[0] = T_htf_in;
	for(k=1; k<=nz; k++){
		Temperature (coolant, Ri, Ro, m_flow, Tf[k-1], Tamb, CG[k-1], nt, R_fouling, ab, em, kp, h_ext, BDp, BDpp, Ti, To);
		C = specificHeatCapacityCp(Tf[k-1], coolant);
		Q = 2*pi*kp*dz*(BDpp[0] - BDp[0])/log(Ro/Ri);
		Tf[k] = Tf[k-1] + Q/m_flow/C;
		T_fluid[k-1] = Tf[k];
		Tcrown_i[k-1] = Ti[0];
		Tcrown_o[k-1] = To[0];
		Thermoelastic(To[0], Ro, theta, Ro, Ri, alpha, E, nu, BDp, BDpp, invprop, stress_sec, strain_sec);
		stress[k-1] = stress_sec[4]/1e6;
	}

	return;
}

void stress2(
	int coolant,
	double Ri,
	double Ro,
	double dz,
	double m_flow,
	double T_htf_in,
	double Tamb,
	double * CG,
	int nt,
	int nz,
	double R_fouling,
	double ab,
	double em,
	double kp,
	double h_ext,
	double alpha,
	double E,
	double nu,
	double * Tcrown_o,
	double * T_fluid,
	double * stress
	)
	{

	double BDp[3], BDpp[3], Ti[1], To[1], Tf[nz+1];
	double Tcrown_i[nz];
	double theta = 0.;
	double C;

	// Mechanical params
	double l = E*nu/((1+nu)*(1-2*nu));
	double m = 0.5*E/(1+nu);

	// Variables
	int k;
	double Q;
	double stress_sec[5];
	double strain_sec[1];

	// GSL matrix inverse
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

	Tf[0] = T_htf_in;
	for(k=1; k<=nz; k++){
		Temperature2 (coolant, Ri, Ro, m_flow, Tf[k-1], Tamb, CG[k-1], nt, R_fouling, ab, em, kp, h_ext, BDp, BDpp, Ti, To);
		C = specificHeatCapacityCp(Tf[k-1], coolant);
		Q = 2*pi*kp*dz*(BDpp[0] - BDp[0])/log(Ro/Ri);
		Tf[k] = Tf[k-1] + Q/m_flow/C;
		T_fluid[k-1] = Tf[k];
		Tcrown_i[k-1] = Ti[0];
		Tcrown_o[k-1] = To[0];
		Thermoelastic(To[0], Ro, theta, Ro, Ri, alpha, E, nu, BDp, BDpp, invprop, stress_sec, strain_sec);
		stress[k-1] = stress_sec[4]/1e6;
	}

	return;
}
