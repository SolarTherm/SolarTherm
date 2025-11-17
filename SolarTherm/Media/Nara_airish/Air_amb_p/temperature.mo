within SolarTherm.Media.Nara_airish.Air_amb_p;

function extends temperature "Return temperature"
	algorithm
		T := T_h(state.h);
		annotation (Inline=true);
	end temperature;