within SolarTherm.Receivers;
model HeatedFluid "Section of fluid that is heated"
 extends Modelica.Fluid.Interfaces.PartialTwoPort(
  allowFlowReversal=false);
 import SI = Modelica.SIunits;

 replaceable model FlowModel = SolarTherm.Fluid.Flows.LosslessFlow
  constrainedby SolarTherm.Fluid.Flows.Flow;

 input SI.HeatFlowRate Q_flow "Fluid heat gain";

 Medium.BaseProperties mprop_a;
 Medium.BaseProperties mprop_b;
protected
 FlowModel flowmod;
equation
 mprop_a.p = port_a.p;
 mprop_a.h = inStream(port_a.h_outflow);
 port_a.h_outflow = inStream(port_b.h_outflow); // shouldn't flow back

 mprop_b.p = port_b.p;
 mprop_b.h = port_b.h_outflow;

 port_a.m_flow + port_b.m_flow = 0;

 flowmod.m_flow = port_a.m_flow;
 flowmod.d_avg = mprop_a.d; // set it equal to inlet density
 port_b.p - port_a.p = flowmod.dp;

 Q_flow = port_a.m_flow*(port_b.h_outflow - inStream(port_a.h_outflow));
end HeatedFluid;
