within SolarTherm.Validation.Models;

model Thermocline_Anderson_2014_VD
  //Use hybrid
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import Tables = Modelica.Blocks.Tables;
  package Medium = SolarTherm.Media.Air.Air_amb_p;
  package Filler = SolarTherm.Materials.Al2O3_Munro;
  package Fluid = SolarTherm.Materials.Air_Table;
  parameter Integer N_f = 100;
  parameter Integer N_p = 10;
  parameter SI.Length H_tank = 3.048;
  parameter SI.Diameter D_tank = 0.2428;
  parameter Real eta = 0.40;
  parameter SI.Diameter d_p = 0.006;
  parameter Real U_loss_tank = 0.0;
  parameter Integer Correlation = 2; //1:Wakao-kaguei, 2:melissari-argyropoulos
  parameter Real ar = H_tank/D_tank;
  
  parameter SI.Volume V_tank = 0.25*CN.pi*D_tank*D_tank*H_tank;
  
  //Properties of Fluid
  parameter SI.Density rho_f_avg = 0.5*(Fluid.rho_Tf(T_max,1.0)+Fluid.rho_Tf(T_min,0.0)) "averaged fluid density";
  parameter SI.SpecificEnthalpy h_f_max = Fluid.h_Tf(T_max,1.0) "Max fluid specific enthalpy";
  parameter SI.SpecificEnthalpy h_f_min = Fluid.h_Tf(T_min,0.0) "Min fluid specific enthalpy";
  
  parameter SI.Density rho_p_min = min(Filler.rho_Tf(T_max,1.0),Filler.rho_Tf(T_min,0.0)) "averaged filler density";
  parameter SI.SpecificEnthalpy h_p_max = Filler.h_Tf(T_max,1.0) "Max filler specific enthalpy";
  parameter SI.SpecificEnthalpy h_p_min = Filler.h_Tf(T_min,0.0) "Min filler specific enthalpy";
  
  parameter SI.Temperature T_min = 20.0+273.15 "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = 120.0+273.15 "Design hot Temperature of everything in the tank (K)";
  
  parameter Real E_v = eta*rho_f_avg*(h_f_max-h_f_min) + (1.0-eta)*rho_p_min*(h_p_max-h_p_min) "Volumetric Energy density of the tank (J/m3)";
  parameter SI.Energy E_max = E_v*V_tank "Total capacity of the tank";
  
  parameter SI.Length z_f[N_f] = SolarTherm.Models.Storage.Thermocline.Z_position(H_tank, N_f);
  parameter SI.Temperature T_f_start[N_f] = fill(T_min,N_f);
  parameter SI.Temperature h_f_start[N_f] = fill(Fluid.h_Tf(T_min,0),N_f);
  parameter SI.Temperature T_p_start[N_f,N_p] = fill(fill(T_min,N_p),N_f);
  parameter SI.Temperature h_p_start[N_f,N_p] = fill(fill(Filler.h_Tf(T_min,0.0),N_p),N_f);
  
  
  parameter SI.Length[:] z_exp_2000s = {0.0015822851,0.1565912778,0.3064865317,0.4589936067,0.6115588658,0.766729481,0.9165924104, 1.0718018151,1.3793696019,1.6841962696,1.8365611167,1.9915571796,2.2962222247,2.4432858509,2.5955925138,2.902804731};

  parameter SI.Temperature[:] TC_exp_2000s = {40.6281964605,44.0178166634,50.5111950686,56.7088486777,64.2365480215,71.3207397097,	77.0752038179,85.0460926626,95.8156293498,103.9252336449,106.8716643468,109.9657188308,114.3807516405,116.1452376218,117.761622589, 120.4031020084};

  //All tank sections have HTF type in common!
  //Fluid.State fluid_top(h_start=h_f_start[N_f]) "Top fluid property object";
  //Fluid.State fluid_bot(h_start=h_f_start[1]) "Bottom fluid property object";
  parameter SI.Time t_charge = 3 * 3600 "charging time";
  parameter SI.Time t_discharge = 3 * 3600 "discharging time";
  //parameter SI.MassFlowRate m_flow_charge = E_max/((h_f_max-h_f_min)*t_charge) "Design mass flow rate of charging";
  //parameter SI.MassFlowRate m_flow_discharge = E_max/((h_f_max-h_f_min)*t_discharge) "Design mass flow rate of charging";
  //Inlet and Outlet
  SI.SpecificEnthalpy h_top "J/kg";
  SI.SpecificEnthalpy h_bot "J/kg";
  SI.MassFlowRate m_Recv_signal "kg/s";
  //SI.MassFlowRate m_PB_signal "kg/s";
  //Boundary Conditions
  SI.Temperature T_top(start = T_min) "Temperature at the top";
  SI.Temperature T_bot(start = T_min) "Temperature at the bottom";
  
  //Recorded Variable
  SI.Energy E_stored (start=0.0) "J";
  SI.Energy E_pump_loss (start=0.0) "J";
  Real E_stored_kWh = E_stored/(3600.0e3) "kWh";
  Real E_pump_loss_kWh = E_pump_loss/(3600.0e3) "kWh";
  
  Modelica.Fluid.Sources.Boundary_pT Recv_outlet(redeclare package Medium = Medium, T = T_max, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-154, 74}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  SolarTherm.Models.Storage.Thermocline.Variable_Density.Thermocline_Spheres_SingleTank_VD_Final thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler, Correlation = Correlation, E_max = E_max, ar = ar, N_f = N_f, N_p = N_p, T_max = T_max, T_min = T_min, U_loss_tank = U_loss_tank, d_p = d_p, eta = eta) annotation(
    Placement(visible = true, transformation(origin = {-4, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-46, -2}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {49, -6}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-113, 95}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-128, -66}, extent = {{26, -26}, {-26, 26}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y = 1) annotation(
    Placement(visible = true, transformation(origin = {52, 28}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
//Connections
  h_bot = thermocline_Tank.fluid_bot.h;
  h_top = thermocline_Tank.fluid_top.h;
  T_bot = thermocline_Tank.fluid_bot.T;
  T_top = thermocline_Tank.fluid_top.T;
  m_Recv_signal = 0.0130956; //0.01024 m3/s at a density of 0.8881 kg/m3
  
  der(E_stored) = abs(thermocline_Tank.fluid_b.m_flow)*h_bot-abs(thermocline_Tank.fluid_a.m_flow)*h_top;
  der(E_pump_loss) = thermocline_Tank.Tank_A.W_loss_pump;
//PB_Sink.port_a.p = 101325;
//Fluid inlet and outlet properties
//fluid_top.h = h_top;
//fluid_bot.h = h_bot;
//fluid_top.T = T_top;
//fluid_bot.T = T_bot;
  connect(p_amb.y, thermocline_Tank.p_amb) annotation(
    Line(points = {{35, -6}, {13, -6}}, color = {0, 0, 127}));
  connect(Tamb.y, thermocline_Tank.T_amb) annotation(
    Line(points = {{-33, -2}, {-21, -2}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure.fluid_a, Recv_outlet.ports[1]) annotation(
    Line(points = {{-66, 74}, {-138, 74}}, color = {0, 127, 255}));
  connect(integerExpression.y, thermocline_Tank.Control_State) annotation(
    Line(points = {{40, 28}, {34, 28}, {34, 6}, {13, 6}, {13, 5}}, color = {255, 127, 0}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure.m_flow) annotation(
    Line(points = {{-92, 95}, {-56, 95}, {-56, 83}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure.fluid_b, thermocline_Tank.fluid_a) annotation(
    Line(points = {{-46, 74}, {-4, 74}, {-4, 28}, {-4, 28}}, color = {0, 127, 255}));
  connect(Recv_Sink.port_a, thermocline_Tank.fluid_b) annotation(
    Line(points = {{-102, -66}, {-4, -66}, {-4, -32}, {-4, -32}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 4000, StartTime = 0, Tolerance = 1e-3, Interval = 100.0));
end Thermocline_Anderson_2014_VD;