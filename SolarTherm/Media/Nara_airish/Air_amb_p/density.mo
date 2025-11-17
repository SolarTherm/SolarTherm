within SolarTherm.Media.Nara_airish.Air_amb_p;

function extends density "Return density"
	algorithm
		d := rho_T(T_h(state.h));
		annotation (Inline=true);
	end density;