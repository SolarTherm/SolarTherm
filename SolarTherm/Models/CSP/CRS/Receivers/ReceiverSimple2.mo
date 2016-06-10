within SolarTherm.Models.CSP.CRS.Receivers;
model ReceiverSimple2
  extends Interfaces.Models.ReceiverFluid;
  Medium.BaseProperties medium;
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;
  //SI.MassFlowRate m_flow;
  parameter SI.Efficiency ab=1 "Absortance";
  parameter SI.Efficiency em=1 "Emitance";
  parameter SI.Area A=1 "Area";
  Real on;
  SI.HeatFlowRate Q_loss;
  Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,84}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,78})));
equation
  medium.h=(h_in+h_out)/2;
  h_in=inStream(fluid_a.h_outflow);
  h_out=fluid_b.h_outflow;
  fluid_a.h_outflow=0;

  heat.T=medium.T;
  fluid_b.m_flow=-fluid_a.m_flow;
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;

  Q_loss=-A*sigma*em*(medium.T^4-Tamb^4);
  //0=ab*heat.Q_flow+Q_loss+fluid_a.m_flow*(h_in-h_out);
  0=on*ab*heat.Q_flow+Q_loss+fluid_a.m_flow*(h_in-h_out);
  on=noEvent(sign(fluid_a.m_flow));
end ReceiverSimple2;
