within SolarTherm.Models.Storage.Thermocline.Annular;

model Thermocline_Annular_SingleTank_SM

  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  //Initialise Material Packages
  replaceable package Medium = SolarTherm.Media.Air.Air_amb_p;
  replaceable package Fluid_Package = SolarTherm.Materials.PartialMaterial;
  replaceable package Filler_Package = SolarTherm.Materials.PartialMaterial;
  
  //Storage Parameter Settings
  parameter Integer Correlation = 2 "1=Smooth_Pipes, 2=SwameeJain_KawaseDe, 3=SwameeJain_GowenSmith, 4=SwameeJain_Gnielinski";
  parameter SI.Length E_roughness = 46.0e-6 "Pipe surface roughness (m)"; //{drawn tubing = 1.5e-6, commercial steel = 46.0e-6, cast iron = 260.0e-6, concrete = 300-3000e-6}
  parameter SI.ThermalInsulance R_foul = 0.0 "Fouling factor (m2K/W)";
    //Storage Capacity
  parameter SI.Energy E_max = 144.0e9 "Maximum storage capacity";
  parameter Real N_units = Tank_A.E_max/Tank_A.E_unit;
    
    //Storage Geometry  SI.HeatFlowRate Q_loss_total "Heat loss from the entire surface area (W)";
  SI.Pressure p_drop_total "Sum of all pressure drops (Pa)";
  SI.Power W_loss_pump "losses due to pressure drop (W)";
  parameter SI.Length d_pipe = 0.10 "Air pipe diameter (m)";
  parameter SI.Length d_solid = 0.20 "Solid cylinder outer diameter (m)";
  parameter SI.Length L_pipe = 10.0 "Length of the pipe in x-axis (m)";
  
  //Just to help visualise
  
  
    //Discretization Settings
  parameter Integer N_f = 10;
  parameter Integer N_p = 5;
  
  
  //Heat loss coefficient of tanks
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.4 "W/m2K";
  
  //Temperature Settings
  parameter SI.Temperature T_min = 100.0 + 273.15  "Minimum design temperature also initial T (K)";
  parameter SI.Temperature T_max = 300.0 + 273.15 "Maximum design temperature (K)";


  //Input and Output Ports
  Modelica.Blocks.Interfaces.RealOutput T_top_measured "Temperature at the top of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_bot_measured "Temperature at the bottom of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {45, -57}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
          
  Modelica.Blocks.Interfaces.RealOutput T_p_top_measured = Tank_A.T_s[N_f] "Temperature of the innermost solid element at the the hot-end of the TES (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 36}, {60, 56}}, rotation = 0), iconTransformation(origin = {45, 43}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_p_bot_measured = Tank_A.T_s[1] "Temperature of the innermost solid element at the the cold-end of the TES (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, -54}, {60, -34}}, rotation = 0), iconTransformation(origin = {45, -45}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (J/kg)"
                                          annotation (Placement(visible = true,transformation(
          origin = {-40, -70},extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-27, -69}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
          
  Modelica.Blocks.Interfaces.RealOutput h_top_outlet "Enthaply at the top of the tank as an output signal (J/kg)"
                                          annotation (Placement(visible = true,transformation(
          origin = {-40, 56},extent = {{10, -10}, {-10, 10}}, rotation = -90), iconTransformation(origin = {-27, 65}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));
          
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
  SolarTherm.Models.Storage.Thermocline.Annular.Annular_Storage_Section_SM Tank_A(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package, Correlation = Correlation, T_min = T_min, T_max = T_max, N_f = N_f, N_p = N_p,E_max = E_max,L_pipe=L_pipe,d_pipe=d_pipe,d_solid=d_solid,U_loss_tank=U_loss_tank,E_roughness=E_roughness, R_foul = R_foul);


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
  h_top_outlet = Tank_A.h_f[N_f];
  
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
  T_top_measured = Tank_A.T_f[N_f];// 0.5*(Tank_A.T_f[N_f]+Tank_A.T_s[N_f]);//Tank_A.T_f[N_f];;Tank_A.T_p[N_f,1];
  T_bot_measured = Tank_A.T_f[1];//0.5*(Tank_A.T_f[1]+Tank_A.T_s[1]);//Tank_A.T_f[1];//Tank_A.T_p[1,1];
  
  
  p_drop_total = Tank_A.p_drop_total;
  W_loss_pump = Tank_A.W_loss_pump;
annotation(
    Icon(graphics = {Text(origin = {-60, 11}, extent = {{-8, 3}, {8, -3}}, textString = "T_amb"), Text(origin = {54, -12}, extent = {{-8, 6}, {8, -6}}, textString = "p_amb"), Text(origin = {-52, -71}, extent = {{-28, 3}, {28, -3}}, textString = "h_bot_outlet"), Text(origin = {64, -65}, extent = {{-18, 5}, {24, -9}}, textString = "T_bot_measured"), Text(origin = {61, 70}, extent = {{-15, 4}, {25, -12}}, textString = "T_top_measured"), Text(origin = {18, 80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_a"), Text(origin = {18, -80}, extent = {{-12, 4}, {12, -4}}, textString = "fluid_b"), Text(origin = {54, 39.5}, extent = {{-6, 2.5}, {34, -7.5}}, textString = "T_p_top_measured"), Text(origin = {56, -48.5}, extent = {{-6, 2.5}, {38, -11.5}}, textString = "T_p_bot_measured"), Text(origin = {56, 27}, extent = {{-8, 3}, {8, -3}}, textString = "Level"), Ellipse(origin = {-30, -56}, fillColor = {153, 153, 153}, fillPattern = FillPattern.Solid, extent = {{-10, 4}, {70, -12}}, endAngle = 360), Rectangle(fillColor = {153, 153, 153}, fillPattern = FillPattern.Solid, extent = {{-40, 60}, {40, -60}}), Rectangle(origin = {0, -2}, fillColor = {153, 153, 153}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-39.5, -56}, {40, -60}}), Ellipse(origin = {-30, 64}, fillColor = {207, 207, 207}, fillPattern = FillPattern.Solid, extent = {{-10, 4}, {70, -12}}, endAngle = 360), Rectangle(fillColor = {227, 227, 227}, pattern = LinePattern.Dash, extent = {{-10, 60}, {10, -68}}), Ellipse(origin = {-42, 60}, fillColor = {221, 221, 221}, fillPattern = FillPattern.Solid, extent = {{32, 2}, {52, -2}}, endAngle = 360), Line(origin = {0, 64}, points = {{0, 4}, {0, -4}}), Text(origin = {-50, 69}, extent = {{-28, 3}, {28, -3}}, textString = "h_top_outlet")}, coordinateSystem(initialScale = 0.1)), Documentation(revisions = "<html><head></head><body><p>By Zebedee Kee on 07-Aug-2025</p>
		</body></html>",info= "<html><head></head><body><p>This model contains the fluid_a (top) and fluid_b (bottom) ports, basically a complete TES component. This model simply connects the Annular_Storage_Section_SM to the correct ports.</p><p><u>Correlation Settings:</u></p><p><b>1. Smooth Pipes. f: Petukhov, Nu: Gnielinski</b></p><p>0.5 &lt; Pr &lt; 2000 (Gnielinski)</p><p>Re &lt; 5000000 (Gnielinski)</p><p><b>2. Rough Pipes. f: Swamee-Jain, Nu: Kawase-De.&nbsp;</b><b>High Prandtl number e.g oils or cool water.&nbsp;</b></p><p>0.0024 &lt; E/d &lt; 0.1 (Swamee-Jain &amp; Kawase-De combined restriction)</p><p>5.1 &lt; Pr &lt; 390 (Kawase-De)&nbsp;</p><p>Re &lt; 500000 (Kawase-De)</p><p><b>3. Rough Pipes. f: Swamee-Jain, Nu: Gowen-Smith. Med-Low Prandtl number e.g. cool water, gases.</b></p><p>0.021 &lt; E/d &lt; 0.095 (Gowen-Smith)</p><p>0.7 &lt; Pr &lt; 14.3 (Gowen-Smith)</p><p>Re &lt; 50000 (Gowen-Smith)</p><p><b>4. Rough Pipes. f: Swamee-Jain, Nu: Gnielinski. Smooth-pipe Nusselt number correlation but using a rough-tube friction factor. Not recommended due to overestimation of heat-transfer correlation</b></p><p>2.0e-8 &lt; E/d &lt; 0.1 (Swamee-Jain)</p><p>0.5 &lt; Pr &lt; 2000 (Gnielinski)</p><p>Re &lt; 5000000 (Gnielinski)</p>
		</body></html>"));

end Thermocline_Annular_SingleTank_SM;