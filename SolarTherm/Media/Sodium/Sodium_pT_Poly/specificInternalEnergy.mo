within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function extends specificInternalEnergy "Return specific internal energy"
	algorithm
		u := SolarTherm.Media.Sodium.Sodium_Poly_utilities.h_T(state.T) - state.p / SolarTherm.Media.Sodium.Sodium_Poly_utilities.rho_T(state.T);
		annotation (Inline=true);
	end specificInternalEnergy;