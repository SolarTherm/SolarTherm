within SolarTherm.Media.Nara_airish.Air_amb_p_curvefit;

function extends specificEnthalpy "Return specific enthalpy"
	algorithm
		h := state.h;
		annotation (Inline=true);
		end specificEnthalpy;