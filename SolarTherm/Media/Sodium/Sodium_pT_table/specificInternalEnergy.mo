within SolarTherm.Media.Sodium.Sodium_pT_table;

function extends specificInternalEnergy "Return specific internal energy"
	algorithm
		u := h_T(state.T) - state.p / rho_T(state.T);
		annotation (Inline=true);
	end specificInternalEnergy;