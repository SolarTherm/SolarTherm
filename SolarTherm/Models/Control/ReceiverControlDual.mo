within SolarTherm.Models.Control;
model ReceiverControlDual
  extends Icons.Control;
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph constrainedby Modelica.Media.Interfaces.PartialMedium;
  replaceable package MediumH = SolarTherm.Media.Sodium.Sodium_pT constrainedby Modelica.Media.Interfaces.PartialMedium;
  parameter Medium.ThermodynamicState state_out_cold_set = Medium.setState_pTX(101325, T_out_cold_set);
  parameter MediumH.ThermodynamicState state_out_hot_set = MediumH.setState_pTX(101325, T_out_hot_set);
  Medium.ThermodynamicState state_in_cold = Medium.setState_pTX(101325, T_in_cold);
  MediumH.ThermodynamicState state_in_hot = MediumH.setState_pTX(101325, T_in_hot);
  parameter Modelica.SIunits.SpecificEnthalpy h_out_cold_set = Medium.specificEnthalpy(state_out_cold_set);
  parameter Modelica.SIunits.SpecificEnthalpy h_out_hot_set = MediumH.specificEnthalpy(state_out_hot_set);
  Modelica.SIunits.SpecificEnthalpy h_in_cold = Medium.specificEnthalpy(state_in_cold);
  Modelica.SIunits.SpecificEnthalpy h_in_hot = MediumH.specificEnthalpy(state_in_hot);
  Real eps = Modelica.Constants.small;
  Modelica.SIunits.MassFlowRate m_cold_internal;
  Modelica.SIunits.MassFlowRate m_hot_internal;
  
  parameter SI.Temperature T_out_cold_set=from_degC(574) "Setpoint of temperature";
  parameter SI.Temperature T_out_hot_set=from_degC(594) "Setpoint of temperature";
  parameter SI.MassFlowRate m_flow_max=1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min=0 "Mass flow rate when control off";
  parameter Real L_on = 30 "Level of start discharge";
  parameter Real L_off=10 "Level of stop discharge";
  parameter Real L_df_on=99 "Level of start defocus";
  parameter Real L_df_off=96 "Level of stop defocus";

  SolarTherm.Models.Control.Switch2 switch
    annotation (Placement(visible = true, transformation(extent = {{54, -6}, {66, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_off_input(y=0)
    annotation (Placement(transformation(extent={{6,-34},{32,-10}})));
  Modelica.Blocks.Interfaces.RealInput L_mea
    annotation (Placement(visible = true, transformation(extent = {{-130, -60}, {-90, -20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_cold
    annotation (Placement(visible = true, transformation(extent = {{94, -78}, {130, -42}}, rotation = 0), iconTransformation(extent = {{94, -78}, {130, -42}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_hot annotation(
    Placement(visible = true, transformation(extent = {{94, 42}, {130, 78}}, rotation = 0), iconTransformation(extent = {{94, 42}, {130, 78}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput sf_on
    annotation (Placement(visible = true, transformation(extent = {{-130, -100}, {-90, -60}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_in_hot
    annotation (Placement(visible = true, transformation(extent = {{-130, 20}, {-90, 60}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_in_cold
    annotation (Placement(visible = true, transformation(extent = {{-130, 60}, {-90, 100}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Level2Logic hotTankLogic(level_max=30, level_min=L_off)
    annotation (Placement(transformation(extent={{-74,-10},{-54,10}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-34,-22},{-14,-2}})));
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
  Modelica.Blocks.Sources.RealExpression m_cold_calc(y = m_cold_internal) annotation(
    Placement(visible = true, transformation(origin = {10, 19}, extent = {{-10, -9}, {10, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_hot_calc(y = m_hot_internal) annotation(
    Placement(visible = true, transformation(origin = {10, 59}, extent = {{-10, -9}, {10, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Q_rec_out annotation(
    Placement(visible = true,transformation(origin = {0, 110},extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  m_cold_internal = Q_rec_out/(h_out_cold_set - h_in_cold + eps);
  m_hot_internal = Q_rec_out/(h_out_hot_set - h_in_hot + eps);
  connect(L_mea, hotTankLogic.level_ref) annotation(
    Line(points = {{-110, -40}, {-92, -40}, {-92, 0}, {-74, 0}}, color = {0, 0, 127}));
  connect(hotTankLogic.y, and1.u1) annotation(
    Line(points = {{-53.2, 0}, {-44, 0}, {-44, -12}, {-36, -12}}, color = {255, 0, 255}));
  connect(and1.u2, sf_on) annotation(
    Line(points = {{-36, -20}, {-64, -20}, {-64, -80}, {-110, -80}}, color = {255, 0, 255}));
  connect(defocus_logic.level_ref, hotTankLogic.level_ref) annotation(
    Line(points = {{0, -36}, {0, -30}, {-80, -30}, {-80, 0}, {-74, 0}}, color = {0, 0, 127}));
  connect(not1.u, defocus_logic.y) annotation(
    Line(points = {{1.33227e-015, -66.8}, {1.33227e-015, -64}, {0, -64}, {0, -60.96}}, color = {255, 0, 255}));
  connect(not1.y, defocus) annotation(
    Line(points = {{0, -80.6}, {0, -114}}, color = {255, 0, 255}));
  connect(switch.y2, m_hot) annotation(
    Line(points = {{67, 2}, {80, 2}, {80, 60}, {112, 60}}, color = {0, 0, 127}));
  connect(switch.y1, m_cold) annotation(
    Line(points = {{67, -2}, {80, -2}, {80, -60}, {112, -60}}, color = {0, 0, 127}));
  connect(m_flow_off_input.y, switch.u3) annotation(
    Line(points = {{34, -22}, {40, -22}, {40, -5}, {53, -5}}, color = {0, 0, 127}));
  connect(switch.in1, m_cold_calc.y) annotation(
    Line(points = {{52, 2}, {34, 2}, {34, 19}, {21, 19}}, color = {0, 0, 127}));
  connect(m_hot_calc.y, switch.in2) annotation(
    Line(points = {{21, 59}, {40, 59}, {40, 4}, {52, 4}}, color = {0, 0, 127}));
  connect(and1.y, switch.u2) annotation(
    Line(points = {{-12, -12}, {-4, -12}, {-4, -2}, {52, -2}}, color = {255, 0, 255}));
  annotation (Documentation(revisions = "<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"),
    Icon(graphics = {Text(origin = {0, 140}, lineColor = {0, 0, 255}, extent = {{-140, 20}, {140, -20}}, textString = "%name")}));
end ReceiverControlDual;