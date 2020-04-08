within SolarTherm.Models.PowerBlocks.sCO2_cycle;
model TestTCC
	extends Modelica.Icons.Example;
	import SolarTherm.{Models,Media};
	import Modelica.SIunits.Conversions.from_degC;
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import Modelica.SIunits.Conversions.*;
	import Modelica.Math;
	import Modelica.Blocks;

	replaceable package Medium = SolarTherm.Media.CarbonDioxide;

	parameter SI.MassFlowRate m_flow_blk = 1000 "Receiver inlet mass flow rate, in kg/s";
	parameter SI.Temperature T_hot_set = from_degC(715) "Turbine inlet temperature at design";
	parameter SI.Temperature T_cold_set = from_degC(45) "Turbine outlet temperature at design";
	parameter SI.Pressure p_hot_set = 24e6 "Turbine inlet pressure at design";
	parameter SI.Pressure p_cold_set = 8e6 "Turbine outlet pressure at design";
	parameter String fluid = "R744";

	Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_hot_set, nPorts = 1, p = p_hot_set, use_T = true, use_p = true) annotation(
		Placement(visible = true, transformation(origin = {40, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	SolarTherm.Models.PowerBlocks.sCO2_cycle.Turbine turbine(T_in_des = T_hot_set, m_flow_des = m_flow_blk) annotation(
		Placement(visible = true, transformation(origin = {40, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

	SolarTherm.Models.PowerBlocks.sCO2_cycle.Cooler cooler(m_flow_des = m_flow_blk, T_out_des = T_cold_set) annotation(
		Placement(visible = true, transformation(origin = {0, -16}, extent = {{20, 20}, {-20, -20}}, rotation = 0)));

	SolarTherm.Models.PowerBlocks.sCO2_cycle.Compressor Compresor(T_in_des = T_cold_set, m_flow_des = m_flow_blk) annotation(
		Placement(visible = true, transformation(origin = {-36, 36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

	Modelica.Fluid.Sources.MassFlowSource_T sink(redeclare package Medium = Medium, T = 293.15, m_flow = -0.1, nPorts = 1, use_m_flow_in = true) annotation(
		Placement(visible = true, transformation(origin = {-40, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Sources.Step step(height = 0*m_flow_blk, offset = m_flow_blk, startTime = 2e4) annotation(
		Placement(visible = true, transformation(origin = {-90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
	connect(source.ports[1],turbine.port_a) annotation(
		Line(points = {{30, 70}, {20,70}, {20, 60}, {20, 40}, {27, 40}}, color = {0, 127, 255}));

	connect(turbine.port_b, cooler.port_a) annotation(
		Line(points = {{52, 28}, {52, -8}, {12, -8}}, color = {0, 127, 255}));

	connect(cooler.port_b, Compresor.port_a) annotation(
		Line(points = {{-12, -8}, {-48, -8}, {-48, 28}}, color = {0, 127, 255}));

	connect(Compresor.port_b, sink.ports[1]) annotation(
		Line(points = {{-24, 40}, {-20, 40}, {-20, 70}, {-30, 70}}, color = {0, 127, 255}));

	connect(step.y, sink.m_flow_in) annotation(
		Line(points = {{-80, 70}, {-60, 70}, {-60, 78}, {-51, 78}}, color = {0, 0, 127}));

	annotation(
		Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1)),
		Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
		experiment(StopTime = 43200, StartTime = 0, Tolerance = 0.0001, Interval = 300),
		__Dymola_experimentSetupOutput,
		Documentation(info = "<html>
	<p>
		<b>TestTurbine</b> models the CO2 turbine.
	</p>
	</html>", revisions = "<html>
	<ul>		
		<li><i>Mar 2020</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
		First release.</li>
	</ul>
	</html>"),
		__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
		uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")));
end TestTCC;
