within SolarTherm.Systems;

model WindPVRadChgTESsystem_Air
  extends Modelica.Icons.Example;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Constants.*;
  import CV = Modelica.SIunits.Conversions;
  parameter String PV_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/pv_gen_Gladstone_1MWe.motab");
  parameter String Wind_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/wind_gen_Gladstone320MWe.motab");
  parameter String schd_input = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/schedule_Qflow.motab");
  replaceable package Medium = SolarTherm.Media.Air.Air_amb_p_curvefit;
  replaceable package Fluid = SolarTherm.Materials.Air_amb_p_curvefit;
  replaceable package Filler = SolarTherm.Materials.Brick_Stack;
  //Inputs
  parameter Real RM = 2.0 "Renewable Multiple";
  parameter Real PV_fraction = 0.7 "PV_fraction";
  parameter Real t_storage = 40.0 "Hours of storage (hours)";
  //parameter Real util_storage_des = 0.5995;
  //Utilisation determined via component-level analysis
  //parameter Real level_storage_mid = 0.5486;
  //Midpoint of minimum and maximum storage levels determine via component-level analysis
  //Renewable Parameters
  parameter SI.Power P_renewable_des = RM * Q_flow_des;
  parameter SI.Power PV_ref_size = 1.0e6;
  parameter SI.Power Wind_ref_size = 320.0e6;
  //Results
  SI.Energy E_supplied(start = 0) "Energy supplied by the boiler to the industrial process (J)";
  SI.Energy E_demand(start = 0) "Energy demanded by the industrial process (J)";
  Real Capacity_Factor(start = 0) "Capacity factor of the system";
  //Discretisation and geometry
  parameter Integer N_f = 6;
  parameter Real eta = 0.40;
  parameter SI.Length H_unit = 0.50;
  parameter SI.WaveNumber c_surf = 100.0;
  parameter SI.Length L_char = 0.02;
  parameter SI.Temperature T_rad = CV.from_degC(1200);
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.0 "W/m2K";
  //1=Liq 2=Air
  //Temperature Controls
  parameter SI.Temperature T_max = 1050.0 + 273.15 "Maximum temperature";
  parameter SI.Temperature T_PB_start = 450 + 273.15 "Temperature at which TES can start being discharged";
  //halfway between
  parameter SI.Temperature T_PB_min = 400.0 + 273.15 "Minimum tolerated outlet temperature to PB";
  parameter SI.Temperature T_top_max = 1050.0 + 273.15 "Temperature at which TES is stopped being charged";
  parameter SI.Temperature T_top_start = 1000.0 + 273.15 "Temperature at which TES can start being charged";
  //halfway between
  parameter SI.Temperature T_min = 125.0 + 273.15 "Minimum temperature";
  parameter SI.Temperature T_target = 600.0 + 273.15 "Minimum temperature";
  //parameter SI.TemperatureDifference T_tol_Recv = 300.0 "Power block Temperature Tolerance (K)";
  //parameter SI.TemperatureDifference T_tol_PB = 200.0 "Power block Temperature Tolerance (K)";
  //Level-Controls
  //parameter SI.Time t_stor_startPB = 0.2 * t_storage * 3600.0 "Number of storage seconds stored before TES can start discharging (20% of capacity)";
  parameter Modelica.SIunits.Energy E_max = t_storage * 3600.0 * Q_flow_des "Maximum tank stored energy";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_des = 600.0e6 "Heat to boiler at design";
  parameter Modelica.SIunits.MassFlowRate m_boiler_des = Q_flow_des / (h_air_hot_set - h_air_cold_set);
  //parameter Real ar = 0.48/0.5;
  parameter Modelica.SIunits.Temperature T_hot_set = T_max "Ideal hot temperature";
  parameter Modelica.SIunits.Temperature T_cold_set = T_min "Ideal cold temperature";
  parameter Medium.ThermodynamicState state_air_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold air thermodynamic state at design";
  parameter Medium.ThermodynamicState state_air_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hold air thermodynamic state at design";
  parameter Modelica.SIunits.SpecificEnthalpy h_air_cold_set = Medium.specificEnthalpy(state_air_cold_set) "Cold air specific enthalpy at design";
  parameter Modelica.SIunits.SpecificEnthalpy h_air_hot_set = Medium.specificEnthalpy(state_air_hot_set) "Hot air specific enthalpy at design";
  replaceable package SaltRef = SolarTherm.Media.MoltenSalt.MoltenSalt_ph;
  parameter Medium.ThermodynamicState state_salt_cold_set = SaltRef.setState_pTX(SaltRef.p_default, T_cold_set) "Cold salt thermodynamic state at design";
  parameter Medium.ThermodynamicState state_salt_hot_set = SaltRef.setState_pTX(SaltRef.p_default, T_hot_set) "Hold salt thermodynamic state at design";
  parameter Modelica.SIunits.SpecificEnthalpy h_salt_cold_set = SaltRef.specificEnthalpy(state_salt_cold_set) "Cold salt specific enthalpy at design";
  parameter Modelica.SIunits.SpecificEnthalpy h_salt_hot_set = SaltRef.specificEnthalpy(state_salt_hot_set) "Hot salt specific enthalpy at design";
  parameter Modelica.SIunits.HeatFlowRate Q_start = 1e-3;
  parameter Modelica.SIunits.HeatFlowRate Q_stop = 1e-3;
  Modelica.SIunits.HeatFlowRate Q_scheduled;
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {84, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-71, -26}, extent = {{-9, -12}, {9, 12}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {60, 11}, extent = {{12, -13}, {-12, 13}}, rotation = 0)));
  //inner Modelica.Fluid.System system(T_start = from_degC(290), allowFlowReversal = false, p_start = Medium.p_default) annotation(
  //Placement(visible = true, transformation(origin = {-136, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable scheduler(fileName = schd_input, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, tableName = "Q_flow", tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {184, 38}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.Boiler_Basic Boiler(redeclare package Medium = Medium, T_cold_set = T_cold_set, T_hot_set = T_hot_set) annotation(
    Placement(visible = true, transformation(origin = {162, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable PV_input(fileName = PV_file, tableName = "Power", tableOnFile = true, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation(
    Placement(visible = true, transformation(origin = {-166, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add Grid_Sum(k1 = P_renewable_des * PV_fraction / PV_ref_size, k2 = P_renewable_des * (1.0 - PV_fraction) / Wind_ref_size) annotation(
    Placement(visible = true, transformation(origin = {-106, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable Wind_input(fileName = Wind_file, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, tableName = "Power", tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-166, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.Basic_Heater_Energy Heater(Q_limit = P_renewable_des)  annotation(
    Placement(visible = true, transformation(origin = {-68, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Storage.Thermocline.RadCharge.RadCharge_Tank RadChg_TES(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler ,Correlation = 2, E_max = E_max, H_unit = H_unit, L_char = L_char, N_f = N_f, T_max = T_max, T_min = T_min, T_rad = T_rad, U_loss_tank = U_loss_tank, c_surf = c_surf, eta = eta)  annotation(
    Placement(visible = true, transformation(origin = {3, 11}, extent = {{-47, -47}, {47, 47}}, rotation = 0)));
  SolarTherm.Models.Control.WindPV_RadTESControl windPV_RadTESControl(redeclare package HTF = Medium, Q_des_blk = Q_flow_des, T_PB_min = T_PB_min, T_PB_start = T_PB_start, T_target = T_target, T_top_max = T_top_max, T_top_start = T_top_start, h_target = h_air_hot_set, m_flow_PB_des = m_boiler_des)  annotation(
    Placement(visible = true, transformation(origin = {112, 8}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.mass_loop_breaker mass_loop_breaker annotation(
    Placement(visible = true, transformation(origin = {80, 76}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  der(E_supplied) = Boiler.Q_flow;
  der(E_demand) = windPV_RadTESControl.Q_demand;
  if time > 86400.0 then
    Capacity_Factor = E_supplied / E_demand;
  else
    Capacity_Factor = 0.0;
  end if;
//grid_input.Q_defocus_y = min(gridInput.grid_input.y[1], scheduler.y[1] * (h_salt_hot_set - h_salt_cold_set));
  Q_scheduled = scheduler.y[1] * (h_salt_hot_set - h_salt_cold_set);
  connect(PV_input.y[1], Grid_Sum.u1) annotation(
    Line(points = {{-154, 34}, {-144, 34}, {-144, 24}, {-118, 24}}, color = {0, 0, 127}));
  connect(Wind_input.y[1], Grid_Sum.u2) annotation(
    Line(points = {{-154, 4}, {-142, 4}, {-142, 12}, {-118, 12}}, color = {0, 0, 127}));
  connect(Grid_Sum.y, Heater.Q_heater_raw) annotation(
    Line(points = {{-94, 18}, {-79, 18}}, color = {0, 0, 127}));
  connect(Boiler.fluid_b, pumpCold.fluid_a) annotation(
    Line(points = {{162, -10}, {162, -50}, {94, -50}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, RadChg_TES.fluid_b) annotation(
    Line(points = {{74, -50}, {3, -50}, {3, -27}}, color = {0, 127, 255}));
  connect(p_amb.y, RadChg_TES.p_amb) annotation(
    Line(points = {{47, 11}, {25, 11}}, color = {0, 0, 127}));
  connect(Tamb.y, RadChg_TES.T_amb) annotation(
    Line(points = {{-62, -26}, {-50, -26}, {-50, 3}, {-19, 3}}, color = {0, 0, 127}));
  connect(Heater.Q_heater, RadChg_TES.Q_input) annotation(
    Line(points = {{-56, 18}, {-19, 18}}, color = {0, 0, 127}));
  connect(windPV_RadTESControl.heater_on, Heater.on) annotation(
    Line(points = {{126, 4}, {138, 4}, {138, -78}, {-98, -78}, {-98, 0}, {-68, 0}, {-68, 6}, {-68, 6}}, color = {255, 0, 255}));
  connect(windPV_RadTESControl.m_flow_PB, pumpCold.m_flow) annotation(
    Line(points = {{126, 12}, {144, 12}, {144, -30}, {84, -30}, {84, -42}, {84, -42}}, color = {0, 0, 127}));
  connect(RadChg_TES.T_p_top_measured, windPV_RadTESControl.T_top_tank) annotation(
    Line(points = {{24, 32}, {86, 32}, {86, 10}, {100, 10}, {100, 10}}, color = {0, 0, 127}));
  connect(RadChg_TES.h_top_outlet, windPV_RadTESControl.h_tank_top) annotation(
    Line(points = {{-10, 42}, {-10, 42}, {-10, 58}, {102, 58}, {102, 22}, {102, 22}}, color = {0, 0, 127}));
  connect(Boiler.h_out_signal, windPV_RadTESControl.h_PB_outlet) annotation(
    Line(points = {{153, -7}, {153, -12}, {146, -12}, {146, 36}, {114, 36}, {114, 22}}, color = {0, 0, 127}));
  connect(scheduler.y[1], windPV_RadTESControl.Q_demand) annotation(
    Line(points = {{174, 38}, {164, 38}, {164, 30}, {122, 30}, {122, 22}, {120, 22}}, color = {0, 0, 127}));
  connect(mass_loop_breaker.port_a, RadChg_TES.fluid_a) annotation(
    Line(points = {{68, 76}, {4, 76}, {4, 48}, {4, 48}}, color = {0, 127, 255}));
  connect(mass_loop_breaker.port_b, Boiler.fluid_a) annotation(
    Line(points = {{92, 76}, {162, 76}, {162, 10}, {162, 10}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-200, -100}, {200, 100}}, initialScale = 0.1), graphics = {Text(origin = {83, -66}, extent = {{-11, 2}, {15, -6}}, textString = "Pump"), Text(origin = {-69, 32}, extent = {{-11, 4}, {13, -6}}, textString = "Heater")}),
    Icon(coordinateSystem(extent = {{-200, -100}, {200, 100}}, preserveAspectRatio = false)),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.001, Interval = 300, maxStepSize = 60, initialStepSize = 60));
end WindPVRadChgTESsystem_Air;