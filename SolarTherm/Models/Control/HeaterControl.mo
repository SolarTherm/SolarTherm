within SolarTherm.Models.Control;
model HeaterControl
  extends Icons.Control;
  parameter SI.Temperature T_ref=from_degC(570) "Setpoint of temperature";
  parameter SI.MassFlowRate m_flow_max=1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min=0 "Mass flow rate when control off";
  parameter Real L_on = 30 "Level of start discharge";
  parameter Real L_off=10 "Level of stop discharge";
  parameter Real L_df_on=99 "Level of start defocus";
  parameter Real L_df_off=96 "Level of stop defocus";

  parameter Real y_start=300 "Initial value of output";
  parameter Real Ti=1 "Integer constant";
  parameter Real Kp=-10 "Proportional constant";
  Modelica.Blocks.Interfaces.RealInput L_mea
    annotation (Placement(visible = true, transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0), iconTransformation(extent = {{-128, -20}, {-88, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput sf_on
    annotation (Placement(visible = true, transformation(extent = {{-140, -80}, {-100, -40}}, rotation = 0), iconTransformation(extent = {{-130, -80}, {-90, -40}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_mea
    annotation (Placement(visible = true, transformation(extent = {{-140, 40}, {-100, 80}}, rotation = 0), iconTransformation(extent = {{-130, 40}, {-90, 80}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow annotation(
    Placement(visible = true, transformation(origin = {120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation

  annotation (Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"), Icon(graphics = {Text(origin = {-10, 254},lineColor={0,0,255},extent={{-149,-114},{151,-154}}, textString = "%name")}));
end HeaterControl;