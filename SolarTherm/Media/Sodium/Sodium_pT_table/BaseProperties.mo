within SolarTherm.Media.Sodium.Sodium_pT_table;

model extends BaseProperties(final standardOrderComponents=true)
		"Base properties of medium"

 equation
	T = state.T;
	p = state.p;
	d = rho_T(T);
	h = h_T(T);
	u = h - p / d;
	MM = 0.02298977;
	R = 8.3144 / MM;
	//T = T_h(h);
	//h = state.h;

	end BaseProperties;