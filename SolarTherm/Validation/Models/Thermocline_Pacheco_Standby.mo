within SolarTherm.Validation.Models;

model Thermocline_Pacheco_Standby "Validating the OpenModelica model against Pacheco's standby data of the Sandia National Laboratory test tank"
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;

  package MS = SolarTherm.Materials.SolarSalt_Constant;
  package Quartzite = SolarTherm.Materials.Quartzite_Sand;

  parameter Integer N_f = 320;
  parameter Integer N_p = 10;
  parameter SI.Length H_tank = 6.1;
  parameter SI.Diameter D_tank = 3.0;
  parameter Real U_top = 0.416;
  parameter Real U_wall = 1.0;
  parameter Real U_bot = 1.50;
  parameter SI.Length z_f[N_f] = SolarTherm.Models.Storage.Thermocline.Z_position(H_tank,N_f);
  parameter SI.Temperature T_f_start[N_f] = SolarTherm.Validation.Datasets.Pacheco_Standby_Dataset.Initial_Temperature_f(z_f);
  parameter SI.Temperature h_f_start[N_f] = SolarTherm.Validation.Datasets.Pacheco_Standby_Dataset.Initial_Enthalpy_f(z_f);
  parameter SI.Temperature T_p_start[N_f,N_p] = SolarTherm.Validation.Datasets.Pacheco_Standby_Dataset.Initial_Temperature_p(z_f,N_p);
  parameter SI.Temperature h_p_start[N_f,N_p] = SolarTherm.Validation.Datasets.Pacheco_Standby_Dataset.Initial_Enthalpy_p(z_f,N_p);

  //Thermocline Tank A (Bottom PCM)
  SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_Section_Final Tank_A (redeclare package Fluid_Package = MS, redeclare package Filler_Package = Quartzite, N_f = N_f, N_p = N_p,T_f_start=T_f_start,T_p_start=T_p_start,h_f_start=h_f_start,h_p_start=h_p_start,T_max=396.0+273.15,T_min=290.0+273.15,d_p=15.0e-3,H_tank=H_tank,D_tank=D_tank,Correlation=1,U_top=U_top,U_wall=U_wall,U_bot=U_bot,U_loss_tank=0.0) "The bottom tank";
  
  //All tank sections have HTF type in common!
  MS Fluid "Fluid package";
  MS.State fluid_top(h_start=h_f_min) "Top fluid property object";
  MS.State fluid_bot(h_start=h_f_min) "Bottom fluid property object";
  
  //Property bounds
  //Fluid
  parameter SI.SpecificEnthalpy h_f_min=Fluid.h_Tf(T_min) "Starting enthalpy of the HTF";
  parameter SI.SpecificEnthalpy h_f_max=Fluid.h_Tf(T_max) "Starting enthalpy of the HTF";
  parameter SI.Density rho_f_min=Fluid.rho_Tf(T_min);
  parameter SI.Density rho_f_max=Fluid.rho_Tf(T_max);
  parameter SI.Density rho_f_avg=(rho_f_min+rho_f_max)/2;
  //Design parameters
  parameter SI.Energy E_max = 144e9 "Maximum theoretical storage capacity of combined tanks";
  parameter SI.Time t_charge = 4 * 3600 "charging time";
  parameter SI.Time t_discharge = 4 * 3600 "discharging time";
  parameter SI.Temperature T_min = CV.from_degC(290.0) "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = CV.from_degC(396.0) "Design hot Temperature of everything in the tank (K)";
 
  //Inlet and Outlet
  SI.SpecificEnthalpy h_top "J/kg";
  SI.SpecificEnthalpy h_bot "J/kg";
  SI.MassFlowRate m_flow "kg/s";
  
  //Boundary Conditions
  SI.Temperature T_top (start=T_min) "Temperature at the top";
  SI.Temperature T_bot (start=T_min) "Temperature at the bottom";
  
  //Measured Temperature degC
  Real T_f_degC[N_f] "Fluid temperature in degC";

equation
  //Connections
  m_flow = Tank_A.m_flow;
  h_bot = Tank_A.h_in;
  h_top = Tank_A.h_out;
  Tank_A.T_amb = 298.15;

  m_flow = 0.0;
  T_bot = 290.0;
  
  //Fluid inlet and outlet properties
  fluid_top.h = h_top;
  fluid_bot.h = h_bot;
  fluid_top.T = T_top;
  fluid_bot.T = T_bot;
  
  T_f_degC = Tank_A.T_f .- 273.15;
  
annotation(experiment(StopTime = 180000, StartTime = 0, Tolerance = 1e-3, Interval = 1800.0));
end Thermocline_Pacheco_Standby;