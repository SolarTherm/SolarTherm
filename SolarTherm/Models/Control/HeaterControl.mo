within SolarTherm.Models.Control;
model HeaterControl
	extends Icons.Control;

	// Operation parameters
	parameter SI.Temperature T_heater_set=from_degC(565) "Heater setpoint of temperature";
	parameter SI.MassFlowRate m_flow_max=1400 "Maximum discharge mass flow rate";
	parameter SI.MassFlowRate m_flow_min=0 "Mass flow rate when control off";

	// Level thresholds
	parameter Real level_on = 30 "Level of start discharge";
	parameter Real level_off = 10 "Level of stop discharge";
	parameter Real level_curtailment_on=99 "Level of start curtailment";
	parameter Real level_curtailment_off=96 "Level of stop curtailment";

	// PI controller parameters
	parameter Real y_start=300 "Initial value of output";
	parameter Real Ti=1 "Integer constant";
	parameter Real Kp=-10 "Proportional constant";

	// Connectors
	Modelica.Blocks.Logical.Switch switch "PI controller on/off switch"
		annotation (Placement(transformation(extent={{54,-6},{66,6}})));

	Modelica.Blocks.Sources.RealExpression m_flow_heater_off(y=m_flow_min) "Mass flow rate when heater is off" 
		annotation(Placement(transformation(extent={{6,-34},{32,-10}})));

	Modelica.Blocks.Math.Feedback feedback annotation(
		Placement(transformation(extent={{-28,38}, {-8,18}})));

	SolarTherm.Models.Control.PID_AW_reset3 PI(
		Tt = 1,
		uMax=m_flow_max,
		uMin=m_flow_min,
		initType=Modelica.Blocks.Types.InitPID.InitialOutput,
		y_start=y_start,
		Ti=Ti,
		Kp=Kp) "PI Controller to adjust heater mass flow rate to meet the temperature set point"
		annotation(Placement(transformation(extent={{14,18}, {34,38}})));

	Modelica.Blocks.Sources.RealExpression T_heater_set_connector(y=T_heater_set) "Real connector to feedback"
		annotation(Placement(transformation(extent={{-62,18},{-42,38}})));

	Modelica.Blocks.Interfaces.RealInput tank_level "Level of the tank connected to the heater"
		annotation(Placement(transformation(extent={{-128,-20},{-88,20}})));

	Modelica.Blocks.Interfaces.RealOutput m_flow_heater "Mass flow rate pumped to the heater"
		annotation(Placement(transformation(extent={{94,-18},{130,18}})));

	Modelica.Blocks.Interfaces.BooleanInput on_input_signal "On/off signal from heater power supply"
		annotation(Placement(transformation(extent={{-130,-80},{-90,-40}})));

	Modelica.Blocks.Interfaces.RealInput T_heater_measured "Fluid temperature at the heater outlet"
		annotation(Placement(transformation(extent={{-130,40},{-90,80}})));

	SolarTherm.Models.Control.Level2Logic tank_discharge_logic(
		level_max=level_on, 
		level_min=level_off) "Algorithm to start/stop discharge of tank based on tank level"
		annotation(Placement(transformation(extent={{-74,-10},{-54,10}})));

	Modelica.Blocks.Logical.And and1 annotation(
		Placement(transformation(extent={{-34,-22},{-14,-2}})));

	SolarTherm.Models.Control.Level2Logic curtailment_logic(
		y(start=false),
		level_max=level_curtailment_off,
		level_min=level_curtailment_on) "Algorithm to curtail the heater power supply"
		annotation (Placement(transformation(extent={{-12,-10},{12,10}}, rotation=-90, origin={0,-48})));

	Modelica.Blocks.Logical.Not not1 annotation(
		Placement(transformation(extent={{-6,-6},{6,6}}, rotation=-90, origin={0,-74})));

	Modelica.Blocks.Interfaces.BooleanOutput curtailment annotation(
		Placement(transformation(extent={{-20,-20},{20,20}}, rotation=-90, origin={0,-114})));

