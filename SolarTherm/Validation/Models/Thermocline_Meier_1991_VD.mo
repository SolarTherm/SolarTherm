within SolarTherm.Validation.Models;

model Thermocline_Meier_1991_VD
  //Use hybrid
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;
  package Medium = SolarTherm.Media.Air.Air_amb_p;
  package Filler = SolarTherm.Materials.Steatite_Constant;
  package Fluid = SolarTherm.Materials.Air_Table;
  parameter Integer N_f = 100;
  parameter Integer N_p = 10;
  parameter SI.Length H_tank = 1.20;
  parameter SI.Diameter D_tank = 0.15;
  parameter Real eta = 0.40;
  parameter SI.Diameter d_p = 0.02;
  parameter Real U_loss_tank = 0.678;
  parameter Integer Correlation = 1;
  parameter SI.Length z_f[N_f] = SolarTherm.Models.Storage.Thermocline.Z_position(H_tank, N_f);
  parameter SI.Temperature T_f_start[N_f] = fill(25.0 + 273.15, N_f);
  parameter SI.Temperature h_f_start[N_f] = fill(Fluid.h_Tf(25.0 + 273.15, 0), N_f);
  parameter SI.Temperature T_p_start[N_f, N_p] = fill(fill(25.0 + 273.15, N_p), N_f);
  parameter SI.Temperature h_p_start[N_f, N_p] = fill(fill(Filler.h_Tf(25.0 + 273.15, 0.0), N_p), N_f);
  //All tank sections have HTF type in common!
  //Fluid.State fluid_top(h_start=h_f_start[N_f]) "Top fluid property object";
  //Fluid.State fluid_bot(h_start=h_f_start[1]) "Bottom fluid property object";
  parameter SI.Time t_charge = 3 * 3600 "charging time";
  parameter SI.Time t_discharge = 3 * 3600 "discharging time";
  //parameter SI.MassFlowRate m_flow_charge = E_max/((h_f_max-h_f_min)*t_charge) "Design mass flow rate of charging";
  //parameter SI.MassFlowRate m_flow_discharge = E_max/((h_f_max-h_f_min)*t_discharge) "Design mass flow rate of charging";
  parameter SI.Temperature T_min = 25 + 273.15 "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = 550 + 273.15 "Design hot Temperature of everything in the tank (K)";
  //Inlet and Outlet
  SI.SpecificEnthalpy h_top "J/kg";
  SI.SpecificEnthalpy h_bot "J/kg";
  SI.MassFlowRate m_Recv_signal "kg/s";
  //SI.MassFlowRate m_PB_signal "kg/s";
  //Boundary Conditions
  SI.Temperature T_top(start = T_min) "Temperature at the top";
  SI.Temperature T_bot(start = T_min) "Temperature at the bottom";
  Modelica.Fluid.Sources.Boundary_pT Recv_outlet(redeclare package Medium = Medium, T = T_max, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_SingleTank_VD_Final thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler, Correlation = Correlation, Tank_A.H_tank = H_tank, Tank_A.D_tank = D_tank, N_f = N_f, N_p = N_p, T_max = T_max, T_min = T_min, U_loss_tank = U_loss_tank, d_p = d_p, eta = eta) annotation(
    Placement(visible = true, transformation(origin = {-4, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-38, -2}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {49, -6}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-105, 3}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-118, -36}, extent = {{26, -26}, {-26, 26}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y = 1) annotation(
    Placement(visible = true, transformation(origin = {52, 28}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
//Connections
  h_bot = thermocline_Tank.fluid_bot.h;
  h_top = thermocline_Tank.fluid_top.h;
  T_bot = thermocline_Tank.fluid_bot.T;
  T_top = thermocline_Tank.fluid_top.T;
  m_Recv_signal = 0.004*0.75;
//PB_Sink.port_a.p = 101325;
//Fluid inlet and outlet properties
//fluid_top.h = h_top;
//fluid_bot.h = h_bot;
//fluid_top.T = T_top;
//fluid_bot.T = T_bot;
  connect(p_amb.y, thermocline_Tank.p_amb) annotation(
    Line(points = {{35, -6}, {13, -6}}, color = {0, 0, 127}));
  connect(Tamb.y, thermocline_Tank.T_amb) annotation(
    Line(points = {{-24, -2}, {-21, -2}}, color = {0, 0, 127}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure.m_flow) annotation(
    Line(points = {{-84, 3}, {-72, 3}, {-72, 70}, {-54, 70}, {-54, 56}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure.fluid_a, Recv_outlet.ports[1]) annotation(
    Line(points = {{-64, 48}, {-96, 48}, {-96, 48}, {-96, 48}}, color = {0, 127, 255}));
  connect(integerExpression.y, thermocline_Tank.Control_State) annotation(
    Line(points = {{40, 28}, {34, 28}, {34, 6}, {13, 6}, {13, 5}}, color = {255, 127, 0}));
  connect(thermocline_Tank.fluid_b, Recv_Sink.port_a) annotation(
    Line(points = {{-4, -32}, {-4, -32}, {-4, -48}, {-74, -48}, {-74, -36}, {-92, -36}, {-92, -36}}, color = {0, 127, 255}));
  connect(pumpSimple_EqualPressure.fluid_b, thermocline_Tank.fluid_a) annotation(
    Line(points = {{-44, 48}, {-4, 48}, {-4, 28}, {-4, 28}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 14400, StartTime = 0, Tolerance = 1e-3, Interval = 180.0));
end Thermocline_Meier_1991_VD;