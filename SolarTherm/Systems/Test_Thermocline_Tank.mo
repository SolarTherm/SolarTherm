within SolarTherm.Systems;

model Test_Thermocline_Tank
  package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  package Fluid = SolarTherm.Media.Materials.Sodium;
  package Filler = SolarTherm.Media.Materials.CaO;
  SolarTherm.Models.Fluid.Sources.FluidSink pbSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {64, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpRecv(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-74, 20}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = 120)  annotation(
    Placement(visible = true, transformation(origin = {-80, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Storage.Thermocline.Thermocline_Tank thermocline_Tank(redeclare package Medium = Medium,  redeclare package Fluid = Fluid, redeclare package Filler = Filler, N_f = 25, T_max = 800 + 273.15, T_min = 600 + 273.15) annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary_pT(redeclare package Medium=Medium, T = 800 + 273.15, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-116, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(m_flow_Recv.y, pumpRecv.m_flow) annotation(
    Line(points = {{-69, 64}, {-64, 64}, {-64, 32}, {-74, 32}, {-74, 26}}, color = {0, 0, 127}));
  connect(pumpRecv.fluid_b, thermocline_Tank.fluid_a) annotation(
    Line(points = {{-66, 20}, {-42, 20}, {-42, 28}, {0, 28}, {0, 28}}, color = {0, 127, 255}));
  connect(thermocline_Tank.fluid_b, pbSink.port_a) annotation(
    Line(points = {{0, -32}, {44, -32}, {44, -34}, {44, -34}}, color = {0, 127, 255}));
  connect(Tamb.y, thermocline_Tank.T_amb) annotation(
    Line(points = {{-58, -12}, {-42, -12}, {-42, -2}, {-18, -2}, {-18, -2}}, color = {0, 0, 127}));
  connect(boundary_pT.ports[1], pumpRecv.fluid_a) annotation(
    Line(points = {{-106, 20}, {-82, 20}, {-82, 20}, {-82, 20}}, color = {0, 127, 255}));
end Test_Thermocline_Tank;