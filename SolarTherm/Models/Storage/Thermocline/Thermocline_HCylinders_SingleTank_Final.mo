within SolarTherm.Models.Storage.Thermocline;

model Thermocline_HCylinders_SingleTank_Final

  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  //Initialise Material Packages
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Materials.PartialMaterial;
  replaceable package Filler_Package = SolarTherm.Materials.PartialMaterial;
  replaceable package Encapsulation_Package = Filler_Package; //Defaults to filler material
  
  //Storage Parameter Settings
  parameter Integer Correlation = 1 "Interfacial convection correlation {1 = WakaoKaguei, 2 = MelissariArgyropoulos, 3 = Conservative}";
    //Storage CApacity
  parameter SI.Energy E_max = 144.0e9 "Maximum storage capacity";
  
    //Aspect ratios (H/D) of tank
  parameter Real ar = 2.0 "Aspect ratio of tank";
  
    //Porosity of tank filler materials
  parameter Real eta = 0.22 "Porosity";
  
    //Filler diameter of materials
  parameter SI.Length d_p = 0.015 "Filler sphere diameter";
  parameter Real f_ht = 1.0 "filler-fluid surface heat transfer enhancement factor";
  parameter Real f_Nu = 1.0 "Nusselt number correction factor";
  
    //Encapsulation thickness
  parameter SI.Length t_e = d_p/(2*N_p) "Encapsulation thickness"; //Defaults to equidistant radial discretization
  
    //Discretization Settings
  parameter Integer N_f = 10;
  parameter Integer N_p = 5;
  
  
  //Heat loss coefficient of tanks
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.1 "W/m2K";
  
  //Temperature Settings
  parameter SI.Temperature T_min = CV.from_deg(290) "Minimum temperature (design) also starting T";
  parameter SI.Temperature T_max = CV.from_deg(574) "Maximum design temperature (design)";


  //Input and Output Ports
  Modelica.Blocks.Interfaces.RealOutput T_top_measured "Temperature at the top of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_bot_measured "Temperature at the bottom of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {45, -55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
          
  Modelica.Blocks.Interfaces.RealOutput T_95_measured = Interpolate_Temperature(ZDH,T_f_degC,N_f,0.95) + 273.15 "Temperature at the 90% height of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 36}, {60, 56}}, rotation = 0), iconTransformation(origin = {45, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_05_measured = Interpolate_Temperature(ZDH,T_f_degC,N_f,0.05) + 273.15"Temperature at the 10% height of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, -54}, {60, -34}}, rotation = 0), iconTransformation(origin = {45, -39}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          origin = {-40, -70},extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-27, -65}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_amb "Ambient Temperature" annotation (Placement(
        visible = true,transformation(
        
        origin={-50, 8.88178e-16},extent={{-10, -10}, {10, 10}},
        rotation=0), iconTransformation(
        
        origin={-46, 0},extent={{-6, -6}, {6, 6}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation (Placement(
        visible = true,transformation(
        
        origin={48, 8.88178e-16},extent={{10, -10}, {-10, 10}},
        rotation=0), iconTransformation(
        
        origin={46, 0},extent={{6, -6}, {-6, 6}},
        rotation=0)));
  
  //Initialize Tank
  SolarTherm.Models.Storage.Thermocline.Thermocline_HCylinders_Section_Final Tank_A(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package, redeclare replaceable package  Encapsulation_Package = Encapsulation_Package, Correlation = Correlation, E_max = E_max, ar = ar, eta = eta, d_p = d_p, T_min = T_min, T_max = T_max, N_f = N_f, N_p = N_p, U_loss_tank = U_loss_tank, t_e = t_e, f_ht = f_ht, f_Nu = f_Nu);


  //Cost BreakDown
  parameter Real C_filler = Tank_A.C_filler;
  parameter Real C_fluid = Tank_A.C_fluid;
  parameter Real C_total = Tank_A.C_section;
  parameter Real C_tank = Tank_A.C_tank;
  parameter Real C_insulation = Tank_A.C_insulation;
  parameter Real C_encapsulation = Tank_A.C_encapsulation;
  //Theoretical Tank Level
  Real Level;

  //Tank Non-dimensionalized vertical axis
  parameter Real ZDH[N_f] = Tank_A.ZDH;
  
  //Plotting Temperature degC
  Real T_f_degC[N_f](start=fill(T_min,N_f));
  
  //Analysis of fluid entering and exiting storage
  Fluid_Package.State fluid_top "Fluid entering/exiting top";
  Fluid_Package.State fluid_bot "Fluid entering/exiting bottom";
  
equation
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
  T_f_degC = (Tank_A.T_f).-273.15;
  
  //Calculate tank energy level
  Level = Tank_A.Level;
  
  //Determine tank outlet enthalpy used by external control system
  h_bot_outlet = Tank_A.h_f[1];
  
  //Mass balance
  fluid_a.m_flow = -1.0*fluid_b.m_flow; //always true for a steady state component
  if fluid_a.m_flow > 0.0 then //mass is flowing into the top, direction is downwards so Tank_A.m_flow is (negative), charging
    Tank_A.m_flow = -1.0*fluid_a.m_flow;
    Tank_A.h_in = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = Tank_A.h_in;//Tank_A.h_f[N_f];//fluid_top.h;
    fluid_b.h_outflow = Tank_A.h_out;//Tank_A.h_f[1];//fluid_bot.h;
  else //discharging
    Tank_A.m_flow = -1.0*fluid_a.m_flow;
    Tank_A.h_in = inStream(fluid_b.h_outflow);
    fluid_a.h_outflow = Tank_A.h_out;//Tank_A.h_f[N_f];//fluid_top.h;
    fluid_b.h_outflow = Tank_A.h_in;//Tank_A.h_f[1];//fluid_bot.h;
  end if;

  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  T_amb = Tank_A.T_amb;
  T_top_measured = Tank_A.T_f[N_f];
  T_bot_measured = Tank_A.T_f[1];

annotation(
    Icon(graphics = {Text(origin = {-62, 11}, extent = {{-8, 3}, {8, -3}}, textString = "T_amb"), Text(origin = {62, 12}, extent = {{-8, 6}, {8, -6}}, textString = "p_amb"), Text(origin = {-52, -65}, extent = {{-28, 3}, {28, -3}}, textString = "h_bot_outlet"), Text(origin = {48, -63}, extent = {{-18, 5}, {24, -9}}, textString = "T_bot_measured"), Text(origin = {49, 70}, extent = {{-15, 4}, {25, -12}}, textString = "T_top_measured"), Text(origin = {18, 80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_a"), Text(origin = {18, -80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_b"), Text(origin = {50, 35.5}, extent = {{-6, 2.5}, {10, -7.5}}, textString = "T_95%"), Text(origin = {50, -26.5}, extent = {{-6, 2.5}, {10, -7.5}}, textString = "T_05%"), Ellipse(origin = {-23.9, 55.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {-25, 56.5}, rotation = 30, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-23.9, 55.6}, fillColor = {240, 50, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-30, 52}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {1, 56.5}, rotation = 30, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-4, 52}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {2.1, 55.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {2.05, 55.55}, fillColor = {240, 50, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {29, 56.5}, rotation = 30, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {24, 52}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {30.1, 55.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {30.05, 55.55}, fillColor = {240, 50, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {-11, 46.5}, rotation = 30, fillColor = {220, 50, 20}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-16, 42}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-9.9, 45.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-9.95, 45.55}, fillColor = {220, 50, 20}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {15, 46.5}, rotation = 30, fillColor = {220, 50, 20}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {10, 42}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {16.1, 45.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {16.05, 45.55}, fillColor = {220, 50, 20}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {-25, 36.5}, rotation = 30, fillColor = {200, 50, 40}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-30, 32}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-23.9, 35.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-23.95, 35.55}, fillColor = {200, 50, 40}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {1, 36.5}, rotation = 30, fillColor = {200, 50, 40}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-4, 32}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {2.1, 35.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {2.05, 35.55}, fillColor = {200, 50, 40}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {29, 36.5}, rotation = 30, fillColor = {200, 50, 40}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {24, 32}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {30.1, 35.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {30.05, 35.55}, fillColor = {200, 50, 40}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {-11, 26.5}, rotation = 30, fillColor = {180, 50, 60}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-16, 22}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-9.9, 25.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-9.95, 25.55}, fillColor = {180, 50, 60}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {15, 26.5}, rotation = 30, fillColor = {180, 50, 60}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {10, 22}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {16.1, 25.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {16.05, 25.55}, fillColor = {180, 50, 60}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {-25, 16.5}, rotation = 30, fillColor = {160, 50, 80}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-30, 12}, fillColor = {160, 50, 80}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-23.9, 15.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-23.95, 15.55}, fillColor = {160, 50, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {29, 16.5}, rotation = 30, fillColor = {160, 50, 80}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {24, 12}, fillColor = {160, 50, 80}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {30.1, 15.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {30.05, 15.55}, fillColor = {160, 50, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {15, 6.5}, rotation = 30, fillColor = {140, 50, 100}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {10, 2}, fillColor = {140, 50, 100}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {16.1, 5.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {16.05, 5.55}, fillColor = {140, 50, 100}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {-11, 6.5}, rotation = 30, fillColor = {140, 50, 100}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-16, 2}, fillColor = {140, 50, 100}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-9.9, 5.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-9.95, 5.55}, fillColor = {140, 50, 100}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {1, 16.5}, rotation = 30, fillColor = {160, 50, 80}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-4, 12}, fillColor = {160, 50, 80}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {2.1, 15.6}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {2.05, 15.55}, fillColor = {160, 50, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {-25, -3.5}, rotation = 30, fillColor = {120, 50, 120}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-30, -8}, fillColor = {120, 50, 120}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-23.9, -4.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-23.95, -4.45}, fillColor = {120, 50, 120}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {1, -3.5}, rotation = 30, fillColor = {120, 50, 120}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-4, -8}, fillColor = {120, 50, 120}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {2.1, -4.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {2.05, -4.45}, fillColor = {120, 50, 120}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {29, -3.5}, rotation = 30, fillColor = {120, 50, 120}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {24, -8}, fillColor = {120, 50, 120}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {30.1, -4.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {30.05, -4.45}, fillColor = {120, 50, 120}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {-11, -13.5}, rotation = 30, fillColor = {100, 50, 140}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-16, -18}, fillColor = {100, 50, 140}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-9.9, -14.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-9.95, -14.45}, fillColor = {100, 50, 140}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {15, -13.5}, rotation = 30, fillColor = {100, 50, 140}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {10, -18}, fillColor = {100, 50, 140}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {16.1, -14.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {16.05, -14.45}, fillColor = {100, 50, 140}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {-25, -23.5}, rotation = 30, fillColor = {80, 50, 160}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-30, -28}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-23.9, -24.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-23.95, -24.45}, fillColor = {80, 50, 160}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {1, -23.5}, rotation = 30, fillColor = {80, 50, 160}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-4, -28}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {2.1, -24.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {2.05, -24.45}, fillColor = {80, 50, 160}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {29, -23.5}, rotation = 30, fillColor = {80, 50, 160}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {24, -28}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {30.1, -24.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {30.05, -24.45}, fillColor = {80, 50, 160}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {-11, -33.5}, rotation = 30, fillColor = {60, 50, 180}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-16, -38}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-9.9, -34.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-9.95, -34.45}, fillColor = {60, 50, 180}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {15, -33.5}, rotation = 30, fillColor = {60, 50, 180}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {10, -38}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {16.1, -34.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {16.05, -34.45}, fillColor = {60, 50, 180}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {-25, -43.5}, rotation = 30, fillColor = {40, 50, 200}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-30, -48}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-23.9, -44.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-23.95, -44.45}, fillColor = {40, 50, 200}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {1, -43.5}, rotation = 30, fillColor = {40, 50, 200}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-4, -48}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {2.1, -44.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {2.05, -44.45}, fillColor = {40, 50, 200}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {29, -43.5}, rotation = 30, fillColor = {40, 50, 200}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {24, -48}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {30.1, -44.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {30.05, -44.45}, fillColor = {40, 50, 200}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {-11, -53.5}, rotation = 30, fillColor = {0, 50, 240}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {-16, -58}, fillColor = {0, 50, 240}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-9.9, -54.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {-9.95, -54.45}, fillColor = {0, 50, 240}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Rectangle(origin = {15, -53.5}, rotation = 30, fillColor = {0, 50, 240}, fillPattern = FillPattern.Solid, extent = {{-7, 3}, {1, -3}}), Ellipse(origin = {10, -58}, fillColor = {0, 50, 240}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {16.1, -54.4}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Ellipse(origin = {16.05, -54.45}, fillColor = {0, 50, 240}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {2, -2}}, endAngle = 360), Text(origin = {9, -16}, extent = {{-49, 42}, {35, -10}}, textString = "TC")}, coordinateSystem(initialScale = 0.1)), Documentation(revisions ="<html>
		<p>By Zebedee Kee on 03/12/2020</p>
		</html>",info="<html>
		<p>This model contains the fluid_a (top) and fluid_b (bottom) ports, basically a complete CSP component. This model simply connects the Thermocline_Spheres_Section models to the correct ports.</p>
		</html>"));

end Thermocline_HCylinders_SingleTank_Final;