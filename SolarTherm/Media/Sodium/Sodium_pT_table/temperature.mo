within SolarTherm.Media.Sodium.Sodium_pT_table;

function extends temperature "Return temperature"
	algorithm
		//T := T_h(state.h);
		T := state.T;
		annotation (Inline=true);
	end temperature;