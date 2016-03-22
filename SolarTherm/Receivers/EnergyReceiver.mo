within SolarTherm.Receivers;
partial model EnergyReceiver "Solar receiver with energy interface"
	import SI = Modelica.SIunits;
	parameter Integer nelem = 1 "Number of aperture elements";
	parameter SI.Area A "Area of aperture";
	input SolarTherm.Interfaces.WeatherBus wbus;
	// Will typically use Tdry, Tdew, wdir, wspd.
	input SI.RadiantPower R[nelem] "Radiant power on aperture";
	SolarTherm.Interfaces.EnergyPort p;
end EnergyReceiver;
