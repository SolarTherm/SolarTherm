within SolarTherm.Systems.PCMStorage;

model Test4_3PCMCascade_Charge
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;

  package Sodium = SolarTherm.Media.Materials.Sodium; 
  package Wall = SolarTherm.Media.Materials.SS316L; 
  package PCM1 = SolarTherm.Media.Materials.PCM710_UniSA; 
  package PCM2 = SolarTherm.Media.Materials.PCM635_UniSA;
  package PCM3 = SolarTherm.Media.Materials.PCM569_UniSA;
  
  parameter SI.Length r_shell = 0.03 "Outer shell radius";
  parameter SI.Length r_tube_in = 0.006265 "Tube inner radius";
  parameter SI.Length r_tube_out = 0.008575 "Tube outer radius";
  parameter SI.Length L1 = 210 "Length of PCM1_PCM710tank";
  parameter SI.Length L2 = 66.4 "Length of PCM2_PCM635tank";
  parameter SI.Length L3 = 120 "Length of PCM3_PCM569tank";
  parameter Integer N_tube1 = 1 "Number of tubes"; 
  parameter Integer N_tube2 = 1 "Number of tubes";  
  parameter Integer N_tube3 = 1 "Number of tubes";
  parameter Integer N_sec = 100 "Number of mesh elements";  
