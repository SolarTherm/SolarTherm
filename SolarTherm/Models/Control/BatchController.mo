within SolarTherm.Models.Control;

model BatchController
extends Icons.Control;

  import SI = Modelica.SIunits;
  import Modelica.SIunits.Conversions.from_degC;
  import CN = Modelica.Constants;
  import ModelicaReference.Operators;

  parameter Real on_level = 70;
  parameter Real L_mea_tank_lower_bound = 10;
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
  parameter SI.Time t_sk =3600;
  parameter Real N_sk (fixed=false) "Number of skips ";
  parameter SI.Power P_lift (fixed=false);
  discrete Modelica.SIunits.Time t_off;
  discrete Modelica.SIunits.Time t_on;
  Modelica.Blocks.Interfaces.RealOutput m_flow annotation(
      Placement(visible = true, transformation(origin = {106, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Boolean on (start=false);
  Modelica.Blocks.Interfaces.RealInput L_mea annotation(
    Placement(visible = true, transformation(origin = {-101, 55}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(origin = {-101, 55}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput L_mea_tank annotation(
    Placement(visible = true, transformation(origin = {-100, -26}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-100, -26}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  ////////////////////////////////////////////////////////////////////////////////////////////////
initial algorithm
  m_max_hop :=t_sk*m_flow_fac*safety_factor; 
  N_sk:= (H_total*2)/(t_sk*omega_max_mtr*d_gear*0.5);
  P_lift:= (m_flow_fac*CN.g_n) * d_gear/2 * omega_max_mtr * N_sk;

initial equation
  pre(t_off)=0;
  pre(t_on)=0;
  
algorithm
  if L_mea<on_level and L_mea_tank>L_mea_tank_lower_bound then
    on := true;
    t_on:=time;
  elseif on_level>95 or L_mea_tank<L_mea_tank_lower_bound then
    on := false;
    t_off:=time;
  end if;
  
  when on == true then
    if rem(time-t_on,t_sk) == 0 then
      m_flow := m_flow_fac;
    else 
      m_flow := 0;
    end if;
  end when;
   
end BatchController;