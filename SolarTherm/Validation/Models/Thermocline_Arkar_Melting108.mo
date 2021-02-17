within SolarTherm.Validation.Models;

model Thermocline_Arkar_Melting108
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;

  package RT20_Paraffin = SolarTherm.Materials.RT20_Paraffin_Melting;
  package Air = SolarTherm.Materials.Air_Table;

  parameter Integer N_f = 105; 
  parameter Integer N_p = 5;
  parameter SI.Length H_tank = 1.52;
  parameter SI.Diameter D_tank = 0.34;
  parameter Real eta = 0.388;
  parameter SI.Length z_f[N_f] = SolarTherm.Models.Storage.Thermocline.Z_position(H_tank,N_f);
  parameter SI.Temperature T_f_start[N_f] = fill(284.07,N_f);
  parameter SI.Temperature h_f_start[N_f] = fill(Air.h_Tf(284.07,0),N_f);
  parameter SI.Temperature T_p_start[N_f,N_p] = fill(fill(284.07,N_p),N_f);
  parameter SI.Temperature h_p_start[N_f,N_p] = fill(fill(RT20_Paraffin.h_Tf(284.07
,0.0),N_p),N_f);

  //Thermocline Tank A (Bottom PCM)
  SolarTherm.Models.Storage.Thermocline.Thermocline_Section2 Tank_A (redeclare package Fluid_Package = Air, redeclare package Filler_Package = RT20_Paraffin, N_f = N_f, N_p = N_p,T_f_start=T_f_start,T_p_start=T_p_start,h_f_start=h_f_start,h_p_start=h_p_start,T_max=T_max,T_min=T_min,d_p=50.0e-3,H_tank=H_tank,D_tank=D_tank,Correlation=1,eta=eta,rho_p=RT20_Paraffin.rho_Tf(T_max,1.0),U_loss_tank = 0.0) "The bottom tank";
  
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
  parameter SI.Temperature T_min = 284.07 "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = 306.15
 "Design hot Temperature of everything in the tank (K)";
 
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
  
  //Validation set A assumes inlet discharge volumetric flow rate of 108 m3/hr
  m_flow = (108.0/3600.0)*rho_f_avg;
  T_bot = SolarTherm.Validation.Datasets.Arkar_Melting108_Dataset.T_t(time);
  Tank_A.T_amb = 298.15;
  
  //Fluid inlet and outlet properties
  fluid_top.h = h_top;
  fluid_bot.h = h_bot;
  fluid_top.T = T_top;
  fluid_bot.T = T_bot;
  
annotation(experiment(StopTime = 50400, StartTime = 0, Tolerance = 1e-3, Interval = 180.0));
end Thermocline_Arkar_Melting108;