within SolarTherm.Media.H2.H2_amb_p_table;

function extends specificInternalEnergy "Return specific internal energy"
	algorithm
		u := state.h - state.p / rho_T(T_h(state.h));
		annotation (Inline=true);
	end specificInternalEnergy;