within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function extends density "Return density"
	algorithm
		d := SolarTherm.Media.Sodium.Sodium_Poly_utilities.rho_T(state.T);
		annotation (Inline=true);
	end density;