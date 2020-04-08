within SolarTherm.Models.PowerBlocks.sCO2_cycle;
model TestHeater
	import SolarTherm.{Models,Media};
	import Modelica.SIunits.Conversions.from_degC;
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import Modelica.SIunits.Conversions.*;
	import Modelica.Math.*;
	import Modelica.Blocks;

	replaceable package MediumHTF = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
	replaceable package MediumPB = SolarTherm.Media.CarbonDioxide;

	extends Modelica.Icons.Example;

	parameter SI.MassFlowRate m_flow_htf_des = m_flow_pc_des * (h_turb_in_des - h_comp_out_des) / (h_htf_in - h_htf_out) "HTF mass flow rate, in kg/s";
	parameter SI.Temperature T_htf_in_des = from_degC(720) "Turbine inlet temperature at design";
	parameter SI.Temperature T_htf_out_des = from_degC(500) "Turbine outlet temperature at design";
	parameter SI.Pressure p_htf = 1e5 "HTF pressure at design";
	parameter SI.SpecificEnthalpy h_htf_in = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_in_des)) "HTF inlet specific enthalpy to power block at design";
	parameter SI.SpecificEnthalpy h_htf_out = MediumHTF.specificEnthalpy(MediumHTF.setState_pTX(p_htf, T_htf_out_des)) "HTF outlet specific enthalpy to power block at design";

	//Power cycle
	parameter SI.Temperature T_turb_in_des = from_degC(715) "Turbine inlet temperature at design";
	parameter SI.Temperature T_comp_in_des = from_degC(45) "Compresor outlet temperature at design";
	parameter SI.Pressure p_turb_in_des = 24e6 "Turbine inlet temperature at design";
	parameter SI.Pressure p_comp_in_des = 8e6 "Compresor outlet temperature at design";
	parameter SI.Efficiency eta_comp = 0.89 "Compresor isentropic efficiency at design";
	parameter SI.Efficiency eta_turb = 0.9 "Turbine isentropic efficiency at design";

	parameter SI.SpecificEnthalpy h_turb_in_des = MediumPB.specificEnthalpy(MediumPB.setState_pTX(p_turb_in_des, T_turb_in_des));
	parameter SI.SpecificEnthalpy h_comp_in_des = MediumPB.specificEnthalpy(MediumPB.setState_pTX(p_comp_in_des, T_comp_in_des)) "Compressor outlet entropy at design";
	parameter SI.SpecificEntropy s_turb_in_des = MediumPB.specificEntropy(MediumPB.setState_pTX(p_turb_in_des, T_turb_in_des)) "Turbine outlet entropy at design";
	parameter SI.SpecificEntropy s_comp_in_des = MediumPB.specificEntropy(MediumPB.setState_pTX(p_comp_in_des, T_comp_in_des)) "Compressor outlet entropy at design";
	parameter SI.SpecificEnthalpy h_turb_out_des_isen = MediumPB.specificEnthalpy(MediumPB.setState_psX(p_comp_in_des, s_turb_in_des)) "Turbine outlet isentropic enthalpy at design";
	parameter SI.SpecificEnthalpy h_comp_out_des_isen = MediumPB.specificEnthalpy(MediumPB.setState_psX(p_turb_in_des, s_comp_in_des)) "Compressor outlet isentropic enthalpy at design";
	parameter SI.SpecificEnthalpy h_comp_out_des = h_comp_in_des + w_comp "Compressor outlet enthalpy at design";
	parameter SI.Temperature T_comp_out_des = MediumPB.temperature(MediumPB.setState_phX(p_turb_in_des, h_comp_out_des)) "Compressor outlet isentropic enthalpy at design";
	parameter SI.SpecificEnthalpy w_comp = (h_comp_out_des_isen - h_comp_in_des) / eta_comp "Compressor spefific power input at design";
	parameter SI.SpecificEnthalpy w_turb = (h_turb_in_des - h_turb_out_des_isen) * eta_turb "Turbine specific power output at design";
	parameter SI.Power W_net = 100e6 "Net power output at design";
	parameter SI.MassFlowRate m_flow_pc_des = W_net / (w_turb - w_comp) "Power cycle mass flow rate at design";
	parameter SI.TemperatureDifference dT_approach = T_htf_in_des - T_turb_in_des "Minimum temperature difference at the heater";
	parameter SI.TemperatureDifference dT_hot = T_htf_in_des - T_turb_in_des "Temperature difference at hot side";
	parameter SI.TemperatureDifference dT_cold = T_htf_out_des - T_comp_out_des "Temperature difference at cold side";
	parameter SI.TemperatureDifference LMTD_des = (dT_hot - dT_cold)/log(dT_hot/dT_cold) "Logarithmic mean temperature difference at design";
	parameter SI.Area A = m_flow_pc_des * (h_turb_in_des - h_comp_out_des)/LMTD_des/U_des "Heat transfer area for heater at design";
	parameter SI.CoefficientOfHeatTransfer U_des = 1000 "Heat tranfer coefficient at design";

	Modelica.Fluid.Sources.FixedBoundary sourceHot(
		redeclare package Medium = MediumHTF,
		T = T_htf_in_des,
		nPorts = 1,
		p = p_htf,
		use_T = true,
		use_p = true)
		annotation(Placement(visible = true, transformation(origin = {60, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	Modelica.Blocks.Sources.Step step(
		height = 0.2 * m_flow_htf_des,
		offset = m_flow_htf_des,
		startTime = 2e4)
		annotation(Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Fluid.Sources.MassFlowSource_h sinkHot(
		redeclare package Medium = MediumHTF,
		m_flow = -0.1, 
		nPorts = 1,
		use_m_flow_in = true)
		annotation(Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	sCO2_cycle.Heater heater(
		U = U_des,
		A = A,
		LMTD_des = LMTD_des, 
		T_a_in_des = T_htf_in_des, 
		T_a_out_des = T_htf_out_des, 
		T_b_in_des = T_comp_out_des, 
		T_b_out_des = T_turb_in_des, 
		dT_approach = dT_approach, 
		m_flow_a_des = m_flow_htf_des)
		annotation(Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

	Modelica.Fluid.Sources.FixedBoundary sourceCold(
		redeclare package Medium = MediumPB,
		T = T_comp_out_des,
		nPorts = 1,
		p = p_turb_in_des,
		use_T = true,
		use_p = true)
		annotation(Placement(visible = true, transformation(origin = {-60, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Fluid.Sources.MassFlowSource_h sinkCold(
		redeclare package Medium = MediumPB,
		m_flow = -0.1, 
		nPorts = 1,
		use_m_flow_in = true)
		annotation(Placement(visible = true, transformation(origin = {60, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	Modelica.Blocks.Sources.RealExpression m_cold(
			y = m_flow_pc_des)
		annotation(Placement(visible = true, transformation(origin = {100, -12.5}, extent = {{30, -10}, {-10, 10}}, rotation = 0)));

equation

	connect(step.y, sinkHot.m_flow_in) annotation(
		Line(points = {{-90, 40}, {-80, 40}, {-80, 27.5}, {-70, 27.5}}, color = {0, 0, 127}));

	connect(sinkHot.ports[1], heater.port_a_out) annotation(
		Line(points = {{-50, 20}, {-32, 20}, {-32, 10}, {-20, 10}, {-20, 10}}, color = {0, 127, 255}));

	connect(heater.port_a_in, sourceHot.ports[1]) annotation(
		Line(points = {{20, 10}, {40, 10}, {40, 20}, {50, 20}}, color = {0, 127, 255}));

	connect(sourceCold.ports[1], heater.port_b_in) annotation(
		Line(points = {{-50, -20}, {-40, -20}, {-40, -10}, {-20, -10}}, color = {0, 127, 255}));

	connect(heater.port_b_out, sinkCold.ports[1]) annotation(
		Line(points = {{20, -10}, {40, -10}, {40, -20}, {50, -20}}, color = {0, 127, 255}));

	connect(m_cold.y, sinkCold.m_flow_in) annotation(
		Line(points = {{70, -12.5}, {90, -12.5}}, color = {0, 127, 255}));

	annotation(
		Diagram(coordinateSystem(extent = {{-120, -60}, {140, 60}}, initialScale = 0.1)),
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
end TestHeater;
