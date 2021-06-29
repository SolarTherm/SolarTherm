within SolarTherm.Systems.PCMStorage;

model Test1_CaOSensibleStorage
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;

  package Sodium = SolarTherm.Media.Materials.Sodium; 
  package Wall = SolarTherm.Media.Materials.SS316L; 
  package CaO = SolarTherm.Media.Materials.CaO; 

  parameter SI.Length L = 10 "Length of PCM tank";
  parameter SI.Length r_tube_in = 0.006265 "Tube inner radius";
  parameter SI.Length r_tube_out = 0.008575 "Tube outer radius";
  parameter SI.Length r_shell = 0.03 "Shell radius";
  parameter Integer N_tube = 1 "Number of tubes";
  parameter Integer N_sec = 20 "Number of mesh elements";  
  parameter SI.Length z_f[N_sec] = SolarTherm.Models.Storage.PCMTubeInTank_Test.Z_position(L, N_sec); 
  parameter SI.Temperature T_min = CV.from_degC(540) "Design cold Temperature of everything in the tank, K";
  parameter SI.Temperature T_max = CV.from_degC(750) "Design hot Temperature of everything in the tank, K";
  parameter SI.Temperature T_f_start[N_sec] = fill(T_min,N_sec);
  parameter SI.Temperature h_f_start[N_sec] = fill(Sodium.h_Tf(T_min,0),N_sec);
  parameter SI.Temperature T_w_start[N_sec] = fill(T_min,N_sec);
  parameter SI.Temperature h_w_start[N_sec] = fill(Wall.h_Tf(T_min,0),N_sec);
  parameter SI.Temperature T_p_start[N_sec] = fill(T_min,N_sec);
  parameter SI.Temperature h_p_start[N_sec] = fill(CaO.h_Tf(T_min,0),N_sec);

  SolarTherm.Models.Storage.PCMTubeInTank_Test.TubeInTank_Section SensibleStorageTank(redeclare package Fluid = Sodium, redeclare package Wall = Wall, redeclare package Storage = CaO, L = L, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max, N_sec = N_sec, N_tube = N_tube, T_f_start = T_f_start, T_w_start = T_w_start, T_p_start = T_p_start, h_f_start = h_f_start, h_w_start = h_w_start, h_p_start = h_p_start) annotation(Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  //All tank sections have HTF type in common!
  //Fluid.State fluid[N_sec](each h_start = h_f_min) "Fluid array";
  Sodium Fluid "Fluid package";
  Sodium.State fluid_top(h_start = h_f_min) "Top fluid property object";
  Sodium.State fluid_bot(h_start = h_f_min) "Bottom fluid property object";

  //Property bounds
  //Fluid
  parameter SI.SpecificEnthalpy h_f_min=Sodium.h_Tf(T_min,0) "Starting enthalpy of the HTF";
  parameter SI.SpecificEnthalpy h_f_max=Sodium.h_Tf(T_max,0) "Starting enthalpy of the HTF";
  parameter SI.Density rho_f_min=Sodium.rho_Tf(T_min,0);
  parameter SI.Density rho_f_max=Sodium.rho_Tf(T_max,0);
  parameter SI.Density rho_f_avg=(rho_f_min+rho_f_max)/2;
 
  //Design parameters
  parameter SI.Time t_charge = 10 * 3600 "charging time";
  parameter SI.Time t_discharge = 10 * 3600 "discharging time";

  //Inlet and Outlet
  SI.SpecificEnthalpy h_top "J/kg";
  SI.SpecificEnthalpy h_bot "J/kg";
  SI.MassFlowRate m_flow "kg/s";
  
  //Boundary Conditions
  SI.Temperature T_top (start=T_min) "Temperature at the top";
  SI.Temperature T_bot (start=T_min) "Temperature at the bottom";
equation

  //Connections
  m_flow = SensibleStorageTank.m_flow;
  h_bot = SensibleStorageTank.h_bot;
  h_top = SensibleStorageTank.h_top;
  
  //Validation set A assumes inlet discharge volumetric flow rate of 108 m3/hr
  //m_flow = (108.0/3600.0)*rho_f_avg;
  m_flow = 0.01;
  T_top = T_max;
  
  //Fluid inlet and outlet properties
  fluid_top.h = h_top;
  fluid_bot.h = h_bot;
  fluid_top.T = T_top;
  fluid_bot.T = T_bot;
  
annotation(experiment(StopTime = 14400, StartTime = 0, Tolerance = 1e-6, Interval = 10.0));

annotation (Documentation(info ="<html>
  		<p>This is an isolation test case for using CaO as a sensible storage material in the shell side.</p>
  		<p>By Ming Liu on 03/09/2020</p>
  		</html>"));    

end Test1_CaOSensibleStorage;

