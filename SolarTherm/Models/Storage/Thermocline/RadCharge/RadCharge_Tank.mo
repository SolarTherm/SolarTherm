within SolarTherm.Models.Storage.Thermocline.RadCharge;

model RadCharge_Tank
  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  //Initialise Material Packages
  replaceable package Medium = SolarTherm.Media.Air.Air_amb_p;
  replaceable package Fluid_Package = SolarTherm.Materials.PartialMaterial;
  replaceable package Filler_Package = SolarTherm.Materials.PartialMaterial;
  //replaceable package Encapsulation_Package = Filler_Package; //Defaults to filler material
  
  //Storage Parameter Settings
  parameter Integer Correlation = 1 "Interfacial convection correlation {1 = WakaoKaguei, 2 = MelissariArgyropoulos, 3 = Conservative}";
    //Storage CApacity
  parameter SI.Energy E_max = 144.0e9 "Maximum storage capacity";
  parameter Integer N_f = 6;
  parameter Real eta = 0.25;
  parameter SI.Length H_unit = 0.50;
  parameter SI.WaveNumber c_surf = 10.0 "Total surface area to Volume ratio (m^-1)";
  parameter SI.Length L_char = 0.05 "Characteristic length of channel for convection calculations";
  parameter SI.Temperature T_rad = CV.from_degC(1100);

  
    //Porosity of tank filler materials
  //parameter Real eta = 0.22 "Porosity";
  
    //Filler diameter of materials
  //parameter SI.Length d_p = 0.015 "Filler sphere diameter";
  
    //Encapsulation thickness
  //parameter SI.Length t_e = d_p/(2*N_p) "Encapsulation thickness"; //Defaults to equidistant radial discretization
  
    //Discretization Settings
  //parameter Integer N_f = 10;
  //parameter Integer N_p = 5;
  
  
  //Heat loss coefficient of tanks
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.4 "W/m2K";
  
  //Temperature Settings
  parameter SI.Temperature T_min = CV.from_deg(290) "Minimum temperature (design) also starting T";
  parameter SI.Temperature T_max = CV.from_deg(574) "Maximum design temperature (design)";


  //Input and Output Ports
  Modelica.Blocks.Interfaces.RealOutput T_top_measured "Temperature at the top of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_bot_measured "Temperature at the bottom of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {45, -57}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
          
  Modelica.Blocks.Interfaces.RealOutput T_p_top_measured = Tank_A.T_p[N_f] "Temperature of the innermost solid element at the the hot-end of the TES (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 36}, {60, 56}}, rotation = 0), iconTransformation(origin = {45, 43}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_p_bot_measured = Tank_A.T_p[1] "Temperature of the innermost solid element at the the cold-end of the TES (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, -54}, {60, -34}}, rotation = 0), iconTransformation(origin = {45, -45}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  
          
  Modelica.Blocks.Interfaces.RealOutput h_top_outlet "Enthaply at the top of the tank as an output signal (J/kg)"
                                          annotation (Placement(visible = true,transformation(
          origin = {-40, 56},extent = {{10, -10}, {-10, 10}}, rotation = -90), iconTransformation(origin = {-27, 65}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealInput Q_input "Direct Charging" annotation (Placement(
        visible = true,transformation(
        
        origin={-50, 12},extent={{-10, -10}, {10, 10}},
        rotation=0), iconTransformation(
        
        origin={-46, 14},extent={{-6, -6}, {6, 6}},
        rotation=0)));
       
  Modelica.Blocks.Interfaces.RealInput T_amb "Ambient Temperature" annotation (Placement(
        visible = true,transformation(
        
        origin={-50, -16},extent={{-10, -10}, {10, 10}},
        rotation=0), iconTransformation(
        
        origin={-46, -16},extent={{-6, -6}, {6, 6}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation (Placement(
        visible = true,transformation(
        
        origin={48, 8.88178e-16},extent={{10, -10}, {-10, 10}},
        rotation=0), iconTransformation(
        
        origin={46, 0},extent={{6, -6}, {-6, 6}},
        rotation=0)));
  
  //Initialize Tank
  SolarTherm.Models.Storage.Thermocline.RadCharge.RadCharge_Section Tank_A(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package, Correlation = Correlation, T_min = T_min, T_max = T_max, N_f = N_f,E_max = E_max,U_loss_tank=U_loss_tank, eta = eta, H_unit = H_unit, c_surf = c_surf, L_char = L_char, T_rad = T_rad );


  //Cost BreakDown
  //parameter Real C_filler = Tank_A.C_filler;
  //parameter Real C_fluid = Tank_A.C_fluid;
  //parameter Real C_total = Tank_A.C_section;
  //parameter Real C_tank = Tank_A.C_tank;
  //parameter Real C_insulation = Tank_A.C_insulation;
  //parameter Real C_encapsulation = Tank_A.C_encapsulation;
  //Theoretical Tank Level
  Modelica.Blocks.Interfaces.RealOutput Level "Theoretical Tank Level"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 16}, {60, 36}}, rotation = 0), iconTransformation(origin = {45, 21}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  //Tank Non-dimensionalized vertical axis
  parameter Real ZDH[N_f] = Tank_A.ZDH;
  
  //Plotting Temperature degC
  Real T_f_degC[N_f](start=fill(T_min,N_f));
  
  //Analysis of fluid entering and exiting storage
  Fluid_Package.State fluid_top "Fluid entering/exiting top";
  Fluid_Package.State fluid_bot "Fluid entering/exiting bottom";
  
equation
  //Charging Rate
  if Tank_A.T_p[N_f-1] > T_rad - 10.0 then
    Tank_A.Q_input = 0.0;
  else
    Tank_A.Q_input = Q_input;
  end if;
  //if fluid_a.m_flow > 1e-6 then
    fluid_top.h = inStream(fluid_a.h_outflow);
    fluid_bot.h = fluid_b.h_outflow;
  //elseif fluid_a.m_flow < -1e-6 then
    //fluid_top.h = fluid_a.h_outflow;
    //fluid_bot.h = inStream(fluid_b.h_outflow);
  //else
    //fluid_top.T = 298.15;
    //fluid_bot.T = 298.15;
  //end if;
  //Convert from Kelvin to degC for easier plotting
  T_f_degC = (Tank_A.T_f).-273.15;
  
  //Calculate tank energy level
  Level = Tank_A.Level;
  
  //Determine tank outlet enthalpy used by external control system
  //h_bot_outlet = Tank_A.h_f[1];
  h_top_outlet = Tank_A.h_f[N_f];
  
  //Mass balance
  fluid_a.m_flow = -1.0*fluid_b.m_flow; //always true for a steady state component
  //if fluid_a.m_flow > 0.0 then //mass is flowing into the top, direction is downwards so Tank_A.m_flow is (negative), charging
    //Tank_A.m_flow = -1.0*fluid_a.m_flow;
    //Tank_A.h_in = inStream(fluid_a.h_outflow);
    //fluid_a.h_outflow = Tank_A.h_in;//Tank_A.h_f[N_f];//fluid_top.h;
    //fluid_b.h_outflow = Tank_A.h_out;//Tank_A.h_f[1];//fluid_bot.h;
  //else //discharging
    Tank_A.m_flow = -1.0*fluid_a.m_flow;
    Tank_A.h_in = inStream(fluid_b.h_outflow);
    fluid_a.h_outflow = Tank_A.h_out;//Tank_A.h_f[N_f];//fluid_top.h;
    fluid_b.h_outflow = Tank_A.h_in;//Tank_A.h_f[1];//fluid_bot.h;
  //end if;

  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  T_amb = Tank_A.T_amb;
  T_top_measured = Tank_A.T_f[N_f];// 0.5*(Tank_A.T_f[N_f]+Tank_A.T_s[N_f]);//Tank_A.T_f[N_f];;Tank_A.T_p[N_f,1];
  T_bot_measured = Tank_A.T_f[1];//0.5*(Tank_A.T_f[1]+Tank_A.T_s[1]);//Tank_A.T_f[1];//Tank_A.T_p[1,1];

annotation(
    Icon(graphics = {Text(origin = {-64, -27}, extent = {{-8, 3}, {8, -3}}, textString = "T_amb"), Text(origin = {54, -12}, extent = {{-8, 6}, {8, -6}}, textString = "p_amb"), Text(origin = {-52, -71}, extent = {{-28, 3}, {28, -3}}, textString = "h_bot_outlet"), Text(origin = {64, -65}, extent = {{-18, 5}, {24, -9}}, textString = "T_bot_measured"), Text(origin = {61, 70}, extent = {{-15, 4}, {25, -12}}, textString = "T_top_measured"), Text(origin = {18, 80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_a"), Text(origin = {18, -80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_b"), Text(origin = {54, 39.5}, extent = {{-6, 2.5}, {34, -7.5}}, textString = "T_p_top_measured"), Text(origin = {56, -48.5}, extent = {{-6, 2.5}, {38, -11.5}}, textString = "T_p_bot_measured"), Text(origin = {56, 27}, extent = {{-8, 3}, {8, -3}}, textString = "Level"), Rectangle(origin = {0, -2},fillColor = {220, 220, 220}, fillPattern = FillPattern.Solid, extent = {{-40, 62}, {40, -60}}), Line(origin = {0, 64}, points = {{0, 4}, {0, -4}}), Text(origin = {-50, 69}, extent = {{-28, 3}, {28, -3}}, textString = "h_top_outlet"), Text(origin = {-64, 29}, extent = {{-8, 3}, {12, -7}}, textString = "Q_input"), Polygon(origin = {-30, 35}, fillColor = {248, 120, 81}, fillPattern = FillPattern.Backward, points = {{-4, -11}, {-4, -87}, {4, -79}, {4, -3}, {-4, -11}}), Rectangle(origin = {24, -48}, fillColor = {106, 106, 106}, fillPattern = FillPattern.Solid, extent = {{-34, 6}, {12, -10}}), Rectangle(origin = {24, -28}, fillColor = {106, 106, 106}, fillPattern = FillPattern.Solid, extent = {{-34, 6}, {12, -10}}), Rectangle(origin = {24, 32}, fillColor = {106, 106, 106}, fillPattern = FillPattern.Solid, extent = {{-34, 6}, {12, -10}}), Rectangle(origin = {24, -8}, fillColor = {106, 106, 106}, fillPattern = FillPattern.Solid, extent = {{-34, 6}, {12, -10}}), Rectangle(origin = {24, 12}, fillColor = {106, 106, 106}, fillPattern = FillPattern.Solid, extent = {{-34, 6}, {12, -10}}), Rectangle(origin = {24, 52}, fillColor = {106, 106, 106}, fillPattern = FillPattern.Solid, extent = {{-34, 6}, {12, -10}}), Line(origin = {-17.1183, 27.8973}, points = {{-6, -5}, {6, 5}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-18, 17.9052}, points = {{-6, -5}, {6, 5}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-17.7061, 8.79467}, points = {{-6, -5}, {6, 5}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-18, -1.19749}, points = {{-6, -5}, {6, 5}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-18.2939, -11.1897}, points = {{-6, -5}, {6, 5}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-18, -21.7696}, points = {{-6, -5}, {6, 5}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-17.7061, -32.6434}, points = {{-6, -5}, {6, 5}}, arrow = {Arrow.None, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)), Documentation(revisions ="<html>
		<p>By Zebedee Kee on 03/12/2020</p>
		</html>",info="<html>
		<p>This model contains the fluid_a (top) and fluid_b (bottom) ports, basically a complete CSP component. This model simply connects the Thermocline_Spheres_Section models to the correct ports.</p>
		</html>"));
end RadCharge_Tank;