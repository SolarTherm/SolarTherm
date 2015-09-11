within SolarTherm.Receivers;
partial model Receiver "Solar receiver with fluid interface"
	extends Modelica.Fluid.Interfaces.PartialTwoPort;
	// Contains medium, port_a and port_b and flow reversal switch
	import SI = Modelica.SIunits;

	parameter SI.Area A "Area of aperture";
	input SolarTherm.Interfaces.WeatherBus wbus;
	// Will typically use Tdry, Tdew, wdir, wspd.
	input SI.RadiantPower R "Radiant power on aperture";
end Receiver;
