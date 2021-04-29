within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function extends specificEnthalpy "Return specific enthalpy"
	algorithm
		//h := state.h;
		h := SolarTherm.Media.Sodium.Sodium_Poly_utilities.h_T(state.T);
		annotation (Inline=true);
	end specificEnthalpy;