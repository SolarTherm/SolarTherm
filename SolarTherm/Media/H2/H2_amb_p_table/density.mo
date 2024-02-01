within SolarTherm.Media.H2.H2_amb_p_table;

function extends density "Return density"
	algorithm
		d := rho_T(T_h(state.h));
		annotation (Inline=true);
	end density;