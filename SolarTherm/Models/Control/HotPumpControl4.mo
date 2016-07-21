within SolarTherm.Models.Control;
model HotPumpControl4
  extends Icons.Control;
  parameter SI.HeatFlowRate Q_max = 294.118e6;
  parameter SI.HeatFlowRate Q_min = 294.118e6*0.5;
  parameter SI.MassFlowRate m_flow_max=682.544 "Constant mass flow rate on";
  parameter SI.MassFlowRate m_flow_off=0 "Constant mass flow rate off";

  parameter Real L_off=10 "Level of stop discharge";
  parameter Real L_df_on=99 "Level of start defocus";
  parameter Real L_df_off=96 "Level of stop defocus";

  parameter SI.Time delay=from_hour(0.5) "Start-up delay time";




  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(transformation(extent={{66,-6},{78,6}})));
  Modelica.Blocks.Sources.RealExpression m_flow_off_input(y=m_flow_off)
    annotation (Placement(transformation(extent={{28,-16},{52,-4}})));
  Modelica.Blocks.Interfaces.RealInput L_mea
    annotation (Placement(transformation(extent={{-128,-20},{-88,20}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow
    annotation (Placement(transformation(extent={{92,-20},{132,20}})));
  Level2Logic logic1(
    y(start=false),
    level_max=L_df_on,
    level_min=L_df_off)
    annotation (Placement(transformation(extent={{-46,-58},{-22,-38}})));
  Modelica.Blocks.Interfaces.BooleanOutput defocus annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-112})));
  Modelica.Blocks.MathBoolean.OnDelay onDelay(delayTime=delay)
    annotation (Placement(transformation(extent={{-20,-4},{-12,4}})));
  Modelica.Blocks.Interfaces.RealInput Q_solar annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,106})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=L_off)
    annotation (Placement(transformation(extent={{-64,-22},{-52,-10}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold=Q_min)
    annotation (Placement(transformation(extent={{-64,6},{-52,18}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-40,-6},{-28,6}})));
  M_flow_calculator m_flow_calculator(
    Q_max=Q_max,
    Q_min=Q_min,
    m_flow_max=m_flow_max)
    annotation (Placement(transformation(extent={{6,32},{32,46}})));
equation
  connect(m_flow_off_input.y, switch.u3) annotation (Line(points={{53.2,-10},{58,
          -10},{58,-4.8},{64.8,-4.8}},
                           color={0,0,127}));
  connect(switch.y, m_flow) annotation (Line(points={{78.6,0},{78.6,0},{112,0}},
                       color={0,0,127}));
  connect(logic1.level_ref, L_mea) annotation (Line(points={{-46,-48},{-70,-48},
          {-70,0},{-108,0}}, color={0,0,127}));
  connect(logic1.y, defocus) annotation (Line(points={{-21.04,-48},{-6,-48},{0,-48},
          {0,-112}}, color={255,0,255}));
  connect(onDelay.y, switch.u2)
    annotation (Line(points={{-11.2,0},{-11.2,0},{64.8,0}},
                                                      color={255,0,255}));
  connect(Q_solar, greaterThreshold1.u) annotation (Line(points={{0,106},{0,106},
          {0,78},{-80,78},{-80,12},{-65.2,12}}, color={0,0,127}));
  connect(greaterThreshold1.y, and1.u1) annotation (Line(points={{-51.4,12},{-46,
          12},{-46,0},{-41.2,0}}, color={255,0,255}));
  connect(greaterThreshold.y, and1.u2) annotation (Line(points={{-51.4,-16},{-46,
          -16},{-46,-4.8},{-41.2,-4.8}}, color={255,0,255}));
  connect(greaterThreshold.u, L_mea) annotation (Line(points={{-65.2,-16},{-70,-16},
          {-70,0},{-108,0}}, color={0,0,127}));
  connect(and1.y, onDelay.u)
    annotation (Line(points={{-27.4,0},{-21.6,0}}, color={255,0,255}));
  connect(m_flow_calculator.m_flow, switch.u1) annotation (Line(points={{33.04,
          39},{40,39},{40,4.8},{64.8,4.8}},
                                        color={0,0,127}));
  connect(m_flow_calculator.Q_solar, greaterThreshold1.u) annotation (Line(
        points={{6,39},{-46,39},{-46,78},{-80,78},{-80,12},{-65.2,12}},
                                                                    color={0,0,127}));
end HotPumpControl4;
