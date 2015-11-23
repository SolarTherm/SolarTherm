within SolarTherm.Optics;
partial block Concentrator "Solar concentrator"
	import SI = Modelica.SIunits;
	parameter Integer nelem = 1 "Number of aperture elements";
	parameter SI.Area A_con "Area of concentrator aperture";
	parameter SI.Area A_foc "Area of focal aperture";
	input SolarTherm.Interfaces.WeatherBus wbus;
	// Will typically use alt, azi and dni
	input Boolean track "Set to true to start tracking";
	output SI.RadiantPower R_foc[nelem](each min=0) "Radiant power on focal aperture";
end Concentrator;
