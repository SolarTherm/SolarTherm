within SolarTherm.Models.Fluid.HeatExchangers;

model modello
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  SolarTherm.Models.Fluid.Pumps.IdealPump idealPump1(allowFlowReversal = false, cont_m_flow = false, m_flow_fixed = 20) annotation(
    Placement(visible = true, transformation(origin = {-44, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient ambient1(constantAmbientPressure(displayUnit = "Pa") = 101325, constantAmbientTemperature = 1013.15, medium = SolarTherm.Models.Media.Sodium.Sodium_pT) annotation(
    Placement(visible = true, transformation(origin = {-82, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient ambient2(constantAmbientPressure = 1.01325e+10, constantAmbientTemperature = 773.15, medium = SolarTherm.Models.Media.ChlorideSalt) annotation(
    Placement(visible = true, transformation(origin = {10, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient ambient3(medium = SolarTherm.Models.Media.Sodium.Sodium_pT) annotation(
    Placement(visible = true, transformation(origin = {62, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient ambient4(constantAmbientPressure(displayUnit = "Pa"), constantAmbientTemperature = 993.15, medium = SolarTherm.Models.Media.ChlorideSalt) annotation(
    Placement(visible = true, transformation(origin = {2, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.HE_wports hE_wports annotation(
    Placement(visible = true, transformation(origin = {0, -4}, extent = {{-36, -36}, {36, 36}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.IdealPump idealPump2(allowFlowReversal = false) annotation(
    Placement(visible = true, transformation(origin = {10, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(hE_wports.port_b_out, ambient4.flowPort) annotation(
    Line(points = {{-10, 12}, {-8, 12}, {-8, 56}, {-8, 56}}, color = {0, 127, 255}));
  connect(idealPump1.port_b, hE_wports.port_a_in) annotation(
    Line(points = {{-34, 6}, {-22, 6}}, color = {0, 127, 255}));
  connect(idealPump1.port_a, ambient1.flowPort) annotation(
    Line(points = {{-54, 6}, {-61, 6}, {-61, -6}, {-92, -6}}, color = {0, 127, 255}));
  connect(idealPump2.port_a, ambient2.flowPort) annotation(
    Line(points = {{10, -54}, {0, -54}, {0, -84}}, color = {0, 127, 255}));
  connect(idealPump2.port_b, hE_wports.port_b_in) annotation(
    Line(points = {{10, -34}, {10, -34}, {10, -14}, {10, -14}}, color = {0, 127, 255}));
  connect(hE_wports.port_a_out, ambient3.flowPort) annotation(
    Line(points = {{22, -6}, {52, -6}}, color = {0, 127, 255}));
end modello;