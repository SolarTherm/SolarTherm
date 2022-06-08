within SolarTherm.Models.Storage.Tank;
model BufferTank2
  extends SolarTherm.Interfaces.Models.StorageFluid;
  parameter SI.Diameter D = 18.667 "Diameter";
  parameter SI.Height H = 20 "Height";
  final parameter SI.Volume V_t=(H*pi*D^2)/4;
  parameter Real L_start = 50 "Start value of level in %" annotation (Dialog(group="Initialization"));
  parameter SI.Temperature T_start = from_degC(574) "Start value of temperature" annotation (Dialog(group="Initialization"));
  
  //Variables
  SI.Volume V;
  SI.Mass m;
  Medium.BaseProperties medium;
  SI.Temperature T(start=T_start);
  Medium.ThermodynamicState state_i;
  Real L "Level in %";
  Modelica.Blocks.Interfaces.RealInput p_top annotation (Placement(
        transformation(
        extent={{-16,-16},{16,16}},
        rotation=-90,
        origin={0,108}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=-90,
        origin={45,97})));

initial equation
  medium.h=Medium.specificEnthalpy(state_i);
  m=Medium.density(state_i)*V_t*L_start/100;
  
equation
  p_top = medium.p;
  fluid_a.h_outflow = inStream(fluid_a.h_outflow); // shouldn't flow backwards anyway
  fluid_b.h_outflow = medium.h;
  fluid_b.p = p_top;
  fluid_a.p = p_top;
  state_i = Medium.setState_pTX(p_top, T_start);
  T = Medium.temperature(medium.state);
  der(m) = fluid_a.m_flow + fluid_b.m_flow;
  m*der(medium.h) + der(m)*medium.h = fluid_a.m_flow*inStream(fluid_a.h_outflow) + fluid_b.m_flow*medium.h;
  V=m/medium.d;
  L=100*V/V_t;

annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics = {Text(origin = {0, -140}, lineColor = {0, 0, 255}, extent = {{-120, 20}, {120, -20}}, textString = "%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end BufferTank2;