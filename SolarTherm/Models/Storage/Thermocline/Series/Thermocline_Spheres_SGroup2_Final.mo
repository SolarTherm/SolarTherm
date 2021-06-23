within SolarTherm.Models.Storage.Thermocline.Series;

model Thermocline_Spheres_SGroup2_Final
  //Three Tanks in series
  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  //Initialise Material Packages
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Materials.PartialMaterial;
  replaceable package Filler_Package_A = SolarTherm.Materials.PartialMaterial; //Bot
  replaceable package Filler_Package_B = SolarTherm.Materials.PartialMaterial; //Mid
  replaceable package Filler_Package_C = SolarTherm.Materials.PartialMaterial; //Top
  replaceable package Encapsulation_Package_A = Filler_Package_A; //Defaults to filler material
  replaceable package Encapsulation_Package_B = Filler_Package_B; //Defaults to filler material
  replaceable package Encapsulation_Package_C = Filler_Package_C; //Defaults to filler material
  //Storage Parameter Settings
  parameter Integer Correlation = 3 "Interfacial convection correlation {1 = WakaoKaguei, 2 = MelissariArgyropoulos, 3 = Conservative}";
    //Storage Cpacity and Fractions
  parameter SI.Energy E_max = 144.0e9 "Maximum storage capacity of entire group";
  parameter Real frac_1 = 0.5 "Fraction of storage capacity of Tank_A";
    //Aspect ratios (H/D) of tanks
  parameter Real ar_A = 2.0 "Aspect ratio of tank A";
  parameter Real ar_B = ar_A "Aspect ratio of tank B";
    //Porosity of tank filler materials
  parameter Real eta_A = 0.26 "Porosity";
  parameter Real eta_B = eta_A "Porosity";
    //Filler diameter of materials
  parameter Real d_p_A = 0.3 "Filler diameter";
  parameter Real d_p_B = d_p_A "Filler diameter";
    //Discretization settings
  parameter Integer N_f_A = 10 "Number of fluid CVs in Tank_A";
  parameter Integer N_p_A = 5 "Number of filler CVs in Tank_A";  
  parameter Integer N_f_B = N_f_A "Number of fluid CVs in Tank_B";
  parameter Integer N_p_B = N_p_A "Number of filler CVs in Tank_B";
    //Encapsulation thickness
  parameter SI.Length t_e_A = d_p_A/(2*N_p_A) "Encapsulation thickness"; //Defaults to equidistant radial
  parameter SI.Length t_e_B = d_p_B/(2*N_p_B) "Encapsulation thickness"; //Defaults to equidistant radial
    //Heat loss coefficient of tanks
  parameter SI.CoefficientOfHeatTransfer U_loss_tank_A = 0.1 "W/m2K";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank_B = U_loss_tank_A "W/m2K";
    //Temperature settings
  parameter SI.Temperature T_min = CV.from_deg(515) "Minimum temperature (design) also starting T";
  parameter SI.Temperature T_max = CV.from_deg(715) "Maximum design temperature (design)";
  
  //Input and Output Ports
  Modelica.Blocks.Interfaces.RealOutput T_top_measured "Temperature at the top of the tank as an output signal (K)" annotation (Placement(visible = true,transformation(
          extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_bot_measured "Temperature at the bottom of the tank as an output signal (K)" annotation (Placement(visible = true,transformation(
          extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {45, -55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)" annotation (Placement(visible = true,transformation(
          origin = {-40, -74},extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-27, -65}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
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
        
  //Initialize Tank_A (Bottom)
  SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_Section_Final Tank_A(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_A, redeclare replaceable package Encapsulation_Package = Encapsulation_Package_A, Correlation = Correlation, E_max = E_max*frac_1, ar = ar_A, eta = eta_A, d_p = d_p_A, T_min = T_min, T_max = T_max, N_f = N_f_A, N_p = N_p_A, U_loss_tank = U_loss_tank_A, t_e = t_e_A, z_offset = 0.0);
  //Initialize Tank_B (Top)
  SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_Section_Final Tank_B(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_B, redeclare replaceable package Encapsulation_Package = Encapsulation_Package_B, Correlation = Correlation, E_max = E_max*(1.0-frac_1), ar = ar_B, eta = eta_B, d_p = d_p_B, T_min = T_min, T_max = T_max, N_f = N_f_B, N_p = N_p_B, U_loss_tank = U_loss_tank_B, t_e = t_e_B, z_offset = Tank_A.H_tank);
  
  //Cost BreakDown
  parameter Real C_filler = Tank_A.C_filler + Tank_B.C_filler;
  parameter Real C_fluid = Tank_A.C_fluid + Tank_B.C_fluid;
  parameter Real C_total = Tank_A.C_section + Tank_B.C_section;
  parameter Real C_tank = Tank_A.C_tank + Tank_B.C_tank;
  parameter Real C_insulation = Tank_A.C_insulation + Tank_B.C_insulation;
  parameter Real C_encapsulation = Tank_A.C_encapsulation + Tank_B.C_encapsulation;
  
  //Analysis of fluid entering and exiting storage
  Fluid_Package.State fluid_top "Fluid entering/exiting top";
  Fluid_Package.State fluid_bot "Fluid entering/exiting bottom";

  //Analytics
    //Tank Energy Levels
      //Tank Energy Levels
  Modelica.Blocks.Interfaces.RealOutput Level "Level of the entire storage" annotation(
    Placement(visible = true, transformation(extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 21}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
    //Tank Temperature measurements
  Modelica.Blocks.Interfaces.RealOutput T_95_measured = Interpolate_Temperature(ZDH,T_f_degC,N_f_A+N_f_B,0.95) + 273.15 "Temperature at the 95% height of the tank as an output signal (K)" annotation (Placement(visible = true,transformation(
          extent = {{40, 36}, {60, 56}}, rotation = 0), iconTransformation(origin = {45, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_05_measured = Interpolate_Temperature(ZDH,T_f_degC,N_f_A+N_f_B,0.05) + 273.15"Temperature at the 5% height of the tank as an output signal (K)" annotation (Placement(visible = true,transformation(
          extent = {{40, -54}, {60, -34}}, rotation = 0), iconTransformation(origin = {45, -39}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
    
    //Tank Non-dimensionalized vertical axis
  parameter Real ZDH[N_f_A+N_f_B] = cat(1,((Tank_A.ZDH.*Tank_A.H_tank).+Tank_A.z_offset)./(Tank_A.H_tank+Tank_B.H_tank),((Tank_B.ZDH.*Tank_B.H_tank).+Tank_B.z_offset)./(Tank_A.H_tank+Tank_B.H_tank));
    //Tank Temperature profiles in degC units
  Real T_f_degC[N_f_A+N_f_B](start=fill(T_min,N_f_A+N_f_B));
  
algorithm
  T_bot_measured := Tank_A.T_f[1];
  T_top_measured := Tank_B.T_f[N_f_B];
equation
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
  T_f_degC = (cat(1,Tank_A.T_f,Tank_B.T_f)).-273.15;
  //Calculate tank energy level
  Level = (Tank_A.Level*Tank_A.E_max+Tank_B.Level*Tank_B.E_max)/E_max;
  
  //Determine tank outlet enthalpy used by external control system
  h_bot_outlet = Tank_A.h_f[1];
  
  
  if fluid_a.m_flow > 0.0 then// charging
    Tank_B.m_flow = -1.0*fluid_a.m_flow;
    Tank_B.h_in = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = Tank_B.h_in;
    fluid_b.h_outflow = Tank_A.h_out;
    Tank_A.h_in = Tank_B.h_out;
  else//discharging
    Tank_B.m_flow = -1.0*fluid_a.m_flow;
    Tank_A.h_in = inStream(fluid_b.h_outflow);
    fluid_b.h_outflow = Tank_A.h_in;
    fluid_a.h_outflow = Tank_B.h_out;
    Tank_B.h_in = Tank_A.h_out;
  end if;
  
  //Connect pressure and ambient temp
  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  T_amb = Tank_A.T_amb;
  T_amb = Tank_B.T_amb;
  

  //Intertank connection
  fluid_a.m_flow = -1.0*fluid_b.m_flow; //always true for a steady state component
  Tank_A.m_flow = Tank_B.m_flow;

annotation(
    Icon(graphics = {Rectangle(origin = {9, 49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-49, 11}, {31, -109}}), Rectangle(origin = {7, 43}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Rectangle(origin = {7, 33}, fillColor = {124, 124, 124}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Rectangle(origin = {7, 23}, fillColor = {113, 113, 113}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Rectangle(origin = {7, -17}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Rectangle(origin = {7, 13}, fillColor = {104, 104, 104}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Rectangle(origin = {7, -27}, fillColor = {89, 89, 89}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Rectangle(origin = {7, -37}, fillColor = {71, 71, 71}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Rectangle(origin = {7, -47}, fillColor = {66, 66, 66}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Text(origin = {-35, -31}, extent = {{-5, 5}, {5, -7}}, textString = "A"), Text(origin = {-35, 31}, extent = {{-5, 5}, {5, -7}}, textString = "B"), Ellipse(origin = {-25, 45}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {25, 45}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {15, 45}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {5, 45}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-5, 45}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-15, 45}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-21, -45}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {19, -45}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {9, -45}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-1, -45}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-11, -45}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-19, 35}, fillColor = {80, 0, 20}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-9, 35}, fillColor = {80, 0, 20}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {21, 35}, fillColor = {80, 0, 20}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {1, 35}, fillColor = {80, 0, 20}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {11, 35}, fillColor = {80, 0, 20}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-25, 25}, fillColor = {60, 0, 40}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-15, 25}, fillColor = {60, 0, 40}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {15, 25}, fillColor = {60, 0, 40}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-5, 25}, fillColor = {60, 0, 40}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {5, 25}, fillColor = {60, 0, 40}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {25, 25}, fillColor = {60, 0, 40}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-21, 15}, fillColor = {50, 0, 50}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {19, 15}, fillColor = {50, 0, 50}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {9, 15}, fillColor = {50, 0, 50}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-1, 15}, fillColor = {50, 0, 50}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-11, 15}, fillColor = {50, 0, 50}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-25, -15}, fillColor = {50, 0, 50}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {25, -15}, fillColor = {50, 0, 50}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {15, -15}, fillColor = {50, 0, 50}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {5, -15}, fillColor = {50, 0, 50}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-5, -15}, fillColor = {50, 0, 50}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-15, -15}, fillColor = {50, 0, 50}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-21, -25}, fillColor = {40, 0, 60}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-11, -25}, fillColor = {40, 0, 60}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {19, -25}, fillColor = {40, 0, 60}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {9, -25}, fillColor = {40, 0, 60}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-1, -25}, fillColor = {40, 0, 60}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-25, -35}, fillColor = {20, 0, 80}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-15, -35}, fillColor = {20, 0, 80}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {25, -35}, fillColor = {20, 0, 80}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {15, -35}, fillColor = {20, 0, 80}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {5, -35}, fillColor = {20, 0, 80}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-5, -35}, fillColor = {20, 0, 80}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Text(origin = {59, 66}, extent = {{-15, 4}, {25, -12}}, textString = "T_top_measured"), Text(origin = {18, 80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_a"), Text(origin = {50, 35.5}, extent = {{-6, 2.5}, {10, -7.5}}, textString = "T_95%"), Text(origin = {50, -10}, extent = {{-8, 6}, {8, -6}}, textString = "p_amb"), Text(origin = {50, -26.5}, extent = {{-6, 2.5}, {10, -7.5}}, textString = "T_05%"), Text(origin = {62, -63}, extent = {{-18, 5}, {24, -9}}, textString = "T_bot_measured"), Text(origin = {18, -80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_b"), Text(origin = {-52, -75}, extent = {{-28, 3}, {28, -3}}, textString = "h_bot_outlet"), Text(origin = {-62, 11}, extent = {{-8, 3}, {8, -3}}, textString = "T_amb"), Line(points = {{0, 10}, {0, -10}}), Line(origin = {0, 55}, points = {{0, 5}, {0, -5}}), Line(origin = {0, -56}, points = {{0, -6}, {0, 6}})}, coordinateSystem(initialScale = 0.1)));
end Thermocline_Spheres_SGroup2_Final;