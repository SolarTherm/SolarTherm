within SolarTherm.Models.Storage.Thermocline;

model Thermocline_Spheres_SingleTank_LC_Final_for_FMU

  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  //Initialise Material Packages
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Materials.Sodium;
  replaceable package Filler_Package = SolarTherm.Materials.MgO_Constant;
  replaceable package Encapsulation_Package = Filler_Package; //Defaults to filler material
  
  //Storage Parameter Settings
  parameter Integer Correlation = 1 "Interfacial convection correlation {1 = WakaoKaguei, 2 = MelissariArgyropoulos, 3 = Conservative}";
    //Storage CApacity
  parameter SI.Energy E_max = 144.0e9 "Maximum storage capacity";
  parameter SI.Energy E_min = 100e9 "Minimum storage capacity";
  parameter SI.Energy E_init = 100e9 "Initial storage capacity";
  
    //Aspect ratios (H/D) of tank
  parameter Real ar = 2.0 "Aspect ratio of tank";
  
    //Porosity of tank filler materials
  parameter Real eta = 0.22 "Porosity";
  
    //Filler diameter of materials
  parameter SI.Length d_p = 0.015 "Filler sphere diameter";
  
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
  SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_Section_LC_Final Tank_A(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package, Correlation = Correlation, E_max = E_max, ar = ar, eta = eta, d_p = d_p, T_min = T_min, T_max = T_max, N_f = N_f, U_loss_tank = U_loss_tank);
  
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
  
  //************* Tracking the storage energy
  SI.Energy E_stored(start=E_init);
  
  //Analysis of fluid entering and exiting storage
  //Fluid_Package.State fluid_top "Fluid entering/exiting top";
  //Fluid_Package.State fluid_bot "Fluid entering/exiting bottom";
  Modelica.Blocks.Interfaces.RealOutput SOC annotation(
    Placement(visible = true, transformation(extent = {{40, 18}, {60, 38}}, rotation = 0), iconTransformation(origin = {45, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
equation
  //if fluid_a.m_flow > 1e-6 then
  //  fluid_top.h = inStream(fluid_a.h_outflow);
  //  fluid_bot.h = fluid_b.h_outflow;
  //elseif fluid_a.m_flow < -1e-6 then
  //  fluid_top.h = fluid_a.h_outflow;
  //  fluid_bot.h = inStream(fluid_b.h_outflow);
  //else
  //  fluid_top.h = Fluid_Package.h_Tf(298.15);
  //  fluid_bot.h = Fluid_Package.h_Tf(298.15);
  //end if;
  //Convert from Kelvin to degC for easier plotting
  T_f_degC = (Tank_A.T_f).-273.15;
  
  //Calculate tank energy level
  Level = Tank_A.Level;
  
  //Determine tank outlet enthalpy used by external control system
  h_bot_outlet = Tank_A.h_f[1];
  
  //Mass balance
  //fluid_a.m_flow = -1.0*fluid_b.m_flow; //always true for a steady state component
    Tank_A.m_flow = -1.0*fluid_a.m_flow;
    
  if fluid_a.m_flow > 0.0 then //mass is flowing into the top, direction is downwards so Tank_A.m_flow is (negative), charging
    //Tank_A.m_flow = -1.0*fluid_a.m_flow;
    Tank_A.h_in = inStream(fluid_a.h_outflow);
    
    Tank_A.h_in = fluid_a.h_outflow;//Tank_A.h_f[N_f];//fluid_top.h;
    
    fluid_b.h_outflow = Tank_A.h_out;//Tank_A.h_f[1];//fluid_bot.h;
  else //discharging
    //Tank_A.m_flow = -1.0*fluid_a.m_flow;
    Tank_A.h_in = inStream(fluid_b.h_outflow);
    
    fluid_a.h_outflow = Tank_A.h_out;//Tank_A.h_f[N_f];//fluid_top.h;
    
    fluid_b.h_outflow = Tank_A.h_in;//Tank_A.h_f[1];//fluid_bot.h;
  end if;

  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  T_amb = Tank_A.T_amb;
  T_top_measured = Tank_A.T_f[N_f];
  T_bot_measured = Tank_A.T_f[1];
  
  
  der(E_stored) = abs(Tank_A.m_flow) * (Tank_A.h_in - Tank_A.h_out) - Tank_A.Q_loss_total;
  SOC = E_stored / E_max;

annotation(
    Icon(graphics = {Text(origin = {7, -16}, extent = {{-49, 42}, {35, -10}}, textString = "TC"), Ellipse(origin = {-36, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-16, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-26, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {24, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {4, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {14, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, 56}, fillColor = {240, 50, 0}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-20, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-10, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {0, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {20, 46}, fillColor = {220, 50, 20}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {24, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {14, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {4, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-16, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-26, 36}, fillColor = {200, 50, 40}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {20, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {0, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-10, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-20, 26}, fillColor = {180, 50, 60}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, 16}, fillColor = {160, 50, 80}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, 16}, fillColor = {160, 50, 80}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, 6}, fillColor = {140, 50, 100}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, 6}, fillColor = {140, 50, 100}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, -4}, fillColor = {120, 50, 120}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, -4}, fillColor = {120, 50, 120}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, -14}, fillColor = {100, 50, 140}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, -14}, fillColor = {100, 50, 140}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {24, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {14, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {4, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-16, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-26, -24}, fillColor = {80, 50, 160}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {20, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {0, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-10, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-20, -34}, fillColor = {60, 50, 180}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-36, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {34, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {24, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {14, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {4, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-6, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-16, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-26, -44}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-30, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {30, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {20, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {10, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {0, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-10, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Ellipse(origin = {-20, -54}, fillColor = {40, 50, 200}, fillPattern = FillPattern.Sphere, extent = {{-4, 4}, {6, -6}}, endAngle = 360), Text(origin = {-62, 11}, extent = {{-8, 3}, {8, -3}}, textString = "T_amb"), Text(origin = {62, 12}, extent = {{-8, 6}, {8, -6}}, textString = "p_amb"), Text(origin = {-52, -65}, extent = {{-28, 3}, {28, -3}}, textString = "h_bot_outlet"), Text(origin = {48, -63}, extent = {{-18, 5}, {24, -9}}, textString = "T_bot_measured"), Text(origin = {49, 70}, extent = {{-15, 4}, {25, -12}}, textString = "T_top_measured"), Text(origin = {18, 80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_a"), Text(origin = {18, -80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_b"), Text(origin = {50, 35.5}, extent = {{-6, 2.5}, {10, -7.5}}, textString = "T_95%"), Text(origin = {50, -26.5}, extent = {{-6, 2.5}, {10, -7.5}}, textString = "T_05%")}, coordinateSystem(initialScale = 0.1)), Documentation(revisions ="<html>
		<p>By Zebedee Kee on 03/12/2020</p>
		</html>",info="<html>
		<p>This model contains the fluid_a (top) and fluid_b (bottom) ports, basically a complete CSP component. This model simply connects the Thermocline_Spheres_Section models to the correct ports.</p>
		</html>"));

end Thermocline_Spheres_SingleTank_LC_Final_for_FMU;