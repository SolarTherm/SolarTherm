within SolarTherm.Validation.Models;

model RadCharge_160kWt_v2
  //Baseline 3-tank series component analysis simulation from Chapter 7 and 8.3
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  package Medium = SolarTherm.Media.Air.Air_amb_p_curvefit;
  package Fluid_Package = SolarTherm.Materials.Air_amb_p_curvefit;
  package Filler_Package = SolarTherm.Materials.Brick_Stack;
  //Numerical Discretisation
  //parameter Integer N_f = 50;
  //parameter Integer N_p = 5;
  //TES Parameters
  //Storage Parameter Settings
  parameter Integer Correlation = 2 "Interfacial convection correlation {1 = WakaoKaguei, 2 = MelissariArgyropoulos, 3 = Conservative}";
  //Storage CApacity
  parameter Integer N_f = 6;
  parameter Real eta = 0.50512;
  parameter SI.Length H_unit = 0.50;
  parameter SI.WaveNumber c_surf = 83.340;
  parameter SI.Length L_char = 0.01136;
  parameter SI.Temperature T_rad_max = CV.from_degC(1200);
  parameter Real f_rad_fluid = 0.0 "Fraction of radiative heating absorbed by the fluid";
  parameter Real c_cond_z = 1.0 "Multiplier to the vertical thermal conductivity of solid due to radiation";
  parameter SI.MassAttenuationCoefficient A_radperkg = 0.0011796 "Radiative wire area per kg of bricks (m2/kg)";  
  parameter Real em_wire = 0.70 "Emissivity of the radiative wire (-)";
  //1=Liq 2=Air
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.0 "W/m2K";
  //Temperature Controls
  parameter SI.Temperature T_max = 1000.0 + 273.15 "Maximum temperature";
  parameter SI.Temperature T_PB_des = T_max - 0.5 * T_tol_PB "Design blended Power Block inlet temperature";
  parameter SI.Temperature T_PB_min = 200.0 +273.15 "Minimum tolerated outlet temperature to PB";
  parameter SI.Temperature T_Recv_max = T_min + T_tol_Recv "Maximum tolerated outlet temperature to recv";
  parameter SI.Temperature T_Recv_des = T_min + 0.5 * T_tol_Recv "Design blended receiver inlet temperature";
  parameter SI.Temperature T_min = 100.0 + 273.15 "Minimum temperature";
  //Temp Tolerance Settings
  parameter SI.TemperatureDifference T_tol_Recv = 500.0 "Power block Temperature Tolerance (K) (Redundant, no receiver)";
  parameter SI.TemperatureDifference T_tol_PB = T_max - T_PB_min "Power block Temperature Tolerance (K)";
  parameter SI.Temperature T_chg_stop = 1000.0 + 273.15 "Temperature of element 5 at which charging is stopped";
  //parameter SI.Temperature T_cold_inlet = 100.0 + 273.15 "Cold inlet temperature";
  //Tank Geometry
  parameter Real RM = 2.8125 "Renewable Multiple";
  parameter SI.Power Q_dis_des = 160.0e3 "Design storage discharge heat-rate";
  parameter SI.Power Q_chg_des = 420.0e3 "Design storage charge heat-rate";
  parameter Real oversize_factor = 1.4698*1.0 "Oversize factor of the storage";
  parameter SI.Energy E_max = 2.0e6*3600.0*oversize_factor "Ideal storage capacity (J_thermal), slightly higher than the discharge time";
  parameter SI.Time t_charge = 12.0*3600.0;//(RM - 1.0) * t_discharge "Charging period";
  parameter SI.Time t_discharge = 12.0 * 3600.0 "Discharging period";
  parameter SI.Time t_extension = 0.0 * 3600.0 "Extension period to make sure charging and discharging complete, applied twice";
  //parameter SI.Time t_standby = 24.0 * 3600.0 - t_charge - t_discharge - 2.0 * t_extension "Standby period between discharge and charge";
  //Derived Parameters
  parameter SI.Time t_cycle = 24.0*3600.0; //t_charge + t_discharge + t_standby + 2.0 * t_extension;
  //this is 24 hours
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0.0);
  parameter SI.SpecificEnthalpy h_f_des = Fluid_Package.h_Tf(200.0+273.15, 0.0);
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 1.0);
  parameter SI.MassFlowRate m_charge_des = Q_chg_des / (h_f_max - h_f_min); //redundant
  parameter SI.MassFlowRate m_discharge_des = Q_dis_des / (h_f_des - h_f_min);
  //Output signals
  Modelica.Fluid.Sources.Boundary_pT PB_outlet(redeclare package Medium = Medium, T = T_min, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {92, -60}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  //Storage Model
  SolarTherm.Models.Storage.Thermocline.RadCharge.RadCharge_Tank_v2 thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Filler_Package = Filler_Package, N_f = N_f, T_max = T_max, T_min = T_min, Correlation = Correlation, E_max = E_max, U_loss_tank = U_loss_tank, eta = eta, H_unit = H_unit, c_surf = c_surf, L_char = L_char, T_rad_max = T_rad_max,f_rad_fluid = f_rad_fluid, c_cond_z = c_cond_z, A_radperkg = A_radperkg, em_wire = em_wire) annotation(
    Placement(visible = true, transformation(origin = { 0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  //Componenets and Connectors
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-66, -32}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_PB(y = m_PB_signal) annotation(
    Placement(visible = true, transformation(origin = {110, 3}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {40, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink PB_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {108, 58}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {49, 0}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
  //Mass flow Signals starts in charging state
  //SI.MassFlowRate m_Recv_signal(start = m_charge_des);
  SI.MassFlowRate m_PB_signal(start = m_discharge_des);
  SI.HeatFlowRate Q_charge_signal(start = Q_chg_des);
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
  //SI.Energy E_dis_prev(start = 0.001) "Total discharged energy for previous cycle";
  //SI.Energy E_pump_prev(start = 0.001) "Total pump energy losses for previous cycle";
  //Real util_prev(start = 0.001) "Previous day's level, starts at 0.1% to prevent divbyzero";
  //Real time_stop(start = 3600.0 * 24.0 * 10.0) "The maximum time this simulation can last";
  //Integer Control_State(start = 1) "Control state 1= Charge 2=Standby 3=Discharge";
  //Boolean Begin_PB(start = false);
  Boolean Chg(start = false);
  Boolean Dis(start = false);
  
  SI.HeatFlowRate Q_chg = thermocline_Tank.Tank_A.Q_input;
  SI.HeatFlowRate Q_dis = thermocline_Tank.Tank_A.m_flow*(thermocline_Tank.Tank_A.h_out-thermocline_Tank.Tank_A.h_in);
  //Real Level_high(start = 1.0);
  //Real Level_low(start = 0.0);
  //Real Level_mid(start = 0.5);
  Modelica.Blocks.Sources.RealExpression realExpression(y = Q_charge_signal) annotation(
    Placement(visible = true, transformation(origin = {-100, 27}, extent = {{-20, -19}, {20, 19}}, rotation = 0)));
algorithm
  when rem(time, t_cycle) > 6.0*3600.0*1e-6 then
    //if thermocline_Tank.Tank_A.T_p[N_f-1] < T_chg_stop - 50.0 then
      Chg := true;
    //end if;
  end when;
  
  when thermocline_Tank.Tank_A.T_p[N_f-1] > T_PB_min then 
      if rem(time, t_cycle) < t_charge +t_discharge then
        Dis := true;
      end if;
  end when;
  //when thermocline_Tank.Tank_A.T_f[N_f-1] > T_PB_min then
    //if time < t_charge + t_discharge then
      //Dis := true;
    //end if;
  //end when;
  
  //when thermocline_Tank.Tank_A.T_p[N_f-1] > T_chg_stop then
    //Chg := false;
  //end when;
  
  /*
  when thermocline_Tank.Tank_A.T_p[N_f-1] < T_chg_stop - 10.0 then
    Chg := true;
  end when;
  */
  
  //when rem(time, t_cycle) > t_charge + t_discharge + 1e-6 then //Shut down
    //Chg := false;
    //Dis := false;
  //end when;
  
  when thermocline_Tank.Tank_A.T_p[N_f] < T_PB_min - 25.0 then 
      Dis := false;
  end when; 

equation
  if Chg == true then
    if rem(time, t_cycle) > 6.0*3600.0 and rem(time, t_cycle) <= 9.0*3600.0 then
      Q_charge_signal = Q_chg_des * (((rem(time, t_cycle)-6.0*3600)/(3.0*3600.0))*(170/420) + 250/420 );
    elseif rem(time, t_cycle) > 9.0*3600.0 and rem(time, t_cycle) <= 15.0*3600.0 then
      Q_charge_signal = Q_chg_des;
    elseif rem(time, t_cycle) > 15.0*3600.0 and rem(time, t_cycle) <= 18.0*3600.0 then
      Q_charge_signal = Q_chg_des * (( (18.0*3600.0-rem(time, t_cycle))/(3.0*3600.0))*(170/420) + 250/420 );
    else
      Q_charge_signal = 0.0;
    end if;
    else
    Q_charge_signal = 0.0;
  end if;
  
  if Dis == true then
    m_PB_signal = m_discharge_des * (h_f_des - h_f_min) / (thermocline_Tank.h_top_outlet - h_f_min);
  else
    m_PB_signal = 1e-8;
  end if;

//Measured temperature sensors
  T_top_degC = thermocline_Tank.T_top_measured - 273.15;
  T_bot_degC = thermocline_Tank.T_bot_measured - 273.15;
//Combined storage outlet temperatures (25degC if no flow)
  //if thermocline_Tank.fluid_a.m_flow > 1.0e-3 then
//there is mass flow
    //T_outlet_degC = thermocline_Tank.fluid_bot.T - 273.15;
  //else
  if thermocline_Tank.fluid_a.m_flow < (-1.0e-3) then
    T_outlet_degC = thermocline_Tank.fluid_top.T - 273.15;
  else
    T_outlet_degC = 25.0;
  end if;
  if time > 9.0*t_cycle then
//this is the final cycle
//Charging Phase
    if rem(time, t_cycle) < t_charge + t_extension then
      der(E_chg) = thermocline_Tank.Tank_A.Q_input;
//thermocline_Tank.fluid_a.m_flow * (inStream(thermocline_Tank.fluid_a.h_outflow) - thermocline_Tank.fluid_b.h_outflow);
      der(E_dis) = thermocline_Tank.fluid_b.m_flow * (thermocline_Tank.fluid_a.h_outflow - inStream(thermocline_Tank.fluid_b.h_outflow));
      der(X_chg) = thermocline_Tank.Tank_A.Q_input;
//thermocline_Tank.fluid_a.m_flow * (inStream(thermocline_Tank.fluid_a.h_outflow) * (1.0 - 298.15 / thermocline_Tank.fluid_top.T) - thermocline_Tank.fluid_b.h_outflow * (1.0 - 298.15 / thermocline_Tank.fluid_bot.T));
      der(X_dis) = thermocline_Tank.fluid_b.m_flow * (thermocline_Tank.fluid_a.h_outflow * (1.0 - 298.15 / thermocline_Tank.fluid_top.T) - inStream(thermocline_Tank.fluid_b.h_outflow) * (1.0 - 298.15 / thermocline_Tank.fluid_bot.T));
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
  if time > 9.0*t_cycle + t_charge + 100.0 then
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
  connect(thermocline_Tank.T_amb, Tamb.y) annotation(
    Line(points = {{-17, -8}, {-17, -7}, {-53, -7}, {-53, -32}}, color = {0, 0, 127}));
  connect(thermocline_Tank.p_amb, p_amb.y) annotation(
    Line(points = {{17, -2}, {28, -2}, {28, 0}, {35, 0}}, color = {0, 0, 127}));
  connect(PB_outlet.ports[1], pumpSimple_EqualPressure3.fluid_a) annotation(
    Line(points = {{76, -60}, {50, -60}}, color = {0, 127, 255}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure3.m_flow) annotation(
    Line(points = {{88, 3}, {70, 3}, {70, -30}, {40, -30}, {40, -52}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure3.fluid_b, thermocline_Tank.fluid_b) annotation(
    Line(points = {{30, -60}, {0, -60}, {0, -32}}, color = {0, 127, 255}));
  connect(realExpression.y, thermocline_Tank.Q_input) annotation(
    Line(points = {{-78, 28}, {-54, 28}, {-54, 3}, {-17, 3}}, color = {0, 0, 127}));
  connect(thermocline_Tank.fluid_a, PB_Sink.port_a) annotation(
    Line(points = {{0, 28}, {0, 58}, {84, 58}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 864000, StartTime = 0, Tolerance = 1e-3, Interval = 60),
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false)),
    Icon(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false)));
end RadCharge_160kWt_v2;