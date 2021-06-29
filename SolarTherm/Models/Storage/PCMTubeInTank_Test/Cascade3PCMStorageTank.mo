within SolarTherm.Models.Storage.PCMTubeInTank_Test;

model Cascade3PCMStorageTank
extends SolarTherm.Interfaces.Models.HeatTransferFluid_3PCMs;

  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Media.Materials.PartialMaterial;
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
  parameter Integer N_sec1 = 20 "Number of mesh elements";  
  parameter Integer N_sec2 = 20 "Number of mesh elements"; 
  parameter Integer N_sec3 = 20 "Number of mesh elements"; 

  //Cost of Storage Tank
  parameter Real Cost_Storage = Cost_StorageTank_Top.TotalCost + Cost_StorageTank_Mid.TotalCost + Cost_StorageTank_Bot.TotalCost "Cost of storage tank";  
  
  Modelica.Blocks.Interfaces.RealOutput T_top_measured "Temperature at the top of the tank as an an output signal (K)"
                                            annotation (Placement(visible = true,transformation(
            extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {35, 87}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_bot_measured "Temperature at the bottom of the tank as an output signal (K)"
                                            annotation (Placement(visible = true,transformation(
            extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {35, -91}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)"
                                            annotation (Placement(visible = true,transformation(
            extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {-17, -97}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_amb "Ambient Temperature" annotation (Placement(
          visible = true,transformation(
          
          origin={-50, 8.88178e-16},extent={{-10, -10}, {10, 10}},
          rotation=0), iconTransformation(
          
          origin={-34, 40},extent={{-6, -6}, {6, 6}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation (Placement(
          visible = true,transformation(
          
          origin={48, 8.88178e-16},extent={{10, -10}, {-10, 10}},
          rotation=0), iconTransformation(
          
          origin={34, 38},extent={{6, -6}, {-6, 6}},
          rotation=0)));
  
  SolarTherm.Models.Storage.PCMTubeInTank_Test.TubeInTank_Section2 Tank_Top(redeclare replaceable package Fluid = Fluid_Package, redeclare replaceable package Wall = Wall_Package, redeclare replaceable package Storage = PCM_Package1, L = L1, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max, N_tube = N_tube1, N_sec = N_sec1);
  SolarTherm.Models.Storage.PCMTubeInTank_Test.TubeInTank_Section2 Tank_Mid(redeclare replaceable package Fluid = Fluid_Package, redeclare replaceable package Wall = Wall_Package, redeclare replaceable package Storage = PCM_Package2, L = L2, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max, N_tube = N_tube2, N_sec = N_sec2);
  SolarTherm.Models.Storage.PCMTubeInTank_Test.TubeInTank_Section2 Tank_Bot(redeclare replaceable package Fluid = Fluid_Package, redeclare replaceable package Wall = Wall_Package, redeclare replaceable package Storage = PCM_Package3, L = L3, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max, N_tube = N_tube3, N_sec = N_sec3);

  SolarTherm.Models.Storage.PCMTubeInTank_Test.Cost_PCMStorage Cost_StorageTank_Top(redeclare replaceable package Fluid = Fluid_Package, redeclare replaceable package Tank = Wall_Package, redeclare replaceable package Tube = Wall_Package,redeclare replaceable package Storage = PCM_Package1, L = L1, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, N_tube = N_tube1);
  
  SolarTherm.Models.Storage.PCMTubeInTank_Test.Cost_PCMStorage Cost_StorageTank_Mid(redeclare replaceable package Fluid = Fluid_Package, redeclare replaceable package Tank = Wall_Package, redeclare replaceable package Tube = Wall_Package,redeclare replaceable package Storage = PCM_Package2, L = L2, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, N_tube = N_tube2);   
  
  SolarTherm.Models.Storage.PCMTubeInTank_Test.Cost_PCMStorage Cost_StorageTank_Bot(redeclare replaceable package Fluid = Fluid_Package, redeclare replaceable package Tank = Wall_Package, redeclare replaceable package Tube = Wall_Package,redeclare replaceable package Storage = PCM_Package3, L = L3, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, N_tube = N_tube3);
       
  Medium.BaseProperties fluid_top;
  Medium.BaseProperties fluid_bot;
  
equation 
  fluid_top.p = fluid_a.p;
  fluid_bot.p = fluid_b.p;
  fluid_top.T = Tank_Top.T_top;
  fluid_bot.T = Tank_Bot.T_bot;
    
  h_bot_outlet = max(Tank_Bot.h_f[N_sec3],fluid_bot.h);
    
  fluid_a.m_flow = -1.0*fluid_b.m_flow;
//always true for a steady state component
  if fluid_a.m_flow > 1.0e-3 then
// charging
    Tank_Top.m_flow = fluid_a.m_flow;
    Tank_Mid.m_flow = fluid_a.m_flow;
    Tank_Bot.m_flow = fluid_a.m_flow;
    Tank_Top.h_top = inStream(fluid_a.h_outflow);
    Tank_Mid.h_top = Tank_Top.h_bot;
    Tank_Bot.h_top = Tank_Mid.h_bot;
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
  elseif fluid_a.m_flow < (-1.0e-3) then
//discharing
    Tank_Top.m_flow = fluid_a.m_flow;
    Tank_Mid.m_flow = fluid_a.m_flow;
    Tank_Bot.m_flow = fluid_a.m_flow;
    Tank_Bot.h_bot = inStream(fluid_b.h_outflow);
    Tank_Bot.h_top = Tank_Mid.h_bot;
    Tank_Mid.h_top = Tank_Top.h_bot;
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
  else
//force standby
    Tank_Top.m_flow = 0.0;
    Tank_Mid.m_flow = 0.0;
    Tank_Bot.m_flow = 0.0;
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
    Tank_Top.h_top = Tank_Top.h_f[1];
    Tank_Mid.h_top = Tank_Mid.h_f[1];
    Tank_Bot.h_top = Tank_Bot.h_f[1];
  end if;
//End try
  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  T_amb = Tank_Top.T_amb;
  T_amb = Tank_Mid.T_amb;
  T_amb = Tank_Bot.T_amb;
  T_top_measured = Tank_Top.T_f[1];
  T_bot_measured = Tank_Bot.T_f[N_sec3];
  
annotation(
      Documentation(info ="<html>
        <p>This model connects three single PCM tanks in series as shown in the figure below. The HTF flows into the cascade storage system in opposite directions in charging and discharging, respectively. This model contains two fluid connectors: fluid_a and fluid_b at the top of PCMTank_top and bottom of PCMTank_bot. Three output signals are included: T_top_measured (temperature at the top of the tank), T_bot_measured (temperature at the bottom of the tank) and h_bot_outlet (enthaply at the bottom of the tank). </p>
        
        <img src=\"modelica://SolarTherm/Resources/Images/PCMModels/3PCMCascade.png\"> 
                
  		<p>By Ming Liu on 22/06/2021</p>
  		</html>"));

annotation (Icon(coordinateSystem(initialScale = 0.1))); 
  		  
end Cascade3PCMStorageTank;
