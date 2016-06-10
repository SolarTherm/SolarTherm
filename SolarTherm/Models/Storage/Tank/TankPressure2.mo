within SolarTherm.Models.Storage.Tank;
model TankPressure2
  extends Interfaces.Models.StorageFluid;
  SI.Mass m;
  parameter SI.Temperature T_start=from_degC(500);

  //parameter SI.AbsolutePressure p_top=1e5;
  Medium.BaseProperties medium;
  SI.AbsolutePressure p "Pressure";
  SI.Diameter D=18.667 "Diameter";
  SI.Height H=20 "Height";
  //Real L "Level in %";
  parameter Real L_start=70 "Inital level in %";

  Medium.ThermodynamicState state_i=Medium.setState_pTX(1e5,T_start);
  SI.Volume V_t=(H*pi*D^2)/4;
  SI.Volume V;
  SI.AbsolutePressure p_bot;
  Modelica.Blocks.Interfaces.RealInput p_top annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-4,102}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,98})));
  Modelica.Blocks.Interfaces.RealOutput L "Tank level in %" annotation (Placement(transformation(
          extent={{92,34},{112,54}}), iconTransformation(extent={{92,34},{112,54}})));
initial equation
  medium.h=Medium.specificEnthalpy(state_i);
  m=Medium.density(state_i)*V_t*L_start/100;
equation
  p=(p_top+p_bot)/2;
  fluid_a.p=p_top;
  p_bot=medium.d*g_n*H*(L/100)+p_top;
  fluid_b.p=p_bot;
  medium.p=p;
  fluid_a.h_outflow=medium.h;
  fluid_b.h_outflow=medium.h;
  der(m)=fluid_a.m_flow+fluid_b.m_flow;
  m*der(medium.h)+der(m)*medium.h=fluid_a.m_flow*inStream(fluid_a.h_outflow)+fluid_b.m_flow*medium.h;

  V=m/medium.d;
  L=100*V/V_t;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TankPressure2;
