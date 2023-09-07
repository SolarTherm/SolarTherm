within SolarTherm.Validation.Models;

model Annular_Laing_2006
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;

  package Medium = SolarTherm.Media.DowthermA.DowthermA_ph;
  package Filler = SolarTherm.Materials.Concrete_Laing_2006_Variation;// ;_2006_Variation;
  package Fluid = SolarTherm.Materials.Dowtherm_Table;

  parameter Integer N_f = 50; 
  parameter Integer N_p = 9;
  parameter SI.Length L_pipe = 23.0;
  parameter SI.Length D_pipe = 0.020;
  parameter SI.Length D_solid = 0.080;//0.09003;
  parameter Real Multiplier = 36.0;
  //parameter SI.Length H_tank = 0.48;
  //parameter SI.Diameter D_tank = 0.5;
  //parameter Real eta = 0.37;
  //parameter SI.Diameter d_p = 0.018;
  parameter Real U_loss_tank = 0.0;
  parameter Integer Correlation = 1; //1:Liquid 2:Gas
  //parameter Real ar = 0.48/0.5;
  
  //parameter SI.Volume V_tank = 0.25*CN.pi*D_tank*D_tank*H_tank;
  
  //Properties of Fluid
  parameter SI.Density rho_f_avg = 0.5*(Fluid.rho_Tf(T_max,1.0)+Fluid.rho_Tf(T_min,0.0)) "averaged fluid density";
  parameter SI.SpecificEnthalpy h_f_max = Fluid.h_Tf(T_max,1.0) "Max fluid specific enthalpy";
  parameter SI.SpecificEnthalpy h_f_min = Fluid.h_Tf(T_min,0.0) "Min fluid specific enthalpy";
  
  parameter SI.Density rho_p_min = min(Filler.rho_Tf(T_max,1.0),Filler.rho_Tf(T_min,0.0)) "averaged filler density";
  parameter SI.SpecificEnthalpy h_p_max = Filler.h_Tf(T_max,1.0) "Max filler specific enthalpy";
  parameter SI.SpecificEnthalpy h_p_min = Filler.h_Tf(T_min,0.0) "Min filler specific enthalpy";
  
  parameter SI.Temperature T_min = 125.0+273.15 "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = 210.0+273.15 "Design hot Temperature of everything in the tank (K)";
  
  //parameter Real E_v = eta*rho_f_avg*(h_f_max-h_f_min) + (1.0-eta)*rho_p_min*(h_p_max-h_p_min) "Volumetric Energy density of the tank (J/m3)";
  //parameter SI.Energy E_max = E_v*V_tank "Total capacity of the tank";
  parameter SI.Energy E_max = Multiplier*(thermocline_Tank.Tank_A.E_unit/thermocline_Tank.Tank_A.E_unit_solid) "Total capacity of the tank";
  parameter SI.Length z_f[N_f] = SolarTherm.Models.Storage.Thermocline.Z_position(L_pipe,N_f);
  //parameter SI.Temperature T_f_start[N_f] = fill(30.0+273.15,N_f);
  //parameter SI.Temperature h_f_start[N_f] = fill(Fluid.h_Tf(30.0+273.15,0),N_f);
  //parameter SI.Temperature T_p_start[N_f,N_p] = fill(fill(30.0+273.15,N_p),N_f);
  //parameter SI.Temperature h_p_start[N_f,N_p] = fill(fill(Filler.h_Tf(30.0+273.15,0.0),N_p),N_f);
  
  import Dataset = SolarTherm.Validation.Datasets.Laing_2006_Dataset;
  parameter SI.Temperature T_f_start[N_f] = Dataset.Initial_Temperature_f(z_f/L_pipe);
  parameter SI.Temperature h_f_start[N_f] = Dataset.Initial_Enthalpy_f(z_f/L_pipe);
  parameter SI.Temperature T_p_start[N_f,N_p] = Dataset.Initial_Temperature_p(z_f/L_pipe,N_p);
  parameter SI.Temperature h_p_start[N_f,N_p] = Dataset.Initial_Enthalpy_p(z_f/L_pipe,N_p);

  //parameter SI.Length[:] z_exp_1h = {0.4796,0.4310,0.3303,0.2293,0.1296,0.0295};
  //parameter SI.Length[:] z_exp_2h = {0.48,0.43,0.3299,0.2302,0.1296,0.0290};


  //parameter SI.Temperature[:] TC_exp_1h = {682,664,516,322,164,83};
  //parameter SI.Temperature[:] TC_exp_2h = {682,678,621,516,350,220};

  
  //All tank sections have HTF type in common!
  //Fluid.State fluid_top(h_start=h_f_start[N_f]) "Top fluid property object";
  //Fluid.State fluid_bot(h_start=h_f_start[1]) "Bottom fluid property object";
  
  //parameter SI.Time t_charge = 7 * 3600 "charging time";
  //parameter SI.Time t_discharge = 7 * 3600 "discharging time";
  //parameter SI.MassFlowRate m_flow_charge = E_max/((h_f_max-h_f_min)*t_charge) "Design mass flow rate of charging";
  //parameter SI.MassFlowRate m_flow_discharge = E_max/((h_f_max-h_f_min)*t_discharge) "Design mass flow rate of charging";
  
 
  //Inlet and Outlet
  SI.SpecificEnthalpy h_top "J/kg";
  SI.SpecificEnthalpy h_bot "J/kg";
  SI.MassFlowRate m_Recv_signal "kg/s";
  SI.MassFlowRate m_PB_signal "kg/s";
  
  SI.Temperature T_inlet(start=298.15) "K";
  
  //Core thermocouple temperature
  //Pos4 z/L = 0.0435, Pos1 z/L = 0.9565
  SI.Temperature T_core[N_f](start=T_f_start) "Core temperature, approximated by the filler node furthest from the fluid";
  SI.Temperature T_core_Pos4 = SolarTherm.Utilities.Interpolation.Interpolate1D(z_f,T_core,0.0435*L_pipe);
  SI.Temperature T_core_Pos1 = SolarTherm.Utilities.Interpolation.Interpolate1D(z_f,T_core,0.9565*L_pipe);
  
  SI.Temperature T_s_Pos4 = SolarTherm.Utilities.Interpolation.Interpolate1D(z_f,thermocline_Tank.Tank_A.T_s,0.0435*L_pipe);
  SI.Temperature T_s_Pos1 = SolarTherm.Utilities.Interpolation.Interpolate1D(z_f,thermocline_Tank.Tank_A.T_s,0.9565*L_pipe);
  //Experimental Data ref
  SI.Temperature T_core_Pos4_exp = SolarTherm.Utilities.Interpolation.Interpolate1D(Dataset.T_Pos4_times,Dataset.T_Pos4_TK,time);
  SI.Temperature T_core_Pos1_exp = SolarTherm.Utilities.Interpolation.Interpolate1D(Dataset.T_Pos1_times,Dataset.T_Pos1_TK,time);
  SI.Temperature T_outlet_exp = SolarTherm.Utilities.Interpolation.Interpolate1D(Dataset.T_outlet_times,Dataset.T_outlet_TK,time);
  
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
 Modelica.Fluid.Sources.Boundary_pT PB_outlet(redeclare package Medium = Medium, T = T_min, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {92, -60}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
 SolarTherm.Models.Storage.Thermocline.Thermocline_Annular_SingleTank_Final thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler, N_f = N_f, N_p = N_p, T_max = T_max, T_min = T_min, Correlation = Correlation, E_max = E_max, L_pipe=L_pipe,D_pipe=D_pipe,D_solid=D_solid,Tank_A.T_f_start = T_f_start, Tank_A.h_f_start = h_f_start, Tank_A.T_p_start = T_p_start, Tank_A.h_p_start = h_p_start, Tank_A.Multiplier=Multiplier, Multiplier=Multiplier,U_loss_tank=U_loss_tank) annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
 SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {44, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 SolarTherm.Models.Fluid.Sources.FluidSink PB_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {102, 44}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
 Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-38, -2}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
 Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {47, -2}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
 Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-103, 5}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
 Modelica.Blocks.Sources.RealExpression m_flow_PB(y = m_PB_signal) annotation(
    Placement(visible = true, transformation(origin = {110, 3}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
 SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
 SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {42, -62}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
 SolarTherm.Models.Fluid.Sources.FluidSink Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-120, -36}, extent = {{26, -26}, {-26, 26}}, rotation = 0)));
 SolarTherm.Models.Fluid.Valves.PBS_TeeJunction PBS_TeeJunction_Top(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-16, 0}, {16, 19.7076}}, rotation = 0)));
 SolarTherm.Models.Fluid.Valves.PBS_TeeJunction_LoopBreaker PBS_TeeJunction_LoopBreaker_Bot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-8.88178e-16, -47}, extent = {{-18, -19}, {18, 19}}, rotation = 180)));
 Modelica.Blocks.Sources.RealExpression Receiver_Inlet_T(y = T_inlet)  annotation(
    Placement(visible = true, transformation(origin = {-184, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
    T_inlet := SolarTherm.Utilities.Interpolation.Interpolate1D(Dataset.T_inlet_times,Dataset.T_inlet_TK,time);
    m_Recv_signal := max(1.0e-6, SolarTherm.Utilities.Interpolation.Interpolate1D(Dataset.Massflow_times,Dataset.Massflow_mflow,time));
equation
  //Connections
  h_bot = thermocline_Tank.fluid_bot.h;
  h_top = thermocline_Tank.fluid_top.h;
  T_bot = thermocline_Tank.fluid_bot.T;
  T_top = thermocline_Tank.fluid_top.T;
  //m_Recv_signal = 0.01389;
  m_PB_signal = 0.0;
  PBS_TeeJunction_LoopBreaker_Bot.fluid_b.p = 101325;
  PBS_TeeJunction_LoopBreaker_Bot.fluid_a.p = 101325;
  
  //der(E_stored) = m_Recv_signal*(h_top-h_bot);
  //der(E_pump_loss) = thermocline_Tank.Tank_A.W_loss_pump;
  for i in 1:N_f loop
    T_core[i] = thermocline_Tank.Tank_A.T_p[i,N_p];
  end for;
  //Fluid inlet and outlet properties
  //fluid_top.h = h_top;H_ta
  //fluid_bot.h = h_bot;
  //fluid_top.T = T_top;
  //fluid_bot.T = T_bot;
  connect(p_amb.y, thermocline_Tank.p_amb) annotation(
    Line(points = {{33, -2}, {18, -2}}, color = {0, 0, 127}));
 connect(Tamb.y, thermocline_Tank.T_amb) annotation(
    Line(points = {{-24, -2}, {-18, -2}, {-18, -2}, {-18, -2}}, color = {0, 0, 127}));
 connect(m_flow_Recv.y, pumpSimple_EqualPressure.m_flow) annotation(
    Line(points = {{-82, 6}, {-72, 6}, {-72, 70}, {-54, 70}, {-54, 56}, {-54, 56}}, color = {0, 0, 127}));
 connect(m_flow_Recv.y, pumpSimple_EqualPressure2.m_flow) annotation(
    Line(points = {{-82, 6}, {-56, 6}, {-56, -28}, {-56, -28}}, color = {0, 0, 127}));
 connect(m_flow_PB.y, pumpSimple_EqualPressure1.m_flow) annotation(
    Line(points = {{88, 4}, {62, 4}, {62, 66}, {44, 66}, {44, 52}, {44, 52}}, color = {0, 0, 127}));
 connect(m_flow_PB.y, pumpSimple_EqualPressure3.m_flow) annotation(
    Line(points = {{88, 4}, {62, 4}, {62, -38}, {42, -38}, {42, -54}, {42, -54}}, color = {0, 0, 127}));
 connect(PBS_TeeJunction_LoopBreaker_Bot.fluid_a, pumpSimple_EqualPressure3.fluid_b) annotation(
    Line(points = {{14, -62}, {32, -62}, {32, -62}, {32, -62}}, color = {0, 127, 255}));
 connect(PB_outlet.ports[1], pumpSimple_EqualPressure3.fluid_a) annotation(
    Line(points = {{76, -60}, {64, -60}, {64, -62}, {52, -62}, {52, -62}}, color = {0, 127, 255}));
 connect(PBS_TeeJunction_LoopBreaker_Bot.fluid_b, pumpSimple_EqualPressure2.fluid_a) annotation(
    Line(points = {{-14, -62}, {-28, -62}, {-28, -36}, {-46, -36}, {-46, -36}}, color = {0, 127, 255}));
 connect(pumpSimple_EqualPressure2.fluid_b, Recv_Sink.port_a) annotation(
    Line(points = {{-66, -36}, {-94, -36}, {-94, -36}, {-94, -36}}, color = {0, 127, 255}));
 connect(PB_Sink.port_a, pumpSimple_EqualPressure1.fluid_b) annotation(
    Line(points = {{78, 44}, {54, 44}, {54, 44}, {54, 44}}, color = {0, 127, 255}));
 connect(pumpSimple_EqualPressure1.fluid_a, PBS_TeeJunction_Top.fluid_b) annotation(
    Line(points = {{34, 44}, {26, 44}, {26, 60}, {12, 60}, {12, 60}}, color = {0, 127, 255}));
 connect(PBS_TeeJunction_Top.fluid_a, pumpSimple_EqualPressure.fluid_b) annotation(
    Line(points = {{-12, 60}, {-28, 60}, {-28, 48}, {-44, 48}, {-44, 48}}, color = {0, 127, 255}));
 connect(pumpSimple_EqualPressure.fluid_a, Recv_outlet.ports[1]) annotation(
    Line(points = {{-64, 48}, {-96, 48}, {-96, 48}, {-96, 48}}, color = {0, 127, 255}));
 connect(PBS_TeeJunction_Top.fluid_c, thermocline_Tank.fluid_a) annotation(
    Line(points = {{0, 44}, {0, 44}, {0, 28}, {0, 28}}, color = {0, 127, 255}));
 connect(thermocline_Tank.fluid_b, PBS_TeeJunction_LoopBreaker_Bot.fluid_c) annotation(
    Line(points = {{0, -32}, {0, -32}, {0, -46}, {0, -46}}, color = {0, 127, 255}));
 connect(Receiver_Inlet_T.y, Recv_outlet.T_in) annotation(
    Line(points = {{-172, 50}, {-160, 50}, {-160, 54}, {-132, 54}, {-132, 54}}, color = {0, 0, 127}));  
annotation(experiment(StopTime = 22680, StartTime = 0, Tolerance = 1e-3, Interval = 180.0));
end Annular_Laing_2006;