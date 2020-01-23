within SolarTherm.Validation.Models;

model Thermocline_Arkar_Solidification76
  //discharging for 2h
  //extends Interfaces.Models.StorageFluid;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;

  package RT20_Paraffin_Slow = SolarTherm.Media.Materials.RT20_Paraffin_Melting;
  package Air = SolarTherm.Media.Materials.Air_Table;

  parameter Integer N_f = 35;
  parameter Integer N_p = 20;
  parameter SI.Length H_tank = 1.52;
  parameter SI.Diameter D_tank = 0.34;
  parameter Real eta = 0.388;
  parameter SI.Length z_f[N_f] = SolarTherm.Models.Storage.Thermocline.Z_position(H_tank,N_f);
  parameter SI.Temperature T_f_start[N_f] = fill(307.494497607655,N_f);
  parameter SI.Temperature h_f_start[N_f] = fill(Air.h_Tf(307.494497607655,0),N_f);
  parameter SI.Temperature T_p_start[N_f,N_p] = fill(fill(307.494497607655,N_p),N_f);
  parameter SI.Temperature h_p_start[N_f,N_p] = fill(fill(RT20_Paraffin_Slow.h_Tf(307.494497607655,1.0),N_p),N_f);

  //Thermocline Tank A (Bottom PCM)
  SolarTherm.Models.Storage.Thermocline.Thermocline_Section Tank_A (redeclare package Fluid = Air, redeclare package Filler = RT20_Paraffin_Slow, N_f = N_f, N_p = N_p,T_f_start=T_f_start,T_p_start=T_p_start,h_f_start=h_f_start,h_p_start=h_p_start,T_max=T_max,T_min=T_min,d_p=50.0e-3,H_tank=H_tank,D_tank=D_tank,Correlation=1,eta=eta,rho_p=RT20_Paraffin_Slow.rho_Tf(T_max,1.0)) "The bottom tank";
  
  //All tank sections have HTF type in common!
  Air Fluid "Fluid package";
  Air.State fluid_top(h_start=h_f_min) "Top fluid property object";
  Air.State fluid_bot(h_start=h_f_min) "Bottom fluid property object";
  
  //Property bounds
  //Fluid
  parameter SI.SpecificEnthalpy h_f_min=Fluid.h_Tf(T_min,0) "Starting enthalpy of the HTF";
  parameter SI.SpecificEnthalpy h_f_max=Fluid.h_Tf(T_max,0) "Starting enthalpy of the HTF";
  parameter SI.Density rho_f_min=Fluid.rho_Tf(T_min,0);
  parameter SI.Density rho_f_max=Fluid.rho_Tf(T_max,0);
  parameter SI.Density rho_f_avg=(rho_f_min+rho_f_max)/2;
  //Design parameters
  parameter SI.Energy E_max = 144e9 "Maximum theoretical storage capacity of combined tanks";
  parameter SI.Time t_charge = 4 * 3600 "charging time";
  parameter SI.Time t_discharge = 4 * 3600 "discharging time";
  //parameter SI.MassFlowRate m_flow_charge = E_max/((h_f_max-h_f_min)*t_charge) "Design mass flow rate of charging";
  //parameter SI.MassFlowRate m_flow_discharge = E_max/((h_f_max-h_f_min)*t_discharge) "Design mass flow rate of charging";
  parameter SI.Temperature T_min = 285.0 "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = 307.5 "Design hot Temperature of everything in the tank (K)";
 
  //Inlet and Outlet
  SI.SpecificEnthalpy h_top "J/kg";
  SI.SpecificEnthalpy h_bot "J/kg";
  SI.MassFlowRate m_flow "kg/s";
  
  //Boundary Conditions
  SI.Temperature T_top (start=T_min) "Temperature at the top";
  SI.Temperature T_bot (start=T_min) "Temperature at the bottom";

equation
  //Connections
  m_flow = Tank_A.m_flow;
  h_bot = Tank_A.h_bot;
  h_top = Tank_A.h_top;
  
  //Validation set A assumes inlet discharge volumetric flow rate of 76 m3/hr
  m_flow = (76.0/3600.0)*rho_f_avg;
  T_bot =SolarTherm.Validation.Datasets.Arkar_Solidification76_Dataset.T_t(time);
  
  //Fluid inlet and outlet properties
  fluid_top.h = h_top;
  fluid_bot.h = h_bot;
  fluid_top.T = T_top;
  fluid_bot.T = T_bot;
  
annotation(experiment(StopTime = 61200, StartTime = 0, Tolerance = 1e-6, Interval = 180.0));



end Thermocline_Arkar_Solidification76;