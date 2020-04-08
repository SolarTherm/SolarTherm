within SolarTherm.Models.PowerBlocks.sCO2_cycle;
model TestTurbine
	import SolarTherm.{Models,Media};
	import Modelica.SIunits.Conversions.from_degC;
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import Modelica.SIunits.Conversions.*;
	import Modelica.Math;
	import Modelica.Blocks;
	replaceable package Medium = SolarTherm.Media.CarbonDioxide;
	extends Modelica.Icons.Example;
	
	parameter SI.MassFlowRate m_flow_blk = 1000 "Receiver inlet mass flow rate, in kg/s";

	parameter SI.Temperature T_hot_set = from_degC(735) "Turbine inlet temperature at design";
	parameter SI.Temperature T_cold_set = from_degC(500) "Turbine outlet temperature at design";

	parameter SI.Pressure p_hot_set = 24e6 "Turbine inlet pressure at design";
	parameter SI.Pressure p_cold_set = 8e6 "Turbine outlet pressure at design";

	parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(p_hot_set,T_hot_set);
	parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(p_cold_set,T_cold_set);

	parameter String fluid = "R744";

	parameter SI.SpecificEnthalpy h_hot_set = state_hot_set.h "HTF inlet specific enthalpy to power block at design";
	parameter SI.SpecificEnthalpy h_cold_set = state_cold_set.h "HTF outlet specific enthalpy to power block at design";

	Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, h = h_hot_set, nPorts = 1, p = p_hot_set, use_T = false, use_p = true)
		annotation(Placement(visible = true, transformation(origin = {-86, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Sources.MassFlowSource_T sink(redeclare package Medium = Medium, T = 293.15, m_flow = -0.1, nPorts = 1, use_m_flow_in = true)
		annotation(Placement(visible = true, transformation(origin = {24, 2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
	SolarTherm.Models.PowerBlocks.sCO2_cycle.Turbine turbine annotation(
		Placement(visible = true, transformation(origin = {-26, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
	Modelica.Blocks.Sources.Step step(height = 0.2 * m_flow_blk, offset = m_flow_blk, startTime = 2e4)
		annotation(Placement(visible = true, transformation(origin = {82, 10}, extent = {{20, -10}, {0, 10}}, rotation = 0)));

equation
	connect(sink.m_flow_in, step.y) annotation(
		Line(points = {{34, 10}, {81, 10}}, color = {0, 0, 127}));
	connect(sink.ports[1], turbine.port_b) annotation(
		Line(points = {{14, 2}, {-14, 2}, {-14, 2}, {-14, 2}}, color = {0, 127, 255}));
	connect(turbine.port_a, source.ports[1]) annotation(
		Line(points = {{-38, 14}, {-76, 14}}, color = {0, 127, 255}));

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
end TestTurbine;
