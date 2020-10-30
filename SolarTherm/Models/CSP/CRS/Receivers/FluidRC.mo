within SolarTherm.Models.CSP.CRS.Receivers;
partial model FluidRC "Solar receiver with fluid interface"
	import SI = Modelica.SIunits;
	extends SolarTherm.Models.CSP.CRS.Receivers.Receiver;
	extends Modelica.Fluid.Interfaces.PartialTwoPort(
		allowFlowReversal=false);
end FluidRC;
