within SolarTherm.Models.CSP.CRS.Receivers;
model ReceiverConstant
  extends Interfaces.Models.ReceiverFluid;
  parameter SI.Efficiency nu_rc=0.6;
  Medium.BaseProperties medium;
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;
  SI.MassFlowRate m_flow;
  SI.HeatFlowRate Q_flow;
equation
  //inputs
  medium.p=fluid_a.p;
  m_flow=fluid_a.m_flow;
  h_in=inStream(fluid_a.h_outflow);

  Q_flow=heat.Q_flow;

  //outputs
  fluid_a.h_outflow=h_out;

  fluid_b.p=medium.p;
  fluid_b.m_flow=-m_flow;
  fluid_b.h_outflow=h_out;

  heat.T=medium.T;

  //equations
  medium.h=(h_in+h_out)/2;
  0=Q_flow-nu_rc*fluid_a.m_flow*(h_out-h_in);

end ReceiverConstant;
