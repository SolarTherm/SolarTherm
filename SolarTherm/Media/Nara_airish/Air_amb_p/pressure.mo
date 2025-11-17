within SolarTherm.Media.Nara_airish.Air_amb_p;

function extends pressure "Return pressure"
	algorithm
		p := 101325.0;
		annotation (Inline=true);
	end pressure;