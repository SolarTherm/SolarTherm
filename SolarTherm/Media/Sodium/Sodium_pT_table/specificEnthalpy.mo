within SolarTherm.Media.Sodium.Sodium_pT_table;

function extends specificEnthalpy "Return specific enthalpy"
	algorithm
		//h := state.h;
		h := h_T(state.T);
		annotation (Inline=true);
	end specificEnthalpy;