equation
	//Connections
	connect(m_flow_heater_off.y, switch.u3) annotation(
	Line(points={{33.3,-22},{44,-22},{44,-4.8},{52.8,-4.8}}, color={0,0,127}));
	connect(PI.u,feedback. y) annotation(
	Line(points={{12,28},{12,28},{-9,28}}, color = {0, 0, 127}));
	connect(T_heater_set_connector.y, feedback.u1) annotation(
	Line(points={{-41,28},{-28,28},{-26,28}}, color={0,0,127}));
	connect(PI.y, switch.u1) annotation(
	Line(points={{35,28},{46,28},{46,16},{46,4.8},{52.8,4.8}},color={0,0,127}));
	connect(T_heater_measured, feedback.u2) annotation(
	Line(points={{-110,60},{-18,60},{-18,36}}, color={0,0,127}));
	connect(PI.reset, switch.u2) annotation(
	Line(points={{12,20},{0,20},{0,0},{52.8,0}}, color={255,0,255}));
	connect(tank_level, tank_discharge_logic.level_ref) annotation(
	Line(points={{-108,0},{-74,0}}, color={0,0,127}));
	connect(tank_discharge_logic.y, and1.u1) annotation (
	Line(points={{-53.2,0},{-44,0},{-44,-12},{-36,-12}}, color={255,0,255}));
	connect(and1.y, switch.u2) annotation (
	Line(points={{-13,-12},{-6,-12},{-6,0},{52.8,0}}, color={255,0,255}));
	connect(and1.u2, on_input_signal) annotation (
	Line(points={{-36,-20},{-64,-20},{-64,-60},{-110,-60}}, color={255,0,255}));
	connect(switch.y, m_flow_heater) annotation (
	Line(points={{66.6,0},{112,0},{112,0}}, color={0,0,127}));
	connect(curtailment_logic.level_ref, tank_discharge_logic.level_ref) annotation (
	Line(points={{0,-36},{0,-30},{-80,-30},{-80,0},{-74,0}}, color={0,0,127}));
	connect(not1.u, curtailment_logic.y) annotation (
	Line(points={{1.33227e-015,-66.8},{1.33227e-015,-64},{0,-64},{0,-60.96}}, color={255,0,255}));
	connect(not1.y, curtailment)

annotation (Line(points={{0,-80.6},{0,-114}}, color={255,0,255}));

annotation (Documentation(info="<html>
<p>
<b>HeaterControl</b> models a heater control system for maintaining a specific temperature at the heater's outlet. It adjusts the mass flow rate of the pump connected to the heater based on tank levels and temperature setpoints. The model includes a PI controller to regulate the heater's mass flow rate to achieve the desired outlet temperature. The model can turn on/off the PI by using a switch that sets the mass flow rate to a user-specified minimum.
</p>
<p>
The model features the following connectors:
</p>
<ul>
  <li>A <b>RealInput</b> connector for the measured ambient temperature (in K).</li>
  <li>A <b>RealInput</b> connector for the fluid temperature at the heater outlet (in K).</li>
  <li>A <b>RealOutput</b> connector for the mass flow rate pumped to the heater (in kg/s).</li>
  <li>A <b>BooleanInput</b> connector for the on/off signal from the heater power supply.</li>
  <li>A <b>RealInput</b> connector for the scheduled discharge mass flow rate (in kg/s).</li>
  <li>A <b>RealInput</b> connector for the mass flow rate of the pump charging the tank (in kg/s).</li>
  <li>A <b>RealInput</b> connector for the instantaneous tank level (in meters).</li>
</ul>
<p>
The model includes the following parameters:
</p>
<ul>
  <li> <b>T_heater_set</b>: Setpoint of temperature (in K). Default: 565 Celsius.</li>
  <li> <b>m_flow_max</b>: Maximum discharge mass flow rate (in kg/s). Default: 1400 kg/s.</li>
  <li> <b>m_flow_min</b>: Mass flow rate when control is off (in kg/s). Default: 0 kg/s.</li>
  <li> <b>level_on</b>: Level of start discharge (in meters). Default: 30 %.</li>
  <li> <b>level_off</b>: Level of stop discharge (in meters). Default: 10 %.</li>
  <li> <b>level_curtailment_on</b>: Level of start curtailment (in meters). Default: 99 %.</li>
  <li> <b>level_curtailment_off</b>: Level of stop curtailment (in meters). Default: 96 %.</li>
  <li> <b>y_start</b>: Initial value of output for the PI controller (in kg/s). Default: 300 kg/s.</li>
  <li> <b>Ti</b>: Integer constant for the PI controller. Default: 1 s.</li>
  <li> <b>Kp</b>: Proportional constant for the PI controller. Default: -10 Hz.</li>
</ul>
<p>
The model is equipped with a PI controller, logic blocks for discharge and curtailment control, and feedback mechanisms to adjust the heater's operation.
</p>
</html>",
revisions="<html>
<ul>
  <li><i>September 2023</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
  Created documentation for HeaterControl.</li>
</ul>
</html>"),
Icon(graphics = {Text(origin = {-10, 254},lineColor={0,0,255},extent={{-149,-114},{151,-154}}, textString = "%name")}));
end HeaterControl;
