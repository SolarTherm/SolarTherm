within SolarTherm.Models.Storage.Thermocline.Parallel;

model Thermocline_Spheres_3P_MixedOutlet
  //Three-tank mixed outlet flow, charging C-CB-B-BA-A discharging A-AB-B-BC-C
  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  //Initialise Material Packages
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Materials.PartialMaterial;
  replaceable package Filler_Package_A = SolarTherm.Materials.PartialMaterial;
  replaceable package Filler_Package_B = SolarTherm.Materials.PartialMaterial;
  replaceable package Filler_Package_C = SolarTherm.Materials.PartialMaterial;
  
  replaceable package Encapsulation_Package_A = Filler_Package_A; //Defaults to filler material
  replaceable package Encapsulation_Package_B = Filler_Package_B; //Defaults to filler material
  replaceable package Encapsulation_Package_C = Filler_Package_C; //Defaults to filler material
  //Storage Parameter Settings
  parameter Integer Correlation = 3 "Interfacial convection correlation {1 = WakaoKaguei, 2 = MelissariArgyropoulos, 3 = Conservative}";
    //Storage Cpacity and Fractions
  parameter SI.Energy E_max = 144.0e9 "Maximum storage capacity of entire group (J)";
  parameter Real frac_1 = 1.0 / 3.0 "Fraction of storage capacity of Tank_A";
  parameter Real frac_2 = frac_1 "Fraction of storage capacity of Tank_B";
    //Aspect ratios (H/D) of tanks
  parameter Real ar_A = 2.0 "Aspect ratio of tank";
  parameter Real ar_B = ar_A "Aspect ratio of tank";
  parameter Real ar_C = ar_A "Aspect ratio of tank";
    //Porosity of tank filler materials
  parameter Real eta_A = 0.26 "Porosity";
  parameter Real eta_B = eta_A "Porosity";
  parameter Real eta_C = eta_A "Porosity";
    //Filler diameter of materials
  parameter Real d_p_A = 0.1 "Filler diameter";
  parameter Real d_p_B = d_p_A "Filler diameter";
  parameter Real d_p_C = d_p_A "Filler diameter";
    //Encapsulation thickness
  parameter SI.Length t_e_A = d_p_A/(2*N_p_A) "Encapsulation thickness"; //Defaults to equidistant radial
  parameter SI.Length t_e_B = d_p_B/(2*N_p_B) "Encapsulation thickness"; //Defaults to equidistant radial
  parameter SI.Length t_e_C = d_p_C/(2*N_p_C) "Encapsulation thickness"; //Defaults to equidistant radial
    //Discretization settings
  parameter Integer N_f_A = 20 "Number of fluid CVs in Tank_A";
  parameter Integer N_p_A = 5 "Number of filler CVs in Tank_A";
  parameter Integer N_f_B = N_f_A "Number of fluid CVs in Tank_B";
  parameter Integer N_p_B = N_p_A "Number of filler CVs in Tank_B";
  parameter Integer N_f_C = N_f_A "Number of fluid CVs in Tank_B";
  parameter Integer N_p_C = N_p_A "Number of filler CVs in Tank_B";
    //Heat loss coefficient of tanks
  parameter SI.CoefficientOfHeatTransfer U_loss_tank_A = 0.1 "W/m2K";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank_B = U_loss_tank_A "W/m2K";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank_C = U_loss_tank_A "W/m2K";
    //Temperature settings
  parameter SI.Temperature T_min = CV.from_deg(515) "Minimum temperature (design) also starting T";
  parameter SI.Temperature T_max = CV.from_deg(715) "Maximum design temperature (design)";
    //Internal control for temperature
  parameter SI.Temperature T_recv_set = 273.15 + 570.0 "Temperature of T_05 at which it switches to the next tank during charging";
  parameter SI.Temperature T_PB_set = 273.15 + 680.0 "Temperature of T_95 at which it switches to the previous tank durng discharging";
  //Internal Controls
  //Integer Active_Tank(start = 1) "Which tank is in use currently";
  Real f_chg_guess_1(start=0.0) "Fraction of mass flow of secondary tank during charging";
  Real f_disch_guess_1(start=0.0) "Fraction of mass flow of secondary tank during discharging";
  
  Real f_chg_guess_2(start=0.0) "Fraction of mass flow of secondary tank during charging";
  Real f_disch_guess_2(start=0.0) "Fraction of mass flow of secondary tank during discharging";
  
  Real f_chg(start=0.0) "Fraction of mass flow of secondary tank during charging";
  Real f_disch(start=0.0) "Fraction of mass flow of secondary tank during discharging";
  
  Integer Charge_State(start=1) "1 = Only A, 2 = B assists A, 3 = Only B";
  Integer Discharge_State(start=1) "1 = Only A, 2 = B assists A, 3 = Only B";
  
  parameter SI.SpecificEnthalpy h_recv_set = Fluid_Package.h_Tf(T_recv_set,0.0);
  parameter SI.SpecificEnthalpy h_PB_set = Fluid_Package.h_Tf(T_PB_set,0.0);
  
  //Input and Output Ports
  Modelica.Blocks.Interfaces.RealOutput T_top_measured "Temperature at the top of the tank as an output signal (K)" annotation(
    Placement(visible = true, transformation(extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_bot_measured "Temperature at the bottom of the tank as an output signal (K)" annotation(
    Placement(visible = true, transformation(extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {45, -55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)" annotation(
    Placement(visible = true, transformation(extent = {{40, -72}, {60, -52}}, rotation = 0), iconTransformation(origin = {-27, -65}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_amb "Ambient Temperature" annotation(
    Placement(visible = true, transformation(origin = {-50, 8.88178e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-46, 0}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation(
    Placement(visible = true, transformation(origin = {48, 8.88178e-16}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {46, 0}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  //Initialize Tank_A
  SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_Section_Final Tank_A(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_A, redeclare replaceable package Encapsulation_Package = Encapsulation_Package_A, Correlation = Correlation, E_max = E_max * frac_1, ar = ar_A, eta = eta_A, d_p = d_p_A, T_min = T_min, T_max = T_max, N_f = N_f_A, N_p = N_p_A, U_loss_tank = U_loss_tank_A, t_e = t_e_A, z_offset = 0.0, eff_pump=eff_pump);
  //Initialize Tank_B
  SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_Section_Final Tank_B(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_B, redeclare replaceable package Encapsulation_Package = Encapsulation_Package_B, Correlation = Correlation, E_max = E_max * (frac_2), ar = ar_B, eta = eta_B, d_p = d_p_B, T_min = T_min, T_max = T_max, N_f = N_f_B, N_p = N_p_B, U_loss_tank = U_loss_tank_B, t_e = t_e_B, z_offset = 0.0, eff_pump=eff_pump);
  //Initialize Tank_C
  SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_Section_Final Tank_C(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_C, redeclare replaceable package Encapsulation_Package = Encapsulation_Package_C, Correlation = Correlation, E_max = E_max * (1.0 - frac_1 - frac_2), ar = ar_C, eta = eta_C, d_p = d_p_C, T_min = T_min, T_max = T_max, N_f = N_f_C, N_p = N_p_C, U_loss_tank = U_loss_tank_C, t_e = t_e_C, z_offset = 0.0, eff_pump=eff_pump);

  //Cost BreakDown
  parameter Real C_filler = Tank_A.C_filler + Tank_B.C_filler + Tank_C.C_filler;
  parameter Real C_fluid = Tank_A.C_fluid + Tank_B.C_fluid + Tank_C.C_fluid;
  parameter Real C_total = Tank_A.C_section + Tank_B.C_section + Tank_C.C_section;
  parameter Real C_tank = Tank_A.C_tank + Tank_B.C_tank + Tank_C.C_tank;
  parameter Real C_insulation = Tank_A.C_insulation + Tank_B.C_insulation + Tank_C.C_insulation;
  parameter Real C_encapsulation = Tank_A.C_encapsulation + Tank_B.C_encapsulation + Tank_C.C_encapsulation;
  
  //Analytics
    //Tank Energy Levels
  Modelica.Blocks.Interfaces.RealOutput Level "Level of the entire storage" annotation(
    Placement(visible = true, transformation(extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 21}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

    //Tank Non-dimensionalized vertical axis
  parameter Real ZDH_A[N_f_A] = Tank_A.ZDH;
  parameter Real ZDH_B[N_f_B] = Tank_B.ZDH;
  parameter Real ZDH_C[N_f_C] = Tank_C.ZDH;
    //Tank Temperature profiles in degC units
  Real T_f_A_degC[N_f_A](start = fill(T_min, N_f_A));
  Real T_f_B_degC[N_f_B](start = fill(T_min, N_f_B));
  Real T_f_C_degC[N_f_C](start = fill(T_min, N_f_C));
    //Tank temperature at 5% and 95% vertical positions

  parameter SI.MassFlowRate m_0 = 1.0e-7 "Minimum mass flow rate, just to avoid zero";
  
  //Analysis of fluid entering and exiting storage
  Fluid_Package.State fluid_top "Fluid entering/exiting top";
  Fluid_Package.State fluid_bot "Fluid entering/exiting bottom";
  
  //Enthaply tolerance to avoid chattering
  parameter SI.SpecificEnthalpy h_tol = 0.005*(Tank_A.h_f_max - Tank_A.h_f_min) "enthalpy tolerance, 0.5% of maximum difference";
  
  //Total pumping losses
  SI.Power W_loss_pump = Tank_A.W_loss_pump + Tank_B.W_loss_pump + Tank_C.W_loss_pump;
  parameter Real eff_pump = 0.8 "Pumping efficiency, fed into physical model";

algorithm
//Tank A assists Tank B during charging, therefore when Tank B needs help, modify the chargestate boolean
  when Tank_C.T_f[1] > T_recv_set then
    if Charge_State == 1 then
      Charge_State := 2;
    end if;
  elsewhen Tank_B.T_f[1] > T_recv_set then
    if Charge_State == 2 or Charge_State == 3 then
      Charge_State := 4;
    end if;
  elsewhen Tank_B.T_f[1] < T_recv_set - 1 then
    if Charge_State == 4 or Charge_State == 5 then
      Charge_State := 3;
    end if;
  elsewhen Tank_C.T_f[1] < T_recv_set - 1 then
    if Charge_State == 2 or Charge_State == 3 then
      Charge_State := 1;
    end if;
  end when;
//Bottom of C too hot, need help from B
//Bottom of B too hot, need help from A
//Bottom of B now cold enough to charge by itself
//Bottom of C now cold enough to charge by itself
  when f_chg_guess_2 > 1.0 then
    if Charge_State == 4 then
      Charge_State := 5;
    end if;
  end when;
//Tank A no longer able to assist B, proceeds to charge by itself
  when f_chg_guess_1 > 1.0 then
    if Charge_State == 2 then
      if Tank_B.T_f[1] < T_recv_set - 1 then
        Charge_State := 3;
      else
        Charge_State := 4;
      end if;
    end if;
  end when;
//Tank B no longer able to assist C, proceeds to charge itself if below set T
//new
//new
  when f_chg_guess_1 < 0.99 then
    if Charge_State == 3 then
      Charge_State := 2;
    end if;
  end when;
//Tank B now able to assist C
//new
//new
  when f_chg_guess_2 < 0.99 then
    if Charge_State == 5 then
      Charge_State := 4;
    end if;
  end when;
//Tank A now able to assist B
//Tank C assists Tank B during discharge
  when Tank_A.T_f[N_f_A] < T_PB_set then
    if Discharge_State == 1 then
      Discharge_State := 2;
    end if;
  elsewhen Tank_B.T_f[N_f_B] < T_PB_set then
    if Discharge_State == 2 or Discharge_State == 3 then
      Discharge_State := 4;
    end if;
  elsewhen Tank_B.T_f[N_f_B] > T_PB_set + 1 then
    if Discharge_State == 4 or Discharge_State == 5 then
      Discharge_State := 3;
    end if;
  elsewhen Tank_A.T_f[N_f_A] > T_PB_set + 1 then
    if Discharge_State == 2 or Discharge_State == 3 then
      Discharge_State := 1;
    end if;
  end when;
//top of A is too cold, need help from B
//top of B is too cold, need help from C
//top of B is hot enough to discharge by itself
//Top of A is hot enough to discharge by itself
  when f_disch_guess_2 > 1.0 then
    if Discharge_State == 4 then
      Discharge_State := 5;
    end if;
  end when;
//Tank C no longer able to assist B, proceeds to discharge by itself
  when f_disch_guess_1 > 1.0 then
    if Discharge_State == 2 then
      if Tank_B.T_f[N_f_B] > T_PB_set + 1 then
        Discharge_State := 3;
      else
        Discharge_State := 4;
      end if;
    end if;
  end when;
//Tank B no longer able to assist A, proceeds to discharge by itself if above set T
//new
//new
//new
  when f_disch_guess_1 < 0.99 then
    if Discharge_State == 3 then
      Discharge_State := 2;
    end if;
  end when;
//Tank B is now able to assist A
//new
//new
  when f_disch_guess_2 < 0.99 then
    if Discharge_State == 5 then
      Discharge_State := 4;
    end if;
  end when;
//Tank C is now able to assist B
//The assisting tank gets measured
  T_bot_measured := Tank_A.T_f[1];
  T_top_measured := Tank_C.T_f[N_f_C];

equation
  //Figure out assisted mass fraction
  //Tank B assists A discharging, Tank C assist B discharging
  //Discharge
    if Tank_B.h_f[N_f_B] > Tank_A.h_f[N_f_A] + h_tol then //100.0 then
      f_disch_guess_1 = (h_PB_set - Tank_A.h_f[N_f_A]) / (Tank_B.h_f[N_f_B] - Tank_A.h_f[N_f_A]);
    else //Cannot Assist
      f_disch_guess_1 = 0.0;
    end if;

    if Tank_C.h_f[N_f_C] > Tank_B.h_f[N_f_B] + h_tol then //100.0 then
      f_disch_guess_2 = (h_PB_set - Tank_B.h_f[N_f_B]) / (Tank_C.h_f[N_f_C] - Tank_B.h_f[N_f_B]);
    else //Cannot Assist
      f_disch_guess_2 = 0.0;
    end if;

  //Tank A assists B charging, Tank B assists C charging
  //Charge
    if Tank_A.h_f[1] < Tank_B.h_f[1] - h_tol then //100.0 then
      f_chg_guess_2 = (h_recv_set - Tank_B.h_f[1]) / (Tank_A.h_f[1] - Tank_B.h_f[1] );
    else
      f_chg_guess_2 = 0.0;
    end if;

    if Tank_B.h_f[1] < Tank_C.h_f[1] - h_tol then //100.0 then
      f_chg_guess_1 = (h_recv_set - Tank_C.h_f[1]) / (Tank_B.h_f[1] - Tank_C.h_f[1] );
    else
      f_chg_guess_1 = 0.0;
    end if;
  
  //End points (need review)
  if Charge_State == 1 then
    f_chg = 0.0;
  elseif Charge_State == 2 then
    f_chg = f_chg_guess_1;
  elseif Charge_State == 3 then
    f_chg = 0.0;
  elseif Charge_State == 4 then
    f_chg = f_chg_guess_2;
  else
    f_chg = 1.0;
  end if;
  
  if Discharge_State == 1 then
    f_disch = 0.0;
  elseif Discharge_State == 2 then
    f_disch = f_disch_guess_1;
  elseif Discharge_State == 3 then
    f_disch = 0.0;
  elseif Discharge_State == 4 then
    f_disch = f_disch_guess_2;
  else
    f_disch = 1.0;
  end if;
  
  
  //Determine inlet/outlet fluid state for plotting only. If mass flow is close to zero, return 298.15K temperature.
  if fluid_a.m_flow > 1e-6 then
    fluid_top.h = inStream(fluid_a.h_outflow);
    fluid_bot.h = fluid_b.h_outflow;
  elseif fluid_a.m_flow < -1e-6 then
    fluid_top.h = fluid_a.h_outflow;
    fluid_bot.h = inStream(fluid_b.h_outflow);
  else
    fluid_top.T = 298.15;
    fluid_bot.T = 298.15;
  end if;
  //Convert from Kelvin to degC for easier plotting
  T_f_A_degC = Tank_A.T_f .- 273.15;
  T_f_B_degC = Tank_B.T_f .- 273.15;
  T_f_C_degC = Tank_C.T_f .- 273.15;
  //Calculate tank energy level
  Level = frac_1 * Tank_A.Level + frac_2 * Tank_B.Level + (1 - frac_1 - frac_2) * Tank_C.Level;
  //Determine tank outlet enthalpy used by external control system
  /*
  if Active_Tank == 1 then 
    h_bot_outlet = Tank_A.h_f[1];
  elseif Active_Tank == 2 then
    h_bot_outlet = Tank_B.h_f[1];
  else
    h_bot_outlet = Tank_C.h_f[1];
  end if;
  */

  //Charging
  if fluid_a.m_flow > 0.0 then //Charging
      if Charge_State > 2 then
        Tank_C.m_flow = 0.0;
        Tank_B.m_flow = -1.0 * fluid_a.m_flow * (1.0 - f_chg);
        Tank_A.m_flow = -1.0 * fluid_a.m_flow * f_chg;
        
        Tank_A.h_in = inStream(fluid_a.h_outflow);
        Tank_B.h_in = inStream(fluid_a.h_outflow);
        Tank_C.h_in = inStream(fluid_a.h_outflow);
      
        fluid_a.h_outflow = Tank_B.h_in * (1.0 - f_chg) + Tank_A.h_in * (f_chg);
        fluid_b.h_outflow = Tank_B.h_out * (1.0 - f_chg) + Tank_A.h_out * (f_chg);
      
        h_bot_outlet = (1.0 - f_chg)*Tank_B.h_f[1] + f_chg*Tank_A.h_f[1];
      else
        Tank_C.m_flow = -1.0 * fluid_a.m_flow * (1.0 - f_chg);
        Tank_B.m_flow = -1.0 * fluid_a.m_flow * f_chg;
        Tank_A.m_flow = 0.0;
        
        Tank_A.h_in = inStream(fluid_a.h_outflow);
        Tank_B.h_in = inStream(fluid_a.h_outflow);
        Tank_C.h_in = inStream(fluid_a.h_outflow);
      
        fluid_a.h_outflow = Tank_C.h_in * (1.0 - f_chg) + Tank_B.h_in * (f_chg);
        fluid_b.h_outflow = Tank_C.h_out * (1.0 - f_chg) + Tank_B.h_out * (f_chg);
      
        h_bot_outlet = (1.0 - f_chg)*Tank_C.h_f[1] + f_chg*Tank_B.h_f[1];
      end if;
  else //Discharging
      if Discharge_State < 3 then
        Tank_A.m_flow = -1.0 * fluid_a.m_flow * (1.0 - f_disch);
        Tank_B.m_flow = -1.0 * fluid_a.m_flow * f_disch;
        Tank_C.m_flow = 0.0;
      
        Tank_A.h_in = inStream(fluid_b.h_outflow);
        Tank_B.h_in = inStream(fluid_b.h_outflow);
        Tank_C.h_in = inStream(fluid_b.h_outflow);
      
        fluid_a.h_outflow = Tank_A.h_out * (1.0 - f_disch) + Tank_B.h_out * (f_disch);
        fluid_b.h_outflow = Tank_A.h_in * (1.0 - f_disch) + Tank_B.h_in * (f_disch);
      
        h_bot_outlet = (1.0 - f_disch)*Tank_A.h_f[1] + f_disch*Tank_B.h_f[1];
      else
        Tank_A.m_flow = 0.0;
        Tank_B.m_flow = -1.0 * fluid_a.m_flow * (1.0 - f_disch);
        Tank_C.m_flow = -1.0 * fluid_a.m_flow * f_disch;
        
        Tank_A.h_in = inStream(fluid_b.h_outflow);
        Tank_B.h_in = inStream(fluid_b.h_outflow);
        Tank_C.h_in = inStream(fluid_b.h_outflow);
      
        fluid_a.h_outflow = Tank_B.h_out * (1.0 - f_disch) + Tank_C.h_out * (f_disch);
        fluid_b.h_outflow = Tank_B.h_in * (1.0 - f_disch) + Tank_C.h_in * (f_disch);
      
        h_bot_outlet = (1.0 - f_disch)*Tank_B.h_f[1] + f_disch*Tank_C.h_f[1];
      end if;
  end if;
  //Connect pressure and ambient temp
  fluid_a.p = p_amb;
  fluid_a.p = fluid_b.p;
  T_amb = Tank_A.T_amb;
  T_amb = Tank_B.T_amb;
  T_amb = Tank_C.T_amb;
  
  //Steady state mass flows
  fluid_a.m_flow = -1.0 * fluid_b.m_flow;
  annotation(
    Icon(graphics = {Rectangle(origin = {9, 49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-49, 11}, {31, -109}}), Text(origin = {-35, 37}, extent = {{-5, 5}, {5, -7}}, textString = "A"), Text(origin = {-7, 37}, extent = {{-5, 5}, {5, -7}}, textString = "B"), Rectangle(origin = {1, 3}, fillColor = {104, 104, 104}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, 15}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, 11}, fillColor = {124, 124, 124}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, -1}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {-5, 23}, fillColor = {203, 203, 203}, fillPattern = FillPattern.Solid, extent = {{-31, 7}, {-11, 3}}), Rectangle(origin = {1, -5}, fillColor = {89, 89, 89}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {-5, -17}, fillColor = {24, 24, 24}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {-7, 19}, fillColor = {184, 184, 184}, fillPattern = FillPattern.Solid, extent = {{-29, 7}, {-9, 3}}), Rectangle(origin = {-5, -13}, fillColor = {31, 31, 31}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {1, -9}, fillColor = {71, 71, 71}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, -13}, fillColor = {66, 66, 66}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, 7}, fillColor = {113, 113, 113}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {-5, -9}, fillColor = {47, 47, 47}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {21, 23}, fillColor = {203, 203, 203}, fillPattern = FillPattern.Solid, extent = {{-31, 7}, {-11, 3}}), Rectangle(origin = {27, -9}, fillColor = {71, 71, 71}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {27, 11}, fillColor = {124, 124, 124}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {21, -17}, fillColor = {24, 24, 24}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {27, 15}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {27, -13}, fillColor = {66, 66, 66}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {27, -1}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {19, 19}, fillColor = {184, 184, 184}, fillPattern = FillPattern.Solid, extent = {{-29, 7}, {-9, 3}}), Rectangle(origin = {27, 7}, fillColor = {113, 113, 113}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {21, -9}, fillColor = {47, 47, 47}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {27, 3}, fillColor = {104, 104, 104}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {21, -13}, fillColor = {31, 31, 31}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {27, -5}, fillColor = {89, 89, 89}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Line(origin = {-26, -34}, points = {{0, -12}, {0, 12}, {0, 12}}), Line(origin = {-26, 38}, points = {{0, 8}, {0, -8}, {0, -8}}), Line(origin = {-15.5, 46}, points = {{-10.5, 0}, {11.5, 0}, {9.5, 0}}), Line(origin = {-11, 38}, points = {{-11, 8}, {11, 8}, {11, -8}, {11, -8}}), Line(origin = {0, 53}, points = {{0, 7}, {0, -7}, {0, -7}}), Line(origin = {0, -53}, points = {{0, -7}, {0, 7}, {0, 7}}), Line(origin = {-15, -46}, points = {{-11, 0}, {11, 0}, {11, 0}}), Line(origin = {-11, -34}, points = {{11, 12}, {11, -12}, {-11, -12}, {-11, -12}}), Ellipse(origin = {-5, -41}, extent = {{1, -1}, {9, -9}}, endAngle = 360), Ellipse(origin = {-5, 51}, extent = {{1, -1}, {9, -9}}, endAngle = 360), Rectangle(origin = {47, 23}, fillColor = {203, 203, 203}, fillPattern = FillPattern.Solid, extent = {{-31, 7}, {-11, 3}}), Rectangle(origin = {45, 19}, fillColor = {184, 184, 184}, fillPattern = FillPattern.Solid, extent = {{-29, 7}, {-9, 3}}), Rectangle(origin = {53, 15}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, 11}, fillColor = {124, 124, 124}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, 7}, fillColor = {113, 113, 113}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, 3}, fillColor = {104, 104, 104}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, -1}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, -5}, fillColor = {89, 89, 89}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, -9}, fillColor = {71, 71, 71}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, -13}, fillColor = {66, 66, 66}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {47, -9}, fillColor = {47, 47, 47}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {47, -13}, fillColor = {31, 31, 31}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {47, -17}, fillColor = {24, 24, 24}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Line(origin = {13, 38}, points = {{-13, 8}, {13, 8}, {13, -8}, {13, -8}}),  Text(origin = {21, 37}, extent = {{-5, 5}, {5, -7}}, textString = "C"), Line(origin = {13, -34}, points = {{-13, -12}, {13, -12}, {13, 12}, {13, 12}}), Text(origin = {18, 80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_a"), Text(origin = {59, 66}, extent = {{-15, 4}, {25, -12}}, textString = "T_top_measured"), Text(origin = {50, 35.5}, extent = {{-6, 2.5}, {10, -7.5}}, textString = "T_95%"), Text(origin = {50, -10}, extent = {{-8, 6}, {8, -6}}, textString = "p_amb"), Text(origin = {50, -26.5}, extent = {{-6, 2.5}, {10, -7.5}}, textString = "T_05%"), Text(origin = {62, -63}, extent = {{-18, 5}, {24, -9}}, textString = "T_bot_measured"), Text(origin = {18, -80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_b"), Text(origin = {-52, -65}, extent = {{-28, 3}, {28, -3}}, textString = "h_bot_outlet"), Text(origin = {-62, 11}, extent = {{-8, 3}, {8, -3}}, textString = "T_amb")}, coordinateSystem(initialScale = 0.1)));
end Thermocline_Spheres_3P_MixedOutlet;