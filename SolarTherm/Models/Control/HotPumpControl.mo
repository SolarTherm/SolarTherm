within SolarTherm.Models.Control;
model HotPumpControl
	extends SolarTherm.Icons.Control;
	parameter Modelica.SIunits.MassFlowRate m_flow_on=1400 "Constant mass flow rate on";
	parameter Modelica.SIunits.MassFlowRate m_flow_off=0 "Constant mass flow rate off";
	parameter Real level_on=10 "Level of start discharge";
	parameter Real level_off=5 "Level of stop discharge";
	
	parameter Real level_curtailment_on=99 "Level of start curtailment";
	parameter Real level_curtailment_off=96 "Level of stop curtailment";
	parameter SI.SpecificEnergy k_loss = 0.55e3 "Hot tank parasitic power coefficient";

	Modelica.Blocks.Interfaces.RealInput m_flow_schedule "Scheduled discharge mass flow rate" annotation(
		Placement(visible = true, transformation(origin = {-108, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), 
		iconTransformation(extent = {{-128, -20}, {-88, 20}}, rotation = 0)));

	Modelica.Blocks.Interfaces.RealInput m_flow_pump_charging "Mass flow rate of pump charging the tank" annotation (
		Placement(visible = true, transformation(origin = {-108, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), 
		iconTransformation(extent = {{-128, 60}, {-88, 100}}, rotation = 0)));

	Modelica.Blocks.Interfaces.RealInput tank_level "Instantaneous tank level" annotation (
		Placement(visible = true, transformation(extent = {{-128, -80}, {-88, -40}}, rotation = 0),
		iconTransformation(extent = {{-128, -100}, {-88, -60}}, rotation = 0)));

	SolarTherm.Models.Control.Level2Logic curtailment_logic(
		y(start=false),
		level_max=level_curtailment_on,
		level_min=level_curtailment_off) "Algorithm to activate/deactivate curtailment" 
		annotation (Placement(visible = true, transformation(origin = {-3.55271e-15, -51}, extent = {{-17, -10}, {17, 10}}, rotation = -90)));

	SolarTherm.Models.Control.ScheduleLogic logic(
		level_off=level_off,
		level_on=level_on,
		m_flow_max=m_flow_on,
		m_flow_standby=0,
		m_flow_startup=0) "Algorithm to calculate the dischargin mass flow rate"
		annotation (	Placement(visible = true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Interfaces.BooleanOutput curtailment "Curtailment signal to power input" annotation (
		Placement(transformation(extent={{20,-20},{-20,20}},rotation=90,origin={0,-114})));

	Modelica.Blocks.Interfaces.RealOutput m_flow_pump_discharging "Mass flow rate of pump discharging the tank" annotation (
		Placement(transformation(extent={{92,-20},{132,20}})));

	SI.Power W_loss "Pumping parasitic power due to discharge";

equation
	W_loss = (abs(m_flow_pump_charging - m_flow_pump_discharging) + m_flow_pump_discharging)*k_loss;

	connect(curtailment_logic.level_ref, tank_level) annotation(
		Line(points = {{-4.44089e-16, -34}, {0, -34}, {0, -20}, {-38, -20}, {-38, -60}, {-108, -60}}, color = {0, 0, 127}));
	connect(curtailment_logic.y, curtailment) annotation(
		Line(points = {{-2.22045e-15, -69.36}, {-2.22045e-15, -69.36}, {-2.22045e-15, -82}, {0, -82}, {0, -114}}, color = {255, 0, 255}));
	connect(logic.m_flow, m_flow_pump_discharging) annotation(
		Line(points = {{11, 0}, {112, 0}}, color = {0, 0, 127}));
	connect(tank_level, logic.level) annotation(
		Line(points = {{-108, -60}, {-38, -60}, {-38, -8}, {-10, -8}}, color = {0, 0, 127}));
	connect(m_flow_pump_charging, logic.m_flow_in) annotation(
		Line(points = {{-108, 0}, {-10, 0}}, color = {0, 0, 127}));
	connect(m_flow_schedule, logic.m_flow_sch) annotation(
		Line(points = {{-108, 60}, {-56, 60}, {-56, 8}, {-10, 8}}, color = {0, 0, 127}));

annotation (Documentation(revisions = "<html>
<ul>
<li>A. Fontalvo:<br>Released first version. </li>
</ul>
</html>"),
	Icon(graphics = {Text(origin = {-10, 254},lineColor={0,0,255},extent={{-149,-114},{151,-154}}, textString = "%name")}));
end HotPumpControl;