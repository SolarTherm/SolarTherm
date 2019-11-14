within SolarTherm.Models.Fluid.HeatExchangers;

model test_HX_2
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  //Parameters
  parameter SI.MassFlowRate m_flow_Na_des = 666;
  parameter SI.MassFlowRate m_flow_Na_min = m_flow_Na_des * 0.25;
  parameter SI.MassFlowRate m_flow_Na_max = m_flow_Na_des * 1.1;
  parameter SI.Temperature T_MS1_des = 500 + 273.15;
  parameter SI.Temperature T_Na1_des = 740 + 273.15;
  //Variables
  SI.MassFlowRate m_flow_Na(min = 0, start = 200);
  SI.Temperature T_Na1(start = 700 + 273.15, nominal = 700 + 273.15);
  SI.Temperature T_MS1(start = 500 + 273.15, nominal = 500 + 273.15);
  //Components
  SolarTherm.Models.Fluid.HeatExchangers.HX_2 HX_shell_tube_2 annotation(
    Placement(visible = true, transformation(origin = {4, -4}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T Na_inlet(replaceable package Medium = Medium1, T(start = 900, nominal = 900), nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-66, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T MS_inlet(replaceable package Medium = Medium2, T(start = 700, nominal = 700), nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-32, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink Na_Sink(replaceable package Medium = Medium1) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink MS_Sink(replaceable package Medium = Medium2) annotation(
    Placement(visible = true, transformation(origin = {30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Sweep Parameter
  m_flow_Na = (m_flow_Na_min - m_flow_Na_max) * time + m_flow_Na_max;
  Na_inlet.m_flow_in = m_flow_Na;
//Sodium Inlet Temperature
  //T_Na1 = T_Na1_des;
  T_Na1=T_Na1_des+5*sin(time*2*CN.pi);
  Na_inlet.T_in = T_Na1;
//Molten Salt Inlet Temperature
  T_MS1 = T_MS1_des;
  MS_inlet.T_in = T_MS1;
  connect(MS_inlet.ports[1], HX_shell_tube_2.port_b_in) annotation(
    Line(points = {{-22, -50}, {15, -50}, {15, -15}}, color = {0, 127, 255}));
  connect(HX_shell_tube_2.port_b_out, MS_Sink.port_a) annotation(
    Line(points = {{-8, 14}, {-8, 37}, {20, 37}, {20, 50}}, color = {0, 127, 255}));
  connect(Na_inlet.ports[1], HX_shell_tube_2.port_a_in) annotation(
    Line(points = {{-56, 0}, {-41.5, 0}, {-41.5, 6}, {-21, 6}}, color = {0, 127, 255}));
  connect(HX_shell_tube_2.port_a_out, Na_Sink.port_a) annotation(
    Line(points = {{29, -6}, {60, -6}, {60, 0}}, color = {0, 127, 255}));
end test_HX_2;
