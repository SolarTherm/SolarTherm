within SolarTherm.Systems.PCMStorage;

model Test3_PCM635_Solidification
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;

  package Sodium = SolarTherm.Media.Materials.Sodium; 
  package Wall = SolarTherm.Media.Materials.SS316L; 
  package PCM = SolarTherm.Media.Materials.PCM635_UniSA; 

  parameter SI.Length L = 10 "Length of PCM tank";
  parameter SI.Length r_tube_in = 0.006265 "Tube inner radius";
  parameter SI.Length r_tube_out = 0.008575 "Tube outer radius";
  parameter SI.Length r_shell = 0.03 "Shell radius";
  parameter Integer N_sec = 100 "Number of mesh elements";  
  //parameter SI.Length z_f[N_sec] = SolarTherm.Models.Storage.PCMTubeInTank_Test.Z_position(L, N_sec); 
  parameter SI.Temperature T_min = CV.from_degC(540.0) "Design cold Temperature of everything in the tank, K";
  parameter SI.Temperature T_max = CV.from_degC(750.0) "Design hot Temperature of everything in the tank, K";
  parameter SI.Temperature T_f_start[N_sec] = fill(T_max,N_sec);
  parameter SI.Temperature T_w_start[N_sec] = fill(T_max,N_sec);
  parameter SI.Temperature T_p_start[N_sec] = fill(T_max,N_sec);
  parameter SI.SpecificEnthalpy h_f_start[N_sec] = fill(Sodium.h_Tf(T_max,0.0),N_sec);
  parameter SI.SpecificEnthalpy h_w_start[N_sec] = fill(Wall.h_Tf(T_max,0.0),N_sec);
  parameter SI.SpecificEnthalpy h_p_start[N_sec] = fill(PCM.h_Tf(T_max,0.0),N_sec);

  SolarTherm.Models.Storage.PCMTubeInTank_Test.TubeInTank_Section PCMTank(redeclare package Fluid = Sodium, redeclare package Wall = Wall, redeclare package Storage = PCM, L = L, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max, N_sec = N_sec, T_f_start = T_f_start, T_w_start = T_w_start, T_p_start = T_p_start, h_f_start = h_f_start, h_w_start = h_w_start, h_p_start = h_p_start) annotation(Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  //All tank sections have HTF type in common!
  //Fluid.State fluid[N_sec](each h_start = h_f_max) "Fluid array";
  Sodium Fluid "Fluid package";
  Sodium.State fluid_top(h_start = h_f_max) "Top fluid property object";
  Sodium.State fluid_bot(h_start = h_f_max) "Bottom fluid property object";

  //Property bounds
  //Fluid
  //parameter SI.SpecificEnthalpy h_f_min = Fluid.h_Tf(T_min,1.0) "Starting enthalpy of the HTF";
  parameter SI.SpecificEnthalpy h_f_max = Fluid.h_Tf(T_max,1.0) "Starting enthalpy of the HTF";
  //parameter SI.Density rho_f_min = Fluid.rho_Tf(T_min,1.0);
  //parameter SI.Density rho_f_max = Fluid.rho_Tf(T_max,1.0);
  //parameter SI.Density rho_f_avg = (rho_f_min+rho_f_max)/2.0;

  //PCM
  //parameter SI.SpecificEnthalpy h_p_min = PCM.h_Tf(T_min) "Starting enthalpy of the PCM";
  //parameter SI.SpecificEnthalpy h_p_max = PCM.h_Tf(T_max) "Starting enthalpy of the PCM";
  //parameter SI.Density rho_p_min = PCM.rho_Tf(T_min);
  //parameter SI.Density rho_p_max = PCM.rho_Tf(T_max);
  //parameter SI.Density rho_p_avg = (rho_p_min + rho_p_max) / 2.0;
  //parameter SI.ThermalConductivity k_p[N_sec] = fill(0.5, N_sec) "W/mK";
       
  //Design parameters
  parameter SI.Energy E_max = 144e9 "Maximum theoretical storage capacity of combined tanks";
  parameter SI.Time t_charge = 10.0 * 3600 "charging time";
  parameter SI.Time t_discharge = 10.0 * 3600 "discharging time";

  //Inlet and Outlet
  SI.SpecificEnthalpy h_top "J/kg";
  SI.SpecificEnthalpy h_bot "J/kg";
  SI.MassFlowRate m_flow "kg/s";
  
  //Boundary Conditions
  SI.Temperature T_top (start=T_max) "Temperature at the top";
  SI.Temperature T_bot (start=T_max) "Temperature at the bottom";
equation

  //Connections
  m_flow = PCMTank.m_flow;
  h_bot = PCMTank.h_bot;
  h_top = PCMTank.h_top;
  
  //Validation set A assumes inlet discharge volumetric flow rate of 108 m3/hr
  //m_flow = (108.0/3600.0)*rho_f_avg;
  m_flow = 0.003;
  T_top = T_min;
  
  //Fluid inlet and outlet properties
  fluid_top.h = h_top;
  fluid_bot.h = h_bot;
  fluid_top.T = T_top;
  fluid_bot.T = T_bot;
  
annotation(experiment(StopTime = 108000, StartTime = 0, Tolerance = 1e-6, Interval = 10.0));

annotation (Documentation(revisions ="<html>
  		<p>By Ming Liu on 11/06/2021</p>
  		<p>This is an isolation test case for solidifying PCM635 (a phase change material with melting temperature of 635 deg. C) contained in the shell side. Initially, the PCM is at a temperature of 750 deg. C and liquid sodium enters the tube at 540 deg.C with a mass flow rate of 0.003 kg/s. </p>
  		</html>")); 
  		
end Test3_PCM635_Solidification;
