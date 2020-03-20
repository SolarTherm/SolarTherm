model TestSCO2PB
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math;
  import Modelica.Blocks;
  replaceable package Medium = CarbonDioxide_ph;
  parameter Real par_fr = 0.099099099 "Parasitics fraction of power block rating at design point";
  parameter SI.Power P_name = 100e6 "Nameplate rating of power block";
  parameter SI.Power P_gross = P_name / (1 - par_fr) "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk = 0.502 "Power block efficiency at design point";
  parameter SI.HeatFlowRate Q_flow_des = P_gross / eff_blk "Incident heat flux on receiver surface, in W";
  parameter SI.MassFlowRate m_flow_blk = Q_flow_des / (h_hot_set - h_cold_set) "Receiver inlet mass flow rate, in kg/s";
  parameter SI.Temperature T_hot_set = from_degC(735) "Turbine inlet temperature at design";
  parameter SI.Temperature T_cold_set = from_degC(500) "Turbine outlet temperature at design";
  parameter SI.Pressure p_hot_set = 24e6 "Turbine inlet pressure at design";
  parameter SI.Pressure p_cold_set = 8e6 "Turbine outlet pressure at design";
  parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(p_hot_set, T_hot_set);
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(p_cold_set, T_cold_set);
  parameter String fluid = "R744";
  parameter SI.SpecificEnthalpy h_hot_set = state_hot_set.h "HTF inlet specific enthalpy to power block at design";
  parameter SI.SpecificEnthalpy h_cold_set = state_cold_set.h "HTF outlet specific enthalpy to power block at design";
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_cold_set, h = h_hot_set, nPorts = 1, p = p_hot_set, use_T = false, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {58, 28}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Medium, T = T_cold_set, h = h_cold_set, nPorts = 1, p = p_cold_set, use_T = false, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {52, -6}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  //	Modelica.Blocks.Sources.RealExpression m_flow_in(y = m_flow_blk) annotation(
  //		Placement(visible = true, transformation(origin = {-80, 62}, extent = {{0, 10}, {40, -10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pump(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {20, 28}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Turbine Turbina annotation(
    Placement(visible = true, transformation(origin = {-26, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0.2 * m_flow_blk, offset = m_flow_blk, startTime = 2e4) annotation(
    Placement(visible = true, transformation(origin = {-20, 62}, extent = {{0, -10}, {20, 10}}, rotation = 0)));
equation
//	connect(m_flow_in.y, pump.m_flow) annotation(
//		Line(points = {{35, 62}, {20, 62}, {20, 37}}, color = {0, 127, 255}));
  connect(step.y, pump.m_flow) annotation(
    Line(points = {{0, 62}, {20, 62}, {20, 37}}, color = {0, 127, 255}));
  connect(pump.fluid_a, source.ports[1]) annotation(
    Line(points = {{20, 28}, {48, 28}}, color = {0, 127, 255}));
  connect(pump.fluid_b, Turbina.port_a) annotation(
    Line(points = {{10, 28}, {-38, 28}, {-38, 14}, {-38, 14}}, color = {0, 127, 255}));
  connect(Turbina.port_b, sink.ports[1]) annotation(
    Line(points = {{-14, 2}, {42, 2}, {42, -6}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 43200, StartTime = 0, Tolerance = 0.0001, Interval = 300),
    __Dymola_experimentSetupOutput,
    Documentation(info = "<html>
	<p>
		<b>TestSCO2PB</b> models the CO2 turbine.
	</p>
	</html>", revisions = "<html>
	<ul>		
		<li><i>Mar 2020</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
		First release.</li>
	</ul>
	</html>"),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")));
end TestSCO2PB;