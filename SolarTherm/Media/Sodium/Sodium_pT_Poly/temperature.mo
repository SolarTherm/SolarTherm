within SolarTherm.Media.Sodium.Sodium_pT_Poly;

function extends temperature "Return temperature"
	algorithm
		//T := T_h(state.h);
		T := state.T;
		annotation (Inline=true);
	end temperature;