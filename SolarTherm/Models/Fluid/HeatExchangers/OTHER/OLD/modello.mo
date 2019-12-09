within SolarTherm.Models.Fluid.HeatExchangers;

model modello
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  SI.MassFlowRate m_flow(start = 5);
  SolarTherm.Models.Fluid.HeatExchangers.HX_wports hX_wports1 annotation(
    Placement(visible = true, transformation(origin = {1.77636e-15, 6}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T Na_inlet(replaceable package Medium = Medium1, T = 740 + 273.15, m_flow = 100, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {-58, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T MS_inlet(replaceable package Medium = Medium2, T = 500 + 273.15, nPorts = 1, use_T_in = false, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-6, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT MS_outlet(replaceable package Medium = Medium2, T = 720 + 273.15, nPorts = 1, p = 101325, use_C_in = false, use_T_in = false, use_X_in = false, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {-22, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Na_outlet(replaceable package Medium = Medium1, nPorts = 1, p = 101325, use_C_in = false, use_T_in = false, use_X_in = false, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {54, -8}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(hX_wports1.port_a_out, Na_outlet.ports[1]) annotation(
    Line(points = {{14, 4}, {33, 4}, {33, -8}, {44, -8}}, color = {0, 127, 255}));
  MS_inlet.m_flow = m_flow;
  connect(hX_wports1.port_b_out, MS_outlet.ports[1]) annotation(
    Line(points = {{-6, 16}, {-12, 16}, {-12, 62}}, color = {0, 127, 255}));
  connect(MS_inlet.ports[1], hX_wports1.port_b_in) annotation(
    Line(points = {{4, -32}, {6, -32}, {6, 0}, {6, 0}}, color = {0, 127, 255}));
  connect(Na_inlet.ports[1], hX_wports1.port_a_in) annotation(
    Line(points = {{-48, 12}, {-14, 12}, {-14, 12}, {-14, 12}}, color = {0, 127, 255}));
end modello;