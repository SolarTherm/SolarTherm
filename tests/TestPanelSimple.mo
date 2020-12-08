model TestPanelSimple
  extends Modelica.Icons.Example;
  import SI = Modelica.SIunits;
  import Modelica.SIunits.Conversions.*;
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  parameter SI.Temperature T_in_des = from_degC(520) "Receiver inlet temperature";
  parameter SI.Temperature T_out_des = from_degC(740) "Receiver inlet temperature";
  parameter SI.Efficiency eff_blk = 0.51 "Power block efficiency at design point";
  parameter SI.Power P_name = 100e6 "Nameplate rating of power block";
  parameter Real SM = 2.7 "Solar multiple";
  parameter SI.Power P_gross = P_name * 111 / 100 "Power block gross rating at design point";
  parameter SI.HeatFlowRate Q_flow_ref_blk = P_gross / eff_blk "Thermal power to power block at design";
  parameter Medium.ThermodynamicState state_in_des = Medium.setState_pTX(p_blk, T_in_des) "medium state: pressure,temperature,composition";
  parameter Medium.ThermodynamicState state_out_des = Medium.setState_pTX(p_blk, T_out_des) "medium state: pressure,temperature,composition";
  parameter SI.SpecificEnthalpy h_in_des = Medium.specificEnthalpy(state_in_des) "specific inlet enthalpy at design point";
  parameter SI.SpecificEnthalpy h_out_des = Medium.specificEnthalpy(state_out_des) "specific outlet enthalpy at design point";
  parameter SI.MassFlowRate m_flow_blk = Q_flow_ref_blk * SM / (h_out_des - h_in_des) "Mass flow rate to power block at design";
  parameter SI.Pressure p_blk = 1e5 "Receiver operation pressure";
  // sink
  Modelica.Fluid.Sources.MassFlowSource_T sink(redeclare package Medium = Medium, T = T_in_des, m_flow = m_flow_blk, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {30, -64}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // source
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, nPorts = 1, p = p_blk, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {30, 140}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Valve input
  Modelica.Blocks.Sources.RealExpression open1(y = 0.125 * m_flow_blk) annotation(
    Placement(visible = true, transformation(origin = {22, -92}, extent = {{25, -15}, {-25, 15}}, rotation = 0)));
  // Flow paths
  SolarTherm.Models.CSP.CRS.Receivers.Panel.PanelSimple flowpath1(N_start = 0, Nel = 50, Npa_fl = 2) annotation(
    Placement(visible = true, transformation(origin = {-20, -20}, extent = {{-13, -13}, {13, 13}}, rotation = 90)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.PanelSimple flowpath2(N_start = 100, Nel = 50,   Npa_fl = 2) annotation(
    Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-13, -13}, {13, 13}}, rotation = 90)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.PanelSimple flowpath3(N_start = 200, Nel = 50,  Npa_fl = 2) annotation(
    Placement(visible = true, transformation(origin = {-60, -20}, extent = {{-13, -13}, {13, 13}}, rotation = 90)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.PanelSimple flowpath4(N_start = 300, Nel = 50,  Npa_fl = 2) annotation(
    Placement(visible = true, transformation(origin = {-82, -20}, extent = {{-13, -13}, {13, 13}}, rotation = 90)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.PanelSimple flowpath5(N_start = 400, Nel = 50,  Npa_fl = 2) annotation(
    Placement(visible = true, transformation(origin = {-106, -20}, extent = {{-13, -13}, {13, 13}}, rotation = 90)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.PanelSimple flowpath6(N_start = 500, Nel = 50, Npa_fl = 2) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-13, -13}, {13, 13}}, rotation = 90)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.PanelSimple flowpath7(N_start = 600, Nel = 50, Npa_fl = 2) annotation(
    Placement(visible = true, transformation(origin = {-152, -20}, extent = {{-13, -13}, {13, 13}}, rotation = 90)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.PanelSimple flowpath8(N_start = 700, Nel = 50, Npa_fl = 2) annotation(
    Placement(visible = true, transformation(origin = {-174, -20}, extent = {{-13, -13}, {13, 13}}, rotation = 90)));
  // Tees
  Modelica.Fluid.Fittings.TeeJunctionIdeal tee1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal tee2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, 20}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal tee7(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, 126}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal tee3 annotation(
    Placement(visible = true, transformation(origin = {-20, 40}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal tee4 annotation(
    Placement(visible = true, transformation(origin = {-20, 62}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal tee5 annotation(
    Placement(visible = true, transformation(origin = {-20, 82}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal tee6 annotation(
    Placement(visible = true, transformation(origin = {-20, 104}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  // Valves
  SolarTherm.Models.CSP.CRS.Receivers.Panel.Valve valve1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, -64}, extent = {{7.5, 7.5}, {-7.5, -7.5}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.Valve valve2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-40, -64}, extent = {{7.5, 7.5}, {-7.5, -7.5}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.Valve valve3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-60, -64}, extent = {{7.5, 7.5}, {-7.5, -7.5}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.Valve valve annotation(
    Placement(visible = true, transformation(origin = {-82, -64}, extent = {{7.5, 7.5}, {-7.5, -7.5}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.Valve valve4 annotation(
    Placement(visible = true, transformation(origin = {-106, -64}, extent = {{7.5, 7.5}, {-7.5, -7.5}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.Valve valve5 annotation(
    Placement(visible = true, transformation(origin = {-130, -64}, extent = {{7.5, 7.5}, {-7.5, -7.5}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.Panel.Valve valve6 annotation(
    Placement(visible = true, transformation(origin = {-152, -64}, extent = {{7.5, 7.5}, {-7.5, -7.5}}, rotation = 0)));
equation
  connect(open1.y, valve1.m_flow) annotation(
    Line(points = {{-5.5, -92}, {-20, -92}, {-20, -66}}, color = {0, 0, 127}));
  connect(sink.ports[1], valve1.fluid_a) annotation(
    Line(points = {{20, -64}, {-16, -64}}, color = {0, 127, 255}));
  connect(flowpath2.fluid_b, tee1.port_3) annotation(
    Line(points = {{-40, -10}, {-40, 0}, {-27, 0}}, color = {0, 127, 255}));
  connect(flowpath1.fluid_b, tee1.port_1) annotation(
    Line(points = {{-20, -10}, {-20, -7}}, color = {0, 127, 255}));
  connect(flowpath3.fluid_b, tee2.port_3) annotation(
    Line(points = {{-60, -10}, {-60, 20}, {-27, 20}}, color = {0, 127, 255}));
  connect(tee1.port_2, tee2.port_1) annotation(
    Line(points = {{-20, 7}, {-20, 13}}, color = {0, 127, 255}));
  connect(tee7.port_2, source.ports[1]) annotation(
    Line(points = {{-20, 133}, {-20, 140}, {20, 140}}, color = {0, 127, 255}));
  connect(valve1.fluid_b2, flowpath1.fluid_a) annotation(
    Line(points = {{-20, -60}, {-20, -60}, {-20, -30}, {-20, -30}}, color = {0, 127, 255}));
  connect(valve2.fluid_b2, flowpath2.fluid_a) annotation(
    Line(points = {{-40, -60}, {-40, -60}, {-40, -30}, {-40, -30}}, color = {0, 127, 255}));
  connect(valve3.fluid_b2, flowpath3.fluid_a) annotation(
    Line(points = {{-60, -60}, {-60, -60}, {-60, -30}, {-60, -30}}, color = {0, 127, 255}));
  connect(valve3.fluid_a, valve2.fluid_b1) annotation(
    Line(points = {{-56, -64}, {-44, -64}, {-44, -64}, {-44, -64}}, color = {0, 127, 255}));
  connect(valve2.fluid_a, valve1.fluid_b1) annotation(
    Line(points = {{-36, -64}, {-24, -64}, {-24, -64}, {-24, -64}}, color = {0, 127, 255}));
  connect(valve3.fluid_b1, valve.fluid_a) annotation(
    Line(points = {{-64, -64}, {-78, -64}, {-78, -64}, {-78, -64}}, color = {0, 127, 255}));
  connect(valve.fluid_b2, flowpath4.fluid_a) annotation(
    Line(points = {{-82, -60}, {-82, -60}, {-82, -30}, {-82, -30}}, color = {0, 127, 255}));
  connect(valve4.fluid_b2, flowpath5.fluid_a) annotation(
    Line(points = {{-106, -60}, {-106, -60}, {-106, -30}, {-106, -30}}, color = {0, 127, 255}));
  connect(valve5.fluid_b2, flowpath6.fluid_a) annotation(
    Line(points = {{-130, -60}, {-130, -60}, {-130, -30}, {-130, -30}}, color = {0, 127, 255}));
  connect(valve6.fluid_b2, flowpath7.fluid_a) annotation(
    Line(points = {{-152, -60}, {-152, -60}, {-152, -30}, {-152, -30}}, color = {0, 127, 255}));
  connect(valve.fluid_b1, valve4.fluid_a) annotation(
    Line(points = {{-86, -64}, {-102, -64}, {-102, -64}, {-102, -64}}, color = {0, 127, 255}));
  connect(valve4.fluid_b1, valve5.fluid_a) annotation(
    Line(points = {{-110, -64}, {-126, -64}, {-126, -64}, {-126, -64}}, color = {0, 127, 255}));
  connect(valve5.fluid_b1, valve6.fluid_a) annotation(
    Line(points = {{-134, -64}, {-148, -64}, {-148, -64}, {-148, -64}}, color = {0, 127, 255}));
  connect(valve6.fluid_b1, flowpath8.fluid_a) annotation(
    Line(points = {{-156, -64}, {-174, -64}, {-174, -30}, {-174, -30}}, color = {0, 127, 255}));
  connect(flowpath8.fluid_b, tee7.port_3) annotation(
    Line(points = {{-174, -10}, {-174, 126}, {-27, 126}}, color = {0, 127, 255}));
  connect(flowpath4.fluid_b, tee3.port_3) annotation(
    Line(points = {{-82, -10}, {-82, -10}, {-82, 40}, {-28, 40}, {-28, 40}, {-26, 40}}, color = {0, 127, 255}));
  connect(flowpath5.fluid_b, tee4.port_3) annotation(
    Line(points = {{-106, -10}, {-106, -10}, {-106, 62}, {-26, 62}, {-26, 62}}, color = {0, 127, 255}));
  connect(flowpath6.fluid_b, tee5.port_3) annotation(
    Line(points = {{-130, -10}, {-130, -10}, {-130, 82}, {-26, 82}, {-26, 82}}, color = {0, 127, 255}));
  connect(tee5.port_2, tee6.port_1) annotation(
    Line(points = {{-20, 90}, {-20, 90}, {-20, 98}, {-20, 98}}, color = {0, 127, 255}));
  connect(tee6.port_2, tee7.port_1) annotation(
    Line(points = {{-20, 112}, {-20, 112}, {-20, 120}, {-20, 120}}, color = {0, 127, 255}));
  connect(flowpath7.fluid_b, tee6.port_3) annotation(
    Line(points = {{-152, -10}, {-152, -10}, {-152, 104}, {-26, 104}, {-26, 104}}, color = {0, 127, 255}));
  connect(tee2.port_2, tee3.port_1) annotation(
    Line(points = {{-20, 28}, {-20, 28}, {-20, 34}, {-20, 34}}, color = {0, 127, 255}));
  connect(tee3.port_2, tee4.port_1) annotation(
    Line(points = {{-20, 48}, {-20, 48}, {-20, 56}, {-20, 56}}, color = {0, 127, 255}));
  connect(tee4.port_2, tee5.port_1) annotation(
    Line(points = {{-20, 70}, {-20, 70}, {-20, 76}, {-20, 76}}, color = {0, 127, 255}));
  connect(valve2.m_flow, open1.y) annotation(
    Line(points = {{-40, -66}, {-40, -92}, {-5.5, -92}}, color = {0, 0, 127}));
  connect(valve3.m_flow, open1.y) annotation(
    Line(points = {{-60, -66}, {-60, -92}, {-5.5, -92}}, color = {0, 0, 127}));
  connect(valve.m_flow, open1.y) annotation(
    Line(points = {{-82, -66}, {-82, -92}, {-5.5, -92}}, color = {0, 0, 127}));
  connect(valve4.m_flow, open1.y) annotation(
    Line(points = {{-106, -66}, {-106, -92}, {-5.5, -92}}, color = {0, 0, 127}));
  connect(valve5.m_flow, open1.y) annotation(
    Line(points = {{-130, -66}, {-130, -92}, {-5.5, -92}}, color = {0, 0, 127}));
  connect(valve6.m_flow, open1.y) annotation(
    Line(points = {{-152, -66}, {-152, -92}, {-5.5, -92}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.2")),
    experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-6, Interval = 0.4),
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    version = "");
end TestPanelSimple;