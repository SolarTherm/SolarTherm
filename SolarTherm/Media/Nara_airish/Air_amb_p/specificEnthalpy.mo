within SolarTherm.Media.Nara_airish.Air_amb_p;

function extends specificEnthalpy "Return specific enthalpy"
	algorithm
		h := state.h;
		annotation (Inline=true);
		end specificEnthalpy;