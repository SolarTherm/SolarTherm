within SolarTherm.Systems;

model WindPVannularTESsystem_v3_Air
  extends Modelica.Icons.Example;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Constants.*;
  parameter String PV_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/pv_gen_Gladstone_1MWe.motab");
  parameter String Wind_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/wind_gen_Gladstone320MWe.motab");
  parameter String schd_input = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/schedule_Qflow_5min.motab");
  //parameter String schd_input = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/schedule_Qflow_minute.motab");
  replaceable package Medium = SolarTherm.Media.Air.Air_amb_p_curvefit;
  replaceable package Fluid = SolarTherm.Materials.Air_amb_p_curvefit;
  replaceable package Filler = SolarTherm.Materials.Concrete_Constant;
  //Inputs
  parameter Real RM = 2.0 "Renewable Multiple (pre-transmission oversizing)";
  parameter Real HM = 2.2 "Heater Multiple";
  parameter Real PV_fraction = 0.2 "PV_fraction";
  parameter Real t_storage = 20.00 "Hours of storage (hours)";
  parameter Real util_storage_des = 0.5385; //Utilisation determined via component-level analysis
  parameter Real level_storage_mid = 0.5997; //Midpoint of minimum and maximum storage levels determine via component-level analysis
  
  //Heater parameters
  parameter Real eff_heater = 0.99 "Electrical-to-heat conversion efficiency of the heater";
  
  //Renewable Parameters
  parameter SI.Power P_renewable_des = RM*P_heater_des;
  parameter SI.HeatFlowRate Q_heater_des = HM*Q_boiler_des;
  parameter SI.Power P_heater_des = Q_heater_des/eff_heater;
  parameter SI.Power PV_ref_size = 1.0e6;
  parameter SI.Power Wind_ref_size = 320.0e6;
  //Results
  SI.Energy E_supplied(start=0) "Energy supplied by the boiler to the industrial process (J)";
  SI.Energy E_demand(start=0) "Energy demanded by the industrial process (J)";
  Real Capacity_Factor(start=0) "Capacity factor of the system";
  
  //Discretisation and geometry
  parameter Integer N_f = 50;
  parameter Integer N_p = 5;
  parameter SI.Length L_pipe = 60.0;
  parameter SI.Length D_pipe = 0.08;
  parameter SI.Length D_solid = 0.12; 
  
 
  //Misc Parameters
  parameter Real U_loss_tank = 0.0;
  parameter Integer Correlation = 2; //1=Liq 2=Air
  
  //Temperature Controls
  parameter SI.Temperature T_max = 600.0 + 273.15 "Maximum temperature";
  parameter SI.Temperature T_PB_start = 525.0 + 273.15 "Temperature at which TES can start being discharged"; //halfway between
  parameter SI.Temperature T_PB_min = 475.0 + 273.15 "Minimum tolerated outlet temperature to PB";
  parameter SI.Temperature T_Recv_max = 450.0 + 273.15 "Maximum tolerated outlet temperature to recv";
  parameter SI.Temperature T_Recv_start = 400.0 + 273.15 "Temperature at which TES can start being charged"; //halfway between
  parameter SI.Temperature T_min = 175.0 + 273.15 "Minimum temperature";

  //Level-Controls
  parameter SI.Time t_stor_startPB = 1.0*3600.0 "Number of storage seconds stored before TES can start discharging (1 hour)";  
  //parameter SI.Time t_stor_startPB = 0.2*t_storage*3600.0 "Number of storage seconds stored before TES can start discharging (20% of capacity)"; 

  parameter Modelica.SIunits.Energy E_max = t_storage * 3600.0 * Q_boiler_des "Maximum tank stored energy";
  
  parameter Modelica.SIunits.HeatFlowRate Q_boiler_des = 600.0e6 "Heat to boiler at design";
  parameter Modelica.SIunits.MassFlowRate m_boiler_des = Q_boiler_des/(h_air_hot_set-h_air_cold_set);
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
  SolarTherm.Models.Storage.Thermocline.Annular.Thermocline_Annular_SingleTank_SM thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler, N_f = N_f, N_p = N_p, T_max = T_hot_set, T_min = T_cold_set, Correlation = Correlation, E_max = E_max, L_pipe = L_pipe, D_pipe = D_pipe, D_solid = D_solid, U_loss_tank = U_loss_tank) annotation(
    Placement(visible = true, transformation(origin = {32, 2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-18, -78}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction_LoopBreaker Splitter_Top(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {32, 67.6249}, extent = {{-18, -13.9366}, {18, 13.9366}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction Splitter_Bot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {31, -43.8998}, extent = {{17, 0}, {-17, -22.039}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {91, 77}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {1, 0}, extent = {{-9, -12}, {9, 12}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {107, 2.22045e-16}, extent = {{11, -12}, {-11, 12}}, rotation = 0)));
  //inner Modelica.Fluid.System system(T_start = from_degC(290), allowFlowReversal = false, p_start = Medium.p_default) annotation(
    //Placement(visible = true, transformation(origin = {-136, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.WindPV_TESControl_v3 Control(redeclare package HTF = Medium, E_max = E_max, Q_des_blk = Q_boiler_des, T_PB_min = T_PB_min, T_PB_start = T_PB_start, T_recv_max = T_Recv_max, T_recv_start = T_Recv_start, T_target = T_max, eff_storage_des = util_storage_des, h_target = h_air_hot_set, level_mid = level_storage_mid, m_0 = 1e-8, m_flow_PB_des = m_boiler_des, m_min = 1e-8, m_tol = 0.001 * m_boiler_des, t_stor_startPB = t_stor_startPB, t_wait = 1.0 * 3600.0)  annotation(
    Placement(visible = true, transformation(origin = {114, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable scheduler(fileName = schd_input, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, tableName = "Q_flow", tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {184, 38}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.Boiler_Basic Boiler(redeclare package Medium = Medium, T_cold_set = T_cold_set, T_hot_set = T_hot_set) annotation(
    Placement(visible = true, transformation(origin = {158, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.Basic_Heater basic_Heater(redeclare package Medium = Medium, P_heater_des = P_heater_des, Q_heater_des = Q_heater_des, eff_heater = eff_heater, T_cold_set = T_cold_set, T_hot_set = T_hot_set) annotation(
    Placement(visible = true, transformation(origin = {-46, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable PV_input(fileName = PV_file, tableName = "Power", tableOnFile = true, smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation(
    Placement(visible = true, transformation(origin = {-124, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add Grid_Sum(k1 =  P_renewable_des *PV_fraction / PV_ref_size, k2 =  P_renewable_des *(1.0 - PV_fraction) / Wind_ref_size)  annotation(
    Placement(visible = true, transformation(origin = {-84, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable Wind_input(fileName = Wind_file, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, tableName = "Power", tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-124, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  der(E_supplied) = Boiler.Q_flow;
  der(E_demand) = Control.Q_demand;
  if time > 86400.0 then
    Capacity_Factor = E_supplied/E_demand;
  else
    Capacity_Factor = 0.0;
  end if;
//grid_input.Q_defocus_y = min(gridInput.grid_input.y[1], scheduler.y[1] * (h_salt_hot_set - h_salt_cold_set));
  Q_scheduled = scheduler.y[1] * (h_salt_hot_set - h_salt_cold_set);
  connect(thermocline_Tank.fluid_b, Splitter_Bot.fluid_c) annotation(
    Line(points = {{32, -28}, {32, -56.5}, {31, -56.5}, {31, -60}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Tamb.y, thermocline_Tank.T_amb) annotation(
    Line(points = {{11, 0}, {11, 1}, {15, 1}, {15, 2}}, color = {0, 0, 127}));
  connect(p_amb.y, thermocline_Tank.p_amb) annotation(
    Line(points = {{95, 0}, {73, 0}, {73, 2}, {49, 2}}, color = {0, 0, 127}));
  connect(Splitter_Bot.fluid_b, pumpCold.fluid_a) annotation(
    Line(points = {{17, -78}, {-8, -78}}, color = {0, 127, 255}, thickness = 0.5));
  connect(thermocline_Tank.h_bot_outlet, Control.h_tank_outlet) annotation(
    Line(points = {{22, -24}, {22, -32}, {86, -32}, {86, 60}, {110, 60}, {110, 39}}, color = {0, 0, 127}));
  connect(thermocline_Tank.T_top_measured, Control.T_top_tank) annotation(
    Line(points = {{49, 23}, {78, 23}, {78, 26}, {103, 26}}, color = {0, 0, 127}));
  connect(thermocline_Tank.T_bot_measured, Control.T_bot_tank) annotation(
    Line(points = {{49, -20}, {82, -20}, {82, 22}, {103, 22}}, color = {0, 0, 127}));
  connect(thermocline_Tank.Level, Control.Level) annotation(
    Line(points = {{49, 10}, {90, 10}, {90, 28}, {103, 28}, {103, 31}}, color = {0, 0, 127}));
  connect(Splitter_Top.fluid_c, thermocline_Tank.fluid_a) annotation(
    Line(points = {{32, 67}, {32, 32}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Splitter_Top.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{47, 79}, {82, 79}, {82, 76}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Boiler.h_out_signal, Control.h_PB_outlet) annotation(
    Line(points = {{149, -7}, {149, -12}, {138, -12}, {138, 74}, {115, 74}, {115, 39}}, color = {0, 0, 127}));
  connect(Boiler.fluid_b, Splitter_Bot.fluid_a) annotation(
    Line(points = {{158, -10}, {158, -78}, {45, -78}}, color = {0, 127, 255}, thickness = 0.5));
  connect(pumpHot.fluid_b, Boiler.fluid_a) annotation(
    Line(points = {{100, 78}, {158, 78}, {158, 10}, {158, 10}}, color = {0, 127, 255}, thickness = 0.5));
  connect(pumpCold.fluid_b, basic_Heater.fluid_a) annotation(
    Line(points = {{-28, -78}, {-46, -78}, {-46, -3}}, color = {0, 127, 255}, thickness = 0.5));
  connect(basic_Heater.fluid_b, Splitter_Top.fluid_a) annotation(
    Line(points = {{-46, 15}, {-46, 79}, {18, 79}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Control.Q_rcv_raw, basic_Heater.Q_heater_raw) annotation(
    Line(points = {{103, 35}, {-24, 35}, {-24, 13}, {-35, 13}}, color = {0, 0, 127}));
  connect(Control.curtail, basic_Heater.curtail) annotation(
    Line(points = {{125, 24}, {128, 24}, {128, -36}, {-68, -36}, {-68, -2}, {-58, -2}}, color = {255, 0, 255}));
  connect(Control.Q_curtail, basic_Heater.Q_curtail) annotation(
    Line(points = {{103, 19}, {45.5, 19}, {45.5, 15}, {-10, 15}, {-10, -12}, {-72, -12}, {-72, 2}, {-58, 2}, {-58, 0}}, color = {0, 0, 127}));
  connect(Control.m_flow_PB, pumpHot.m_flow) annotation(
    Line(points = {{125, 29}, {132, 29}, {132, 98}, {90, 98}, {90, 84}, {92, 84}}, color = {0, 0, 127}));
  connect(Control.m_flow_recv, pumpCold.m_flow) annotation(
    Line(points = {{125, 34}, {136, 34}, {136, -48}, {-18, -48}, {-18, -69}}, color = {0, 0, 127}));
  connect(scheduler.y[1], Control.Q_demand) annotation(
    Line(points = {{174, 38}, {166, 38}, {166, 56}, {120, 56}, {120, 39}, {121, 39}}, color = {0, 0, 127}));
  connect(thermocline_Tank.h_top_outlet, Control.h_tank_top) annotation(
    Line(points = {{22, 27}, {22, 46}, {105, 46}, {105, 39}}, color = {0, 0, 127}));
  connect(PV_input.y[1], Grid_Sum.u1) annotation(
    Line(points = {{-113, 34}, {-104, 34}, {-104, 24}, {-96, 24}}, color = {0, 0, 127}));
  connect(Wind_input.y[1], Grid_Sum.u2) annotation(
    Line(points = {{-113, 4}, {-104, 4}, {-104, 12}, {-96, 12}}, color = {0, 0, 127}));
  connect(Grid_Sum.y, basic_Heater.P_supply) annotation(
    Line(points = {{-73, 18}, {-66, 18}, {-66, 6}, {-58, 6}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-200, -100}, {200, 100}}, initialScale = 0.1), graphics = {Text(origin = {85, 68}, extent = {{-11, 4}, {23, -10}}, textString = "Hot Pump"), Text(origin = {-21, -90}, extent = {{-11, 4}, {23, -10}}, textString = "Cold Pump"), Text(origin = {-29, 0}, extent = {{-11, 4}, {13, -6}}, textString = "Heater")}),
    Icon(coordinateSystem(extent = {{-200, -100}, {200, 100}}, preserveAspectRatio = false)), experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 1.0e-6, Interval = 300, maxStepSize = 60, initialStepSize = 60));
end WindPVannularTESsystem_v3_Air;