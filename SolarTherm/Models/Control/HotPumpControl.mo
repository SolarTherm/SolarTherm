within SolarTherm.Models.Control;
model HotPumpControl
  extends SolarTherm.Icons.Control;
  parameter Modelica.SIunits.MassFlowRate m_flow_on=1400
    "Constant mass flow rate on";
  parameter Modelica.SIunits.MassFlowRate m_flow_off=0
    "Constant mass flow rate off";
  parameter Real L_on=90 "Level of start discharge";
  parameter Real L_off=10 "Level of stop discharge";

  parameter Real L_df_on=99 "Level of start defocus";
  parameter Real L_df_off=96 "Level of stop defocus";
  parameter SI.SpecificEnergy k_loss = 0.55e3 "Hot tank parasitic power coefficient";
  SI.Power W_loss;

  Modelica.Blocks.Interfaces.RealInput L_mea
    annotation (Placement(visible = true, transformation(extent = {{-128, -80}, {-88, -40}}, rotation = 0), iconTransformation(extent = {{-128, -100}, {-88, -60}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow
    annotation (Placement(transformation(extent={{92,-20},{132,20}})));
  SolarTherm.Models.Control.Level2Logic defocus_logic(
    y(start=false),
    level_max=L_df_on,
    level_min=L_df_off) annotation (Placement(visible = true, transformation(origin = {-3.55271e-15, -51}, extent = {{-17, -10}, {17, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanOutput defocus annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-114})));
  Modelica.Blocks.Interfaces.RealInput m_flow_in annotation (Placement(
        visible = true, transformation(origin = {-108, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-128, 60}, {-88, 100}}, rotation = 0)));
  SolarTherm.Models.Control.ScheduleLogic logic(
    
    level_off=L_off,
    level_on=L_on,m_flow_max=m_flow_on,
    m_flow_standby=0,
    m_flow_startup=0)
    annotation (Placement(visible = true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput m_flow_sch annotation(
    Placement(visible = true, transformation(origin = {-108, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-128, -20}, {-88, 20}}, rotation = 0)));
equation
  W_loss = (abs(m_flow_in - m_flow) + m_flow)*k_loss;
  connect(defocus_logic.level_ref, L_mea) annotation(
    Line(points = {{-4.44089e-16, -34}, {0, -34}, {0, -20}, {-38, -20}, {-38, -60}, {-108, -60}}, color = {0, 0, 127}));
  connect(defocus_logic.y, defocus) annotation(
    Line(points = {{-2.22045e-15, -69.36}, {-2.22045e-15, -69.36}, {-2.22045e-15, -82}, {0, -82}, {0, -114}}, color = {255, 0, 255}));
  connect(logic.m_flow, m_flow) annotation(
    Line(points = {{11, 0}, {112, 0}}, color = {0, 0, 127}));
  connect(L_mea, logic.level) annotation(
    Line(points = {{-108, -60}, {-38, -60}, {-38, -8}, {-10, -8}}, color = {0, 0, 127}));
  connect(m_flow_in, logic.m_flow_in) annotation(
    Line(points = {{-108, 0}, {-10, 0}}, color = {0, 0, 127}));
  connect(m_flow_sch, logic.m_flow_sch) annotation(
    Line(points = {{-108, 60}, {-56, 60}, {-56, 8}, {-10, 8}}, color = {0, 0, 127}));
  annotation (Documentation(revisions = "<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"),
    Icon(graphics = {Text(origin = {-10, 254},lineColor={0,0,255},extent={{-149,-114},{151,-154}}, textString = "%name")}));
end HotPumpControl;