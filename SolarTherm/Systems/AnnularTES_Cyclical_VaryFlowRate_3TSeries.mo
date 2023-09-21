within SolarTherm.Systems;

model AnnularTES_Cyclical_VaryFlowRate_3TSeries
  //Baseline 3-tank series component analysis simulation from Chapter 7 and 8.3
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  package Medium = SolarTherm.Media.Air.Air_amb_p_curvefit;
  package Fluid_Package = SolarTherm.Materials.Air_amb_p_curvefit;
  package Filler_Package = SolarTherm.Materials.Concrete_Laing_2006;
  //Numerical Discretisation
  parameter Integer N_f = 10;
  parameter Integer N_p = 10;
  //TES Parameters
  parameter SI.Length L_pipe = 25.0/3.0; //"length of pipe of each TES module in the series"
  parameter SI.Length D_pipe = 0.10;
  parameter SI.Length D_solid = 0.15;
  parameter Integer Correlation = 2;
  //1=Liq 2=Air
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.0 "W/m2K";
  //Temperature Controls
  parameter SI.Temperature T_max = 600 + 273.15 "Maximum temperature";
  parameter SI.Temperature T_PB_des = T_max - 0.5 * T_tol_PB "Design blended Power Block inlet temperature";
  parameter SI.Temperature T_PB_min = T_max - T_tol_PB "Minimum tolerated outlet temperature to PB";
  parameter SI.Temperature T_Recv_max = T_min + T_tol_Recv "Maximum tolerated outlet temperature to recv";
  parameter SI.Temperature T_Recv_des = T_min + 0.5 * T_tol_Recv "Design blended receiver inlet temperature";
  parameter SI.Temperature T_min = 100 + 273.15 "Minimum temperature";
  //Temp Tolerance Settings
  parameter SI.TemperatureDifference T_tol_Recv = 300.0 "Power block Temperature Tolerance (K)";
  parameter SI.TemperatureDifference T_tol_PB = 150.0 "Power block Temperature Tolerance (K)";
  //Tank Geometry
  parameter SI.Power Q_dis_des = 600.0e6 "Design storage discharge heat-rate";
  parameter SI.Power Q_chg_des = t_discharge / t_charge * Q_dis_des "Design storage charge heat-rate";
  parameter Real stor_oversize_factor = 1.0;
  parameter SI.Energy E_max = t_discharge * Q_dis_des * stor_oversize_factor "Ideal storage capacity (J_thermal)";
  parameter SI.Time t_charge = 10.0 * 3600.0 "Charging period";
  parameter SI.Time t_discharge = 10.0 * 3600.0 "Discharging period";
  parameter SI.Time t_extension = 1.0 * 3600.0 "Extension period to make sure charging and discharging complete, applied twice";
  parameter SI.Time t_standby = 24.0 * 3600.0 - t_charge - t_discharge - 2.0 * t_extension "Standby period between discharge and charge";
  //Derived Parameters
  parameter SI.Time t_cycle = t_charge + t_discharge + t_standby + 2.0 * t_extension;
  //this is 24 hours
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0.0);
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 1.0);
  parameter SI.MassFlowRate m_charge_des = Q_chg_des / (h_f_max - h_f_min);
  parameter SI.MassFlowRate m_discharge_des = Q_dis_des / (h_f_max - h_f_min);
  //Output signals
  Modelica.Fluid.Sources.Boundary_pT Recv_outlet(redeclare package Medium = Medium, T = T_max, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT PB_outlet(redeclare package Medium = Medium, T = T_min, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {92, -60}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  //Storage Model
  SolarTherm.Models.Storage.Thermocline.Annular.Series.Annular_Storage_SGroup3_SM thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Filler_Package = Filler_Package, N_f = N_f, N_p = N_p, T_max = T_max, T_min = T_min, Correlation = Correlation, E_max = E_max, L_pipe = L_pipe, D_pipe = D_pipe, D_solid = D_solid, U_loss_tank = U_loss_tank) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  //Componenets and Connectors
  SolarTherm.Models.Fluid.Sources.FluidSink Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-120, -36}, extent = {{26, -26}, {-26, 26}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-40, -2}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-103, 5}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction thermocline_Splitter1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 67.5547}, extent = {{-16, 0}, {16, 22.4453}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction thermocline_Splitter2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -36.3493}, extent = {{-14, 0}, {14, 21.6507}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression m_flow_PB(y = m_PB_signal) annotation(
    Placement(visible = true, transformation(origin = {110, 3}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {40, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink PB_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {102, 44}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {43, 0}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {44, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.mass_loop_breaker mass_loop_breaker annotation(
    Placement(visible = true, transformation(origin = {0, 50}, extent = {{-24, -24}, {24, 24}}, rotation = -90)));
  //Mass flow Signals starts in charging state
  SI.MassFlowRate m_Recv_signal(start = m_charge_des);
  SI.MassFlowRate m_PB_signal(start = 0.0);
  //Measured Temperatures
  Real T_top_degC;
  Real T_bot_degC;
  Real T_outlet_degC;
  //Energies and Exergies for final cycle calculation
  SI.Energy E_chg(start = 0) "Charged energy into storage";
  SI.Energy E_dis(start = 0) "Discharged energy into storage";
  //SI.Energy E_lost(start = 0) "Externally lost energy from storage";
  //SI.Energy E_pump(start = 0) "Pumping energy consumed";
  parameter SI.Energy X_max = m_discharge_des * t_discharge * (h_f_max * (1.0 - 298.15 / T_max) - h_f_min * (1.0 - 298.15 / T_min)) "Theoretical Exergetic storage capacity (J)";
  SI.Energy X_chg(start = 0.0) "Total exergy charged in the last cycle";
  SI.Energy X_dis(start = 0.0) "Discharged exergy";
  //Utilisation and efficiencies
  Real util_energy(start = 0.0) "Energetic utilisation (1st Law)";
  Real eff_energy(start = 0.0) "Energetic efficiency (1st Law)";
  Real util_exergy(start = 0.0) "Exergetic utilisation (2nd law)";
  Real eff_exergy(start = 0.0) "Exergetic efficiency (2nd law)";
  //Individual Tank Utilization Calculations
  parameter SI.Energy E_max_A = thermocline_Tank.Tank_A.E_max "Maximum energy capacity of Tank A";
  //parameter SI.Energy E_max_B = thermocline_Tank.Tank_B.E_max "Maximum energy capacity of Tank B";
  //parameter SI.Energy E_max_C = thermocline_Tank.Tank_C.E_max "Maximum energy capacity of Tank C";
  //SI.Energy E_dis_A (start = 0.0) "Discharged energy from Tank A";
  //SI.Energy E_dis_B (start = 0.0) "Discharged energy from Tank B";
  //SI.Energy E_dis_C (start = 0.0) "Discharged energy from Tank C";
  //SI.Energy E_pump_A (start = 0.0) "Pumping energy of Tank A";
  //SI.Energy E_pump_B (start = 0.0) "Pumping energy of Tank B";
  //SI.Energy E_pump_C (start = 0.0) "Pumping energy of Tank C";
  //Real util_energy_A(start = 0.0) "Storage utilisation of Tank A";
  //Real util_energy_B(start = 0.0) "Storage utilisation of Tank B";
  //Real util_energy_C(start = 0.0) "Storage utilisation of Tank C";
  //Stats to determine if stable cycle has been reached
  SI.Energy E_dis_total(start = 0.0) "Total discharged energy for entire simulation";
  //SI.Energy E_pump_total(start = 0.0) "Total pump energy losses for entire simulation";
  SI.Energy E_dis_prev(start = 0.001) "Total discharged energy for previous cycle";
  //SI.Energy E_pump_prev(start = 0.001) "Total pump energy losses for previous cycle";
  Real util_prev(start = 0.001) "Previous day's level, starts at 0.1% to prevent divbyzero";
  Real time_stop(start = 3600.0 * 24.0 * 10.0) "The maximum time this simulation can last";
  Integer Control_State(start = 1) "Control state 1= Charge 2=Standby 3=Discharge";
  Real Level_high(start = 1.0);
  Real Level_low(start = 0.0);
  Real Level_mid(start = 0.5);
algorithm
//Mass flow controls
  when rem(time, t_cycle) > 1e-6 then
    if thermocline_Tank.T_bot_measured > T_Recv_max then
      Control_State := 2;
    else
      Control_State := 1;
    end if;
  end when;
//Start charging
//Cannot charge
//Can charge
  when rem(time, t_cycle) > t_charge + 1e-6 + t_extension then
    if thermocline_Tank.T_top_measured < T_PB_min then
      Control_State := 2;
    else
      Control_State := 3;
    end if;
  end when;
//Stop charging and start discharging time is up
//Cannot discharge
//Can discharge
//when rem(time, t_cycle) > t_charge + t_discharge + 1e-6 + 2.0*t_extension then //Stop discharging time is up
//Control_State := 2;
//end when;
  when thermocline_Tank.T_bot_measured > T_Recv_max then
    Control_State := 2;
    Level_high := thermocline_Tank.Level;
  end when;
//Force stop charging, unacceptable bottom outlet Temperature
  when thermocline_Tank.T_top_measured < T_PB_min then
    Control_State := 2;
    Level_low := thermocline_Tank.Level;
    Level_mid := 0.5 * (Level_high + Level_low);
  end when;
//Force stop discharging, unacceptable top outlet Temperature
//Utilisation convergence
  when time > time_stop - 10.0 then
    terminate("Stable cycle has been reached");
  end when;
  when rem(time, t_cycle) > 1.0e-6 then
    if abs((E_dis_total - E_dis_prev) / E_max - util_prev) / util_prev < 0.01 and div(time, t_cycle) > 0.0 then
      time_stop := 3600.0 * 24.0 * 10.0;
    end if;
    if div(time, t_cycle) > 0.0 then
      util_prev := (E_dis_total - E_dis_prev) / E_max;
      E_dis_prev := E_dis_total;
    end if;
  end when;
//Replace time + t_cycle - 1.0e-6 with 3600.0*24.0*10.0 to bypass the 1% check and simulate the full 10 days
//if abs((((E_dis_total - E_dis_prev) - (E_pump_total - E_pump_prev))/E_max) - util_prev)/(util_prev) < 0.01 and div(time,t_cycle) > 0.0 then //stable cycle
//stable cycle
//time + t_cycle - 1.0e-6;
//calculate utilisation
//util_prev := ((E_dis_total - E_dis_prev) - (E_pump_total - E_pump_prev))/E_max;
//E_pump_prev := E_pump_total;
equation
  if Control_State == 1 then
//Charging
    m_Recv_signal = m_charge_des * (h_f_max - h_f_min) / (h_f_max - thermocline_Tank.h_bot_outlet);
    m_PB_signal = 1.0e-8;
  elseif Control_State == 2 then
//Standby
    m_Recv_signal = 1.0e-8;
    m_PB_signal = 1.0e-8;
  else
    m_Recv_signal = 1.0e-8;
    m_PB_signal = m_discharge_des * (h_f_max - h_f_min) / (thermocline_Tank.h_top_outlet - h_f_min);
  end if;
//Measured temperature sensors
  T_top_degC = thermocline_Tank.T_top_measured - 273.15;
  T_bot_degC = thermocline_Tank.T_bot_measured - 273.15;
//Combined storage outlet temperatures (25degC if no flow)
  if thermocline_Tank.fluid_a.m_flow > 1.0e-3 then
//there is mass flow
    T_outlet_degC = thermocline_Tank.fluid_bot.T - 273.15;
  elseif thermocline_Tank.fluid_a.m_flow < (-1.0e-3) then
    T_outlet_degC = thermocline_Tank.fluid_top.T - 273.15;
  else
    T_outlet_degC = 25.0;
  end if;
  if time > time_stop - t_cycle then
//this is the final cycle
//Charging Phase
    if rem(time, t_cycle) < t_charge + t_extension then
      der(E_chg) = thermocline_Tank.fluid_a.m_flow * (inStream(thermocline_Tank.fluid_a.h_outflow) - thermocline_Tank.fluid_b.h_outflow);
      der(E_dis) = 0.0;
      der(X_chg) = thermocline_Tank.fluid_a.m_flow * (inStream(thermocline_Tank.fluid_a.h_outflow) * (1.0 - 298.15 / thermocline_Tank.fluid_top.T) - thermocline_Tank.fluid_b.h_outflow * (1.0 - 298.15 / thermocline_Tank.fluid_bot.T));
      der(X_dis) = 0.0;
//der(E_dis_A) = 0.0;
//der(E_dis_B) = 0.0;
//der(E_dis_C) = 0.0;
    elseif rem(time, t_cycle) > t_charge + t_extension and rem(time, t_cycle) < t_charge + t_discharge + 2.0 * t_extension then
//discharging phase
      der(E_chg) = 0.0;
      der(E_dis) = thermocline_Tank.fluid_b.m_flow * (thermocline_Tank.fluid_a.h_outflow - inStream(thermocline_Tank.fluid_b.h_outflow));
      der(X_chg) = 0.0;
      der(X_dis) = thermocline_Tank.fluid_b.m_flow * (thermocline_Tank.fluid_a.h_outflow * (1.0 - 298.15 / thermocline_Tank.fluid_top.T) - inStream(thermocline_Tank.fluid_b.h_outflow) * (1.0 - 298.15 / thermocline_Tank.fluid_bot.T));
//der(E_dis_A) = thermocline_Tank.Tank_A.m_flow*(thermocline_Tank.Tank_A.fluid_out.h - thermocline_Tank.Tank_A.fluid_in.h);
//der(E_dis_B) = thermocline_Tank.Tank_B.m_flow*(thermocline_Tank.Tank_B.fluid_out.h - thermocline_Tank.Tank_B.fluid_in.h);
//der(E_dis_C) = thermocline_Tank.Tank_C.m_flow*(thermocline_Tank.Tank_C.fluid_out.h - thermocline_Tank.Tank_C.fluid_in.h);
    else
      der(E_chg) = 0.0;
      der(E_dis) = 0.0;
      der(X_chg) = 0.0;
      der(X_dis) = 0.0;
//der(E_dis_A) = 0.0;
//der(E_dis_B) = 0.0;
//der(E_dis_C) = 0.0;
    end if;
//der(E_lost) = thermocline_Tank.Tank_A.Q_loss_total + thermocline_Tank.Tank_B.Q_loss_total + thermocline_Tank.Tank_C.Q_loss_total;
//der(E_pump) = thermocline_Tank.Tank_A.W_loss_pump + thermocline_Tank.Tank_B.W_loss_pump + thermocline_Tank.Tank_C.W_loss_pump;
//der(E_pump_A) = thermocline_Tank.Tank_A.W_loss_pump;
//der(E_pump_B) = thermocline_Tank.Tank_B.W_loss_pump;
//der(E_pump_C) = thermocline_Tank.Tank_C.W_loss_pump;
  else
    der(E_chg) = 0.0;
    der(E_dis) = 0.0;
    der(X_chg) = 0.0;
    der(X_dis) = 0.0;
//der(E_dis_A) = 0.0;
//der(E_dis_B) = 0.0;
//der(E_dis_C) = 0.0;
//der(E_lost) = 0.0;
//der(E_pump) = 0.0;
//der(E_pump_A) = 0.0;
//der(E_pump_B) = 0.0;
//der(E_pump_C) = 0.0;
  end if;
//Utilisation Convergence
  if rem(time, t_cycle) < t_charge + t_extension then
    der(E_dis_total) = 0.0;
  else
    der(E_dis_total) = thermocline_Tank.fluid_b.m_flow * (thermocline_Tank.fluid_a.h_outflow - inStream(thermocline_Tank.fluid_b.h_outflow));
  end if;
//der(E_pump_total) = thermocline_Tank.Tank_A.W_loss_pump + thermocline_Tank.Tank_B.W_loss_pump + thermocline_Tank.Tank_C.W_loss_pump;
  if time > time_stop - t_cycle + t_charge + 100.0 then
//We can calculate these efficiencies without division by zero
/*
    util_energy = (E_dis - E_pump) / E_max; 
    eff_energy = (E_dis - E_pump) / E_chg; 
    util_exergy = (X_dis - E_pump) / X_max;
    eff_exergy = (X_dis - E_pump) / X_chg;
    util_energy_A = (E_dis_A - E_pump_A)/E_max_A;
    util_energy_B = (E_dis_B - E_pump_B)/E_max_B;
    util_energy_C = (E_dis_C - E_pump_C)/E_max_C;
    */
    util_energy = E_dis / E_max;
    eff_energy = E_dis / E_chg;
    util_exergy = X_dis / X_max;
    eff_exergy = X_dis / X_chg;
//util_energy_A = E_dis_A/E_max_A;
//util_energy_B = E_dis_B/E_max_B;
//util_energy_C = E_dis_C/E_max_C;
  else
    util_energy = 0.0;
    eff_energy = 0.0;
    util_exergy = 0.0;
    eff_exergy = 0.0;
//util_energy_A = 0.0;
//util_energy_B = 0.0;
//util_energy_C = 0.0;
  end if;
//Connectors
  connect(thermocline_Tank.fluid_b, thermocline_Splitter2.fluid_c) annotation(
    Line(points = {{0, -30}, {0, -46}}, color = {0, 127, 255}));
  connect(thermocline_Splitter2.fluid_b, pumpSimple_EqualPressure2.fluid_a) annotation(
    Line(points = {{-12, -60}, {-34, -60}, {-34, -36}, {-46, -36}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure2.m_flow) annotation(
    Line(points = {{-82, 5}, {-56, 5}, {-56, -27}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure3.fluid_b, thermocline_Splitter2.fluid_a) annotation(
    Line(points = {{30, -60}, {12, -60}}, color = {0, 127, 255}));
  connect(thermocline_Tank.T_amb, Tamb.y) annotation(
    Line(points = {{-17, 0}, {-17, -1}, {-27, -1}, {-27, -2}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure.fluid_b, thermocline_Splitter1.fluid_a) annotation(
    Line(points = {{-44, 48}, {-30, 48}, {-30, 92}, {-13, 92}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_b, pumpSimple_EqualPressure1.fluid_a) annotation(
    Line(points = {{13, 92}, {22, 92}, {22, 44}, {34, 44}}, color = {0, 127, 255}));
  connect(thermocline_Tank.p_amb, p_amb.y) annotation(
    Line(points = {{17, 0}, {29, 0}}, color = {0, 0, 127}));
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
  connect(mass_loop_breaker.port_b, thermocline_Tank.fluid_a) annotation(
    Line(points = {{0, 36}, {0, 30}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_c, mass_loop_breaker.port_a) annotation(
    Line(points = {{0, 78}, {0, 64}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 864000, StartTime = 0, Tolerance = 1e-3, Interval = 60),
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false)),
    Icon(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false)));
end AnnularTES_Cyclical_VaryFlowRate_3TSeries;