//parameter SI.Length z_f[N_sec] = SolarTherm.Models.Storage.PCMTubeInTank_Test.Z_position(L, N_sec);
  parameter SI.Temperature T_min = CV.from_degC(540.0) "Design cold Temperature of everything in the tank, K";
  parameter SI.Temperature T_max = CV.from_degC(750.0) "Design hot Temperature of everything in the tank, K";
  parameter SI.Temperature T_f1_start[N_sec] = fill(T_min,N_sec);
  parameter SI.Temperature T_f2_start[N_sec] = fill(T_min,N_sec);
  parameter SI.Temperature T_f3_start[N_sec] = fill(T_min,N_sec);
  parameter SI.Temperature T_w1_start[N_sec] = fill(T_min,N_sec);
  parameter SI.Temperature T_w2_start[N_sec] = fill(T_min,N_sec);
  parameter SI.Temperature T_w3_start[N_sec] = fill(T_min,N_sec);  
  parameter SI.Temperature T_p1_start[N_sec] = fill(T_min,N_sec);
  parameter SI.Temperature T_p2_start[N_sec] = fill(T_min,N_sec);
  parameter SI.Temperature T_p3_start[N_sec] = fill(T_min,N_sec);
  parameter SI.SpecificEnthalpy h_f1_start[N_sec] = fill(Sodium.h_Tf(T_min,0.0),N_sec);
  parameter SI.SpecificEnthalpy h_f2_start[N_sec] = fill(Sodium.h_Tf(T_min,0.0),N_sec);
  parameter SI.SpecificEnthalpy h_f3_start[N_sec] = fill(Sodium.h_Tf(T_min,0.0),N_sec);
  parameter SI.SpecificEnthalpy h_w1_start[N_sec] = fill(Wall.h_Tf(T_min,0.0),N_sec);
  parameter SI.SpecificEnthalpy h_w2_start[N_sec] = fill(Wall.h_Tf(T_min,0.0),N_sec);
  parameter SI.SpecificEnthalpy h_w3_start[N_sec] = fill(Wall.h_Tf(T_min,0.0),N_sec);
  parameter SI.SpecificEnthalpy h_p1_start[N_sec] = fill(PCM1.h_Tf(T_min,0.0),N_sec);
  parameter SI.SpecificEnthalpy h_p2_start[N_sec] = fill(PCM2.h_Tf(T_min,0.0),N_sec);
  parameter SI.SpecificEnthalpy h_p3_start[N_sec] = fill(PCM3.h_Tf(T_min,0.0),N_sec);

  SolarTherm.Models.Storage.PCMTubeInTank_Test.TubeInTank_Section PCM710Tank(redeclare package Fluid = Sodium, redeclare package Wall = Wall, redeclare package Storage = PCM1, L = L1, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max, N_tube = N_tube1, N_sec = N_sec, T_f_start = T_f1_start, T_w_start = T_w1_start, T_p_start = T_p1_start, h_f_start = h_f1_start, h_w_start = h_w1_start, h_p_start = h_p1_start) annotation(Placement(visible = true, transformation(origin = {-54, 2}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  SolarTherm.Models.Storage.PCMTubeInTank_Test.TubeInTank_Section PCM635Tank(redeclare package Fluid = Sodium, redeclare package Wall = Wall, redeclare package Storage = PCM2, L = L2, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max, N_tube = N_tube2, N_sec = N_sec, T_f_start = T_f2_start, T_w_start = T_w2_start, T_p_start = T_p2_start, h_f_start = h_f2_start, h_w_start = h_w2_start, h_p_start = h_p2_start) annotation(Placement(visible = true, transformation(origin = {-2, 2}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  SolarTherm.Models.Storage.PCMTubeInTank_Test.TubeInTank_Section PCM569Tank(redeclare package Fluid = Sodium, redeclare package Wall = Wall, redeclare package Storage = PCM3, L = L3, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max, N_tube = N_tube3, N_sec = N_sec, T_f_start = T_f3_start, T_w_start = T_w3_start, T_p_start = T_p3_start, h_f_start = h_f3_start, h_w_start = h_w3_start, h_p_start = h_p3_start) annotation(Placement(visible = true, transformation(origin = {50, 2}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  //All tank sections have HTF type in common!
  //Fluid.State fluid[N_sec](each h_start = h_f_min) "Fluid array";
  Sodium Fluid "Fluid package";
  Sodium.State fluid_top(h_start = h_f_min) "Top fluid property object";
  Sodium.State fluid_bot(h_start = h_f_min) "Bottom fluid property object";

//Property bounds
  //Fluid
  parameter SI.SpecificEnthalpy h_f_min = Fluid.h_Tf(T_min,1.0) "Starting enthalpy of the HTF";
  //parameter SI.SpecificEnthalpy h_f_max = Fluid.h_Tf(T_max,1.0) "Starting enthalpy of the HTF";
  //parameter SI.Density rho_f_min = Fluid.rho_Tf(T_min,1.0);
  //parameter SI.Density rho_f_max = Fluid.rho_Tf(T_max,1.0);
  //parameter SI.Density rho_f_avg = (rho_f_min+rho_f_max)/2.0;
  //PCM
  //parameter SI.SpecificEnthalpy h_p_min = PCM.h_Tf(T_min) "Starting enthalpy of the PCM";
  //parameter SI.SpecificEnthalpy h_p_max = PCM.h_Tf(T_max) "Starting enthalpy of the PCM";
  //parameter SI.Density rho_p_min = PCM.rho_Tf(T_min);
  //parameter SI.Density rho_p_max = PCM.rho_Tf(T_max);
  //parameter SI.Density rho_p_avg = (rho_p_min + rho_p_max) / 2.0;
  ////parameter SI.ThermalConductivity k_p[N_sec] = fill(0.5, N_sec) "W/mK";
  //Design parameters
  parameter SI.Energy E_max_total = PCM710Tank.E_max + PCM635Tank.E_max + PCM569Tank.E_max "Design storage capacity of combined storage tanks, J";  
  parameter SI.Time t_charge = 10.0 * 3600 "charging time";
  parameter SI.Time t_discharge = 10.0 * 3600 "discharging time";

//Inlet and Outlet
  SI.SpecificEnthalpy h_top "J/kg";
  SI.SpecificEnthalpy h_bot "J/kg";
  SI.MassFlowRate m_flow "kg/s";
  //Boundary Conditions
  SI.Temperature T_top (start=T_min) "Temperature at the top";
  SI.Temperature T_bot (start=T_min) "Temperature at the bottom";
  //Analyiics
  SI.Energy E_stored_total(start = 0.0) "Make sure the tank starts from T_min)";
  Real Level_total(start = 0.0) "Tank charging level (0-1)";
  //Real LiquidFraction(start = 0.0) "Average liquid fraction of PCM (0-1)";
equation
  der(E_stored_total) = m_flow * (h_top - h_bot);
  Level_total = E_stored_total / E_max_total;
//Connections
  m_flow = PCM710Tank.m_flow;
  m_flow = PCM635Tank.m_flow; 
  m_flow = PCM569Tank.m_flow;
  h_top = PCM710Tank.h_top;
  PCM635Tank.h_top = PCM710Tank.h_bot;
  PCM569Tank.h_top = PCM635Tank.h_bot;
  h_bot = PCM569Tank.h_bot;
//Validation set A assumes inlet discharge volumetric flow rate of 108 m3/hr
//m_flow = (108.0/3600.0)*rho_f_avg;
  m_flow = 0.096735;
  T_top = T_max;
//Fluid inlet and outlet properties
  fluid_top.h = h_top;
  fluid_bot.h = h_bot;
  fluid_top.T = T_top;
  fluid_bot.T = T_bot;
  
annotation(Documentation(info = "<html>
        
        <p>This is an isolation test case for charging a 3-PCM cascade storage system designed to provide a 1000 MWh<sub>th</sub> discharge capacity for a hypothetical CSP plant being investigated by ASTRI. The detail of the design and the simulation condition was described in the publication (https://doi.org/10.1016/j.renene.2019.11.115). In this cascade storage system, three PCMs with different melting points of 705<sup>o</sup>C, 635<sup>o</sup>C and 569<sup>o</sup>C are connected in series. Initially, all the three PCMs have a temperature of 540<sup>o</sup>C. When the charging process starts, liquid sodium at 750<sup>o</sup>C enters the first PCM (PCM710), and flows through PCM635 and exits from PCM569. </p>
 		
 		<img src=\"modelica://SolarTherm/Resources/Images/PCMModels/3PCMCascade_Charge.png\">  
 		
 		<p> The simulation results were compared with those obtained from a more detailed 2D numerical model. The 2D model was validated against the experimental data and verified against the FLUENT simulated results, which were explained in the publications: <a href=\"https://doi.org/10.1016/B978-0-12-805323-2.00007-2\">https://doi.org/10.1016/B978-0-12-805323-2.00007-2</a> and <a href=\"https://doi.org/10.1016/j.renene.2019.11.115\">https://doi.org/10.1016/j.renene.2019.11.115</a>. The temperatures of the liquid sodium exiting the cascade storage system were predicted by both models and the comparison is shown in the figure below. The results estimated by both models are in very good agreement and the discrepancy is due to the ignorance of natural convection in the 1D model. </p>		
 
  		<img src=\"modelica://SolarTherm/Resources/Images/PCMModels/3PCMCascade_ChargeCurve.png\">
  		   		
  		<p>By Ming Liu on 22/06/2021</p>
  		</html>"),
  experiment(StopTime = 108000, StartTime = 0, Tolerance = 1e-6, Interval = 10.0)); 
  		
end Test4_3PCMCascade_Charge;
