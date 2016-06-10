within SolarTherm.Models.Control;
model HotPumpControl
  extends Icons.Control;
  parameter SI.MassFlowRate m_flow_on=1400 "Constant mass flow rate on";
  parameter SI.MassFlowRate m_flow_off=0 "Constant mass flow rate off";
  parameter Real L_on=90 "Level of start discharge";
  parameter Real L_off=10 "Level of stop discharge";

  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(transformation(extent={{16,-10},{26,0}})));
  Modelica.Blocks.Sources.RealExpression m_flow_on_input(y=m_flow_on)
    annotation (Placement(transformation(extent={{-18,2},{6,16}})));
  Modelica.Blocks.Sources.RealExpression m_flow_off_input(y=m_flow_off)
    annotation (Placement(transformation(extent={{-18,-24},{6,-12}})));
  Level2Logic logic(
    level_max=L_on,
    level_min=L_off,
    y(start=false))
    annotation (Placement(transformation(extent={{-46,-10},{-22,10}})));
  Modelica.Blocks.Interfaces.RealInput L_mea
    annotation (Placement(transformation(extent={{-128,-20},{-88,20}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow
    annotation (Placement(transformation(extent={{92,-20},{132,20}})));
equation
  connect(m_flow_on_input.y, switch.u1) annotation (Line(points={{7.2,9},{10,9},
          {10,-1},{15,-1}}, color={0,0,127}));
  connect(m_flow_off_input.y, switch.u3) annotation (Line(points={{7.2,-18},{8,-18},
          {8,-9},{15,-9}}, color={0,0,127}));
  connect(logic.y, switch.u2) annotation (Line(points={{-21.04,0},{-2,0},{-2,-5},
          {15,-5}}, color={255,0,255}));
  connect(logic.level_ref, L_mea) annotation (Line(points={{-46,0},{-68,0},{-68,
          0},{-108,0}},      color={0,0,127}));
  connect(switch.y, m_flow) annotation (Line(points={{26.5,-5},{61.25,-5},{61.25,
          0},{112,0}}, color={0,0,127}));
end HotPumpControl;
