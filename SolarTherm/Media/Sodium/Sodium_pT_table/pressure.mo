within SolarTherm.Media.Sodium.Sodium_pT_table;

function extends pressure "Return pressure"
	algorithm
		p := state.p;
		annotation (Inline=true);
	end pressure;