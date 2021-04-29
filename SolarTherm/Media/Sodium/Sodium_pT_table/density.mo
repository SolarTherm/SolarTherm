within SolarTherm.Media.Sodium.Sodium_pT_table;

function extends density "Return density"
	algorithm
		d := rho_T(state.T);
		annotation (Inline=true);
	end density;