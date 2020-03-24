model TestSCO2PB
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math;
  import Modelica.Blocks;
  import stprops = SolarTherm.Media.CO2.CO2_utilities.stprops;
  replaceable package Medium = SolarTherm.Media.CarbonDioxide_ph;
  parameter Real par_fr = 0.099099099 "Parasitics fraction of power block rating at design point";
  parameter SI.Power P_name = 100e6 "Nameplate rating of power block";
  parameter SI.Power P_gross = P_name / (1 - par_fr) "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk = 0.502 "Power block efficiency at design point";
  parameter SI.HeatFlowRate Q_flow_des = P_gross / eff_blk "Incident heat flux on receiver surface, in W";
  parameter SI.MassFlowRate m_flow_blk = Q_flow_des / (h_hot_set - h_cold_set) "Receiver inlet mass flow rate, in kg/s";
  parameter SI.Temperature T_hot_set = from_degC(735) "Turbine inlet temperature at design";
  parameter SI.Temperature T_cold_set = from_degC(45) "Turbine outlet temperature at design";
  parameter SI.Pressure p_hot_set = 24e6 "Turbine inlet pressure at design";
  parameter SI.Pressure p_cold_set = 8e6 "Turbine outlet pressure at design";
  parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(p_hot_set, T_hot_set);
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(p_cold_set, T_cold_set);
  parameter String fluid = "R744";
  parameter SI.SpecificEnthalpy h_hot_set = state_hot_set.h "HTF inlet specific enthalpy to power block at design";
  parameter SI.SpecificEnthalpy h_cold_set = state_cold_set.h "HTF outlet specific enthalpy to power block at design";
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_cold_set, h = stprops("H", "P", p_cold_set, "T", T_cold_set, fluid), nPorts = 1, p = p_cold_set, use_T = false, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {58, 28}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Medium, T = T_hot_set, h = h_hot_set, nPorts = 1, p = p_hot_set, use_T = false, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {52, -6}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  //	Modelica.Blocks.Sources.RealExpression m_flow_in(y = m_flow_blk) annotation(
  //		Placement(visible = true, transformation(origin = {-80, 62}, extent = {{0, 10}, {40, -10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pump(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {20, 28}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Compressor compressor(p_in_des = p_cold_set, p_out_des = p_hot_set) annotation(
    Placement(visible = true, transformation(origin = {-29, -31}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression mdot(y = 1000) annotation(
    Placement(visible = true, transformation(origin = {-46, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//	connect(m_flow_in.y, pump.m_flow) annotation(
//		Line(points = {{35, 62}, {20, 62}, {20, 37}}, color = {0, 127, 255}));
  connect(pump.fluid_a, source.ports[1]) annotation(
    Line(points = {{20, 28}, {48, 28}}, color = {0, 127, 255}));
  connect(pump.fluid_b, compressor.port_a) annotation(
    Line(points = {{10, 28}, {-43, 28}, {-43, -26}}, color = {0, 127, 255}));
  connect(compressor.port_b, sink.ports[1]) annotation(
    Line(points = {{-15, -40}, {12.5, -40}, {12.5, -6}, {42, -6}}, color = {0, 127, 255}));
  connect(mdot.y, pump.m_flow) annotation(
    Line(points = {{-34, 62}, {20, 62}, {20, 36}, {20, 36}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 1, StartTime = 0, Tolerance = 0.0001, Interval = 1),
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