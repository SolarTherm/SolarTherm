model TestSCO2PB
	import SolarTherm.{Models,Media};
	import Modelica.SIunits.Conversions.from_degC;
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import Modelica.SIunits.Conversions.*;
	import FI = SolarTherm.Models.Analysis.Finances;
	import Modelica.Math;
	import Modelica.Blocks;
	replaceable package Medium = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
	extends SolarTherm.Media.CO2.PropCO2;

	
	parameter SI.Power P_name = 100e6 "Nameplate rating of power block";
	parameter SI.Power P_gross = P_name/(1 - par_fr) "Power block gross rating at design point";
	parameter Real par_fr = 0.099099099 "Parasitics fraction of power block rating at design point";

	parameter SI.HeatFlowRate Q_flow_des = P_gross/eff_blk "Incident heat flux on receiver surface, in W";
	parameter SI.Temperature T_hot_set = from_degC(735) "HTF inlet temperature to power block at design";
	parameter SI.Temperature T_cold_set = from_degC(500) "HTF outlet temperature to power block at design";
	parameter SI.Temperature T_amb = from_degC(25) "Design ambient temperature";
	parameter SI.Temperature T_comp_in = from_degC(45) "Compressor inlet temperature at design";
	parameter SI.Temperature blk_T_amb_des = from_degC(43) "Ambient temperature at design for power block";

	parameter SI.SpecificEnthalpy h_hot_set = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities.h_T(T_hot_set) "HTF inlet specific enthalpy to power block at design";
	parameter SI.SpecificEnthalpy h_cold_set = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities.h_T(T_cold_set) "HTF outlet specific enthalpy to power block at design";

	parameter SI.MassFlowRate m_flow_blk_des = Q_flow_des/(h_hot_set - h_cold_set) "Receiver inlet mass flow rate, in kg/s";
	parameter SI.MassFlowRate m_flow_blk = 1.0*Q_flow_des/(h_hot_set - h_cold_set) "Receiver inlet mass flow rate, in kg/s";

	parameter SI.AbsolutePressure p_rcv = 1e5 "Receiver operating pressure";

	parameter SI.Efficiency eff_blk = 0.502 "Power block efficiency at design point";

	parameter Boolean external_parasities = true "True if there is external parasitic power losses";

	parameter Real nu_min_blk = 0.5 "Minimum allowed part-load mass flow fraction to power block";
	
	Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_cold_set, nPorts = 1, p = p_rcv, use_p = true) 
		annotation(Placement(visible = true, transformation(origin = {58, 28}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Medium, nPorts = 1, p = p_rcv, use_p = true, use_T = true, T = T_cold_set) 
		annotation(Placement(visible = true, transformation(origin = {32, -14}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression Tamb(y = T_amb) 
		annotation(Placement(visible = true, transformation(origin = {-46, 51}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression Parasites(y = 0) 
		annotation(Placement(visible = true, transformation(origin = {-46, 71}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression m_flow_in(y = m_flow_blk)
		annotation(Placement(visible = true, transformation(origin = {70, 62}, extent = {{5, 10}, {-35, -10}}, rotation = 0)));

	SolarTherm.Models.Fluid.Pumps.PumpSimple pump(redeclare package Medium = Medium) 
		annotation(Placement(visible = true, transformation(origin = {20, 28}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.recompPB powerblock(
		redeclare package MedRec = Medium,
		P_gro = P_gross,
		T_HTF_in_des = T_hot_set,
		T_amb_des = blk_T_amb_des,
		T_low = T_comp_in,
		m_HTF_des = m_flow_blk_des,
		external_parasities = external_parasities,
		nu_min = nu_min_blk) 
		annotation(Placement(visible = true, transformation(origin = {-22, 22}, extent = {{18, -18}, {-18, 18}}, rotation = 0)));

	SolarTherm.Models.Analysis.Market market(redeclare model Price = SolarTherm.Models.Analysis.EnergyPrice.Constant)
		annotation (Placement(transformation(origin={-62, 21}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
	connect(Tamb.y, powerblock.T_amb)
		annotation(Line(points = {{-36, 51}, {-25.5, 51}, {-25.5, 34}}, color = {0, 0, 127}));

	connect(Parasites.y, powerblock.parasities)
		annotation(Line(points = {{-36, 71}, {-18.25, 71}, {-18.25, 34}}, color = {0, 0, 127}));

	connect(pump.fluid_b, powerblock.fluid_a)
		annotation(Line(points = {{12, 28}, {-14, 28}}, color = {0, 127, 255}));

	connect(powerblock.fluid_b, sink.ports[1])
		annotation(Line(points = {{-12, 14}, {-2, 14}, {-2, -14}, {22, -14}}, color = {0, 127, 255}));

	connect(m_flow_in.y,pump.m_flow) 
		annotation(Line(points = {{35, 62}, {20, 62}, {20,37}}, color = {0, 127, 255}));

	connect(pump.fluid_a, source.ports[1]) 
		annotation(Line(points = {{20, 28}, {48, 28}}, color = {0, 127, 255}));

	connect(powerblock.W_net, market.W_net)
		annotation(Line(points = {{-52, 21}, {-22, 21}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 43200, StartTime = 0, Tolerance = 0.0001, Interval = 300),
    __Dymola_experimentSetupOutput,
    Documentation(info = "<html>
	<p>
		<b>TestSCO2PB</b> models the component-level interaction of Chloride Salt/CO2 power block.
	</p>
	</html>", revisions = "<html>
	<ul>		
		<li><i>Jan 2020</i> by <a href=\"mailto:armando.fontalvo@anu.edu.au\">Armando Fontalvo</a>:<br>
		Created to test the sCO2 power block model developed by Simon Kamerling at INES (Institut National de l’Énergie Solaire) in France.</li>
	</ul>
	</html>"),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    uses(Modelica(version = "3.2.2")));
end TestSCO2PB;
