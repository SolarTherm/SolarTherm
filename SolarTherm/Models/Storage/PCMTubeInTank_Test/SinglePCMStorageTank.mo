within SolarTherm.Models.Storage.PCMTubeInTank_Test;

model SinglePCMStorageTank

extends SolarTherm.Interfaces.Models.HeatTransferFluid_PCM;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Media.Materials.PartialMaterial;
  replaceable package Wall_Package = SolarTherm.Media.Materials.PartialMaterial;
  replaceable package PCM_Package = SolarTherm.Media.Materials.PartialMaterial;
    
  parameter SI.Temperature T_min = CV.from_degC(540) "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = CV.from_degC(750) "Design hot Temperature of everything in the tank (K)";
  parameter SI.Length L = 10 "Length of PCM tank";
  parameter SI.Length r_tube_in = 0.006265 "Tube inner radius";
  parameter SI.Length r_tube_out = 0.008575 "Tube outer radius";
  parameter SI.Length r_shell = 0.03 "Shell radius";
  parameter Integer N_tube = 1 "Number of tubes";
  parameter Integer N_sec = 20 "Number of mesh elements";   

  Modelica.Blocks.Interfaces.RealOutput T_top_measured "Temperature at the top of the tank as an an output signal (K)"
                                            annotation (Placement(visible = true,transformation(
            extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {-61, -1}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_bot_measured "Temperature at the bottom of the tank as an output signal (K)"
                                            annotation (Placement(visible = true,transformation(
            extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {71, -9}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)"
                                            annotation (Placement(visible = true,transformation(
            extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {59, 21}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
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
  
  SolarTherm.Models.Storage.PCMTubeInTank_Test.TubeInTank_Section2 Tank_A(redeclare replaceable package Fluid = Fluid_Package, redeclare replaceable package Wall = Wall_Package, redeclare replaceable package Storage = PCM_Package, L = L, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max, N_tube = N_tube, N_sec = N_sec);
  
  Medium.BaseProperties fluid_top;
  Medium.BaseProperties fluid_bot;
  
equation 
  fluid_top.p = fluid_a.p;
  fluid_bot.p = fluid_b.p;
  fluid_top.T = Tank_A.T_top;
  fluid_bot.T = Tank_A.T_bot;
    
  h_bot_outlet = max(Tank_A.h_f[N_sec],fluid_bot.h);
    
  fluid_a.m_flow = -1.0*fluid_b.m_flow; //always true for a steady state component
  
  if fluid_a.m_flow > 1.0e-3 then// charging
    Tank_A.m_flow = 1.0*fluid_a.m_flow;
    Tank_A.h_top = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
  elseif fluid_a.m_flow < -1.0e-3 then //discharing
    Tank_A.m_flow = 1.0*fluid_a.m_flow;
    Tank_A.h_bot = inStream(fluid_b.h_outflow);
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
  else //force standby
    Tank_A.m_flow = 0.0;
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
    Tank_A.h_top = Tank_A.h_f[1];
  end if;
  //End try
  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  T_amb = Tank_A.T_amb;
  T_top_measured = Tank_A.T_f[1];
  T_bot_measured = Tank_A.T_f[N_sec];
  
annotation(
      Icon(coordinateSystem(initialScale = 0.1)));

annotation (Documentation(info ="<html>
        <p>This model contains the 1D model detailed in the component of TubeInTank_Section2 with the addition of two fluid connectors: fluid_a and fluid_b at the top and bottom of a single PCM storage tank. Three output signals are also included: T_top_measured (temperature at the top of the tank), T_bot_measured (temperature at the bottom of the tank) and h_bot_outlet (enthaply at the bottom of the tank). </p>
  		<p>By Ming Liu on 22/06/2021</p>
  		</html>"));   
  		  
end SinglePCMStorageTank;
