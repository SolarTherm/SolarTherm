within SolarTherm.PowerBlocks;
partial model FluidPB "Power block partial model"
 extends Modelica.Fluid.Interfaces.PartialTwoPort(
  allowFlowReversal=false);
 extends SolarTherm.PowerBlocks.PowerBlock;
 import SI = Modelica.SIunits;
equation
 port_a.m_flow + port_b.m_flow = 0;

 port_b.Xi_outflow = inStream(port_a.Xi_outflow);
 port_a.Xi_outflow = inStream(port_b.Xi_outflow);

 port_b.C_outflow = inStream(port_a.C_outflow);
 port_a.C_outflow = inStream(port_b.C_outflow);
end FluidPB;
