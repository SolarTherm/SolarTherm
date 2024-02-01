within SolarTherm.Media.H2.H2_amb_p_table;

function extends specificEnthalpy "Return specific enthalpy"
	algorithm
		h := state.h;
		annotation (Inline=true);
		end specificEnthalpy;