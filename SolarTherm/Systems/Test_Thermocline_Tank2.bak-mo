within SolarTherm.Systems;

model Test_Thermocline_Tank2




  package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  package Fluid = SolarTherm.Media.Materials.Sodium;
  package Filler = SolarTherm.Media.Materials.CaO;
  SolarTherm.Models.Fluid.Sources.FluidSink pbSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-116, -36}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y =  1e-3 +time)  annotation(
    Placement(visible = true, transformation(origin = {-106, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Storage.Thermocline.Thermocline_Tank thermocline_Tank(redeclare package Medium = Medium,  redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler, N_f = 25, T_max = 800 + 273.15, T_min = 600 + 273.15) annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary_pT(redeclare package Medium = Medium, T = 800 + 273.15, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-116, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.Thermocline_Splitter thermocline_Splitter1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 67.5547}, extent = {{-16, 0}, {16, 22.4453}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.Thermocline_Splitter thermocline_Splitter2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -36.3493}, extent = {{-14, 0}, {14, 21.6507}}, rotation = 180)));
  Modelica.Fluid.Sources.Boundary_pT boundary_2(redeclare package Medium = Medium,T = 600 + 273.15, nPorts = 1, p = 101325)  annotation(
    Placement(visible = true, transformation(origin = {76, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 1e-3) annotation(
    Placement(visible = true, transformation(origin = {14, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {40, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink fluidSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {94, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = 101325)  annotation(
    Placement(visible = true, transformation(origin = {68, -2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {44, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.mass_loop_breaker mass_loop_breaker(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {2.44249e-15, 56}, extent = {{-24, -24}, {24, 24}}, rotation = -90)));
equation
  connect(thermocline_Tank.fluid_b, thermocline_Splitter2.fluid_c) annotation(
    Line(points = {{0, -32}, {0, -32}, {0, -46}, {0, -46}}, color = {0, 127, 255}));
  connect(thermocline_Splitter2.fluid_b, pumpSimple_EqualPressure2.fluid_a) annotation(
    Line(points = {{-12, -60}, {-34, -60}, {-34, -36}, {-46, -36}}, color = {0, 127, 255}));
  connect(pumpSimple_EqualPressure2.fluid_b, pbSink.port_a) annotation(
    Line(points = {{-66, -36}, {-96, -36}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure2.m_flow) annotation(
    Line(points = {{-95, -12}, {-56, -12}, {-56, -27}}, color = {0, 0, 127}));
  connect(boundary_2.ports[1], pumpSimple_EqualPressure3.fluid_a) annotation(
    Line(points = {{66, -60}, {50, -60}}, color = {0, 127, 255}));
  connect(pumpSimple_EqualPressure3.fluid_b, thermocline_Splitter2.fluid_a) annotation(
    Line(points = {{30, -60}, {12, -60}}, color = {0, 127, 255}));
  connect(realExpression.y, pumpSimple_EqualPressure3.m_flow) annotation(
    Line(points = {{26, -40}, {40, -40}, {40, -51}}, color = {0, 0, 127}));
  connect(realExpression1.y, thermocline_Tank.p_amb) annotation(
    Line(points = {{56, -2}, {20, -2}, {20, -2}, {18, -2}}, color = {0, 0, 127}));
  connect(thermocline_Tank.T_amb, Tamb.y) annotation(
    Line(points = {{-18, -2}, {-42, -2}, {-42, -4}, {-58, -4}, {-58, -4}}, color = {0, 0, 127}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure.m_flow) annotation(
    Line(points = {{-95, -12}, {-95, 66}, {-54, 66}, {-54, 56}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure1.m_flow, realExpression.y) annotation(
    Line(points = {{44, 52}, {60, 52}, {60, 14}, {40, 14}, {40, -40}, {26, -40}, {26, -40}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure.fluid_b, thermocline_Splitter1.fluid_a) annotation(
    Line(points = {{-44, 48}, {-30, 48}, {-30, 92}, {-13, 92}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_b, pumpSimple_EqualPressure1.fluid_a) annotation(
    Line(points = {{13, 92}, {22, 92}, {22, 44}, {34, 44}}, color = {0, 127, 255}));
  connect(pumpSimple_EqualPressure1.fluid_b, fluidSink.port_a) annotation(
    Line(points = {{54, 44}, {74, 44}}, color = {0, 127, 255}));
  connect(boundary_pT.ports[1], pumpSimple_EqualPressure.fluid_a) annotation(
    Line(points = {{-106, 20}, {-74, 20}, {-74, 48}, {-64, 48}, {-64, 48}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_c, mass_loop_breaker.port_a) annotation(
    Line(points = {{0, 78}, {0, 78}, {0, 70}, {0, 70}}, color = {0, 127, 255}));
  connect(mass_loop_breaker.port_b, thermocline_Tank.fluid_a) annotation(
    Line(points = {{0, 42}, {0, 42}, {0, 28}, {0, 28}}, color = {0, 127, 255}));
end Test_Thermocline_Tank2;