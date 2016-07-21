within SolarTherm.Models.Control;
model HotPumpControl6
  extends Icons.Control;
  parameter SI.HeatFlowRate Q_max = 294.118e6;
  parameter SI.HeatFlowRate Q_min = 294.118e6*0.5;
  parameter SI.MassFlowRate m_flow_max=682.544 "Constant mass flow rate on";
  parameter SI.MassFlowRate m_flow_off=0 "Constant mass flow rate off";

  parameter Real L_on=10 "Level of start discharge";
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
  Level2Logic defocus_logic(
    y(start=false),
    level_max=L_df_on,
    level_min=L_df_off)
    annotation (Placement(transformation(extent={{-46,-58},{-22,-38}})));
  Modelica.Blocks.Interfaces.BooleanOutput defocus annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-112})));
  Modelica.Blocks.Interfaces.RealInput Q_solar annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,106})));
  M_flow_calculator m_flow_calculator(
    Q_max=Q_max,
    Q_min=Q_min,
    m_flow_max=m_flow_max)
    annotation (Placement(transformation(extent={{-30,20},{-4,34}})));
  Level2Logic logic(level_max=Q_max, level_min=Q_min)
    annotation (Placement(transformation(extent={{-74,12},{-60,28}})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{-40,-6},{-28,6}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{34,24},{46,36}})));
  Modelica.Blocks.Sources.RealExpression m_flow_max_input(y=m_flow_max)
    annotation (Placement(transformation(extent={{-14,50},{10,62}})));
  Level2Logic logic1(              level_min=L_off, level_max=L_on)
    annotation (Placement(transformation(extent={{-64,-26},{-50,-10}})));
equation
  connect(m_flow_off_input.y, switch.u3) annotation (Line(points={{53.2,-10},{58,
          -10},{58,-4.8},{64.8,-4.8}},
                           color={0,0,127}));
  connect(switch.y, m_flow) annotation (Line(points={{78.6,0},{78.6,0},{112,0}},
                       color={0,0,127}));
  connect(defocus_logic.level_ref, L_mea) annotation (Line(points={{-46,-48},{-70,
          -48},{-70,0},{-108,0}}, color={0,0,127}));
  connect(defocus_logic.y, defocus) annotation (Line(points={{-21.04,-48},{-6,-48},
          {0,-48},{0,-112}}, color={255,0,255}));
  connect(Q_solar,logic. level_ref) annotation (Line(points={{0,106},{0,106},{0,
          80},{-80,80},{-80,20},{-74,20}},        color={0,0,127}));
  connect(m_flow_calculator.Q_solar,logic. level_ref) annotation (Line(points={
          {-30,27},{-32,27},{-32,28},{-42,28},{-42,80},{-80,80},{-80,20},{-74,
          20}}, color={0,0,127}));
  connect(or1.u1,logic. y) annotation (Line(points={{-41.2,0},{-54,0},{-54,20},
          {-59.44,20}}, color={255,0,255}));
  connect(m_flow_calculator.m_flow, switch1.u3) annotation (Line(points={{-2.96,
          27},{19.52,27},{19.52,25.2},{32.8,25.2}}, color={0,0,127}));
  connect(m_flow_max_input.y, switch1.u1) annotation (Line(points={{11.2,56},{
          12,56},{10,56},{28,56},{28,34.8},{32.8,34.8}},
                                              color={0,0,127}));
  connect(switch1.y, switch.u1) annotation (Line(points={{46.6,30},{52,30},{52,
          8},{52,4.8},{64.8,4.8}}, color={0,0,127}));
  connect(logic1.level_ref, L_mea) annotation (Line(points={{-64,-18},{-70,-18},
          {-70,0},{-108,0}}, color={0,0,127}));
  connect(logic1.y, or1.u2) annotation (Line(points={{-49.44,-18},{-46,-18},{-46,
          -4.8},{-41.2,-4.8}}, color={255,0,255}));
  connect(switch1.u2, or1.u2) annotation (Line(points={{32.8,30},{10,30},{10,
          -18},{-46,-18},{-46,-4.8},{-41.2,-4.8}}, color={255,0,255}));
  connect(or1.y, switch.u2)
    annotation (Line(points={{-27.4,0},{64.8,0},{64.8,0}}, color={255,0,255}));
end HotPumpControl6;
