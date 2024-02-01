within SolarTherm.Media.H2.H2_amb_p_table;

function extends pressure "Return pressure"
	algorithm
		p := 101325.0;
		annotation (Inline=true);
	end pressure;