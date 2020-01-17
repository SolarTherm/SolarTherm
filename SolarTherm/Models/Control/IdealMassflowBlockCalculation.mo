within SolarTherm.Models.Control;
model IdealMassflowBlockCalculation

import SI = Modelica.SIunits;
import Util = SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities; 
parameter Real y_start = 500;

   Modelica.Blocks.Interfaces.RealInput Q_input
    annotation (Placement(visible = true, transformation(origin = {2.22045e-16, 114},extent = {{-24, 12}, {24, -12}}, rotation = -90), iconTransformation(origin = {2.22045e-16, 114},extent = {{-24, 12}, {24, -12}}, rotation = -90)));
    
  Modelica.Blocks.Interfaces.RealInput T_mea
    annotation (Placement(transformation(extent={{-130,-20},{-80,20}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
          
  Modelica.Blocks.Interfaces.RealOutput m_flow (start = y_start) annotation(
    Placement(visible = true, transformation(extent = {{94, -18}, {130, 18}}, rotation = 0), iconTransformation(extent = {{94, -18}, {130, 18}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput T_ref
    annotation (Placement(transformation(extent={{-130,-80},{-90,-40}})));


equation

if Q_input == 0 then
m_flow = 0;

else
m_flow = Q_input / (Util.cp_T(T_mea) * abs(T_ref-T_mea));

end if;
 
 
end IdealMassflowBlockCalculation;