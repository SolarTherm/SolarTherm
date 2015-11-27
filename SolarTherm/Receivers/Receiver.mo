within SolarTherm.Receivers;
partial model Receiver "Solar receiver with fluid interface"
	extends Modelica.Fluid.Interfaces.PartialTwoPort(
		allowFlowReversal=false);
	import SI = Modelica.SIunits;

	parameter Integer nelem = 1 "Number of aperture elements";
	input SolarTherm.Interfaces.WeatherBus wbus;
	// Will typically use Tdry, Tdew, wdir, wspd.
	input SI.RadiantPower R[nelem] "Radiant power on aperture";
end Receiver;
