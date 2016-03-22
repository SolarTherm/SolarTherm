within SolarTherm.Collectors;
partial block Collector "Solar concentrator"
	import SI = Modelica.SIunits;
	parameter Integer nelem = 1 "Number of aperture elements";
	parameter SI.Area A "Area of collector aperture";
	input SolarTherm.Interfaces.WeatherBus wbus;
	output SI.RadiantPower R_foc[nelem](each min=0) "Radiant power on focal aperture";
end Collector;
