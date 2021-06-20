model TestStorageENTU
  //Part one of the baseline comparisons, this one is just the base case.
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  package Filler = SolarTherm.Materials.Graphite;
  parameter Integer Correlation = 3 "Conservative";
  parameter SI.Temperature T_min = 510 + 273.15 "Minimum temperature";
  parameter SI.Temperature T_max = 740 + 273.15 "Maximum temperature";
  //parameter SI.Temperature T_PB_min = 680 + 273.15 "Minimum tolerated outlet temperature to PB";
  //parameter SI.Temperature T_Recv_max = 550 + 273.15 "Maximum tolerated outlet temperature to recv";
  parameter Real eff = 0.95 "Effectiveness";
  //0.36 if randomly packed, 0.26 for perfect packing.
  //Study this
  parameter SI.Time t_charge = 6.0 * 3600.0 "Charging period";
  parameter SI.Time t_standby = 24.0 * 3600.0 - t_charge - t_discharge "Standby period between discharge and charge";
  //Optimise
  parameter SI.Power P_name = 100.0e6 * (t_charge / t_discharge) "Nameplate power block";
  parameter SI.Time t_discharge = 10.0 * 3600.0 "Discharging period";
  //Derived
  parameter SI.Time t_cycle = t_charge + t_discharge + t_standby;

  parameter Real t_storage(unit = "h") = 1.0 "Hours of storage";
  parameter SI.HeatFlowRate Q_flow_ref_blk = P_gross_des / eff_blk_des "design heat input rate into the PB";
  parameter SI.Power P_gross_des = 100e6 "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk_des = 0.51 "Power block efficiency at design point";


  parameter SI.MassFlowRate m_charge = 800.0;
  parameter SI.MassFlowRate m_discharge = 480.0;
  Modelica.Fluid.Sources.Boundary_pT Recv_outlet(redeclare package Medium = Medium, T = T_max, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-88, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT PB_outlet(redeclare package Medium = Medium, T = T_min, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {86, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  //Control
  SolarTherm.Models.Fluid.Sources.FluidSink Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-88, -36}, extent = {{12, -12}, {-12, 12}}, rotation = 0)));

  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-50, 2}, extent = {{-14, -12}, {14, 12}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction thermocline_Splitter1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 47.5547}, extent = {{-16, 0}, {16, 22.4453}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction thermocline_Splitter2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -36.3493}, extent = {{-14, 0}, {14, 21.6507}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression m_flow_PB(y = m_PB_signal) annotation(
    Placement(visible = true, transformation(origin = {96, 2}, extent = {{14, -16}, {-14, 16}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {40, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink PB_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {90, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {35, -1}, extent = {{11, -13}, {-11, 13}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-32, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {42, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  SI.MassFlowRate m_Recv_signal(start = m_charge);
  //starts in charging state
  SI.MassFlowRate m_PB_signal(start = 0.0);

  SolarTherm.Models.Fluid.HeatExchangers.mass_loop_breaker mass_loop_breaker annotation(
    Placement(visible = true, transformation(origin = {0, 36}, extent = {{-24, -24}, {24, 24}}, rotation = -90)));
    
  //Efficiency
  //Real der_numerator "rate of change of the numerator for eff_storage calculations";
  SolarTherm.Models.Storage.eNTU eNTU(redeclare package Medium = Medium, E_max = Q_flow_ref_blk * t_storage * 3600, T_0 = T_min, T_max = T_max, eff_constant=eff, redeclare package Storage = Filler) annotation(
    Placement(visible = true, transformation(origin = {-1, 1}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
algorithm
  when rem(time, t_cycle) > 1e-6 then
    m_Recv_signal := m_charge;
    m_PB_signal := 0.0;
  end when;
  when rem(time, t_cycle) > t_charge + 1e-6 then
    m_Recv_signal := 0.0;
    m_PB_signal := m_discharge;
  end when;
  when rem(time, t_cycle) > t_charge + t_discharge + 1e-6 then
    m_Recv_signal := 0.0;
    m_PB_signal := 0.0;
  end when;
  
  when eNTU.T_st > T_max then
    m_Recv_signal := 0.0;
  end when;
  when eNTU.T_st < T_min then
    m_PB_signal := 0.0;
  end when;
  
/*
  if time > t_cycle * 5.0 and time < t_cycle * 6.0 then
    der_numerator := PB_Sink.port_a.m_flow * (thermocline_Tank.fluid_top.h - h_f_min);
  else
    der_numerator := 0.0;
  end if;
*/
equation
  //mass_loop_breaker.port_b.p = thermocline_Splitter2.fluid_c.p;
  connect(thermocline_Splitter2.fluid_b, pumpSimple_EqualPressure2.fluid_a) annotation(
    Line(points = {{-12, -60}, {-34, -60}, {-34, -36}, {-46, -36}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure2.m_flow) annotation(
    Line(points = {{-35, 2}, {-56, 2}, {-56, -27}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure3.fluid_b, thermocline_Splitter2.fluid_a) annotation(
    Line(points = {{30, -60}, {12, -60}}, color = {0, 127, 255}));
  connect(pumpSimple_EqualPressure.fluid_b, thermocline_Splitter1.fluid_a) annotation(
    Line(points = {{-22, 44}, {-22, 72}, {-13, 72}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_b, pumpSimple_EqualPressure1.fluid_a) annotation(
    Line(points = {{13, 72}, {22, 72}, {22, 44}, {32, 44}}, color = {0, 127, 255}));
  connect(Recv_outlet.ports[1], pumpSimple_EqualPressure.fluid_a) annotation(
    Line(points = {{-78, 44}, {-42, 44}}, color = {0, 127, 255}));
  connect(PB_outlet.ports[1], pumpSimple_EqualPressure3.fluid_a) annotation(
    Line(points = {{76, -60}, {50, -60}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure.m_flow) annotation(
    Line(points = {{-35, 2}, {-74, 2}, {-74, 72}, {-32, 72}, {-32, 53}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure1.m_flow) annotation(
    Line(points = {{81, 2}, {70, 2}, {70, 70}, {42, 70}, {42, 53}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure3.m_flow) annotation(
    Line(points = {{81, 2}, {70, 2}, {70, -30}, {40, -30}, {40, -52}}, color = {0, 0, 127}));
  connect(Recv_Sink.port_a, pumpSimple_EqualPressure2.fluid_b) annotation(
    Line(points = {{-76, -36}, {-66, -36}}, color = {0, 127, 255}));
  connect(PB_Sink.port_a, pumpSimple_EqualPressure1.fluid_b) annotation(
    Line(points = {{80, 44}, {52, 44}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_c, mass_loop_breaker.port_a) annotation(
    Line(points = {{0, 54}, {0, 50}}, color = {0, 127, 255}));
  connect(mass_loop_breaker.port_b, eNTU.fluid_a) annotation(
    Line(points = {{0, 22}, {0, 8}}, color = {0, 127, 255}));
  connect(eNTU.fluid_b, thermocline_Splitter2.fluid_c) annotation(
    Line(points = {{0, -6}, {0, -6}, {0, -42}, {0, -42}}, color = {0, 127, 255}));
  connect(p_amb.y, eNTU.p_amb) annotation(
    Line(points = {{23, -1}, {16.5, -1}, {16.5, 0}, {12, 0}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 518400, StartTime = 0, Tolerance = 1e-3, Interval = 60));
end TestStorageENTU;