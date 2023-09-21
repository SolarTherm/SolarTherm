within SolarTherm.Systems;

model WindPVannularTESsystem_v3_Air_5TSeries
  extends Modelica.Icons.Example;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Constants.*;
  parameter String elec_input = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/heater_input.motab");
  parameter String schd_input = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/schedule_Qflow.motab");
  replaceable package Medium = SolarTherm.Media.Air.Air_amb_p;
  replaceable package Fluid = SolarTherm.Materials.Air_Table;
  replaceable package Filler = SolarTherm.Materials.Concrete_Constant;
  //Results
  SI.Energy E_supplied(start=0) "Energy supplied by the boiler to the industrial process (J)";
  SI.Energy E_demand(start=0) "Energy demanded by the industrial process (J)";
  Real Capacity_Factor(start=0) "Capacity factor of the system";
  
  parameter Integer N_f = 25;
  parameter Integer N_p = 10;
  parameter SI.Length L_pipe = 12.5;
  parameter SI.Length D_pipe = 0.08255;
  parameter SI.Length D_solid = 0.112;
  //0.09003;
  parameter Real U_loss_tank = 0.0;
  parameter Integer Correlation = 2; //1=Liq 2=Air
  //1:Liquid 2:Gas
  parameter Real eff_storage_des = 0.15; //Utilisation
  parameter Modelica.SIunits.Energy E_max = t_storage * 3600.0 * Q_flow_des "Maximum tank stored energy";
  parameter Real stor_oversize_factor = 1;
  parameter Real t_storage(unit = "h") = 10.0*stor_oversize_factor "Hours of storage";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_des = 600.0e6 "Heat to boiler at design";
  parameter Modelica.SIunits.MassFlowRate m_boiler_des = Q_flow_des/(h_air_hot_set-h_air_cold_set);
  //parameter Real ar = 0.48/0.5;
  
  parameter Modelica.SIunits.Temperature T_hot_set = from_degC(600) "Ideal hot temperature";
  parameter Modelica.SIunits.Temperature T_cold_set = from_degC(125) "Ideal cold temperature";
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
  SolarTherm.Models.Storage.Thermocline.Annular.Series.Annular_Storage_SGroup5_SM thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler, N_f = N_f, N_p = N_p, T_max = T_hot_set, T_min = T_cold_set, Correlation = Correlation, E_max = E_max, L_pipe = L_pipe, D_pipe = D_pipe, D_solid = D_solid, U_loss_tank = U_loss_tank) annotation(
    Placement(visible = true, transformation(origin = {32, 2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {10, -64}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction_LoopBreaker Splitter_Top(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {56, 67.6249}, extent = {{-18, -13.9366}, {18, 13.9366}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction Splitter_Bot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {57, -38.5231}, extent = {{17, 0}, {-17, -21.6105}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {91, 77}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {1, 0}, extent = {{-9, -12}, {9, 12}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {107, 2.22045e-16}, extent = {{11, -12}, {-11, 12}}, rotation = 0)));
  //inner Modelica.Fluid.System system(T_start = from_degC(290), allowFlowReversal = false, p_start = Medium.p_default) annotation(
    //Placement(visible = true, transformation(origin = {-136, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.WindPV_TESControl_v3 Control(redeclare package HTF = Medium, E_max = E_max, Q_des_blk = Q_flow_des, T_PB_min = T_hot_set - 150, T_PB_start = T_hot_set - 75, T_recv_max = T_cold_set + 300, T_recv_start = T_cold_set + 150, T_target = T_hot_set, eff_storage_des = eff_storage_des, h_target = h_air_hot_set, level_mid = 0.6439, m_0 = 1e-8, m_flow_PB_des = m_boiler_des, m_min = 1e-8, m_tol = 0.001 * m_boiler_des, t_stor_startPB = 2.0 * 3600.0, t_wait = 2.0 * 3600.0)  annotation(
    Placement(visible = true, transformation(origin = {114, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable scheduler(fileName = schd_input, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, tableName = "Q_flow", tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {184, 38}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.Boiler_Basic Boiler(redeclare package Medium = Medium, T_cold_set = T_cold_set, T_hot_set = T_hot_set) annotation(
    Placement(visible = true, transformation(origin = {158, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.Basic_Heater basic_Heater(redeclare package Medium = Medium, T_cold_set = T_cold_set, T_hot_set = T_hot_set) annotation(
    Placement(visible = true, transformation(origin = {-46, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable grid_input(fileName = elec_input, tableName = "p_pelec", tableOnFile = true, smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation(
    Placement(visible = true, transformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
    Line(points = {{32, -28}, {32, -56.5}, {57, -56.5}, {57, -54}}, color = {0, 127, 255}));
  connect(Tamb.y, thermocline_Tank.T_amb) annotation(
    Line(points = {{11, 0}, {11, 1}, {15, 1}, {15, 2}}, color = {0, 0, 127}));
  connect(p_amb.y, thermocline_Tank.p_amb) annotation(
    Line(points = {{95, 0}, {73, 0}, {73, 2}, {49, 2}}, color = {0, 0, 127}));
  connect(Splitter_Bot.fluid_b, pumpCold.fluid_a) annotation(
    Line(points = {{43, -72}, {33.5, -72}, {33.5, -64}, {20, -64}}, color = {0, 127, 255}));
  connect(thermocline_Tank.h_bot_outlet, Control.h_tank_outlet) annotation(
    Line(points = {{22, -24}, {22, -32}, {86, -32}, {86, 60}, {110, 60}, {110, 37}}, color = {0, 0, 127}));
  connect(thermocline_Tank.T_top_measured, Control.T_top_tank) annotation(
    Line(points = {{49, 23}, {78, 23}, {78, 24}, {103, 24}}, color = {0, 0, 127}));
  connect(thermocline_Tank.T_bot_measured, Control.T_bot_tank) annotation(
    Line(points = {{49, -20}, {82, -20}, {82, 20}, {103, 20}}, color = {0, 0, 127}));
  connect(thermocline_Tank.Level, Control.Level) annotation(
    Line(points = {{49, 10}, {90, 10}, {90, 28}, {103, 28}, {103, 29}}, color = {0, 0, 127}));
  connect(Splitter_Top.fluid_c, thermocline_Tank.fluid_a) annotation(
    Line(points = {{56, 67}, {56, 48.5}, {32, 48.5}, {32, 32}}, color = {0, 127, 255}));
  connect(Splitter_Top.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{71, 79}, {82, 79}, {82, 76}}, color = {0, 127, 255}));
  connect(Boiler.h_out_signal, Control.h_PB_outlet) annotation(
    Line(points = {{149, -7}, {149, -12}, {138, -12}, {138, 74}, {115, 74}, {115, 37}}, color = {0, 0, 127}));
  connect(Boiler.fluid_b, Splitter_Bot.fluid_a) annotation(
    Line(points = {{158, -10}, {158, -10}, {158, -72}, {70, -72}, {70, -72}}, color = {0, 127, 255}));
  connect(pumpHot.fluid_b, Boiler.fluid_a) annotation(
    Line(points = {{100, 78}, {158, 78}, {158, 10}, {158, 10}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, basic_Heater.fluid_a) annotation(
    Line(points = {{0, -64}, {-46, -64}, {-46, -3}}, color = {0, 127, 255}));
  connect(basic_Heater.fluid_b, Splitter_Top.fluid_a) annotation(
    Line(points = {{-46, 15}, {-46, 78}, {42, 78}}, color = {0, 127, 255}));
  connect(Control.Q_rcv_raw, basic_Heater.Q_heater_raw) annotation(
    Line(points = {{104, 32}, {-24, 32}, {-24, 13}, {-35, 13}}, color = {0, 0, 127}));
  connect(Control.curtail, basic_Heater.curtail) annotation(
    Line(points = {{126, 22}, {128, 22}, {128, -36}, {-68, -36}, {-68, -2}, {-58, -2}}, color = {255, 0, 255}));
  connect(Control.Q_curtail, basic_Heater.Q_curtail) annotation(
    Line(points = {{104, 18}, {-12, 18}, {-12, -12}, {-72, -12}, {-72, 2}, {-58, 2}, {-58, 0}}, color = {0, 0, 127}));
  connect(grid_input.y[1], basic_Heater.P_supply) annotation(
    Line(points = {{-98, 10}, {-82, 10}, {-82, 6}, {-58, 6}, {-58, 6}}, color = {0, 0, 127}));
  connect(Control.m_flow_PB, pumpHot.m_flow) annotation(
    Line(points = {{126, 26}, {132, 26}, {132, 98}, {90, 98}, {90, 84}, {92, 84}}, color = {0, 0, 127}));
  connect(Control.m_flow_recv, pumpCold.m_flow) annotation(
    Line(points = {{126, 32}, {136, 32}, {136, -48}, {10, -48}, {10, -56}, {10, -56}}, color = {0, 0, 127}));
  connect(scheduler.y[1], Control.Q_demand) annotation(
    Line(points = {{174, 38}, {166, 38}, {166, 56}, {120, 56}, {120, 38}, {122, 38}}, color = {0, 0, 127}));
  connect(thermocline_Tank.h_top_outlet, Control.h_tank_top) annotation(
    Line(points = {{22, 27}, {22, 48}, {106, 48}, {106, 38}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-200, -100}, {200, 100}}, initialScale = 0.1), graphics = {Text(origin = {85, 68}, extent = {{-11, 4}, {23, -10}}, textString = "Hot Pump"), Text(origin = {7, -78}, extent = {{-11, 4}, {23, -10}}, textString = "Cold Pump"), Text(origin = {-49, -8}, extent = {{-11, 4}, {13, -6}}, textString = "Heater")}),
    Icon(coordinateSystem(extent = {{-200, -100}, {200, 100}}, preserveAspectRatio = false)), experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.001, Interval = 300, maxStepSize = 60, initialStepSize = 60));
end WindPVannularTESsystem_v3_Air_5TSeries;