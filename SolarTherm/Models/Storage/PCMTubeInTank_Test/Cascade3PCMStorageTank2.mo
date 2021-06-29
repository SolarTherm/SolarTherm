within SolarTherm.Models.Storage.PCMTubeInTank_Test;

model Cascade3PCMStorageTank2
extends SolarTherm.Interfaces.Models.HeatTransferFluid_3PCMs;

  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Materials.Sodium_Table constrainedby SolarTherm.Media.Materials.PartialMaterial;
  replaceable package Wall_Package = SolarTherm.Media.Materials.PartialMaterial;
  replaceable package PCM_Package1 = SolarTherm.Media.Materials.PartialMaterial;
  replaceable package PCM_Package2 = SolarTherm.Media.Materials.PartialMaterial;  
  replaceable package PCM_Package3 = SolarTherm.Media.Materials.PartialMaterial;   
     
  parameter SI.Temperature T_min = CV.from_degC(540) "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = CV.from_degC(750) "Design hot Temperature of everything in the tank (K)";
  parameter SI.Length L1 = 210 "Length of PCM1_PCM710tank";
  parameter SI.Length L2 = 66.4 "Length of PCM2_PCM635tank";
  parameter SI.Length L3 = 120 "Length of PCM3_PCM569tank";
  parameter SI.Length r_tube_in = 0.006265 "Tube inner radius";
  parameter SI.Length r_tube_out = 0.008575 "Tube outer radius";
  parameter SI.Length r_shell = 0.03 "Shell radius";
  parameter Integer N_tube1 = 1 "Number of tubes"; 
  parameter Integer N_tube2 = 1 "Number of tubes";  
  parameter Integer N_tube3 = 1 "Number of tubes"; 
  parameter Integer N_sec1 = 100 "Number of mesh elements";  
  parameter Integer N_sec2 = 40 "Number of mesh elements"; 
  parameter Integer N_sec3 = 100 "Number of mesh elements"; 
  
  Modelica.Blocks.Interfaces.RealOutput T_top_measured "Temperature at the top of the tank as an an output signal (K)"
                                            annotation (Placement(visible = true,transformation(
            extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {33, 87}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_bot_measured "Temperature at the bottom of the tank as an output signal (K)"
                                            annotation (Placement(visible = true,transformation(
            extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {33, -89}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)"
                                            annotation (Placement(visible = true,transformation(
            extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {-23, -97}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_amb "Ambient Temperature" annotation (Placement(
          visible = true,transformation(
          
          origin={-50, 8.88178e-16},extent={{-10, -10}, {10, 10}},
          rotation=0), iconTransformation(
          
          origin={-34, 18},extent={{-6, -6}, {6, 6}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation (Placement(
          visible = true,transformation(
          
          origin={48, 8.88178e-16},extent={{10, -10}, {-10, 10}},
          rotation=0), iconTransformation(
          
          origin={34, 18},extent={{6, -6}, {-6, 6}},
          rotation=0)));

  
  
  SolarTherm.Models.Storage.PCMTubeInTank_Test.TubeInTank_Section3 Tank_Top(redeclare replaceable package Fluid = Fluid_Package, redeclare replaceable package Wall = Wall_Package, redeclare replaceable package Storage = PCM_Package1, L = L1, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max, N_tube = N_tube1, N_sec = N_sec1);
  SolarTherm.Models.Storage.PCMTubeInTank_Test.TubeInTank_Section3 Tank_Mid(redeclare replaceable package Fluid = Fluid_Package, redeclare replaceable package Wall = Wall_Package, redeclare replaceable package Storage = PCM_Package2, L = L2, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max, N_tube = N_tube2, N_sec = N_sec2);
  SolarTherm.Models.Storage.PCMTubeInTank_Test.TubeInTank_Section3 Tank_Bot(redeclare replaceable package Fluid = Fluid_Package, redeclare replaceable package Wall = Wall_Package, redeclare replaceable package Storage = PCM_Package3, L = L3, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max, N_tube = N_tube3, N_sec = N_sec3);
    
  Fluid_Package.State fluid_top "Fluid entering/exiting top";
  Fluid_Package.State fluid_bot "Fluid entering/exiting bottom";
  
  Real Level "PCM storage charge/discharge level";
  
equation 
  if fluid_a.m_flow > 1.0e-6 then
    fluid_top.h = inStream(fluid_a.h_outflow);
    fluid_bot.h = fluid_b.h_outflow;
  elseif fluid_a.m_flow < -1e-6 then
    fluid_top.h = fluid_a.h_outflow;
    fluid_bot.h = inStream(fluid_b.h_outflow);
  else
    fluid_top.T = 298.15;
    fluid_bot.T = 298.15;
  end if;    
 
 //Calculate tank energy level
  Level = (Tank_Top.Level*Tank_Top.E_max+Tank_Mid.Level*Tank_Mid.E_max+Tank_Bot.Level*Tank_Bot.E_max)/(Tank_Top.E_max + Tank_Mid.E_max + Tank_Bot.E_max);
//Determine tank outlet enthalpy used by external control system
  h_bot_outlet = Tank_Bot.h_f[1];
//Mass balance
  fluid_a.m_flow = -1.0 * fluid_b.m_flow;
//always true for a steady state component
  if fluid_a.m_flow > 1.0e-6 then //mass is flowing into the top, direction is downwards so Tank_Top.m_flow is negative, charging
// charging
    Tank_Top.m_flow = -1.0 * fluid_a.m_flow;
    Tank_Bot.m_flow = Tank_Top.m_flow;
    Tank_Mid.m_flow = Tank_Top.m_flow;  
    Tank_Top.h_in = inStream(fluid_a.h_outflow);
    Tank_Mid.h_in = Tank_Top.h_out;
    Tank_Bot.h_in = Tank_Mid.h_out;
    fluid_a.h_outflow = Tank_Top.h_in;
    fluid_b.h_outflow = Tank_Bot.h_out;
  else
//discharing
    Tank_Bot.m_flow = -1.0*fluid_a.m_flow;
    Tank_Mid.m_flow = Tank_Bot.m_flow;
    Tank_Top.m_flow = Tank_Bot.m_flow;  
    Tank_Bot.h_in = inStream(fluid_b.h_outflow);
    Tank_Mid.h_in = Tank_Bot.h_out;
    Tank_Top.h_in = Tank_Mid.h_out;
    fluid_a.h_outflow = Tank_Top.h_out;
    fluid_b.h_outflow = Tank_Bot.h_in;
  end if;

//End try
  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  T_amb = Tank_Top.T_amb;
  T_amb = Tank_Mid.T_amb;
  T_amb = Tank_Bot.T_amb;
  T_top_measured = Tank_Top.T_f[N_sec1];
  T_bot_measured = Tank_Bot.T_f[1];  
  
annotation(
      Documentation(info ="<html>
       <p>This model contains the same model as described in Cascade3PCMStorageTank, but some variables have been modified for the trainingdata generation and CSP/CST system simulation. The model connects three single PCM tanks connected in series as shown in the figure below. The HTF enters into the cascade storage system from the PCM Tank_Top in charging process (when m_flow < 0) and the PCM Tank_Bot in discharging process (when m_flow > 0), respectively. </p> 
        
        <img src=\"modelica://SolarTherm/Resources/Images/PCMModels/3PCMCascade.png\">                 
        
  		<p>By Ming Liu on 22/06/2021</p>
  		</html>"));

annotation (Icon(coordinateSystem(initialScale = 0.1))); 
 

end Cascade3PCMStorageTank2;
