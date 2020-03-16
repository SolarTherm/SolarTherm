within SolarTherm.Models.Storage.Tank;

model Hopper
  extends Interfaces.Models.StorageFluid;
  redeclare replaceable package Medium = Media.SolidParticles.CarboHSP_ph;

  import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  import SI = Modelica.SIunits;
  import Modelica.SIunits.Conversions.*;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions;
  parameter SI.Efficiency eta_rec_th_des = 0.8;
  parameter SI.Temperature T_out_design = from_degC(800);
  parameter SI.Pressure P_hopper = 1e5;
  parameter SI.Density rho_particle = 3300;
  parameter SI.Length H_hopper = 20;
  parameter SI.Length D_hopper = 20;
  parameter SI.ThermalInsulance U_value = 2;
  parameter Real L_start = 70;
  parameter Real L_hopper_lower_bound = 30;
  parameter Real L_hopper_lower_bound_off = 2;
  parameter SI.MassFlowRate m_flow_max = 1000;
  parameter SI.Temperature T_Hopper_start = from_degC(630.109);
  parameter Real packing_factor = 0.7;
  Boolean on(start=true);
  SI.SpecificEnthalpy h_particle(start = Util.h_T(T_Hopper_start));
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;
  SI.MassFlowRate  m_in;
  SI.MassFlowRate m_out;
  SI.Mass m_particle (start = rho_particle*1/4*CN.pi*D_hopper^2*L_start/100*H_hopper);
  SI.HeatFlowRate Q_losses_convection;
  SI.HeatFlowRate Q_loss_radiation;
  SI.Length L_particle (start = L_start / 100 * H_hopper);
  SI.Temperature T_Hopper (start = T_Hopper_start);

  Real L_mea_hopper;
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(visible = true, transformation(origin = {-48, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-84, 98}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput L_hopper_mea annotation(
    Placement(visible = true, transformation(origin = {117, 53}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {117, 27}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Q_inc (start=0) annotation(
    Placement(visible = true, transformation(origin = {56, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {76, 98}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput field_operation annotation(
    Placement(visible = true, transformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-4, 98}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput m_flow  annotation(
    Placement(visible = true, transformation(origin = {117, -13}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {117, -29}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput on_y annotation(
    Placement(visible = true, transformation(origin = {110, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));  algorithm
  when L_mea_hopper>L_hopper_lower_bound then
    on:=true;
  elsewhen L_mea_hopper<L_hopper_lower_bound_off then
    on:=false;
  end when;
  on_y:=on;
  
  if on==true then
      if field_operation == false then  
        m_out := 0; 
      else
        m_out := -(min(Q_inc * eta_rec_th_des /(Util.h_T(T_out_design)-h_out),m_flow_max));
      end if;
  else
    m_out := 0;  
  end if;
  equation
  //Connectors completion
  m_in = fluid_a.m_flow;
  m_out = fluid_b.m_flow;
  fluid_a.h_outflow = 0;
  h_in = inStream(fluid_a.h_outflow);
  h_out = fluid_b.h_outflow;
  fluid_a.p=fluid_b.p;
  h_particle = h_out;  
  
  //mass and energy balance
  m_particle = rho_particle * 1/4 * CN.pi * D_hopper^2 * L_particle*packing_factor;
  rho_particle * 1/4 * CN.pi * D_hopper^2 *  der(L_particle) * packing_factor = m_in + m_out;
  L_mea_hopper = L_particle / H_hopper * 100;
  (m_in+m_out)*h_particle + der(h_particle)*m_particle=-Q_losses_convection - Q_loss_radiation+m_in*h_in+m_out*h_out;
  T_Hopper = Util.T_h(h_out);
  L_hopper_mea = L_mea_hopper;
    
  //losses in the hopper
  Q_losses_convection = U_value * CN.pi * D_hopper * L_particle * (Util.T_h(h_particle)-T_amb);
  Q_loss_radiation = 0.8*CN.sigma*(Util.T_h(h_particle)^4-T_amb^4);
//calculating mass flow out
  m_flow = 0;
    
end Hopper;