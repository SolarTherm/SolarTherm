within SolarTherm.Models.Control;
model ReceiverControlSimple
  extends Icons.Control;
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph constrainedby Modelica.Media.Interfaces.PartialMedium;
  parameter Medium.ThermodynamicState state_ref = Medium.setState_pTX(101325, T_ref);
  Medium.ThermodynamicState state_mea = Medium.setState_pTX(101325, T_mea);
  parameter Modelica.SIunits.SpecificEnthalpy h_ref = Medium.specificEnthalpy(state_ref);
  Modelica.SIunits.SpecificEnthalpy h_mea = Medium.specificEnthalpy(state_mea);
  Real eps = Modelica.Constants.small;
  Modelica.SIunits.MassFlowRate m_flow_internal;
  
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

  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(transformation(extent={{54,-6},{66,6}})));
  Modelica.Blocks.Sources.RealExpression m_flow_off_input(y=0)
    annotation (Placement(transformation(extent={{6,-34},{32,-10}})));
  Modelica.Blocks.Sources.RealExpression T_ref_input(y=T_ref)
    annotation (Placement(transformation(extent={{-62,18},{-42,38}})));
  Modelica.Blocks.Interfaces.RealInput L_mea
    annotation (Placement(visible = true, transformation(extent = {{-128, -20}, {-88, 20}}, rotation = 0), iconTransformation(extent = {{-130, -50}, {-90, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow
    annotation (Placement(transformation(extent={{94,-18},{130,18}})));
  Modelica.Blocks.Interfaces.BooleanInput sf_on
    annotation (Placement(visible = true, transformation(extent = {{-130, -80}, {-90, -40}}, rotation = 0), iconTransformation(extent = {{-130, -110}, {-90, -70}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_mea
    annotation (Placement(visible = true, transformation(extent = {{-130, 40}, {-90, 80}}, rotation = 0), iconTransformation(extent = {{-130, 10}, {-90, 50}}, rotation = 0)));
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
  Modelica.Blocks.Sources.RealExpression m_flow_calc(y = m_flow_internal) annotation(
    Placement(visible = true, transformation(origin = {16, 37}, extent = {{-10, -9}, {10, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Q_rec_out annotation(
    Placement(visible = true,transformation(origin = {0, 110},extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-110, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  m_flow_internal = Q_rec_out/(h_ref - h_mea + eps);
  connect(m_flow_off_input.y, switch.u3) annotation(
    Line(points = {{33.3, -22}, {44, -22}, {44, -4.8}, {52.8, -4.8}}, color = {0, 0, 127}));
  connect(L_mea, hotTankLogic.level_ref) annotation(
    Line(points = {{-108, 0}, {-74, 0}}, color = {0, 0, 127}));
  connect(hotTankLogic.y, and1.u1) annotation(
    Line(points = {{-53.2, 0}, {-44, 0}, {-44, -12}, {-36, -12}}, color = {255, 0, 255}));
  connect(and1.y, switch.u2) annotation(
    Line(points = {{-13, -12}, {-6, -12}, {-6, 0}, {52.8, 0}}, color = {255, 0, 255}));
  connect(and1.u2, sf_on) annotation(
    Line(points = {{-36, -20}, {-64, -20}, {-64, -60}, {-110, -60}}, color = {255, 0, 255}));
  connect(switch.y, m_flow) annotation(
    Line(points = {{66.6, 0}, {112, 0}, {112, 0}}, color = {0, 0, 127}));
  connect(defocus_logic.level_ref, hotTankLogic.level_ref) annotation(
    Line(points = {{0, -36}, {0, -30}, {-80, -30}, {-80, 0}, {-74, 0}}, color = {0, 0, 127}));
  connect(not1.u, defocus_logic.y) annotation(
    Line(points = {{1.33227e-015, -66.8}, {1.33227e-015, -64}, {0, -64}, {0, -60.96}}, color = {255, 0, 255}));
  connect(not1.y, defocus) annotation(
    Line(points = {{0, -80.6}, {0, -114}}, color = {255, 0, 255}));
  connect(m_flow_calc.y, switch.u1) annotation(
    Line(points = {{28, 38}, {40, 38}, {40, 4}, {52, 4}}, color = {0, 0, 127}));
  annotation (Documentation(revisions = "<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"),
    Icon(graphics = {Text(origin = {0, 140}, lineColor = {0, 0, 255}, extent = {{-140, 20}, {140, -20}}, textString = "%name")}));
end ReceiverControlSimple;