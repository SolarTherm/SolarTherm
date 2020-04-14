within SolarTherm.Models.Control;
model IdealMassflowBlockCalculation

import SI = Modelica.SIunits;
import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities; 
parameter Real y_start = 500;
Boolean on (start=false);

outer parameter Real eta_rec (start = 0, fixed =false);

outer parameter Real eta_rec_th_des "outer prefix refers to the inner parameters with the same neame within the same, in this cas, it refers to eta_rec_th_desin hte system big code";
Real eta_rec_discrete (start = eta_rec_th_des);

   Modelica.Blocks.Interfaces.RealInput Q_input
    annotation (Placement(visible = true, transformation(origin = {-116, 80},extent = {{-24, 12}, {24, -12}}, rotation = 0), iconTransformation(origin = {-116, 80},extent = {{-24, 12}, {24, -12}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput T_mea
    annotation (Placement(visible = true,transformation(extent = {{-140, -40}, {-90, 0}}, rotation = 0),
        iconTransformation(extent = {{-120, -20}, {-80, 20}}, rotation = 0)));    
        
  Modelica.Blocks.Interfaces.RealOutput m_flow (start = y_start) annotation(
    Placement(visible = true, transformation(extent = {{94, -18}, {130, 18}}, rotation = 0), iconTransformation(extent = {{94, -18}, {130, 18}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput T_ref
    annotation (Placement(visible = true, transformation(origin = {0, -108},extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -108},extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  
  Modelica.Blocks.Interfaces.RealInput T_out_receiver annotation(
    Placement(visible = true, transformation(origin = {-2, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-2, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput eta_rec_in annotation(
    Placement(visible = true, transformation(origin = {50, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {50, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
algorithm

if Q_input <= 1e-6 then
  m_flow := 0;
  on := false;
  
elseif Q_input > 1e-6 then
on:=true;
    if pre(eta_rec)< 1e-20 then 
      m_flow := Q_input * eta_rec_discrete / abs(Util.h_T(T_ref) - Util.h_T(T_mea)) "Start-up condition";
    else
      m_flow := Q_input * eta_rec / abs(Util.h_T(T_ref) - Util.h_T(T_mea));
      eta_rec_discrete := eta_rec "updating eta_rec_discrete";
    end if;    
end if;
end IdealMassflowBlockCalculation;