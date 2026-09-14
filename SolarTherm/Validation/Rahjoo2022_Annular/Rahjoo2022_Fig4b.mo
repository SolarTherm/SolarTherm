within SolarTherm.Validation.Rahjoo2022_Annular;

model Rahjoo2022_Fig4b
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;

  package Medium = SolarTherm.Media.Air.Air_CoolProp_1bar;
  package Filler = SolarTherm.Materials.Geopolymer_Rahjoo_2022;
  package Fluid = SolarTherm.Materials.Air_CoolProp_Table_1bar;

  parameter Integer N_f = 50; 
  parameter Integer N_p = 5;
  parameter SI.Length L_pipe = 0.5;
  parameter SI.Length d_pipe = 0.154;
  parameter SI.Length d_solid = 0.282;//0.25 0.2821 0.3536;
  parameter Real N_units = 1.0;


  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.5;
  
  parameter SI.Length E_roughness = 46.0e-6;
  parameter Integer Correlation = 1; //1: Smooth pipes, 2: Oils/Cool Water, 3: Gases/Cool Water

  
  //Properties of Fluid
  parameter SI.Density rho_f_avg = 0.5*(Fluid.rho_Tf(T_max,1.0)+Fluid.rho_Tf(T_min,0.0)) "averaged fluid density";
  parameter SI.SpecificEnthalpy h_f_max = Fluid.h_Tf(T_max,1.0) "Max fluid specific enthalpy";
  parameter SI.SpecificEnthalpy h_f_min = Fluid.h_Tf(T_min,0.0) "Min fluid specific enthalpy";
  
  parameter SI.Density rho_p_min = min(Filler.rho_Tf(T_max,1.0),Filler.rho_Tf(T_min,0.0)) "averaged filler density";
  parameter SI.SpecificEnthalpy h_p_max = Filler.h_Tf(T_max,1.0) "Max filler specific enthalpy";
  parameter SI.SpecificEnthalpy h_p_min = Filler.h_Tf(T_min,0.0) "Min filler specific enthalpy";
  
  parameter SI.Temperature T_min = 200+273.15 "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = 650.0+273.15 "Design hot Temperature of everything in the tank (K)";
  

  parameter SI.Energy E_max = N_units*(TES.Tank_A.E_unit) "Total capacity of the tank";
  parameter SI.Length z_f[N_f] = SolarTherm.Models.Storage.Thermocline.Z_position(L_pipe,N_f);


  parameter SI.Temperature T_f_start[N_f] = fill(320.0,N_f);
  parameter SI.Temperature h_f_start[N_f] = fill(Fluid.h_Tf(320.0,0.0),N_f);
  parameter SI.Temperature T_p_start[N_f,N_p] = fill(fill(320.0,N_p),N_f);
  parameter SI.Temperature h_p_start[N_f,N_p] = fill(fill(Filler.h_Tf(320.0,0.0),N_p),N_f);

  //Inlet and Outlet
  SI.SpecificEnthalpy h_top "J/kg";
  SI.SpecificEnthalpy h_bot "J/kg";
  SI.MassFlowRate m_Recv_signal "kg/s";
  SI.MassFlowRate m_PB_signal "kg/s";
  
  SI.Temperature T_inlet "K";
  
  //Core thermocouple temperature
  //Pos4 z/L = 0.0435, Pos1 z/L = 0.9565
  SI.Temperature T_core[N_f](start=T_f_start) "Core temperature, approximated by the filler node midway between j = 1 and j = N_p";
  SI.Temperature T_core_Pos1 = Modelica.Math.Vectors.interpolate(z_f,T_core,0.1*L_pipe);
  SI.Temperature T_core_Pos2 = Modelica.Math.Vectors.interpolate(z_f,T_core,0.5*L_pipe);
  SI.Temperature T_core_Pos3 = Modelica.Math.Vectors.interpolate(z_f,T_core,0.9*L_pipe);
  
  //Experimental Data ref
  SI.Temperature T_core_Pos1_exp = SolarTherm.Validation.Rahjoo2022_Annular.Resources.Timeseries_T_pos1(time);
  SI.Temperature T_core_Pos2_exp = SolarTherm.Validation.Rahjoo2022_Annular.Resources.Timeseries_T_pos2(time);
  SI.Temperature T_core_Pos3_exp = SolarTherm.Validation.Rahjoo2022_Annular.Resources.Timeseries_T_pos3(time);
  
  
  //SI.Temperature T_outlet_exp = SolarTherm.Utilities.Interpolation.Interpolate1D(Dataset.T_outlet_times,Dataset.T_outlet_TK,time);
  Integer ControlState(start=1);
  SI.Velocity u_flow_abs=abs(TES.Tank_A.u_flow[25]);
  SI.Velocity u_flow_exp = SolarTherm.Validation.Rahjoo2022_Annular.Resources.Timeseries_u_flow(time);
  //Recorded Variable
  //SI.Energy E_stored (start=0.0) "J";
  //SI.Energy E_pump_loss (start=0.0) "J";
  //Real E_stored_kWh = E_stored/(3600.0e3) "kWh";
  //Real E_pump_loss_kWh = E_pump_loss/(3600.0e3) "kWh";
  
  //Boundary Conditions
  SI.Temperature T_top (start=T_min) "Temperature at the top";
  SI.Temperature T_bot (start=T_min) "Temperature at the bottom";
  Modelica.Fluid.Sources.Boundary_pT Recv_outlet(redeclare package Medium = Medium, nPorts = 1, p = 101325, use_T_in = true) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
 Modelica.Fluid.Sources.Boundary_pT PB_outlet(redeclare package Medium = Medium, nPorts = 1, p = 101325, use_T_in = true) annotation(
    Placement(visible = true, transformation(origin = {92, -60}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
 SolarTherm.Models.Storage.Thermocline.Annular.SM_SingleTank TES(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler, N_f = N_f, N_p = N_p, T_max = T_max, T_min = T_min, Correlation = Correlation, E_max = E_max, L_pipe=L_pipe,d_pipe=d_pipe,d_solid=d_solid,Tank_A.T_f_start = T_f_start, Tank_A.h_f_start = h_f_start, Tank_A.T_p_start = T_p_start, Tank_A.h_p_start = h_p_start, Tank_A.N_units=N_units, N_units=N_units,U_loss_tank=U_loss_tank,E_roughness = E_roughness,R_foul = 0.0) annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
 SolarTherm.Models.Fluid.Pumps.PumpSimple Pump1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure Pump2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {44, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 SolarTherm.Models.Fluid.Sources.FluidSink2 PB_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {102, 44}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
 Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-38, -2}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
 Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {47, -2}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
 Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-103, 5}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
 Modelica.Blocks.Sources.RealExpression m_flow_PB(y = m_PB_signal) annotation(
    Placement(visible = true, transformation(origin = {110, 3}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
 SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure Pump3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
 SolarTherm.Models.Fluid.Pumps.PumpSimple Pump4(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {42, -62}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
 SolarTherm.Models.Fluid.Sources.FluidSink2 Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-120, -36}, extent = {{26, -26}, {-26, 26}}, rotation = 0)));
 SolarTherm.Models.Fluid.Valves.PBS_TeeJunction PBS_TeeJunction_Top(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-16, 0}, {16, 19.7076}}, rotation = 0)));
 SolarTherm.Models.Fluid.Valves.PBS_TeeJunction_LoopBreaker PBS_TeeJunction_LoopBreaker_Bot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-8.88178e-16, -47}, extent = {{-18, -19}, {18, 19}}, rotation = 180)));
 Modelica.Blocks.Sources.RealExpression Receiver_Inlet_T(y = T_inlet)  annotation(
    Placement(visible = true, transformation(origin = {-196, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
    T_inlet := SolarTherm.Validation.Rahjoo2022_Annular.Resources.Timeseries_T_inlet(time);
    //m_Recv_signal := max(1.0e-6, Dataset.Timeseries_uflow(time)*Fluid.rho_Tf(TES.Tank_A.T_f[integer(N_f/2.0)+1],1.0)*TES.Tank_A.A_fx);
  /*
  when time > 1.47*24.0*3600 then
    ControlState := 2;
  elsewhen time > 2.09*24.0*3600 then
    ControlState := 1;
  elsewhen time > 2.71*24.0*3600 then
    ControlState := 2;
  elsewhen time > 3.26*24.0*3600 then
    ControlState := 1;
  elsewhen time > 3.84*24.0*3600 then
    ControlState := 2;
  elsewhen time > 4.34*24.0*3600 then
    ControlState := 1;
  elsewhen time > 4.96*24.0*3600 then
    ControlState := 2;
  elsewhen time > 5.42*24.0*3600 then
    ControlState := 1;
  end when;
  */
  //Always blowing in the -z direction
  ControlState := 1;  
equation
  
  if ControlState == 1 then//charge
    //m_Recv_signal = max(1.0e-6, Dataset.Timeseries_uflow(time) * Fluid.rho_Tf(TES.Tank_A.T_f[integer(N_f / 2.0) + 1], 1.0) * TES.Tank_A.A_fx);
    m_Recv_signal = max(1.0e-6, u_flow_exp * Fluid.rho_Tf(TES.Tank_A.T_f[25],0.0) * TES.Tank_A.A_fz);
    m_PB_signal = 0.0;
    //PB_Sink.port_a.m_flow=0.0;
  else//discharge
    m_Recv_signal = 0.0;
    m_PB_signal = max(1.0e-6, u_flow_exp * Fluid.rho_Tf(TES.Tank_A.T_f[25],0.0) * TES.Tank_A.A_fz);
    //m_PB_signal = max(1.0e-6, Dataset.Timeseries_uflow(time) * Fluid.rho_Tf(TES.Tank_A.T_f[integer(N_f / 2.0) + 1], 1.0) * TES.Tank_A.A_fx);
    //Recv_Sink.port_a.m_flow=0.0;
  end if;
  /*
  if ControlState == 1 then
    //m_Recv_signal = max(1.0e-6, Dataset.Timeseries_uflow(time) * Fluid.rho_Tf(TES.Tank_A.T_f[integer(N_f / 2.0) + 1], 1.0) * TES.Tank_A.A_fx);
    m_Recv_signal = max(1.0e-6, Dataset.Timeseries_uflow(time) * rho_f_avg * TES.Tank_A.A_fx);
    m_PB_signal = 0.0;
    //PB_Sink.port_a.m_flow=0.0;
  else
    m_Recv_signal = max(1.0e-6, Dataset.Timeseries_uflow(time) * rho_f_avg * TES.Tank_A.A_fx);
    m_PB_signal = 0.0;//max(1.0e-6, Dataset.Timeseries_uflow(time) * rho_f_avg * TES.Tank_A.A_fx);
    //m_PB_signal = max(1.0e-6, Dataset.Timeseries_uflow(time) * Fluid.rho_Tf(TES.Tank_A.T_f[integer(N_f / 2.0) + 1], 1.0) * TES.Tank_A.A_fx);
    //Recv_Sink.port_a.m_flow=0.0;
    
  end if;
  */
  //Connections
  h_bot = TES.fluid_bot.h;
  h_top = TES.fluid_top.h;
  T_bot = TES.fluid_bot.T;
  T_top = TES.fluid_top.T;
  //m_Recv_signal = 0.01389;
  //m_PB_signal = 0.0;
  PBS_TeeJunction_LoopBreaker_Bot.fluid_b.p = 101325;
  PBS_TeeJunction_LoopBreaker_Bot.fluid_a.p = 101325;
  
  //der(E_stored) = m_Recv_signal*(h_top-h_bot);
  //der(E_pump_loss) = TES.Tank_A.W_loss_pump;
  for i in 1:N_f loop
    T_core[i] = TES.Tank_A.T_p[i,integer(N_p/2)+1];
  end for;
  //Fluid inlet and outlet properties
  //fluid_top.h = h_top;H_ta
  //fluid_bot.h = h_bot;
  //fluid_top.T = T_top;
  //fluid_bot.T = T_bot;
  connect(p_amb.y, TES.p_amb) annotation(
    Line(points = {{33, -2}, {18, -2}}, color = {0, 0, 127}));
 connect(Tamb.y, TES.T_amb) annotation(
    Line(points = {{-24, -2}, {-18, -2}, {-18, -2}, {-18, -2}}, color = {0, 0, 127}));
 connect(m_flow_Recv.y, Pump1.m_flow) annotation(
    Line(points = {{-82, 6}, {-72, 6}, {-72, 70}, {-54, 70}, {-54, 56}, {-54, 56}}, color = {0, 0, 127}));
 connect(m_flow_Recv.y, Pump3.m_flow) annotation(
    Line(points = {{-82, 6}, {-56, 6}, {-56, -28}, {-56, -28}}, color = {0, 0, 127}));
 connect(m_flow_PB.y, Pump2.m_flow) annotation(
    Line(points = {{88, 4}, {62, 4}, {62, 66}, {44, 66}, {44, 52}, {44, 52}}, color = {0, 0, 127}));
 connect(m_flow_PB.y, Pump4.m_flow) annotation(
    Line(points = {{88, 4}, {62, 4}, {62, -38}, {42, -38}, {42, -54}, {42, -54}}, color = {0, 0, 127}));
 connect(PBS_TeeJunction_LoopBreaker_Bot.fluid_a, Pump4.fluid_b) annotation(
    Line(points = {{14, -62}, {32, -62}, {32, -62}, {32, -62}}, color = {0, 127, 255}));
 connect(PB_outlet.ports[1], Pump4.fluid_a) annotation(
    Line(points = {{76, -60}, {64, -60}, {64, -62}, {52, -62}, {52, -62}}, color = {0, 127, 255}));
 connect(PBS_TeeJunction_LoopBreaker_Bot.fluid_b, Pump3.fluid_a) annotation(
    Line(points = {{-14, -62}, {-28, -62}, {-28, -36}, {-46, -36}, {-46, -36}}, color = {0, 127, 255}));
 connect(Pump3.fluid_b, Recv_Sink.port_a) annotation(
    Line(points = {{-66, -36}, {-94, -36}, {-94, -36}, {-94, -36}}, color = {0, 127, 255}));
 connect(PB_Sink.port_a, Pump2.fluid_b) annotation(
    Line(points = {{78, 44}, {54, 44}, {54, 44}, {54, 44}}, color = {0, 127, 255}));
 connect(Pump2.fluid_a, PBS_TeeJunction_Top.fluid_b) annotation(
    Line(points = {{34, 44}, {26, 44}, {26, 60}, {12, 60}, {12, 60}}, color = {0, 127, 255}));
 connect(PBS_TeeJunction_Top.fluid_a, Pump1.fluid_b) annotation(
    Line(points = {{-12, 60}, {-28, 60}, {-28, 48}, {-44, 48}, {-44, 48}}, color = {0, 127, 255}));
 connect(Pump1.fluid_a, Recv_outlet.ports[1]) annotation(
    Line(points = {{-64, 48}, {-96, 48}, {-96, 48}, {-96, 48}}, color = {0, 127, 255}));
 connect(PBS_TeeJunction_Top.fluid_c, TES.fluid_a) annotation(
    Line(points = {{0, 44}, {0, 44}, {0, 28}, {0, 28}}, color = {0, 127, 255}));
 connect(TES.fluid_b, PBS_TeeJunction_LoopBreaker_Bot.fluid_c) annotation(
    Line(points = {{0, -32}, {0, -32}, {0, -46}, {0, -46}}, color = {0, 127, 255}));
 connect(Receiver_Inlet_T.y, Recv_outlet.T_in) annotation(
    Line(points = {{-185, -8}, {-160, -8}, {-160, 54}, {-132, 54}}, color = {0, 0, 127}));
 connect(Receiver_Inlet_T.y, PB_outlet.T_in) annotation(
    Line(points = {{-185, -8}, {-160, -8}, {-160, -88}, {138, -88}, {138, -52}, {112, -52}, {112, -54}}, color = {0, 0, 127}));  
annotation(experiment(StopTime = 518400, StartTime = 0, Tolerance = 1e-3, Interval = 300.0),
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end Rahjoo2022_Fig4b;