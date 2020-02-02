within SolarTherm.Models.Control;

model SRC2
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

  Modelica.Blocks.Interfaces.RealInput Q_input
    annotation (Placement(transformation(extent={{-130,100},{-90,80}})));
  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(visible = true, transformation(extent = {{70, -6}, {82, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_off_input(y=0)
    annotation (Placement(transformation(extent={{6,-34},{32,-10}})));
  Modelica.Blocks.Math.Feedback feedback annotation(Placement(visible = true, transformation(extent = {{-24, 38}, {-4, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression T_ref_input(y=T_ref)
    annotation (Placement(transformation(extent={{-62,18},{-42,38}})));
  Modelica.Blocks.Interfaces.RealInput L_mea
    annotation (Placement(transformation(extent={{-128,-20},{-88,20}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow
    annotation (Placement(transformation(extent={{94,-18},{130,18}})));
  Modelica.Blocks.Interfaces.BooleanInput sf_on
    annotation (Placement(transformation(extent={{-130,-80},{-90,-40}})));
  Modelica.Blocks.Interfaces.RealInput T_mea
    annotation (Placement(transformation(extent={{-130,40},{-90,80}})));
  SolarTherm.Models.Control.Level2Logic hotTankLogic(level_max=L_on, level_min=L_off)
    annotation (Placement(visible = true, transformation(extent = {{-74, -4}, {-54, 16}}, rotation = 0)));
  Level2Logic defocus_logic(
    y(start=false),
    level_max=L_df_off,
    level_min=L_df_on)  annotation (Placement(transformation(
        extent={{-12,-10},{12,10}},
        rotation=-90,
        origin={0,-48})));
  Modelica.Blocks.Logical.Not not1 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,-74})));
  Modelica.Blocks.Interfaces.BooleanOutput defocus annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,-114})));
  SolarTherm.Models.Control.IdealMassflowBlockCalculation idealMassflowBlockCalculation annotation(
    Placement(visible = true, transformation(origin = {25, 37}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  SolarTherm.ABC abc annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(m_flow_off_input.y, switch.u3) annotation(
    Line(points = {{33.3, -22}, {44, -22}, {44, -5}, {69, -5}}, color = {0, 0, 127}));
  connect(T_ref_input.y, feedback.u1) annotation(
    Line(points = {{-41, 28}, {-22, 28}}, color = {0, 0, 127}));
  connect(T_mea, feedback.u2) annotation(
    Line(points = {{-110, 60}, {-14, 60}, {-14, 36}}, color = {0, 0, 127}));
  connect(L_mea, hotTankLogic.level_ref) annotation(
    Line(points = {{-108, 0}, {-91, 0}, {-91, 6}, {-74, 6}}, color = {0, 0, 127}));
  connect(switch.y, m_flow) annotation(
    Line(points = {{83, 0}, {112, 0}}, color = {0, 0, 127}));
  connect(defocus_logic.level_ref, hotTankLogic.level_ref) annotation(
    Line(points = {{0, -36}, {0, -30}, {-80, -30}, {-80, 6}, {-74, 6}}, color = {0, 0, 127}));
  connect(not1.u, defocus_logic.y) annotation(
    Line(points = {{1.33227e-015, -66.8}, {1.33227e-015, -64}, {0, -64}, {0, -60.96}}, color = {255, 0, 255}));
  connect(not1.y, defocus) annotation(
    Line(points = {{0, -80.6}, {0, -114}}, color = {255, 0, 255}));
  connect(feedback.y, idealMassflowBlockCalculation.delta_T) annotation(
    Line(points = {{-5, 28}, {8.5, 28}}, color = {0, 0, 127}));
  connect(idealMassflowBlockCalculation.Q_input, Q_input) annotation(
    Line(points = {{8, 50}, {0, 50}, {0, 90}, {-110, 90}, {-110, 90}}, color = {0, 0, 127}));
  connect(idealMassflowBlockCalculation.T_mea, T_mea) annotation(
    Line(points = {{10, 38}, {-3.5, 38}, {-3.5, 48}, {-96, 48}, {-96, 60}, {-110, 60}}, color = {0, 0, 127}));
  connect(switch.u2, abc.y) annotation(
    Line(points = {{69, 0}, {-9, 0}}, color = {255, 0, 255}));
  connect(hotTankLogic.y, abc.u1) annotation(
    Line(points = {{-53, 6}, {-31, 6}}, color = {255, 0, 255}));
  connect(abc.u2, sf_on) annotation(
    Line(points = {{-31, -6}, {-32, -6}, {-32, -60}, {-110, -60}}, color = {255, 0, 255}));
  connect(idealMassflowBlockCalculation.m_flow, switch.u1) annotation(
    Line(points = {{42, 38}, {66, 38}, {66, 4}, {68, 4}, {68, 4}}, color = {0, 0, 127}));
  annotation (Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));

end SRC2;