within SolarTherm.Models.CSP.CRS.Receivers;
model ReceiverSimple
  extends Interfaces.Models.ReceiverFluid;
  Medium.BaseProperties medium;
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;
  //SI.MassFlowRate m_flow;
  parameter SI.Efficiency ab=1 "Absortance";
  parameter SI.Efficiency em=1 "Emitance";
  parameter SI.Area A=1 "Area";
  parameter SI.Temperature T_0=from_degC(290);

  SI.HeatFlowRate Q_loss;
  Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,84}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,78})));
protected
  Medium.ThermodynamicState state_0=Medium.setState_pTX(medium.p,T_0);
  SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);
equation
  medium.h=(h_in+h_out)/2;
  h_in=inStream(fluid_a.h_outflow);
  fluid_b.h_outflow=max(h_0,h_out);
  fluid_a.h_outflow=0;

  heat.T=medium.T;
  fluid_b.m_flow=-fluid_a.m_flow;
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;

  Q_loss=-A*sigma*em*(medium.T^4-Tamb^4);
  0=ab*heat.Q_flow+Q_loss+fluid_a.m_flow*(h_in-h_out);


end ReceiverSimple;
