within SolarTherm.Models.Fluid.HeatExchangers;

model test_HX
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  
  //Parameters
  parameter SI.MassFlowRate m_flow_Na_des=212;
  parameter SI.MassFlowRate m_flow_Na_min=212*0.25;
  parameter SI.MassFlowRate m_flow_Na_max=212*1.1;
  
  //Variables
  SI.MassFlowRate m_flow_Na(min = 0, start = 200);
  
  //Components
  SolarTherm.Models.Fluid.HeatExchangers.HX_wports hX_wports1 annotation(
    Placement(visible = true, transformation(origin = {1.77636e-15, 6}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T Na_inlet(replaceable package Medium = Medium1, T = 740 + 273.15, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-58, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T MS_inlet(replaceable package Medium = Medium2, T = 500 + 273.15, nPorts = 1, use_T_in = false, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-6, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink fluidSink1(replaceable package Medium = Medium1) annotation(
    Placement(visible = true, transformation(origin = {60, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink fluidSink2(replaceable package Medium = Medium2) annotation(
    Placement(visible = true, transformation(origin = {16, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  m_flow_Na=((m_flow_Na_min-m_flow_Na_max)*time)+m_flow_Na_max; //Sweep Parameter
  Na_inlet.m_flow_in = m_flow_Na;
  connect(hX_wports1.port_b_out, fluidSink2.port_a) annotation(
    Line(points = {{-6, 16}, {6, 16}, {6, 54}, {6, 54}}, color = {0, 127, 255}));
  connect(hX_wports1.port_a_out, fluidSink1.port_a) annotation(
    Line(points = {{14, 4}, {50, 4}, {50, 6}}, color = {0, 127, 255}));
  connect(MS_inlet.ports[1], hX_wports1.port_b_in) annotation(
    Line(points = {{4, -32}, {6, -32}, {6, 0}, {6, 0}}, color = {0, 127, 255}));
  connect(Na_inlet.ports[1], hX_wports1.port_a_in) annotation(
    Line(points = {{-48, 12}, {-14, 12}, {-14, 12}, {-14, 12}}, color = {0, 127, 255}));
end test_HX;
