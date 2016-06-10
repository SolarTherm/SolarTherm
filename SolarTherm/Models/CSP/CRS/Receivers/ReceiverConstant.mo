within SolarTherm.Models.CSP.CRS.Receivers;
model ReceiverConstant
  extends Interfaces.Models.ReceiverFluid;
  parameter SI.Efficiency nu_rc=0.6;
  Medium.BaseProperties medium;
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;
  //SI.MassFlowRate m_flow;
equation
  medium.h=(h_in+h_out)/2;
  h_in=inStream(fluid_a.h_outflow);
  h_out=fluid_b.h_outflow;
  h_out=fluid_a.h_outflow;
  heat.T=medium.T;
  fluid_a.m_flow+fluid_b.m_flow=0;
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;

  0=heat.Q_flow-nu_rc*fluid_a.m_flow*(h_out-h_in);

end ReceiverConstant;
