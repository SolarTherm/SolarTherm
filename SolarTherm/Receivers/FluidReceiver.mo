within SolarTherm.Receivers;
partial model FluidReceiver "Solar receiver with fluid interface"
	extends Modelica.Fluid.Interfaces.PartialTwoPort(
		allowFlowReversal=false);
	import SI = Modelica.SIunits;

	parameter Integer nelem = 1 "Number of aperture elements";
	input SolarTherm.Interfaces.WeatherBus wbus;
	input SI.RadiantPower R[nelem] "Radiant power on aperture";
end FluidReceiver;
