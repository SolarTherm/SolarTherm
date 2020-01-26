within SolarTherm.Models.Storage.Tank;
model BufferTank
  extends SolarTherm.Interfaces.Models.StorageFluid;
  //replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
//  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium, m_flow(min=0)) annotation (
//  Placement(visible = true,transformation(extent={{-110, -10}, {-90, 10}},  rotation=0), iconTransformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0)));
//  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium=Medium, m_flow(max=0)) annotation (
//  Placement(visible = true,transformation(extent={{88, -10}, {110, 10}},  rotation=0), iconTransformation(extent = {{110, -10}, {90, 10}}, rotation = 0)));

  parameter SI.Diameter D=1 "Diameter";
  parameter SI.Height H=1 "Height";
  parameter SI.Volume V_t=(H*pi*D^2)/4;
  parameter Real L_start=50 "Start value of level in %" annotation (Dialog(group="Initialization"));
  parameter SI.Temperature T_start=from_degC(560) "Start value of temperature" annotation (Dialog(group="Initialization"));
  
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
  p_top=medium.p;
  fluid_a.h_outflow = medium.h; // shouldn't flow backwards anyway
  fluid_b.h_outflow=medium.h;
  fluid_b.p=medium.p;
  fluid_a.p=medium.p;
  state_i=Medium.setState_pTX(medium.p,T_start);
  T=Medium.temperature(medium.state);
  der(m)=fluid_a.m_flow+fluid_b.m_flow;
  m*der(medium.h)+der(m)*medium.h=fluid_a.m_flow*inStream(fluid_a.h_outflow)+fluid_b.m_flow*medium.h;
  V=m/medium.d;
  L=100*V/V_t;

end BufferTank;
