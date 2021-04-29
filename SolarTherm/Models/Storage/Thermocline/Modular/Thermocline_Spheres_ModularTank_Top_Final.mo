within SolarTherm.Models.Storage.Thermocline.Modular;

model Thermocline_Spheres_ModularTank_Top_Final
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
  
  //ModularTank Inputs and Outputs
    Modelica.Blocks.Interfaces.RealOutput k_1 = Tank_A.k_f[1] "Bottom node fluid thermal conductivity"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {20, -64}, extent = {{-4, -4}, {4, 4}}, rotation = -90)));
          
    Modelica.Blocks.Interfaces.RealOutput T_1 = Tank_A.T_f[1] "Bottom node fluid temperature"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {30, -64}, extent = {{-4, -4}, {4, 4}}, rotation = -90)));
    
    Modelica.Blocks.Interfaces.RealInput k_b "Fluid thermal conductivity of the immediately tank BELOW this one" annotation (Placement(
        visible = true,transformation(
        
        origin={-50, 8.88178e-16},extent={{-10, -10}, {10, 10}},
        rotation=0), iconTransformation(
        
        origin={-30, -64},extent={{-4, -4}, {4, 4}},
        rotation= 90)));
        
    Modelica.Blocks.Interfaces.RealInput T_b "Fluid temperature of the immediately tank BELOW this one" annotation (Placement(
        visible = true,transformation(
        
        origin={-50, 8.88178e-16},extent={{-10, -10}, {10, 10}},
        rotation=0), iconTransformation(
        
        origin={-20, -64},extent={{-4, -4}, {4, 4}},
        rotation= 90)));
          
  //Initialize Tank
  SolarTherm.Models.Storage.Thermocline.Modular.Thermocline_Spheres_ModularSection_Top_Final Tank_A(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package, redeclare replaceable package  Encapsulation_Package = Encapsulation_Package, Correlation = Correlation, E_max = E_max, ar = ar, eta = eta, d_p = d_p, T_min = T_min, T_max = T_max, N_f = N_f, N_p = N_p, U_loss_tank = U_loss_tank, t_e = t_e);


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
  
algorithm
  //ModularSection equations
  Tank_A.T_b := T_b;
  Tank_A.k_b := k_b;
  
   if fluid_a.m_flow > 0.0 then //mass is flowing into the top, direction is downwards so Tank_A.m_flow is (negative), charging
    //Tank_A.m_flow = -1.0*fluid_a.m_flow;
    //Tank_A.h_in := inStream(fluid_a.h_outflow);
    fluid_a.h_outflow := Tank_A.h_in;//Tank_A.h_f[N_f];//fluid_top.h;
    fluid_b.h_outflow := Tank_A.h_out;//Tank_A.h_f[1];//fluid_bot.h;
  else //discharging
    //Tank_A.m_flow = -1.0*fluid_a.m_flow;
    //Tank_A.h_in := inStream(fluid_b.h_outflow);
    fluid_a.h_outflow := Tank_A.h_out;//Tank_A.h_f[N_f];//fluid_top.h;
    fluid_b.h_outflow := Tank_A.h_in;//Tank_A.h_f[1];//fluid_bot.h;
  end if;

equation
  if fluid_a.m_flow > 0.0 then
    Tank_A.h_in = inStream(fluid_a.h_outflow);
  else
    Tank_A.h_in = inStream(fluid_b.h_outflow);
  end if;
  /*
  if fluid_a.m_flow > 0.0 then //mass is flowing into the top, direction is downwards so Tank_A.m_flow is (negative), charging
    Tank_A.h_in = fluid_top.h;//fluid_a.h_outflow;//inStream(fluid_a.h_outflow);
  else //discharging
    Tank_A.h_in = fluid_bot.h;//fluid_b.h_outflow;//inStream(fluid_b.h_outflow);
  end if;
  */
  if fluid_a.m_flow > 0.0 then//1e-6 then
    fluid_top.h = inStream(fluid_a.h_outflow);
    fluid_bot.h = fluid_b.h_outflow;
  else//if fluid_a.m_flow < 0.0 then //-1e-6 then
    fluid_top.h = fluid_a.h_outflow;
    fluid_bot.h = inStream(fluid_b.h_outflow);
  //else
    //fluid_top.T = 298.15;
    //fluid_bot.T = 298.15;
  end if;
  //Convert from Kelvin to degC for easier plotting
  T_f_degC = (Tank_A.T_f).-273.15;
  
  //Calculate tank energy level
  Level = Tank_A.Level;
  
  //Determine tank outlet enthalpy used by external control system
  //h_bot_outlet = Tank_A.h_f[1];
  
  //Mass balance
  fluid_a.m_flow = -1.0*fluid_b.m_flow; //always true for a steady state component
  Tank_A.m_flow = -1.0*fluid_a.m_flow;

  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  T_amb = Tank_A.T_amb;
  T_top_measured = Tank_A.T_f[N_f];
  T_bot_measured = Tank_A.T_f[1];
  



annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Icon(graphics = {Text(origin = {0, 1}, extent = {{-14, -21}, {14, 21}}, textString = "Top"), Line(origin = {-39.806, -75.4478}, points = {{0, -15}, {0, 15}}, pattern = LinePattern.DashDot), Line(origin = {40.2387, -75.4478}, points = {{0, -15}, {0, 15}}, pattern = LinePattern.DashDot)}, coordinateSystem(initialScale = 0.1)));
end Thermocline_Spheres_ModularTank_Top_Final;