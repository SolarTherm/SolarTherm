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
  parameter SI.MassFlowRate m_flow_max = 1000;
  Boolean on(start=true);
  SI.SpecificEnthalpy h_particle(start = Util.h_T(from_degC(500)));
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out(start = Util.h_T(from_degC(500)));
  SI.MassFlowRate  m_in;
  SI.MassFlowRate m_out (start = 100);
  SI.Mass m_particle (start = rho_particle*1/4*CN.pi*D_hopper^2*L_start/100*H_hopper);
  SI.HeatFlowRate Q_losses_convection;
  SI.HeatFlowRate Q_loss_radiation;
  SI.Length L_particle (start = L_start / 100 * H_hopper);
  SI.Volume V_particle;
  SI.Temperature T_Hopper (start = from_degC(500));

  Real L_mea_hopper;
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(visible = true, transformation(origin = {-48, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-84, 98}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput L_hopper_mea annotation(
    Placement(visible = true, transformation(origin = {117, 53}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {117, 27}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Q_inc annotation(
    Placement(visible = true, transformation(origin = {56, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {76, 98}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput field_operation annotation(
    Placement(visible = true, transformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-4, 98}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput m_flow (start=100) annotation(
    Placement(visible = true, transformation(origin = {117, -13}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {117, -29}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));  
    
    
  algorithm
  when L_mea_hopper>L_hopper_lower_bound then
    on:=true;
  elsewhen L_mea_hopper<0.8*L_hopper_lower_bound then
    on:=false;
  end when;
  
  if on==true then
      if Q_inc<=1e-6 then  
        m_out := 0; 
      else
        m_out := -(min(Q_inc * eta_rec_th_des /(Util.h_T(T_out_design)-h_out),m_flow_max));
        //m_out = -1000;
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
  der(m_particle) = rho_particle * der(V_particle);
  der(V_particle) = 1/4 * CN.pi * D_hopper^2 * der(L_particle);
  L_mea_hopper = L_particle / H_hopper * 100;
  der(m_particle) = m_in + m_out;
  der(m_particle)*h_particle + der(h_particle)*m_particle=-Q_losses_convection - Q_loss_radiation+m_in*h_in+m_out*h_out;
  T_Hopper = Util.T_h(h_out);
  L_hopper_mea = L_mea_hopper;
  
  //losses in the hopper
  Q_losses_convection = U_value * CN.pi * D_hopper * L_particle * (Util.T_h(h_particle)-T_amb);
  Q_loss_radiation = 0.8*CN.sigma*(Util.T_h(h_particle)^4-T_amb^4);
//calculating mass flow out
  m_flow = 0;
    
end Hopper;