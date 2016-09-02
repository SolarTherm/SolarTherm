within SolarTherm.Models.Control;
model HotControl
  extends Icons.Control;
  parameter SI.MassFlowRate m_flow_on=1400 "Constant mass flow rate on";
  parameter SI.MassFlowRate m_flow_off=0 "Constant mass flow rate off";
  parameter Real L_on=90 "Level of start discharge";
  parameter Real L_off=10 "Level of stop discharge";

  parameter Real L_df_on=99 "Level of start defocus";
  parameter Real L_df_off=96 "Level of stop defocus";

  Level2Logic logic(
    level_max=L_on,
    level_min=L_off,
    y(start=false))
    annotation (Placement(transformation(extent={{-46,-10},{-22,10}})));
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
  StartUpLogic3 startUpLogic(y_des=m_flow_on, y_start=m_flow_on/2)
    annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
equation
  connect(logic.level_ref, L_mea) annotation (Line(points={{-46,0},{-68,0},{-108,
          0}},               color={0,0,127}));
  connect(logic1.level_ref, L_mea) annotation (Line(points={{-46,-48},{-70,-48},
          {-70,0},{-108,0}}, color={0,0,127}));
  connect(logic1.y, defocus) annotation (Line(points={{-21.04,-48},{-6,-48},{0,-48},
          {0,-112}}, color={255,0,255}));
  connect(logic.y, startUpLogic.u)
    annotation (Line(points={{-21.04,0},{-4.8,0}}, color={255,0,255}));
  connect(startUpLogic.y, m_flow)
    annotation (Line(points={{17,0},{112,0}}, color={0,0,127}));
end HotControl;
