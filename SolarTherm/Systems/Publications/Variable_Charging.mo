within SolarTherm.Systems.Publications;

model Variable_Charging
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  //Do not change
  package Fluid_Package = SolarTherm.Materials.Sodium;
  //Do not change
  package Filler_Package = SolarTherm.Materials.MgO_Constant;
  //MgO_Constant;  //Can investigate different filler
  //Design Parameters
  //Fixed
  parameter Integer Correlation = 3 "Conservative";
  parameter SI.Temperature T_min = 550 + 273.15 "Minimum temperature";
  parameter SI.Temperature T_max = 700 + 273.15 "Maximum temperature";
  parameter Real eta = 0.26 "Porosity";
  parameter Integer N_f = 50 "Number of fluid CVs";
  parameter Integer N_p = 10 "Number of filler CVs";
  parameter SI.Energy E_max = t_discharge * (P_name / eff_PB) "Storage capacity (J), t_discharge(s), 100MWe, 50% PB efficiency";
  parameter Real eff_PB = 0.50 "Power block heat to electricity conversion efficiency";
  parameter SI.Time t_charge = 6.0 * 3600.0 "Charging period";
  parameter SI.Time t_standby = 0.0 * 3600.0 "Standby period between discharge and charge";
  parameter SI.Length d_p = 0.30 "Filler diameter";
  //Optimise
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 1.00 "W/m2K";
  parameter SI.Power P_name = 100.0e6 * (t_charge / t_discharge) "Nameplate power block";
  parameter SI.Time t_discharge = 10.0 * 3600.0 "Discharging period";
  parameter Real ar = 2.0 "Tank aspect ratio";
  //Derived
  parameter SI.Time t_cycle = t_charge + t_discharge + t_standby;
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0.0);
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 1.0);
  parameter SI.MassFlowRate m_charge = E_max / (t_charge * (h_f_max - h_f_min));
  parameter SI.MassFlowRate m_discharge = E_max / (t_discharge * (h_f_max - h_f_min));
  Modelica.Fluid.Sources.Boundary_pT Recv_outlet(redeclare package Medium = Medium, T = T_max, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT PB_outlet(redeclare package Medium = Medium, T = T_min, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {92, -60}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  //Efficiency
  parameter SI.Energy denom = m_charge * t_charge * (h_f_max - h_f_min);
  SI.Energy numer(start = 0.0);
  Real eff_storage(start = 0.0) "Storage efficiency";
  //COntrol
  SI.MassFlowRate m_Recv_signal(start = 1e-6);
  SI.MassFlowRate m_PB_signal(start = 1e-6);
  SolarTherm.Models.Storage.Thermocline.Thermocline_Tank thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Filler_Package = Filler_Package, N_f = N_f, N_p = N_p, T_max = T_max, T_min = T_min, E_max = E_max, ar = ar, eta = eta, d_p = d_p, U_loss_tank = U_loss_tank) annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-120, -36}, extent = {{26, -26}, {-26, 26}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-38, -2}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-103, 5}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.Thermocline_Splitter thermocline_Splitter1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 67.5547}, extent = {{-16, 0}, {16, 22.4453}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_PB(y = m_PB_signal) annotation(
    Placement(visible = true, transformation(origin = {110, 3}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {40, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink PB_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {102, 44}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {41, -2}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {44, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Costs
  parameter Real C_fluid = thermocline_Tank.C_fluid;
  parameter Real C_filler = thermocline_Tank.C_filler;
  parameter Real C_tank = thermocline_Tank.C_tank;
  parameter Real C_insulation = thermocline_Tank.C_insulation;
  parameter Real C_total = thermocline_Tank.C_total;
  //Energies
  SI.Energy E_charged(start = 0);
  SI.Energy E_discharged(start = 0);
  SI.Energy E_lost(start = 0);
  SI.Energy E_pump(start = 0);
  SolarTherm.Models.Fluid.Valves.Thermocline_Splitter thermocline_Splitter_2 annotation(
    Placement(visible = true, transformation(origin = {-8.88178e-16, -41.5383}, extent = {{-18, 0}, {18, 16.9712}}, rotation = 180)));
  SolarTherm.Models.Fluid.HeatExchangers.mass_loop_breaker mass_loop_breaker annotation(
    Placement(visible = true, transformation(origin = {0, 52}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
equation
//controls
  m_Recv_signal = 10000.0 - time * 1.0;
  m_PB_signal = 0.0 + time * 1.0;
/*
  if rem(time, t_cycle) < t_charge then
//charging
    m_Recv_signal = m_charge;
    m_PB_signal = 0.0;
  elseif rem(time, t_cycle) >= t_charge and rem(time, t_cycle) < t_discharge + t_charge then
//discharging
    m_Recv_signal = 0.0;
    m_PB_signal = m_discharge;
  else
    m_Recv_signal = 0.0;
    m_PB_signal = 0.0;
  end if;*/
//efficiency
  if time > t_cycle * 5.0 and time < t_cycle * 6.0 then
    der(numer) = PB_Sink.port_a.m_flow * (inStream(PB_Sink.port_a.h_outflow) - h_f_min);
    if time < t_cycle * 5.0 + t_charge then
//charging
      der(E_charged) = thermocline_Tank.fluid_a.m_flow * (inStream(thermocline_Tank.fluid_a.h_outflow) - thermocline_Tank.fluid_b.h_outflow);
      der(E_discharged) = 0.0;
    elseif time > t_cycle * 5.0 + t_charge and time < t_cycle * 5.0 + t_charge + t_discharge then
      der(E_charged) = 0.0;
      der(E_discharged) = thermocline_Tank.fluid_b.m_flow * (thermocline_Tank.fluid_a.h_outflow - inStream(thermocline_Tank.fluid_b.h_outflow));
    else
      der(E_charged) = 0.0;
      der(E_discharged) = 0.0;
    end if;
    der(E_lost) = thermocline_Tank.Tank_A.Q_loss_total;
    der(E_pump) = thermocline_Tank.Tank_A.W_loss_pump;
  else
    der(numer) = 0.0;
    der(E_charged) = 0.0;
    der(E_discharged) = 0.0;
    der(E_lost) = 0.0;
    der(E_pump) = 0.0;
  end if;
  if time > t_cycle * 5.0 + 100.0 then
//eff_storage = (numer)/denom;
    eff_storage = (numer - E_pump) / denom;
//subtract pumping power
  else
    eff_storage = 0.0;
  end if;
  connect(m_flow_Recv.y, pumpSimple_EqualPressure2.m_flow) annotation(
    Line(points = {{-82, 5}, {-56, 5}, {-56, -27}}, color = {0, 0, 127}));
  connect(thermocline_Tank.T_amb, Tamb.y) annotation(
    Line(points = {{-17, -2}, {-25, -2}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure.fluid_b, thermocline_Splitter1.fluid_a) annotation(
    Line(points = {{-44, 48}, {-30, 48}, {-30, 92}, {-13, 92}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_b, pumpSimple_EqualPressure1.fluid_a) annotation(
    Line(points = {{13, 92}, {22, 92}, {22, 44}, {34, 44}}, color = {0, 127, 255}));
  connect(thermocline_Tank.p_amb, p_amb.y) annotation(
    Line(points = {{17, -2}, {27, -2}}, color = {0, 0, 127}));
  connect(Recv_outlet.ports[1], pumpSimple_EqualPressure.fluid_a) annotation(
    Line(points = {{-96, 48}, {-64, 48}}, color = {0, 127, 255}));
  connect(PB_outlet.ports[1], pumpSimple_EqualPressure3.fluid_a) annotation(
    Line(points = {{76, -60}, {50, -60}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure.m_flow) annotation(
    Line(points = {{-82, 5}, {-74, 5}, {-74, 72}, {-54, 72}, {-54, 56}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure1.m_flow) annotation(
    Line(points = {{88, 3}, {70, 3}, {70, 70}, {44, 70}, {44, 52}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure3.m_flow) annotation(
    Line(points = {{88, 3}, {70, 3}, {70, -30}, {40, -30}, {40, -52}}, color = {0, 0, 127}));
  connect(Recv_Sink.port_a, pumpSimple_EqualPressure2.fluid_b) annotation(
    Line(points = {{-94, -36}, {-66, -36}, {-66, -36}, {-66, -36}}, color = {0, 127, 255}));
  connect(PB_Sink.port_a, pumpSimple_EqualPressure1.fluid_b) annotation(
    Line(points = {{78, 44}, {54, 44}, {54, 44}, {54, 44}}, color = {0, 127, 255}));
  connect(pumpSimple_EqualPressure3.fluid_b, thermocline_Splitter_2.fluid_a) annotation(
    Line(points = {{30, -60}, {21.5, -60}, {21.5, -59}, {14, -59}}, color = {0, 127, 255}));
  connect(thermocline_Splitter_2.fluid_c, thermocline_Tank.fluid_b) annotation(
    Line(points = {{0, -45}, {0, -32}}, color = {0, 127, 255}));
  connect(thermocline_Splitter_2.fluid_b, pumpSimple_EqualPressure2.fluid_a) annotation(
    Line(points = {{-14, -58}, {-36, -58}, {-36, -36}, {-46, -36}, {-46, -36}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_c, mass_loop_breaker.port_b) annotation(
    Line(points = {{0, 74}, {0, 74}, {0, 64}, {0, 64}}, color = {0, 127, 255}));
  connect(mass_loop_breaker.port_a, thermocline_Tank.fluid_a) annotation(
    Line(points = {{0, 40}, {0, 40}, {0, 28}, {0, 28}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 360000, StartTime = 0, Tolerance = 1e-6, Interval = 300));
end Variable_Charging;