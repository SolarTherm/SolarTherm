within SolarTherm.Systems.Examples;

model Direct2T_SystemLevel
  extends Modelica.Icons.Example;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  parameter String PV_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Renewable/Normalised/PV_Pilbara.motab");
  parameter String Wind_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Renewable/Normalised/Wind_Pilbara.motab");
  parameter String schd_input = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/schedule_Qflow_Calciner.motab");
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph;
  replaceable package Fluid_Package = SolarTherm.Materials.SolarSalt;
  //Parameter Inputs
  parameter Real RM = 2.0 "Renewable Multiple (pre-transmission oversizing)";
  parameter Real HM = 2.0 "Heater Multiple";
  parameter Real PV_fraction = 0.5 "PV_fraction";
  parameter SI.Time t_storage = 4.0 * 3600.0 "Seconds of storage (s)";
  //Heater Parameters
  parameter Real eff_heater = 0.95 "Electrical-to-heat conversion efficiency of the heater";
  //parameter SI.Pressure p_high = 122000.0 "Blower outlet pressure assuming pressure drop of ~3psig (Pa)";
  //Renewable Parameters
  parameter SI.Power P_renewable_des = RM * P_heater_des;
  parameter SI.HeatFlowRate Q_flow_heater_des = HM * Q_flow_output_des;
  parameter SI.Power P_heater_des = Q_flow_heater_des / eff_heater;
  parameter SI.Power PV_ref_size = 1.0;
  //Already Normalised
  parameter SI.Power Wind_ref_size = 1.0;
  //Already Normalised
  parameter Real LOF_PV = 1.300;
  parameter Real LOF_Wind = 1.131;
  parameter SI.Power P_wind_net = (1.0 - PV_fraction) * P_renewable_des;
  parameter SI.Power P_PV_net = PV_fraction * P_renewable_des;
  parameter SI.Power P_wind_gross = P_wind_net * LOF_Wind;
  parameter SI.Power P_PV_gross = P_PV_net * LOF_PV;
  //Temperature Controls
  parameter SI.Temperature T_max = 574.0 + 273.15 "Maximum system temperature, also heater outlet temperature (K)";
  parameter SI.Temperature T_tank_hot_set = 500.0 + 273.15 "Hot tank fluid temperature below-which auxiliary heater is activated (K)";
  parameter SI.Temperature T_output_des = 500.0 + 273.15 "Design output temperature of the system, blended down to this temperature if needed (K)";
  parameter SI.Temperature T_min = 290.0 + 273.15 "Minimum system temperature, also cold return temperature back into the system (K)";
  parameter SI.Temperature T_tank_cold_set = 280.0 + 273.15 "Cold tank fluid temperature below-which auxiliary heater is activated (K)";
  //Design Mass flow rate of fluid at T_output_des
  parameter SI.MassFlowRate m_flow_output_des = 449.877 "Reference HTF mass flow rate to the boiler at the target enthalpy";
  //Level Controls
  parameter Real Level_hot_max = 0.92 "Maximum allowed level of the hot tank, in decimal form (-)";
  parameter Real Level_hot_chg_start = 0.87 "Level of the hot tank below-which charging of the TES can start, in decimal form (-)";
  parameter Real Level_hot_dis_start = 0.13 "Level of the hot tank above-which discharging of the TES can start, in decimal form (-)";
  parameter Real Level_hot_min = 0.08 "Minimum allowed level of the hot tank, in decimal form (-)";
  parameter Real Level_hot_start = 0.30 "Starting level of the hot tank (-)";
  //TES Parameters
  parameter SI.EnergyDensity E_v = (h_fluid_max_des - h_fluid_min_des) * rho_f_min "Volumetric energy density (J/m3)";
  parameter SI.Volume V_tank = E_max / E_v;
  parameter SI.Length H_tank = 12.0 "Fixed tank height (m)";
  parameter Real ar = (0.25 * CN.pi * E_v * H_tank * H_tank * H_tank / E_max) ^ 0.5 "Aspect ratio H/D of tanks (-)";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank_hot = 0.4 "Heat loss coefficient of the hot tank (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank_cold = 0.4 "Heat loss coefficient at the cold tank (W/m2K)";
  //Level-Controls
  parameter SI.Time t_stor_start_dis = 1.0 * 3600.0 "Number of effective storage seconds stored before TES can start discharging (1 hour)";
  //Calculated Parameters
  parameter Modelica.SIunits.Energy E_max = t_storage * Q_flow_output_des "Maximum tank stored energy (J)";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_output_des = m_flow_output_des * (h_fluid_output_des - h_fluid_min_des);
  //20.398e6 "Heat-rate to process at design (W)";
  //parameter Modelica.SIunits.MassFlowRate m_flow_process_des = 26.6;
  //Q_flow_process_des / (h_air_process_des - h_air_min_des) "Design process input mass flow rate (kg/s)";
  parameter SI.Density rho_f_Tmin = Fluid_Package.rho_Tf(T_min, 0);
  parameter SI.Density rho_f_Tmax = Fluid_Package.rho_Tf(T_max, 0);
  parameter SI.Density rho_f_min = min(rho_f_Tmin, rho_f_Tmax);
  parameter Medium.ThermodynamicState state_fluid_min_des = Medium.setState_pTX(Medium.p_default, T_min) "Thermodynamic state of air at the minimum system temperature T_min.";
  parameter Medium.ThermodynamicState state_fluid_max_des = Medium.setState_pTX(Medium.p_default, T_max) "Thermodynamic state of air at the maximum system temperature T_min.";
  parameter Medium.ThermodynamicState state_fluid_output_des = Medium.setState_pTX(Medium.p_default, T_output_des) "Thermodynamic state of air at the design process inlet T_process_des.";
  parameter Modelica.SIunits.SpecificEnthalpy h_fluid_min_des = Medium.specificEnthalpy(state_fluid_min_des) "Specific enthalpy of fluid at minimum system temperature T_min (J/kg)";
  parameter Modelica.SIunits.SpecificEnthalpy h_fluid_max_des = Medium.specificEnthalpy(state_fluid_max_des) "Specific enthalpy of fluid at maximum system temperature T_max (J/kg)";
  parameter Modelica.SIunits.SpecificEnthalpy h_fluid_output_des = Medium.specificEnthalpy(state_fluid_output_des) "Specific enthalpy of fluid at design process inlet temperature T_process_des (J/kg)";
  SolarTherm.Models.Fluid.Pumps.PumpSimple Pump_Cold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {13, -41}, extent = {{9, -9}, {-9, 9}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple Pump_Hot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {113, 49}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression T_amb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {33, 88}, extent = {{-9, -12}, {9, 12}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {69, 88}, extent = {{-9, -12}, {9, 12}}, rotation = 0)));
  //m_boiler_des needs to be scaled down to the mass flow rate at the overdesigned temperature T_max.
  SolarTherm.Models.Fluid.HeatExchangers.Generic_Load Load(redeclare package Medium = Medium, T_cold_des = T_min, T_hot_des = T_output_des) annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.Basic_Heater Heater(redeclare package Medium = Medium, P_heater_des = P_heater_des, Q_flow_heater_des = Q_flow_heater_des, eff_heater = eff_heater, T_cold_set = T_min, T_hot_set = T_max) annotation(
    Placement(visible = true, transformation(origin = {-41, 11}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable PV_input(fileName = PV_file, tableName = "Power_norm", tableOnFile = true, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation(
    Placement(visible = true, transformation(origin = {-160, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add Grid_Sum(k1 = P_PV_gross / PV_ref_size, k2 = P_wind_gross / Wind_ref_size) annotation(
    Placement(visible = true, transformation(origin = {-84, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable Wind_input(fileName = Wind_file, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, tableName = "Power_norm", tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-160, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression ConstantDemand(y = Q_flow_output_des) annotation(
    Placement(visible = true, transformation(origin = {182, 32}, extent = {{16, -10}, {-16, 10}}, rotation = 0)));
  //Results
  SI.Energy E_supplied(start = 0) "Energy supplied by the boiler to the industrial process (J)";
  SI.Energy E_demand(start = 0) "Energy demanded by the industrial process (J)";
  SI.Energy E_renewable(start = 0) "Electrical energy produced by the renewable source (J)";
  SI.Energy E_wind(start = 0) "Electrical energy produced by the wind renewable source (J)";
  SI.Energy E_pv(start = 0) "Electrical energy produced by the pv renewable source (J)";
  //SI.Energy E_heater_in(start = 0) "Electrical energy transmitted to the heater (J)";
  SI.Energy E_heater_raw(start = 0) "Heat energy produced by the heater (after efficiency losses)";
  SI.Energy E_heater_out(start = 0) "Heat energy transferred to the air (after curtailment)";
  //SI.Energy E_pump(start = 0) "Pumping energy consumption (J)";
  Real Capacity_Factor(start = 0) "Capacity factor of the system";
  //Cost-base parameters
  /*
    parameter SI.MassFlowRate m_flow1_max = 26.6 "Maximum mass flow rate of blower 1 (kg/s) at 317.3C";
    parameter SI.MassFlowRate m_flow2_max = HM * m_flow1_max * (h_air_max_des - h_air_min_des) / (h_air_process_des - Fluid_Package.h_Tf(T_heater_des, 0.0)) "Maximum mass flow rate of blower 2 (kg/s) at 450C";
    parameter SI.VolumeFlowRate V_flow1_max = m_flow1_max / Fluid_Package.rho_Tf(25.0 + 273.15, 0.0);
    parameter SI.VolumeFlowRate V_flow2_max = m_flow2_max / Fluid_Package.rho_Tf(T_heater_des, 0.0);
    parameter SI.Pressure p_amb_des = 100000.0 "Design ambient pressure (Pa)";
    parameter SI.Power P_C1 = 0.9855 * (1.4 / 0.4) * (V_flow1_max * p_high / 0.75) * ((p_high / p_amb_des) ^ (0.4 / 1.4) - 1) / 0.90 "Sizing power of blower 1 (W)";
    parameter SI.Power P_C2 = 0.9855 * (1.4 / 0.4) * (V_flow2_max * p_high / 0.75) * ((p_high / p_amb_des) ^ (0.4 / 1.4) - 1) / 0.90 "Sizing power of blower 2 (W)";
    parameter SI.Length L_piping1 = max(1.5 * TES.Tank_A.D_tank, 50) "Length of piping 1 (m)";
    parameter SI.Length L_piping2 = max(1.5 * TES.Tank_A.D_tank + 0.75 * TES.Tank_A.H_tank, 50) "Length of piping 2 (m)";
    parameter SI.Length L_piping3 = max(1.5 * TES.Tank_A.D_tank + 0.75 * TES.Tank_A.H_tank, 50) "Length of piping 3 (m)";
    parameter SI.Length L_piping4 = max(1.5 * TES.Tank_A.D_tank, 50) "Length of piping 4 (m)";
    parameter SI.Length L_piping5 = max(1.5 * TES.Tank_A.H_tank, 50) "Length of piping 5 (m)";
    parameter Real FCIpL_piping1 = I_year / 816.0 * 479.77 "FCI cost per metre of piping 1 (USD/m)";
    parameter Real FCIpL_piping2 = I_year / 816.0 * 1299.45 "FCI cost per metre of piping 2 (USD/m)";
    parameter Real FCIpL_piping3 = I_year / 816.0 * 2060.85 "FCI cost per metre of piping 3 (USD/m)";
    parameter Real FCIpL_piping4 = I_year / 816.0 * 1291.48 "FCI cost per metre of piping 4 (USD/m)";
    parameter Real FCIpL_piping5 = I_year / 816.0 * 60.21 "FCI cost per metre of piping 5 (USD/m)";
    //Costs  //Level Thresholds
    //TES
    parameter Real I_year = 816.0 "CEPCI for 2022";
    parameter Real FOB_filler = I_year / 816.0 * TES.C_filler "FOB cost of checkerbrick (USD)";
    parameter Real FOB_insulation = I_year / 816.0 * TES.C_insulation "FOB cost of TES insulation (USD)";
    parameter Real FOB_tank = I_year / 816.0 * TES.C_tank "FOB cost of TES tank shell (USD)";
    parameter Real FOB_heater = P_heater_des * 0.206 / (4.0 * 1.05) "FOB cost of the air heaters (USD)";
    parameter Real FOB_HX = I_year / 500.0 * (div(730.406, 185.8) * 6200.0 * (10.764 * 185.8) ^ 0.42 + 6200.0 * (10.764 * rem(730.406, 185.8)) ^ 0.42) "FOB cost of gas-gas HXs at the return air stream";
    parameter Real FOB_blower1 = I_year / 500.0 * 1.0 * (div(P_C1, 745700.0) * exp(6.8929 + 0.79 * log(745700.0 / 745.7)) + exp(6.8929 + 0.79 * log(rem(P_C1, 745700.0) / 745.7))) "FOB cost of blower 1, cast iron (USD)";
    parameter Real FOB_blower2 = I_year / 500.0 * 1.0 * (div(P_C2, 745700.0) * exp(6.8929 + 0.79 * log(745700.0 / 745.7)) + exp(6.8929 + 0.79 * log(rem(P_C2, 745700.0) / 745.7))) "FOB cost of blower 2, cast iron (USD)";
    parameter Real FCI_piping1 = L_piping1 * FCIpL_piping1;
    parameter Real FCI_piping2 = L_piping2 * FCIpL_piping2;
    parameter Real FCI_piping3 = L_piping3 * FCIpL_piping3;
    parameter Real FCI_piping4 = L_piping4 * FCIpL_piping4;
    parameter Real FCI_piping5 = L_piping5 * FCIpL_piping5;
    parameter Real FCI_filler = FOB_filler * 1.05 * 4.0;
    // 1.05 is for delivery cost, 4 is a hand factor (from Sieder)
    parameter Real FCI_insulation = FOB_insulation * 1.05 * 4.0;
    parameter Real FCI_tank = FOB_tank * 1.05 * 4.0;
    parameter Real FCI_heater = FOB_heater * 1.05 * 4.0;
    parameter Real FCI_HX = FOB_HX * 1.05 * 3.5;
    parameter Real FCI_blower1 = FOB_blower1 * 1.05 * 4.0;
    // fresh air blower
    parameter Real FCI_blower2 = FOB_blower2 * 1.05 * 4.0;
    // charging loop blower (before heater)
    parameter Real FCI_PV = 1.075 * P_PV_gross;
    parameter Real FCI_wind = 1.4622 * P_wind_gross;
    parameter Real FCI_total = FCI_filler + FCI_insulation + FCI_tank + FCI_heater + FCI_HX + FCI_blower1 + FCI_blower2 + FCI_piping1 + FCI_piping2 + FCI_piping3 + FCI_piping4 + FCI_piping5 + FCI_PV + FCI_wind;
    */
  SolarTherm.Utilities.Blocks.Bound bound_PV(high = P_PV_gross, low = 0.0) annotation(
    Placement(visible = true, transformation(origin = {-124, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Utilities.Blocks.Bound bound_wind(high = P_wind_gross, low = 0.0) annotation(
    Placement(visible = true, transformation(origin = {-124, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Storage.Tank.Direct_Tank Tank_Cold(redeclare package Medium = Medium, V_tank = V_tank, ar = ar, T_des = T_min, T_set = T_tank_cold_set, Level_start = 1.0 - Level_hot_start, U_loss = U_loss_tank_cold) annotation(
    Placement(visible = true, transformation(origin = {106, -34}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Storage.Tank.Direct_Tank Tank_Hot(redeclare package Medium = Medium, V_tank = V_tank, ar = ar, T_des = T_max, T_set = T_tank_hot_set, Level_start = Level_hot_start, U_loss = U_loss_tank_hot) annotation(
    Placement(visible = true, transformation(origin = {18, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Models.Control.Generic_TwoTank_Control Control(redeclare package Medium = Medium, T_heater_out_des = T_max, T_output_des = T_output_des, T_return_des = T_min, m_flow_output_des = m_flow_output_des, Level_hot_max = Level_hot_max, Level_hot_chg_start = Level_hot_chg_start, Level_hot_dis_start = Level_hot_dis_start, Level_hot_min = Level_hot_min) annotation(
    Placement(visible = true, transformation(origin = {64, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  if time > 10.0 * 86400.0 then
    der(E_pv) = Grid_Sum.k1 * Grid_Sum.u1;
    der(E_wind) = Grid_Sum.k2 * Grid_Sum.u2;
    der(E_renewable) = Grid_Sum.y;
    der(E_heater_raw) = Heater.Q_flow_heater_raw;
    der(E_heater_out) = Heater.Q_flow_out;
    der(E_supplied) = Load.Q_flow;
    der(E_demand) = Control.Q_flow_demand;
//der(E_pump) = TES.W_dot_loss_pump;
  else
    der(E_pv) = 0.0;
    der(E_wind) = 0.0;
    der(E_renewable) = 0.0;
    der(E_heater_raw) = 0.0;
    der(E_heater_out) = 0.0;
    der(E_supplied) = 0.0;
    der(E_demand) = 0.0;
//der(E_pump) = 0.0;
  end if;
  if time > 11.0 * 86400.0 then
    Capacity_Factor = E_supplied / E_demand;
  else
    Capacity_Factor = 0.0;
  end if;
//grid_input.Q_defocus_y = min(gridInput.grid_input.y[1], scheduler.y[1] * (h_salt_hot_set - h_salt_cold_set));
  connect(Grid_Sum.y, Heater.P_supply) annotation(
    Line(points = {{-73, 18}, {-66, 18}, {-66, 17}, {-51, 17}}, color = {0, 0, 127}));
  connect(PV_input.y[1], bound_PV.u) annotation(
    Line(points = {{-148, 36}, {-136, 36}}, color = {0, 0, 127}));
  connect(bound_PV.y, Grid_Sum.u1) annotation(
    Line(points = {{-112, 36}, {-106, 36}, {-106, 24}, {-96, 24}}, color = {0, 0, 127}));
  connect(Wind_input.y[1], bound_wind.u) annotation(
    Line(points = {{-148, 4}, {-136, 4}}, color = {0, 0, 127}));
  connect(bound_wind.y, Grid_Sum.u2) annotation(
    Line(points = {{-113, 4}, {-106, 4}, {-106, 12}, {-96, 12}}, color = {0, 0, 127}));
  connect(Tank_Cold.fluid_b, Pump_Cold.fluid_a) annotation(
    Line(points = {{96, -41}, {22, -41}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Pump_Cold.fluid_b, Heater.fluid_a) annotation(
    Line(points = {{4, -41}, {-58, -41}, {-58, 11}, {-50, 11}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Heater.fluid_b, Tank_Hot.fluid_a) annotation(
    Line(points = {{-32, 11}, {-12, 11}, {-12, 61}, {8, 61}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Tank_Hot.fluid_b, Pump_Hot.fluid_a) annotation(
    Line(points = {{28, 49}, {104, 49}}, color = {0, 127, 255}, thickness = 0.5));
  connect(T_amb.y, Tank_Hot.T_amb) annotation(
    Line(points = {{42, 88}, {46, 88}, {46, 74}, {14, 74}, {14, 66}}, color = {0, 0, 127}));
  connect(T_amb.y, Tank_Cold.T_amb) annotation(
    Line(points = {{42, 88}, {46, 88}, {46, -22}, {110, -22}, {110, -24}}, color = {0, 0, 127}));
  connect(Control.m_flow_heater_signal, Pump_Cold.m_flow) annotation(
    Line(points = {{76, 20}, {78, 20}, {78, -26}, {13, -26}, {13, -33}}, color = {0, 0, 127}));
  connect(Control.m_flow_output_signal, Pump_Hot.m_flow) annotation(
    Line(points = {{76, 14}, {96, 14}, {96, 66}, {113, 66}, {113, 57}}, color = {0, 0, 127}));
  connect(Control.defocus, Heater.curtail) annotation(
    Line(points = {{76, 10}, {82, 10}, {82, 30}, {-56, 30}, {-56, 20}, {-52, 20}}, color = {255, 0, 255}));
  connect(Heater.Q_flow_heater_raw, Control.Q_flow_heater_raw) annotation(
    Line(points = {{-32, 18}, {18, 18}, {18, 20}, {54, 20}}, color = {0, 0, 127}));
  connect(Tank_Hot.Level, Control.Level_hot) annotation(
    Line(points = {{28, 60}, {38, 60}, {38, 16}, {54, 16}}, color = {0, 0, 127}));
  connect(Tank_Hot.h_fluid, Control.h_tank_hot) annotation(
    Line(points = {{28, 52}, {60, 52}, {60, 26}}, color = {0, 0, 127}));
  connect(ConstantDemand.y, Control.Q_flow_demand) annotation(
    Line(points = {{164, 32}, {72, 32}, {72, 26}}, color = {0, 0, 127}));
  connect(Control.Q_flow_curtail, Heater.Q_flow_curtail) annotation(
    Line(points = {{54, 6}, {-20, 6}, {-20, -6}, {-64, -6}, {-64, 14}, {-52, 14}}, color = {0, 0, 127}));
  connect(Tank_Cold.h_fluid, Control.h_tank_cold) annotation(
    Line(points = {{96, -37}, {84, -37}, {84, 36}, {66, 36}, {66, 26}}, color = {0, 0, 127}));
  connect(p_amb.y, Tank_Hot.p_amb) annotation(
    Line(points = {{78, 88}, {88, 88}, {88, 72}, {22, 72}, {22, 66}}, color = {0, 0, 127}));
  connect(p_amb.y, Tank_Cold.p_amb) annotation(
    Line(points = {{78, 88}, {88, 88}, {88, -8}, {101.5, -8}, {101.5, -24}}, color = {0, 0, 127}));
  connect(Pump_Hot.fluid_b, Load.fluid_a) annotation(
    Line(points = {{122, 49}, {144, 49}, {144, 8}, {160, 8}}, color = {0, 127, 255}, thickness = 0.5));
  connect(Load.fluid_b, Tank_Cold.fluid_a) annotation(
    Line(points = {{160, -8}, {144, -8}, {144, -29}, {116, -29}}, color = {0, 127, 255}, thickness = 0.5));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-200, -100}, {200, 100}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-200, -100}, {200, 100}}, preserveAspectRatio = false)),
    experiment(StopTime = 3.24e+07, StartTime = 0, Tolerance = 1.0e-5, Interval = 300, maxStepSize = 60, initialStepSize = 60));
end Direct2T_SystemLevel;