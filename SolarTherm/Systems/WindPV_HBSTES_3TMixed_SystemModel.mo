within SolarTherm.Systems;

model WindPV_HBSTES_3TMixed_SystemModel "Generic system model with WindPV input, Annular TES component and a boiler"
  //Total simulation time = 8448s, Capacity Factor = 98.58%, Total annual heat delivered = 774.4 GWh
  extends Modelica.Icons.Example;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Constants.*;
  parameter String PV_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Renewable/dummy_pv.motab");
  parameter String Wind_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Renewable/dummy_wind.motab");
  parameter String schd_input = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/schedule_Qflow_Calciner.motab");
  replaceable package Medium = SolarTherm.Media.Air.Air_amb_p_curvefit;
  replaceable package Fluid = SolarTherm.Materials.Air_amb_p_curvefit;
  replaceable package Filler = SolarTherm.Materials.Mullite_20pct_porosity;
  //Parameter Inputs
  parameter Real RM = 2.0 "Renewable Multiple (pre-transmission oversizing)";
  parameter Real HM = 2.0 "Heater Multiple";
  parameter Real PV_fraction = 0.5 "PV_fraction";
  parameter Real t_storage = 10.00 "Hours of storage (hours)";
  parameter Real util_storage_des = 0.6386;
  //Utilisation determined via component-level analysis 0.5767
  parameter Real level_storage_mid = 0.4914;
  //Midpoint of minimum and maximum storage levels determine via component-level analysis 0.4637
  parameter SI.SpecificEnthalpy h_tol = 0.05 * (TES.Tank_A.h_f_max - TES.Tank_A.h_f_min);
  //Heater Parameters
  parameter Real eff_heater = 1.00 "Electrical-to-heat conversion efficiency of the heater";
  //Renewable Parameters
  parameter SI.Power P_renewable_des = RM * P_heater_des;
  parameter SI.HeatFlowRate Q_heater_des = HM * Q_boiler_des;
  parameter SI.Power P_heater_des = Q_heater_des / eff_heater;
  parameter SI.Power PV_ref_size = 50.0e6;
  parameter SI.Power Wind_ref_size = 50.0e6;
  //Results
  SI.Energy E_supplied(start = 0) "Energy supplied by the boiler to the industrial process (J)";
  SI.Energy E_demand(start = 0) "Energy demanded by the industrial process (J)";
  Real Capacity_Factor(start = 0) "Capacity factor of the system";
  //Discretisation and geometry
  parameter Integer N_f = 25;
  //50
  parameter Integer N_p = 5;
  parameter SI.Length d_p = 0.02 "Diameter of holes (m)";
  parameter SI.Length s_p = 0.04 "Separation of holes (m)";
  //parameter SI.Length L_pipe = 50.0;
  //parameter SI.Length D_pipe = 0.050;
  //parameter SI.Length D_solid = 0.075;
  //Misc Parameters
  parameter Real U_loss_tank = 0.0;
  parameter Integer Correlation = 1;
  //1=Liq 2=Air
  /*
    parameter SI.Temperature T_max = 1100.0 + 273.15 "Maximum temperature (K)";
    parameter SI.Temperature T_process_des = 1000.0 + 273.15 "Design process inlet temperature (K)";
    parameter SI.Temperature T_high_set = 1000.0 + 273.15 "TES hot blend temperature temperature (K)";
    parameter SI.Temperature T_process_min = 1000.0 + 273.15 "Minimum tolerated outlet temperature to process (K)";
    parameter SI.Temperature T_heater_max = 740.0 + 273.15 "Maximum tolerated outlet temperature to heater (K)";
    parameter SI.Temperature T_low_set = 740.0 + 273.15 "TES cold blend temperature (K)";
    parameter SI.Temperature T_heater_des = 640.0 + 273.15 "Design receiver inlet temperature (K)";
    
    parameter SI.Temperature T_max = 500.0 + 273.15 "Maximum system temperature (K)";
    parameter SI.Temperature T_boiler_start = 400.0 + 273.15 "Temperature above-which TES can start discharge (K)"; //50K buffer
    parameter SI.Temperature T_boiler_min = 350.0 + 273.15 "Temperature below-which TES stops discharge (K)";
    parameter SI.Temperature T_heater_max = 300.0 + 273.15 "Temperature above-which TES stops charging (K)";
    parameter SI.Temperature T_heater_start = 250.0 + 273.15 "Temperature below-which TES can start charging (K)"; //50k buffer
    parameter SI.Temperature T_min = 150.0 + 273.15 "Minimum system temperature (K)";
      //Legacy terms from the CSP field. PB (power block) refers to the boiler, Recv (receiver) refers to the electric heater.
    */
  //Temperature Controls
  parameter SI.Temperature T_max = 1100.0 + 273.15 "Maximum system temperature (K)";
  parameter SI.Temperature T_boiler_start = 1050.0 + 273.15 "Temperature above-which TES can start discharge (K)";
  //50K buffer
  parameter SI.Temperature T_boiler_min = 1000.0 + 273.15 "Temperature below-which TES stops discharge (K)";
  parameter SI.Temperature T_process_des = 1000.0 + 273.15 "Design process inlet temperature (K)";
  parameter SI.Temperature T_heater_max = 740.0 + 273.15 "Temperature above-which TES stops charging (K)";
  parameter SI.Temperature T_heater_des = 740.0 + 273.15 "Design receiver inlet temperature (K)";
  parameter SI.Temperature T_heater_start = 690.0 + 273.15 "Temperature below-which TES can start charging (K)";
  //50k buffer
  parameter SI.Temperature T_min = 640.0 + 273.15 "Minimum system temperature (K)";
  //Legacy terms from the CSP field. PB (power block) refers to the boiler, Recv (receiver) refers to the electric heater.
  //Level-Controls
  parameter SI.Time t_stor_start_dis = 1.0 * 3600.0 "Number of effective storage seconds stored before TES can start discharging (1 hour)";
  //Calculated Parameters
  parameter Modelica.SIunits.Energy E_max = t_storage * 3600.0 * Q_boiler_des "Maximum tank stored energy (J)";
  parameter Modelica.SIunits.HeatFlowRate Q_boiler_des = 15.03e6 "Heat-rate to boiler at design (W)";
  parameter Modelica.SIunits.MassFlowRate m_boiler_des = Q_boiler_des / (h_air_hot_set - h_air_cold_set) "Design boiler input mass flow rate";
  parameter Modelica.SIunits.Temperature T_hot_set = T_max "Ideal hot temperature of the system";
  parameter Modelica.SIunits.Temperature T_cold_set = T_min "Ideal cold temperature of the system";
  parameter Medium.ThermodynamicState state_air_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold air thermodynamic state at design";
  parameter Medium.ThermodynamicState state_air_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hold air thermodynamic state at design";
  parameter Modelica.SIunits.SpecificEnthalpy h_air_cold_set = Medium.specificEnthalpy(state_air_cold_set) "Cold air specific enthalpy at design";
  parameter Modelica.SIunits.SpecificEnthalpy h_air_hot_set = Medium.specificEnthalpy(state_air_hot_set) "Hot air specific enthalpy at design";
  SolarTherm.Models.Storage.Thermocline.Parallel.Thermocline_HBS_LC_3P_MixedOutlet TES(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package_A = Filler, redeclare package Filler_Package_B = Filler, redeclare package Filler_Package_C = Filler, N_f_A = N_f, T_max = T_hot_set, T_min = T_cold_set, T_recv_set = T_heater_des, T_PB_set = T_process_des, Correlation = Correlation, E_max = E_max, d_p_A = d_p, s_p_A = s_p, U_loss_tank_A = U_loss_tank, frac_1 = 1.0 / 3.0, h_tol = h_tol) annotation(
    Placement(visible = true, transformation(origin = {32, 0}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-18, -78}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction_LoopBreaker Splitter_Top(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {32, 67.6249}, extent = {{-18, -13.9366}, {18, 13.9366}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction Splitter_Bot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {31, -43.8998}, extent = {{17, 0}, {-17, -22.039}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {91, 79}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {1, 0}, extent = {{-9, -12}, {9, 12}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {107, 2.22045e-16}, extent = {{11, -12}, {-11, 12}}, rotation = 0)));
  SolarTherm.Models.Control.WindPV_Thermocline_Control Control(redeclare package HTF = Medium, E_max = E_max, Q_boiler_des = Q_boiler_des, T_boiler_min = T_boiler_min, T_boiler_start = T_boiler_start, T_heater_max = T_heater_max, T_heater_start = T_heater_start, T_target = T_max, util_storage_des = util_storage_des, h_target = h_air_hot_set, level_mid = level_storage_mid, m_0 = 1e-8, m_boiler_des = m_boiler_des, m_min = 1e-8, m_tol = 0.01 * m_boiler_des, t_stor_start_dis = t_stor_start_dis, t_wait = 1.0 * 3600.0) annotation(
    Placement(visible = true, transformation(origin = {114, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.Boiler_Basic Process(redeclare package Medium = Medium, T_cold_set = T_cold_set, T_hot_set = T_hot_set) annotation(
    Placement(visible = true, transformation(origin = {158, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.Basic_Heater basic_Heater(redeclare package Medium = Medium, P_heater_des = P_heater_des, Q_heater_des = Q_heater_des, eff_heater = eff_heater, T_cold_set = T_cold_set, T_hot_set = T_hot_set) annotation(
    Placement(visible = true, transformation(origin = {-46, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable PV_input(fileName = PV_file, tableName = "Power", tableOnFile = true, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation(
    Placement(visible = true, transformation(origin = {-124, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add Grid_Sum(k1 = P_renewable_des * PV_fraction / PV_ref_size, k2 = P_renewable_des * (1.0 - PV_fraction) / Wind_ref_size) annotation(
    Placement(visible = true, transformation(origin = {-84, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable Wind_input(fileName = Wind_file, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, tableName = "Power", tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-124, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression ConstantDemand(y = Q_boiler_des) annotation(
    Placement(visible = true, transformation(origin = {180, 42}, extent = {{16, -10}, {-16, 10}}, rotation = 0)));
equation
  der(E_supplied) = Process.Q_flow;
  der(E_demand) = Control.Q_demand;
  if time > 86400.0 then
    Capacity_Factor = E_supplied / E_demand;
  else
    Capacity_Factor = 0.0;
  end if;
//grid_input.Q_defocus_y = min(gridInput.grid_input.y[1], scheduler.y[1] * (h_salt_hot_set - h_salt_cold_set));
  connect(TES.fluid_b, Splitter_Bot.fluid_c) annotation(
    Line(points = {{32, -30}, {32, -56.5}, {31, -56.5}, {31, -60}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Tamb.y, TES.T_amb) annotation(
    Line(points = {{11, 0}, {15, 0}}, color = {0, 0, 127}));
  connect(p_amb.y, TES.p_amb) annotation(
    Line(points = {{95, 0}, {49, 0}}, color = {0, 0, 127}));
  connect(Splitter_Bot.fluid_b, pumpCold.fluid_a) annotation(
    Line(points = {{17, -78}, {-8, -78}}, color = {0, 127, 255}, thickness = 0.5));
  connect(TES.T_top_measured, Control.T_top_tank) annotation(
    Line(points = {{49, 21}, {78, 21}, {78, 24}, {103, 24}}, color = {0, 0, 127}));
  connect(TES.T_bot_measured, Control.T_bot_tank) annotation(
    Line(points = {{49, -21}, {82, -21}, {82, 20}, {103, 20}}, color = {0, 0, 127}));
  connect(TES.Level, Control.Level) annotation(
    Line(points = {{49, 8}, {90, 8}, {90, 28}, {103, 28}, {103, 29}}, color = {0, 0, 127}));
  connect(Splitter_Top.fluid_c, TES.fluid_a) annotation(
    Line(points = {{32, 67}, {32, 30}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Splitter_Top.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{47, 79}, {82, 79}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Process.fluid_b, Splitter_Bot.fluid_a) annotation(
    Line(points = {{158, -10}, {158, -78}, {45, -78}}, color = {0, 127, 255}, thickness = 0.5));
  connect(pumpHot.fluid_b, Process.fluid_a) annotation(
    Line(points = {{100, 79}, {158, 79}, {158, 10}}, color = {0, 127, 255}, thickness = 0.5));
  connect(pumpCold.fluid_b, basic_Heater.fluid_a) annotation(
    Line(points = {{-28, -78}, {-46, -78}, {-46, 1}}, color = {0, 127, 255}, thickness = 0.5));
  connect(basic_Heater.fluid_b, Splitter_Top.fluid_a) annotation(
    Line(points = {{-46, 19}, {-46, 79}, {18, 79}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Control.curtail, basic_Heater.curtail) annotation(
    Line(points = {{125, 22}, {128, 22}, {128, -36}, {-68, -36}, {-68, 1}, {-57, 1}}, color = {255, 0, 255}));
  connect(Control.Q_curtail, basic_Heater.Q_curtail) annotation(
    Line(points = {{103, 17}, {-10, 17}, {-10, -12}, {-72, -12}, {-72, 2}, {-57, 2}, {-57, 5}}, color = {0, 0, 127}));
  connect(TES.h_top_outlet, Control.h_tank_top) annotation(
    Line(points = {{22, 25}, {22, 46}, {105, 46}, {105, 37}}, color = {0, 0, 127}));
  connect(PV_input.y[1], Grid_Sum.u1) annotation(
    Line(points = {{-113, 34}, {-104, 34}, {-104, 24}, {-96, 24}}, color = {0, 0, 127}));
  connect(Wind_input.y[1], Grid_Sum.u2) annotation(
    Line(points = {{-113, 4}, {-104, 4}, {-104, 12}, {-96, 12}}, color = {0, 0, 127}));
  connect(Grid_Sum.y, basic_Heater.P_supply) annotation(
    Line(points = {{-73, 18}, {-66, 18}, {-66, 10}, {-57, 10}}, color = {0, 0, 127}));
  connect(Process.h_out_signal, Control.h_boiler_outlet) annotation(
    Line(points = {{148, -8}, {136, -8}, {136, 52}, {116, 52}, {116, 38}, {116, 38}}, color = {0, 0, 127}));
  connect(TES.h_bot_outlet, Control.h_tank_bot) annotation(
    Line(points = {{22, -25}, {22, -30}, {132, -30}, {132, 46}, {110, 46}, {110, 38}}, color = {0, 0, 127}));
  connect(basic_Heater.Q_heater_raw, Control.Q_heater_raw) annotation(
    Line(points = {{-34, 10}, {-20, 10}, {-20, 52}, {86, 52}, {86, 32}, {104, 32}, {104, 32}}, color = {0, 0, 127}));
  connect(Control.m_heater_signal, pumpCold.m_flow) annotation(
    Line(points = {{126, 32}, {140, 32}, {140, -58}, {-18, -58}, {-18, -70}, {-18, -70}}, color = {0, 0, 127}));
  connect(Control.m_boiler_signal, pumpHot.m_flow) annotation(
    Line(points = {{126, 26}, {130, 26}, {130, 94}, {90, 94}, {90, 86}, {92, 86}}, color = {0, 0, 127}));
  connect(Control.Q_demand, ConstantDemand.y) annotation(
    Line(points = {{122, 38}, {122, 42}, {162, 42}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-200, -100}, {200, 100}}, initialScale = 0.1), graphics = {Text(origin = {-51, -4}, extent = {{-11, 4}, {13, -6}}, textString = "Heater")}),
    Icon(coordinateSystem(extent = {{-200, -100}, {200, 100}}, preserveAspectRatio = false)),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 1.0e-5, Interval = 300, maxStepSize = 60, initialStepSize = 60));
end WindPV_HBSTES_3TMixed_SystemModel;