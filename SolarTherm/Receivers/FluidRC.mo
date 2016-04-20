within SolarTherm.Receivers;
partial model FluidRC "Solar receiver with fluid interface"
 extends Modelica.Fluid.Interfaces.PartialTwoPort(
  allowFlowReversal=false);
 extends SolarTherm.Receivers.Receiver;
 import SI = Modelica.SIunits;
end FluidRC;
