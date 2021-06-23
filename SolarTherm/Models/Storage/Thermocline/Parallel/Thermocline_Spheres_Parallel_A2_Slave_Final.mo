within SolarTherm.Models.Storage.Thermocline.Parallel;

model Thermocline_Spheres_Parallel_A2_Slave_Final
  //A2 Refers to A: Charge 1-2, Discharge 2-1; 2: 2-Tanks
  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  //Initialise Material Packages
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Materials.PartialMaterial;
  replaceable package Filler_Package_A = SolarTherm.Materials.PartialMaterial;
  replaceable package Filler_Package_B = Filler_Package_A;
  
  replaceable package Encapsulation_Package_A = Filler_Package_A; //Defaults to filler material
  replaceable package Encapsulation_Package_B = Encapsulation_Package_A; //Defaults to filler material
  //Storage Parameter Settings
  parameter Integer Correlation = 3 "Interfacial convection correlation {1 = WakaoKaguei, 2 = MelissariArgyropoulos, 3 = Conservative}";
    //Storage Cpacity and Fractions
  parameter SI.Energy E_max = 144.0e9 "Maximum storage capacity of entire group (J)";
  parameter Real frac_1 = 1.0 / 2.0 "Fraction of storage capacity of Tank_A";
    //Aspect ratios (H/D) of tanks
  parameter Real ar_A = 2.0 "Aspect ratio of tank";
  parameter Real ar_B = ar_A "Aspect ratio of tank";
    //Porosity of tank filler materials
  parameter Real eta_A = 0.26 "Porosity";
  parameter Real eta_B = eta_A "Porosity";
    //Filler diameter of materials
  parameter Real d_p_A = 0.3 "Filler diameter";
  parameter Real d_p_B = d_p_A "Filler diameter";
    //Encapsulation thickness
  parameter SI.Length t_e_A = d_p_A/(2*N_p_A) "Encapsulation thickness"; //Defaults to equidistant radial
  parameter SI.Length t_e_B = d_p_B/(2*N_p_B) "Encapsulation thickness"; //Defaults to equidistant radial
    //Discretization settings
  parameter Integer N_f_A = 20 "Number of fluid CVs in Tank_A";
  parameter Integer N_p_A = 5 "Number of filler CVs in Tank_A";
  parameter Integer N_f_B = N_f_A "Number of fluid CVs in Tank_B";
  parameter Integer N_p_B = N_p_A "Number of filler CVs in Tank_B";
    //Heat loss coefficient of tanks
  parameter SI.CoefficientOfHeatTransfer U_loss_tank_A = 0.1 "W/m2K";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank_B = U_loss_tank_A "W/m2K";
    //Temperature settings
  parameter SI.Temperature T_min = CV.from_deg(515) "Minimum temperature (design) also starting T";
  parameter SI.Temperature T_max = CV.from_deg(715) "Maximum design temperature (design)";
    //Internal control for temperature
  parameter SI.Temperature T_recv_max = 273.15 + 570.0 "Temperature of T_05 at which it switches to the next tank during charging";
  parameter SI.Temperature T_PB_min = 273.15 + 680.0 "Temperature of T_95 at which it switches to the previous tank durng discharging";

  //Internal Controls
  //Integer Active_Tank(start = 1) "Which tank is in use currently";
  Real f_chg_guess(start=0.0) "Fraction of mass flow of secondary tank during charging";
  Real f_disch_guess(start=0.0) "Fraction of mass flow of secondary tank during discharging";
  Real f_chg(start=0.0) "Fraction of mass flow of secondary tank during charging";
  Real f_disch(start=0.0) "Fraction of mass flow of secondary tank during discharging";
  Integer Charge_State(start=1) "1 = Only A, 2 = B assists A, 3 = Only B";
  Integer Discharge_State(start=1) "1 = Only A, 2 = B assists A, 3 = Only B";
  
  parameter SI.SpecificEnthalpy h_recv_max = Fluid_Package.h_Tf(T_recv_max,0.0);
  parameter SI.SpecificEnthalpy h_PB_min = Fluid_Package.h_Tf(T_PB_min,0.0);
  //Input and Output Ports
  Modelica.Blocks.Interfaces.RealOutput T_top_measured "Temperature at the top of the tank as an output signal (K)" annotation(
    Placement(visible = true, transformation(extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_bot_measured "Temperature at the bottom of the tank as an output signal (K)" annotation(
    Placement(visible = true, transformation(extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {45, -55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)" annotation(
    Placement(visible = true, transformation(extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {-27, -65}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_amb "Ambient Temperature" annotation(
    Placement(visible = true, transformation(origin = {-50, 8.88178e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-46, 0}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation(
    Placement(visible = true, transformation(origin = {48, 8.88178e-16}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {46, 0}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  //Initialize Tank_A
  SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_Section_Final Tank_A(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_A, redeclare replaceable package Encapsulation_Package = Encapsulation_Package_A, Correlation = Correlation, E_max = E_max * frac_1, ar = ar_A, eta = eta_A, d_p = d_p_A, T_min = T_min, T_max = T_max, N_f = N_f_A, N_p = N_p_A, U_loss_tank = U_loss_tank_A, t_e = t_e_A, z_offset = 0.0);
  //Initialize Tank_B
  SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_Section_Final Tank_B(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_B, redeclare replaceable package Encapsulation_Package = Encapsulation_Package_B, Correlation = Correlation, E_max = E_max * (1.0 - frac_1), ar = ar_B, eta = eta_B, d_p = d_p_B, T_min = T_min, T_max = T_max, N_f = N_f_B, N_p = N_p_B, U_loss_tank = U_loss_tank_B, t_e = t_e_A, z_offset = 0.0);

  //Cost BreakDown
  parameter Real C_filler = Tank_A.C_filler + Tank_B.C_filler;
  parameter Real C_fluid = Tank_A.C_fluid + Tank_B.C_fluid;
  parameter Real C_total = Tank_A.C_section + Tank_B.C_section;
  parameter Real C_tank = Tank_A.C_tank + Tank_B.C_tank;
  parameter Real C_insulation = Tank_A.C_insulation + Tank_B.C_insulation;
  parameter Real C_encapsulation = Tank_A.C_encapsulation + Tank_B.C_encapsulation;
  
  //Analytics
    //Tank Energy Levels
  Modelica.Blocks.Interfaces.RealOutput Level "Level of the entire storage" annotation(
    Placement(visible = true, transformation(extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 21}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
    //Tank Temperature measurements
  Modelica.Blocks.Interfaces.RealOutput T_95_measured = Interpolate_Temperature(ZDH_A, T_f_A_degC, N_f_A, 0.95) + 273.15 "Temperature at the 95% height of the tank as an output signal (K)" annotation(
    Placement(visible = true, transformation(extent = {{40, 36}, {60, 56}}, rotation = 0), iconTransformation(origin = {45, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_05_measured = Interpolate_Temperature(ZDH_B, T_f_B_degC, N_f_B, 0.05) + 273.15 "Temperature at the 5% height of the tank as an output signal (K)" annotation(
    Placement(visible = true, transformation(extent = {{40, -54}, {60, -34}}, rotation = 0), iconTransformation(origin = {45, -39}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
    //Tank Non-dimensionalized vertical axis
  parameter Real ZDH_A[N_f_A] = Tank_A.ZDH;
  parameter Real ZDH_B[N_f_B] = Tank_B.ZDH;
    //Tank Temperature profiles in degC units
  Real T_f_A_degC[N_f_A](start = fill(T_min, N_f_A));
  Real T_f_B_degC[N_f_B](start = fill(T_min, N_f_B));
    //Tank temperature at 5% and 95% vertical positions
  SI.Temperature T_95_B = Interpolate_Temperature(ZDH_B, T_f_B_degC, N_f_B, 0.95) + 273.15;
  SI.Temperature T_05_A = Interpolate_Temperature(ZDH_A, T_f_A_degC, N_f_A, 0.05) + 273.15;
  parameter SI.MassFlowRate m_0 = 1.0e-7 "Minimum mass flow rate, just to avoid zero";
  
  //Analysis of fluid entering and exiting storage
  Fluid_Package.State fluid_top "Fluid entering/exiting top";
  Fluid_Package.State fluid_bot "Fluid entering/exiting bottom";
  
algorithm
  when Tank_A.T_f[1] > T_recv_max then
    Charge_State := 2;
  elsewhen Tank_A.T_f[1] < T_recv_max - 1 then
    Charge_State := 1;
  end when;
  
  when f_chg_guess > 1.0 then
    Charge_State := 3;
  elsewhen f_chg_guess < 0.99 then
    Charge_State := 2;
  end when;
  
  when Tank_A.T_f[N_f_A] < T_PB_min then
    Discharge_State := 2;
  elsewhen Tank_A.T_f[N_f_A] > T_PB_min + 1 then
    Discharge_State := 1;
  end when;
  
  when f_disch_guess > 1.0 then
    Discharge_State := 3;
  elsewhen f_disch_guess < 0.99 then
    Discharge_State := 2;
  end when;
  
  
  T_bot_measured := Tank_B.T_f[1];
  T_top_measured := Tank_B.T_f[N_f_B];

equation
  
  //Figure out assisted mass fraction
    if Tank_B.h_f[N_f_B] > Tank_A.h_f[N_f_A] + 100.0 then
      f_disch_guess = (h_PB_min - Tank_A.h_f[N_f_A]) / (Tank_B.h_f[N_f_B] - Tank_A.h_f[N_f_A]);
    else //Cannot Assist
      f_disch_guess = 0.0;
    end if;

    if Tank_B.h_f[1] < Tank_A.h_f[1] - 100.0 then
      f_chg_guess = (h_recv_max - Tank_A.h_f[1]) / (Tank_B.h_f[1] - Tank_A.h_f[1] );
    else
      f_chg_guess = 0.0;
    end if;

  if Charge_State == 1 then
    f_chg = 0.0;
  elseif Charge_State == 2 then
    f_chg = f_chg_guess;
  else
    f_chg = 1.0;
  end if;
  
  if Discharge_State == 1 then
    f_disch = 0.0;
  elseif Discharge_State == 2 then
    f_disch = f_disch_guess;
  else
    f_disch = 1.0;
  end if;
  /*
  if Tank_B.h_f[N_f_B] > Tank_A.h_f[N_f_A] then
    f_disch = min(1.0, (h_PB_min - Tank_A.h_f[N_f_A]) / (Tank_B.h_f[N_f_B] - Tank_A.h_f[N_f_A] ));
  else
    f_disch = 0.0;
  end if;
  
  if Tank_B.h_f[1] < Tank_A.h_f[1] then
    f_chg = min(1.0, (h_recv_max - Tank_A.h_f[1]) / (Tank_B.h_f[1] - Tank_A.h_f[1] ));
  else
    f_chg = 0.0;
  end if;
  */
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
  //Calculate tank energy level
  Level = (1 - frac_1) * Tank_B.Level + frac_1 * Tank_A.Level;
  //Determine tank outlet enthalpy used by external control system
  //h_bot_outlet = if Active_Tank == 1 then Tank_A.h_f[1] else Tank_B.h_f[1];
  h_bot_outlet = (1.0 - f_chg)*Tank_A.h_f[1] + f_chg*Tank_B.h_f[1];
  //Figure out which tanks need which equations and connections
  if fluid_a.m_flow > 0.0 then //Charging
      Tank_A.m_flow = -1.0 * fluid_a.m_flow * (1.0 - f_chg);
      Tank_B.m_flow = -1.0 * fluid_a.m_flow * f_chg;
      
      Tank_A.h_in = inStream(fluid_a.h_outflow);
      Tank_B.h_in = inStream(fluid_a.h_outflow);
      
      fluid_a.h_outflow = Tank_A.h_in * (1.0 - f_chg) + Tank_B.h_in * (f_chg);
      fluid_b.h_outflow = Tank_A.h_out * (1.0 - f_chg) + Tank_B.h_out * (f_chg);
  else //Discharging
      Tank_A.m_flow = -1.0 * fluid_a.m_flow * (1.0 - f_disch);
      Tank_B.m_flow = -1.0 * fluid_a.m_flow * f_disch;
      
      Tank_A.h_in = inStream(fluid_b.h_outflow);
      Tank_B.h_in = inStream(fluid_b.h_outflow);
      
      fluid_a.h_outflow = Tank_A.h_out * (1.0 - f_disch) + Tank_B.h_out * (f_disch);
      fluid_b.h_outflow = Tank_A.h_in * (1.0 - f_disch) + Tank_B.h_in * (f_disch);
  end if;
  
  //Connect pressure and ambient temp
  fluid_a.p = p_amb;
  fluid_a.p = fluid_b.p;
  T_amb = Tank_A.T_amb;
  T_amb = Tank_B.T_amb;
  
  //Steady state mass flows
  fluid_a.m_flow = -1.0 * fluid_b.m_flow;
  annotation(
    Icon(graphics = {Rectangle(origin = {9, 49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-49, 11}, {31, -109}}), Text(origin = {-35, 37}, extent = {{-5, 5}, {5, -7}}, textString = "A"), Text(origin = {17, 37}, extent = {{-5, 5}, {5, -7}}, textString = "B"), Rectangle(origin = {1, 3}, fillColor = {104, 104, 104}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, 15}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, 11}, fillColor = {124, 124, 124}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, -1}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {-5, 23}, fillColor = {203, 203, 203}, fillPattern = FillPattern.Solid, extent = {{-31, 7}, {-11, 3}}), Rectangle(origin = {1, -5}, fillColor = {89, 89, 89}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {-5, -17}, fillColor = {24, 24, 24}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {-7, 19}, fillColor = {184, 184, 184}, fillPattern = FillPattern.Solid, extent = {{-29, 7}, {-9, 3}}), Rectangle(origin = {-5, -13}, fillColor = {31, 31, 31}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {1, -9}, fillColor = {71, 71, 71}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, -13}, fillColor = {66, 66, 66}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, 7}, fillColor = {113, 113, 113}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {-5, -9}, fillColor = {47, 47, 47}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {47, 23}, fillColor = {203, 203, 203}, fillPattern = FillPattern.Solid, extent = {{-31, 7}, {-11, 3}}), Rectangle(origin = {53, -9}, fillColor = {71, 71, 71}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, 11}, fillColor = {124, 124, 124}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {47, -17}, fillColor = {24, 24, 24}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {53, 15}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, -13}, fillColor = {66, 66, 66}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, -1}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {45, 19}, fillColor = {184, 184, 184}, fillPattern = FillPattern.Solid, extent = {{-29, 7}, {-9, 3}}), Rectangle(origin = {53, 7}, fillColor = {113, 113, 113}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {47, -9}, fillColor = {47, 47, 47}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {53, 3}, fillColor = {104, 104, 104}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {47, -13}, fillColor = {31, 31, 31}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {53, -5}, fillColor = {89, 89, 89}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Line(origin = {-26, -34}, points = {{0, -12}, {0, 12}, {0, 12}}), Line(origin = {-26, 38}, points = {{0, 8}, {0, -8}, {0, -8}}), Line(origin = {-15.5, 46}, points = {{-10.5, 0}, {11.5, 0}, {9.5, 0}}), Line(origin = {15, 38}, points = {{-11, 8}, {11, 8}, {11, -8}, {11, -8}}), Line(origin = {0, 53}, points = {{0, 7}, {0, -7}, {0, -7}}), Line(origin = {0, -53}, points = {{0, -7}, {0, 7}, {0, 7}}), Line(origin = {-15, -46}, points = {{-11, 0}, {11, 0}, {11, 0}}), Line(origin = {15, -34}, points = {{11, 12}, {11, -12}, {-11, -12}, {-11, -12}}), Ellipse(origin = {-5, -41}, extent = {{1, -1}, {9, -9}}, endAngle = 360), Ellipse(origin = {-5, 51}, extent = {{1, -1}, {9, -9}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
end Thermocline_Spheres_Parallel_A2_Slave_Final;