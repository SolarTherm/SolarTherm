within SolarTherm.Media.H2.H2_amb_p_table;

function extends temperature "Return temperature"
	algorithm
		T := T_h(state.h);
		annotation (Inline=true);
	end temperature;