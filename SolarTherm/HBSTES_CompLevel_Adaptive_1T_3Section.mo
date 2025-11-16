within SolarTherm;

model HBSTES_CompLevel_Adaptive_1T_3Section 
/*
Fixed Dimensions (H_tank && D_tank && d_p). 
Variable cycle length where Charging and Discharging follow immediately after each other assuming the system temperature constraints have not been violated. 
*/
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  
  //package Medium = SolarTherm.Media.Air.Air_CoolProp_1bar;   //CoolProp_1bar calls "_utilities"
  package Medium = SolarTherm.Media.Nara_airish.Air_CoolProp_1bar;   //CoolProp_1bar calls "_utilities"
  //package Medium_Utilities = SolarTherm.Media.Air.Air_CoolProp_1bar_utilities;   //calls "property_table"
  package Medium_Utilities = SolarTherm.Media.Nara_airish.Air_CoolProp_1bar_utilities;   //calls "property_table"
  //package Fluid_Package = SolarTherm.Materials.Air_CoolProp_Table_1bar;   //Table_1bar calls "_utilities"
  package Fluid_Package = SolarTherm.Materials.Nara_airish_CoolProp_Table_1bar;   //Table_1bar calls "_utilities"
  
  package Filler_Package_A = SolarTherm.Materials.LowAlumina_27pct_porosity_50K_intervals;
  package Filler_Package_B = SolarTherm.Materials.HighAlumina_32pct_porosity_50K_intervals;
  package Filler_Package_C = SolarTherm.Materials.HighSilica_26pct_porosity_50K_intervals;
 
  //These parameters are varied
  parameter Real HM = 2.0 "Heater Multiple";
  //parameter SI.Time t_discharge = 50.0 *3600.0 "Rated discharging period (s)";
  parameter SI.Time t_discharge = E_max / Q_process_des "Rated discharging period (s)";
  //parameter SI.Time t_standby = 2.0*3600.0 "Additional standby time after both charging and discharging cycle (s)";
  //Numerical Discretisation Settings
  parameter Integer N_f = 100;
  parameter Integer N_tanks = 1 "Number of tanks in the storage array, needed to adjust aspect ratio such that all tanks are 35m high";
  
  parameter Real frac_1 = E_v_A / E_v;
  parameter Real frac_2 = E_v_B / E_v;
  parameter Real frac_3 = E_v_C / E_v;

  parameter Real t_storage_hours_ideal = t_discharge/3600.0;
  //parameter Integer N_p = 5; //Not used
  //TES Geometric Parameters
  parameter SI.Length d_p = 0.02 "Hole diameter in the filler (m)";
  parameter Real epsilon = CN.pi*(d_p ^ 2.0) / (3.464101615 * ((0.015 + d_p) ^ 2.0)) "Packed-bed porosity";
  
  parameter SI.Length H_tank = 35 "Fixed tank height (m)";
  parameter SI.Length D_tank = 8.9208 "Fixed tank diametre (m)";
  
  //parameter SI.EnergyDensity E_v = epsilon*rho_f_avg*(h_f_max-h_f_min) + ((1.0-epsilon))*rho_p_A*(h_p_max_A-h_p_min_A) + ((1.0-epsilon))*rho_p_B*(h_p_max_B-h_p_min_B) + ((1.0-epsilon))*rho_p_C*(h_p_max_C-h_p_min_C) "Volumetric energy density (J/m3)";
  parameter SI.EnergyDensity E_v_A = (1.0-epsilon)*rho_p_A*(h_p_max_A-h_p_min_A) "Volumetric energy density of section A (J/m3)";
  parameter SI.EnergyDensity E_v_B = (1.0-epsilon)*rho_p_B*(h_p_max_B-h_p_min_B) "Volumetric energy density of section B (J/m3)";
  parameter SI.EnergyDensity E_v_C = (1.0-epsilon)*rho_p_C*(h_p_max_C-h_p_min_C) "Volumetric energy density of section C (J/m3)";
  parameter SI.EnergyDensity E_v_fluid = epsilon*rho_f_avg*(h_f_max-h_f_min) "Volumetric energy density of fluid (J/m3)";
  parameter SI.EnergyDensity E_v = E_v_fluid + E_v_A + E_v_B + E_v_C "Volumetric energy density of section A + B + C (J/m3)";
  //parameter Real ar = (N_tanks^0.5)*(0.25*CN.pi*E_v*H_tank*H_tank*H_tank/E_max)^0.5 "Aspect ratio H/D of tanks (-)";
  
  //==================AFTER CHANGES (varying H_tank by fixing D_tank)
  //parameter Real ar = (4.0*E_max) / (CN.pi*(D_tank ^ 3.0)*E_v) "Aspect ratio H/D of tanks (-) THIS ONE for dynamic H_tank";
  //==================
  parameter Real ar_A = (H_tank / 3.0) / D_tank "Aspect ratio H/D = 3.92341494";
  parameter Real ar_B = ar_A "Aspect ratio H/D = 3.92341494";
  parameter Real ar_C = ar_A "Aspect ratio H/D = 3.92341494";
  
  //parameter SI.Volume V_A = E_max*frac_1/E_v_A;
  //parameter SI.Volume V_B = E_max*frac_2/E_v_B;
  //parameter SI.Volume V_C = E_max*(1.0-frac_1-frac_2)/E_v_C;
  parameter SI.Volume V_A = 0.25*CN.pi*D_tank*D_tank*(H_tank/3.0);
  parameter SI.Volume V_B = V_A;
  parameter SI.Volume V_C = V_A;
  
  
  //==================
  //parameter Real ar_A = (4.0*V_A)/(CN.pi*(D_tank^3.0)) "Aspect ratio H/D of tank A(-)";
  //parameter Real ar_B = (4.0*V_B)/(CN.pi*(D_tank^3.0)) "Aspect ratio H/D of tank B(-)";
  //parameter Real ar_C = (4.0*V_C)/(CN.pi*(D_tank^3.0)) "Aspect ratio H/D of tank C(-)";

  //parameter SI.Length s_p = 0.04 "Separation of holes in the filler (m)";
  parameter SI.Temperature T_ext_max = 323.15 "Maximum external temperature of the HBS walls under worst-case conditions (K)";
  parameter SI.CoefficientOfHeatTransfer U_loss_top = 10.0*(T_ext_max-T_amb_des)/(T_max-T_amb_des) "Heat loss coefficient at the top of the tank (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_loss_bot = 10.0*(T_ext_max-T_amb_des)/(T_max-T_amb_des) "Heat loss coefficient at the bottom of the tank (W/m2K)";
  //Temperature Controls
  parameter SI.Temperature T_max = 1100.0 + 273.15 "Maximum temperature (K)";
  parameter SI.Temperature T_process_des = 1000.0 + 273.15 "Design process inlet temperature (K)";
  parameter SI.Temperature T_high_set = 1000.0 + 273.15 "TES hot blend temperature temperature (K)";
  parameter SI.Temperature T_process_min = 1000.0 + 273.15 "Minimum tolerated outlet temperature to process (K)";
  parameter SI.Temperature T_heater_max = 450.0 + 273.15 "Maximum tolerated outlet temperature to heater (K)";
  parameter SI.Temperature T_low_set = 450.0 + 273.15 "TES cold blend temperature (K)";
  parameter SI.Temperature T_heater_des = 317.3 + 273.15 "Design receiver inlet temperature (K)";
  parameter SI.Temperature T_min = 317.3 + 273.15 "Minimum temperature (K)";
  parameter SI.Temperature T_amb_des = 25.0 + 273.15 "Design ambient temperature (K)";
  parameter Integer Correlation = 1; //Gas Internal flow
  //parameter SI.SpecificEnthalpy h_tol = 0.05*(TES.Tank_A.h_f_max - TES.Tank_A.h_f_min);
  //Tank Geometry
  parameter SI.MassFlowRate m_process_des = 26.6;
  parameter SI.SpecificEnthalpy h_f_amb_des = Fluid_Package.h_Tf(T_amb_des,0.0);
  parameter SI.SpecificEnthalpy h_f_process_des = Fluid_Package.h_Tf(T_process_des,1.0);
  parameter SI.Power Q_process_des = m_process_des*(h_f_process_des - h_f_min) "Design required process heat-rate (W_th)";
  parameter SI.Power Q_heater_des = HM * Q_process_des "Design heater output heat-rate (W_th)";
  //parameter SI.Energy E_max = Q_process_des*t_discharge "Ideal storage capacity (J_thermal)"; //Note 3 tanks
  parameter SI.Energy E_max = (E_v_A*V_A) + (E_v_B*V_B) + (E_v_C*V_C) + (E_v_fluid*(V_A + V_B + V_C)) "Ideal storage capacity (J_thermal)"; //Note 3 tanks
  parameter SI.Time t_charge = t_discharge / (HM - 1.0) "Charging period (s)";
  parameter SI.MassFlowRate m_charge_des = (Q_heater_des - Q_process_des) / (h_f_max - h_f_min) "Design charging mass flow rate assuming design temperature outlet (kg/s)";
  parameter SI.MassFlowRate m_discharge_des = Q_process_des / (h_f_max - h_f_min)  "Design discharging mass flow rate assuming design temperature outlet (kg/s)";
  //Derived Parameters
  parameter SI.Time t_cycle = t_charge + t_discharge "Total max duration of one cycle (s)";
  //this is 24 hours
  //Storage sizing equations
  //Fluid
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0);
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 1.0);
  parameter SI.Density rho_f_min = Fluid_Package.rho_Tf(T_min, 0);
  parameter SI.Density rho_f_max = Fluid_Package.rho_Tf(T_max, 0);
  parameter SI.Density rho_f_avg = (rho_f_min + rho_f_max) / 2;
  
  //Filler_A (BOT | Low alumina)
  parameter SI.SpecificEnthalpy h_p_max_A = Filler_Package_A.h_Tf(T_max, 1.0);
  parameter SI.SpecificEnthalpy h_p_min_A = Filler_Package_A.h_Tf(T_min, 0.0);
  parameter SI.Density rho_p_min_A = Filler_Package_A.rho_Tf(T_min, 0.0);
  parameter SI.Density rho_p_max_A = Filler_Package_A.rho_Tf(T_max, 1.0);
  parameter SI.Density rho_p_A = min(rho_p_min_A, rho_p_max_A) "kg/m3";
  
  //Filler_B (MID | High alumina)
  parameter SI.SpecificEnthalpy h_p_max_B = Filler_Package_B.h_Tf(T_max, 1.0);
  parameter SI.SpecificEnthalpy h_p_min_B = Filler_Package_B.h_Tf(T_min, 0.0);
  parameter SI.Density rho_p_min_B = Filler_Package_B.rho_Tf(T_min, 0.0);
  parameter SI.Density rho_p_max_B = Filler_Package_B.rho_Tf(T_max, 1.0);
  parameter SI.Density rho_p_B = min(rho_p_min_B, rho_p_max_B) "kg/m3";
  
  //Filler_C (TOP | High Silica)
  parameter SI.SpecificEnthalpy h_p_max_C = Filler_Package_C.h_Tf(T_max, 1.0);
  parameter SI.SpecificEnthalpy h_p_min_C = Filler_Package_C.h_Tf(T_min, 0.0);
  parameter SI.Density rho_p_min_C = Filler_Package_C.rho_Tf(T_min, 0.0);
  parameter SI.Density rho_p_max_C = Filler_Package_C.rho_Tf(T_max, 1.0);
  parameter SI.Density rho_p_C = min(rho_p_min_C, rho_p_max_C) "kg/m3";
  
  //Fluid Entropy
  parameter SI.SpecificEntropy s_f_max = Medium_Utilities.s_T(T_max);
  parameter SI.SpecificEntropy s_f_process_des = Medium_Utilities.s_T(T_process_des);
  parameter SI.SpecificEntropy s_f_min = Medium_Utilities.s_T(T_min);
  parameter SI.SpecificEntropy s_f_amb = Medium_Utilities.s_T(T_amb_des);
  
  //Output signals
  Modelica.Fluid.Sources.Boundary_pT Heater_outlet(redeclare package Medium = Medium, T = T_max, nPorts = 1, p = 100000) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Process_outlet(redeclare package Medium = Medium, T = T_min, nPorts = 1, p = 100000) annotation(
    Placement(visible = true, transformation(origin = {107, -59}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  //Storage Model
  //Componenets and Connectors
  SolarTherm.Models.Fluid.Sources.FluidSink2 Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-125, -59}, extent = {{21, -21}, {-21, 21}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-40, -4}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Heater(y = m_Heater_signal) annotation(
    Placement(visible = true, transformation(origin = {-119, 3}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure heater_sink_pump(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = { -57, -59}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction thermocline_Splitter1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-2, 69.5547}, extent = {{-16, 0}, {16, 22.4453}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction thermocline_Splitter2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-2, -38.3493}, extent = {{-14, 0}, {14, 21.6507}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression m_flow_Process(y = m_Process_signal) annotation(
    Placement(visible = true, transformation(origin = {120, 3}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple process_source_pump(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {45, -59}, extent = {{13, -13}, {-13, 13}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink2 Process_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {112, 44}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 100000) annotation(
    Placement(visible = true, transformation(origin = {43, -4}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple heater_source_pump(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-52, 48}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure process_sink_pump(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {46, 44}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.mass_loop_breaker mass_loop_breaker(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-2, 50}, extent = {{-24, -24}, {24, 24}}, rotation = -90)));
  SolarTherm.Models.Storage.Thermocline.Series.Thermocline_HBS_LC_SGroup3_Final TES(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Filler_Package_A = Filler_Package_A, redeclare package Filler_Package_B = Filler_Package_B, redeclare package Filler_Package_C = Filler_Package_C, N_f_A = N_f, T_max = T_max, T_min = T_min, Correlation = Correlation, frac_1 = frac_1, frac_2 = frac_2, frac_3 = frac_3, E_max = E_max, ar_A = ar_A ,ar_B = ar_B ,ar_C = ar_C, d_p_A = d_p, eta_A = epsilon, U_loss_tank_A = U_loss_top) annotation(
    Placement(visible = true, transformation(origin = {-2, -4}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  
  //Mass flow Signals starts in charging state //,h_tol=h_tol
  SI.MassFlowRate m_Heater_signal(start = m_charge_des);
  SI.MassFlowRate m_Process_signal(start = 0.0);
  //Measured Temperatures
  Real T_top_degC;
  Real T_bot_degC;
  Real T_outlet_degC;
  Real T_inlet_degC;
  //Energies and Exergies for final cycle calculation
  SI.Energy E_chg(start = 0) "Charged energy into storage";
  SI.Energy E_dis(start = 0) "Discharged energy into storage";
  //SI.Energy E_lost(start = 0) "Externally lost energy from storage";
  //SI.Energy E_pump(start = 0) "Pumping energy consumed";
  parameter SI.Energy X_max_stor = t_discharge * m_discharge_des * ((h_f_max-h_f_min)-T_amb_des*(s_f_max-s_f_min)) "Ideal exergetic storage capacity of the TES (J)";
  parameter SI.Energy X_max_sys = t_discharge * m_process_des * ((h_f_process_des-h_f_min)-T_amb_des*(s_f_process_des-s_f_min)) "Ideal Exergy delivered by the system (J)";
  //SI.Energy X_chg(start = 0.0) "Total exergy charged i3n the last cycle";
  //SI.Energy X_dis(start = 0.0) "Discharged exergy";
  //Utilisation and efficiencies
  Real util_energy(start = 0.0) "Energetic utilisation (1st Law)";
  Real eff_energy(start = 0.0) "Energetic efficiency (1st Law)";
  //Real util_exergy(start = 0.0) "Exergetic utilisation (2nd law)";
  //Real eff_exergy(start = 0.0) "Exergetic efficiency (2nd law)";
  //Individual Tank Utilization Calculations
  //parameter SI.Energy E_max_A = TES.Tank_A.E_max "Maximum energy capacity of Tank A";
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
  //SI.Energy E_dis_total(start = 0.0) "Total discharged energy for entire simulation";
  //SI.Energy E_pump_total(start = 0.0) "Total pump energy losses for entire simulation";
  //SI.Energy E_dis_prev(start = 0.001) "Total discharged energy for previous cycle";
  //SI.Energy E_pump_prev(start = 0.001) "Total pump energy losses for previous cycle";
  //Real util_prev(start = 0.001) "Previous day's level, starts at 0.1% to prevent divbyzero";
  //Real time_stop(start = 3600.0 * 24.0 * 10.0) "The maximum time this simulation can last";
  //Boolean Chg(start = false) "Can storage be charged?";
  //Boolean Dis(start = false) "Can storage be discharged?";
  //Integer Control_State(start = 1) "Control state 1= Charge 2=Standby 3=Discharge";
  Real Level_high(start = 1.0);
  Real Level_low(start = 0.0);
  Real Level_mid(start = 0.5);
  
  SI.Energy E_stored(start = 0.0);
  SI.Energy E_pump(start=0.0);
  SI.Energy E_loss(start=0.0);
  
  //Exergy Analysis
  SI.Energy X_chg(start=0.0) "Total exergy charged in the last cycle";
  SI.Energy X_dis_stor(start=0.0) "Discharged exergy from storage";
  SI.Energy X_dis_sys(start=0.0) "Discharged exergy from system";
  Real util_exergy_stor(start=0.0) "Exergetic utilisation of storage (2nd law)";
  Real eff_exergy_stor(start=0.0) "Exergetic efficiency of storage (2nd law)";
  Real util_exergy_sys(start=0.0) "Exergetic utilisation of system (2nd law)";
  Real eff_exergy_sys(start=0.0) "Exergetic efficiency of system (2nd law)";
  
  //Counters
  Integer Cycle(start=1) "Which cycle number are we in?";
  Integer State(start=1) "Which state are we in? 1=Chg, 2=Discharging";
  
algorithm
//Mass flow controls
  //If we are in the charging cycle:
  when TES.T_bot_measured > T_heater_max then
    if State == 1 then
      State := 2; //Switch to discharging
      Level_high := TES.Level;  //Store the TES level when TES has been charged to the bottom temp limit
    end if;
  end when;
  
  //If we are in the discharging cycle:
  when TES.T_top_measured < T_process_min then
    if State == 2 then
      State := 1;  //Switch back to charging
      Level_low := TES.Level;
      Level_mid := 0.5 * (Level_high + Level_low);
      Cycle := Cycle + 1; //Go to the next cycle
    end if;
  end when;

  when State < 2 then //we have switched to intended charging
    if TES.T_bot_measured > T_heater_max then //we cannot actually charge
      State := 2; //Try discharging instead
    end if;
  end when;
  
  when State > 1 then //we have switched to intended discharging
    if TES.T_top_measured < T_process_min then //we cannot actually discharge
      State := 1; //Try charging instead
      Cycle := Cycle + 1; //Go to the next cycle
    end if;
  end when;

//Force stop discharging, unacceptable top outlet Temperature
//Utilisation convergence
  when Cycle > 10 then
    terminate("Ten cycles have been reached");
  end when;
//  when time > 12.0*t_cycle then //give like 20% leeway
//    terminate("Exceeded expected time limit");
//  end when;
//Replace time + t_cycle - 1.0e-6 with 3600.0*24.0*10.0 to bypass the 1% check and simulate the full 10 days
//if abs((((E_dis_total - E_dis_prev) - (E_pump_total - E_pump_prev))/E_max) - util_prev)/(util_prev) < 0.01 and div(time,t_cycle) > 0.0 then //stable cycle
//stable cycle
//time + t_cycle - 1.0e-6;
//calculate utilisation
//util_prev := ((E_dis_total - E_dis_prev) - (E_pump_total - E_pump_prev))/E_max;
//E_pump_prev := E_pump_total;
equation
  der(E_stored) = TES.fluid_a.m_flow * (TES.fluid_a.h_outflow - TES.fluid_b.h_outflow);

  if State == 1 then
    m_Heater_signal = m_charge_des * (h_f_max - h_f_min) / (h_f_max - TES.h_bot_outlet);
    m_Process_signal = 1.0e-8;
  else 
    m_Process_signal = m_discharge_des * (h_f_max - h_f_min) / (TES.h_top_outlet - h_f_min);
    m_Heater_signal = 1.0e-8;
  end if;

//Measured temperature sensors
  T_top_degC = TES.T_top_measured - 273.15;
  T_bot_degC = TES.T_bot_measured - 273.15;
//Combined storage outlet temperatures (25degC if no flow)
  if TES.fluid_a.m_flow > 1.0e-3 then
//there is mass flow
    T_outlet_degC = TES.fluid_bot.T - 273.15;
    T_inlet_degC = TES.fluid_top.T - 273.15;
  elseif TES.fluid_a.m_flow < (-1.0e-3) then
    T_outlet_degC = TES.fluid_top.T - 273.15;
    T_inlet_degC = TES.fluid_bot.T - 273.15;
  else
    T_outlet_degC = 25.0;
    T_inlet_degC = 25.0;
  end if;
  //if time > 9.0 * t_cycle and time < 9.0 * t_cycle + t_charge then

  if Cycle == 10 and State == 1 then //last charging phase
    der(E_chg) = TES.fluid_a.m_flow * (inStream(TES.fluid_a.h_outflow) - TES.fluid_b.h_outflow);
    der(E_dis) = 0.0;
    der(X_chg) = TES.fluid_a.m_flow * ((inStream(TES.fluid_a.h_outflow) - TES.fluid_b.h_outflow) - T_amb_des*(Medium_Utilities.s_T(Medium_Utilities.T_h(inStream(TES.fluid_a.h_outflow))) - Medium_Utilities.s_T(Medium_Utilities.T_h(TES.fluid_b.h_outflow))));
    der(X_dis_stor) = 0.0;
    der(X_dis_sys) = 0.0;
    der(E_pump) = TES.W_loss_pump;
  //elseif time >= 9.0 * t_cycle + t_charge + t_standby and time < 9.0 * t_cycle + t_charge + t_standby + t_discharge then
  elseif Cycle == 10 and State == 2 then //last discharging phase
    der(E_chg) = 0.0;
    der(E_dis) = TES.fluid_b.m_flow * (TES.fluid_a.h_outflow - inStream(TES.fluid_b.h_outflow));
    der(X_chg) = 0.0;
    der(X_dis_stor) = TES.fluid_b.m_flow*((TES.fluid_a.h_outflow - inStream(TES.fluid_b.h_outflow)) - T_amb_des*(Medium_Utilities.s_T(Medium_Utilities.T_h(TES.fluid_a.h_outflow)) - Medium_Utilities.s_T(Medium_Utilities.T_h(inStream(TES.fluid_b.h_outflow)))));
    if TES.fluid_b.m_flow > 1.0e-6 then
      der(X_dis_sys) = m_process_des*((h_f_process_des - h_f_min) - T_amb_des*(s_f_process_des - s_f_min));
    else
      der(X_dis_sys) = 0.0;
    end if;
    der(E_pump) = TES.W_loss_pump;
  else
    der(E_chg) = 0.0;
    der(E_dis) = 0.0;
    der(X_chg) = 0.0;
    der(X_dis_stor) = 0.0;  
    der(X_dis_sys) = 0.0;  
    der(E_pump) = 0.0;
  end if;
  //if time > 9.0 * t_cycle + t_charge + t_standby then
  if Cycle > 9 then //we can calculate utilisation and efficiency because denominator is not zero;
    util_energy = (E_dis) / E_max;
    eff_energy = (E_dis) / max(E_chg,1.0); //Avoid division by zero
    util_exergy_stor = (X_dis_stor) / X_max_stor;
    eff_exergy_stor = (X_dis_stor) / max(X_chg,1.0); //Avoid division by zero
    util_exergy_sys = (X_dis_sys) / X_max_sys;
    eff_exergy_sys = (X_dis_sys) / max(X_chg,1.0); //Avoid division by zero
    der(E_loss) = TES.Q_loss_total;
  else
    util_energy = 0.0;
    eff_energy = 0.0;
    util_exergy_stor = 0.0;
    eff_exergy_stor = 0.0;
    util_exergy_sys = 0.0;
    eff_exergy_sys = 0.0; //Avoid division by zero
    der(E_loss) = 0.0;
  end if;
//Connectors
  connect(thermocline_Splitter2.fluid_b, heater_sink_pump.fluid_a) annotation(
    Line(points = {{-13, -58}, {-27.5, -58}, {-27.5, -59}, {-42, -59}}, color = {0, 127, 255}));
  connect(m_flow_Heater.y, heater_sink_pump.m_flow) annotation(
    Line(points = {{-98, 3}, {-57, 3}, {-57, -46}}, color = {0, 0, 127}));
  connect(process_source_pump.fluid_b, thermocline_Splitter2.fluid_a) annotation(
    Line(points = {{32, -59}, {20.5, -59}, {20.5, -58}, {9, -58}}, color = {0, 127, 255}));
  connect(heater_source_pump.fluid_b, thermocline_Splitter1.fluid_a) annotation(
    Line(points = {{-40, 48}, {-30, 48}, {-30, 90}, {-15, 90}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_b, process_sink_pump.fluid_a) annotation(
    Line(points = {{11, 90}, {22, 90}, {22, 44}, {34, 44}}, color = {0, 127, 255}));
  connect(Heater_outlet.ports[1], heater_source_pump.fluid_a) annotation(
    Line(points = {{-96, 48}, {-64, 48}}, color = {0, 127, 255}));
  connect(Process_outlet.ports[1], process_source_pump.fluid_a) annotation(
    Line(points = {{92, -59}, {58, -59}}, color = {0, 127, 255}));
  connect(m_flow_Heater.y, heater_source_pump.m_flow) annotation(
    Line(points = {{-98, 3}, {-74, 3}, {-74, 72}, {-52, 72}, {-52, 58}}, color = {0, 0, 127}));
  connect(m_flow_Process.y, process_sink_pump.m_flow) annotation(
    Line(points = {{98, 3}, {70, 3}, {70, 70}, {46, 70}, {46, 54}}, color = {0, 0, 127}));
  connect(m_flow_Process.y, process_source_pump.m_flow) annotation(
    Line(points = {{98, 3}, {70, 3}, {70, -30}, {45, -30}, {45, -48}}, color = {0, 0, 127}));
  connect(Recv_Sink.port_a, heater_sink_pump.fluid_b) annotation(
    Line(points = {{-104, -59}, {-72, -59}}, color = {0, 127, 255}));
  connect(Process_Sink.port_a, process_sink_pump.fluid_b) annotation(
    Line(points = {{94, 44}, {58, 44}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_c, mass_loop_breaker.port_a) annotation(
    Line(points = {{-2, 81}, {-2, 64}}, color = {0, 127, 255}));
  connect(mass_loop_breaker.port_b, TES.fluid_a) annotation(
    Line(points = {{-2, 36}, {-2, 20}}, color = {0, 127, 255}));
  connect(TES.fluid_b, thermocline_Splitter2.fluid_c) annotation(
    Line(points = {{-2, -28}, {-2, -49}}, color = {0, 127, 255}));
  connect(Tamb.y, TES.T_amb) annotation(
    Line(points = {{-27, -4}, {-16, -4}}, color = {0, 0, 127}));
  connect(p_amb.y, TES.p_amb) annotation(
    Line(points = {{29, -4}, {12, -4}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 40640000, StartTime = 0, Tolerance = 1e-4, Interval = 500),
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false)),
    Icon(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false)));
end HBSTES_CompLevel_Adaptive_1T_3Section;