within SolarTherm.Models.Control;

model PulseController

  import SI = Modelica.SIunits;
  import Modelica.SIunits.Conversions.from_degC;
  import CN = Modelica.Constants;
  import ModelicaReference.Operators;
  parameter Real on_level = 50;
  parameter Real L_mea_tank_lower_bound = 10;
  parameter Real L_mea_hopper_upper_bound = 95;
  parameter Real L_mea_tank_upper_bound = 30;
  parameter SI.Time pouring_time = 2;
  parameter SI.Frequency f_mtr_max = 60;
  parameter Real poles = 2;
  parameter Real safety_factor = 2;
  parameter SI.AngularVelocity omega_max_mtr = 120 * f_mtr_max / 2 * 0.104719755 "converting RPM to rad/s";
  parameter SI.Length H_hopper = 20;
  parameter SI.Length H_tower = 200;
  parameter SI.Length H_total = H_hopper+H_tower;
  parameter SI.Length d_hopper = 20;
  parameter SI.Length d_gear = 1;
  parameter SI.Density rho_particle = 3300;
  parameter SI.MassFlowRate m_flow_fac = 2000 "receiver design mass flow rate";
  parameter Real packing_factor = 0.7;
  /////////////////////////////////////////////////////////////////////////////////////////////////
  parameter SI.MassFlowRate m_max_hop (fixed=false); 
  parameter SI.Time t_sk =10;
  parameter Real N_sk (fixed=false) "Number of skips ";
  parameter SI.Power P_lift (fixed=false);
  ////////////////////////////////////////////////////////////////////////////////////////////////
  Modelica.Blocks.Interfaces.RealInput L_mea_hopper annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput L_mea_tank annotation(
    Placement(visible = true, transformation(origin = {-120, -12}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -12}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch lift_switch annotation(
    Placement(visible = true, transformation(origin = {58, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_zero annotation(
    Placement(visible = true, transformation(origin = {-56, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput mass_flow_batch annotation(
    Placement(visible = true, transformation(origin = {110, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {127, 3}, extent = {{-27, -27}, {27, 27}}, rotation = 0)));
  SolarTherm.Models.Control.pulse_modified pulser(on_level=on_level,L_mea_tank_lower_bound=L_mea_tank_lower_bound,L_mea_hopper_upper_bound=L_mea_hopper_upper_bound,width=pouring_time,period=t_sk) annotation(
    Placement(visible = true, transformation(origin = {-38, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow(y=m_flow_fac) annotation(
    Placement(visible = true, transformation(origin = {-70, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /////////////////////////////////////////////////////////////////////////////////////////////////
initial algorithm
  m_max_hop :=t_sk*m_flow_fac*safety_factor; 
  N_sk:= (H_total*2)/(t_sk*omega_max_mtr*d_gear*0.5);
  P_lift:= (m_flow_fac*CN.g_n) * d_gear/2 * omega_max_mtr * N_sk;

equation
  connect(m_zero.y, lift_switch.u3) annotation(
    Line(points = {{-44, -56}, {32, -56}, {32, -4}, {46, -4}, {46, -4}}, color = {0, 0, 127}));
  connect(lift_switch.y, mass_flow_batch) annotation(
    Line(points = {{70, 4}, {102, 4}, {102, 2}, {110, 2}}, color = {0, 0, 127}));
  connect(pulser.y, lift_switch.u2) annotation(
    Line(points = {{-26, 4}, {44, 4}, {44, 4}, {46, 4}}, color = {255, 0, 255}));
  connect(L_mea_hopper, pulser.L_mea_hopper) annotation(
    Line(points = {{-120, 20}, {-66, 20}, {-66, 8}, {-50, 8}, {-50, 10}}, color = {0, 0, 127}));
  connect(L_mea_tank, pulser.L_mea_tank) annotation(
    Line(points = {{-120, -12}, {-66, -12}, {-66, -2}, {-50, -2}, {-50, -2}}, color = {0, 0, 127}));
  connect(m_flow.y, lift_switch.u1) annotation(
    Line(points = {{-58, 58}, {18, 58}, {18, 12}, {46, 12}, {46, 12}}, color = {0, 0, 127}));
annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end PulseController;