within SolarTherm.Receivers.Energy;
partial block Receiver "Solar receiver with energy interface"
	import SI = Modelica.SIunits;
	parameter SI.Area A "Area of aperture";
	input SolarTherm.Interfaces.WeatherBus wbus;
	// Will typically use alt, azi and dni
	SolarTherm.Interfaces.Energy.Port p;
end Receiver;
