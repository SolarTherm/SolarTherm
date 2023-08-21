within SolarTherm.Models.Control;
model ReceiverControl
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

  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(transformation(extent={{54,-6},{66,6}})));
  Modelica.Blocks.Sources.RealExpression m_flow_off_input(y=m_flow_min)
    annotation (Placement(transformation(extent={{6,-34},{32,-10}})));
  Modelica.Blocks.Math.Feedback feedback annotation(Placement(transformation(extent={{-28,38},
            {-8,18}})));
  PID_AW_reset3               PI(                                                                                                                       Tt = 1,
    uMax=m_flow_max,
    uMin=m_flow_min,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_start=y_start,
    Ti=Ti,
    Kp=Kp)                                                                                                           annotation(Placement(transformation(extent={{14,18},
            {34,38}})));
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
equation
  connect(m_flow_off_input.y, switch.u3) annotation (Line(points={{33.3,-22},{44,
          -22},{44,-4.8},{52.8,-4.8}}, color={0,0,127}));
  connect(PI.u,feedback. y) annotation(Line(points={{12,28},{12,28},{-9,28}},              color = {0, 0, 127}));
  connect(T_ref_input.y, feedback.u1)
    annotation (Line(points={{-41,28},{-28,28},{-26,28}}, color={0,0,127}));
  connect(PI.y, switch.u1) annotation (Line(points={{35,28},{46,28},{46,16},{46,
          4.8},{52.8,4.8}},         color={0,0,127}));
  connect(T_mea, feedback.u2)
    annotation (Line(points={{-110,60},{-18,60},{-18,36}}, color={0,0,127}));
  connect(PI.reset, switch.u2) annotation (Line(points={{12,20},{0,20},{0,0},{52.8,
          0}}, color={255,0,255}));
  connect(L_mea, hotTankLogic.level_ref)
    annotation (Line(points={{-108,0},{-74,0}},           color={0,0,127}));
  connect(hotTankLogic.y, and1.u1) annotation (Line(points={{-53.2,0},{-44,0},{
          -44,-12},{-36,-12}}, color={255,0,255}));
  connect(and1.y, switch.u2) annotation (Line(points={{-13,-12},{-6,-12},{-6,0},
          {52.8,0}}, color={255,0,255}));
  connect(and1.u2, sf_on) annotation (Line(points={{-36,-20},{-64,-20},{-64,-60},
          {-110,-60}}, color={255,0,255}));
  connect(switch.y, m_flow)
    annotation (Line(points={{66.6,0},{112,0},{112,0}}, color={0,0,127}));
  connect(defocus_logic.level_ref, hotTankLogic.level_ref) annotation (Line(
        points={{0,-36},{0,-30},{-80,-30},{-80,0},{-74,0}}, color={0,0,127}));
  connect(not1.u, defocus_logic.y) annotation (Line(points={{1.33227e-015,-66.8},
          {1.33227e-015,-64},{0,-64},{0,-60.96}}, color={255,0,255}));
  connect(not1.y, defocus)
    annotation (Line(points={{0,-80.6},{0,-114}}, color={255,0,255}));
  annotation (Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"), Icon(graphics = {Text(origin = {-10, 254},lineColor={0,0,255},extent={{-149,-114},{151,-154}}, textString = "%name")}));
end ReceiverControl;
