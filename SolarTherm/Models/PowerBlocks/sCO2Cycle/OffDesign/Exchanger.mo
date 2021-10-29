within SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign;
	model Exchanger
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		replaceable package MedRec = SolarTherm.Media.Sodium.ConstSodium;
		parameter Modelica.SIunits.MassFlowRate m_des_CO2 = 1.56;
		parameter Modelica.SIunits.MassFlowRate m_des_HTF = 1.56;
		parameter SolarTherm.Types.Conductance UA_HTR = 30000 "on-design conductance of the exchanger";
		parameter Modelica.SIunits.SpecificEnthalpy h_HTF_design = 272193;
		Modelica.Fluid.Interfaces.FluidPort_a HTF_port_a(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {60, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_a CO2_port_a(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {-60, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b HTF_port_b(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b CO2_port_b(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {58, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		MedPB.ThermodynamicState[2] state_CO2;
		MedRec.ThermodynamicState[2] state_HTF;
		Modelica.SIunits.SpecificEnthalpy[2] h_CO2(start = {990000, 1100000});
		Modelica.SIunits.SpecificEnthalpy[2] h_HTF;
		Real[2] deltaT "Temperature difference in the heat exchangers";
		Modelica.SIunits.HeatFlowRate Q_HX_HTR;
		Modelica.SIunits.ThermodynamicTemperature T_CO2_out;
		Modelica.SIunits.ThermodynamicTemperature T_HTF_out;
		input Boolean m_sup;
		//Real deltaT_lm;
		Real deltaTAve;
		Modelica.SIunits.MassFlowRate m_HTF_bis;
	equation
		for i in 1:2 loop
			deltaT[i] = if m_sup then MedRec.temperature(state_HTF[i]) - MedPB.temperature(state_CO2[i]) else 80 + i;
			state_CO2[i] = MedPB.setState_phX(CO2_port_a.p, h_CO2[i]);
			state_HTF[i] = MedRec.setState_phX(HTF_port_a.p, h_HTF[i]);
		end for;
		T_CO2_out = MedPB.temperature(state_CO2[2]);
		T_HTF_out = MedRec.temperature(state_HTF[1]);
		//deltaT_lm = if deltaT[2] * deltaT[1] < 0 then (abs(deltaT[1]) ^ (1 / 3) * sign(deltaT[1]) / 2 + abs(deltaT[2]) ^ (1 / 3) * sign(deltaT[2]) / 2) ^ 3 else (deltaT[1] - deltaT[2]) / (Modelica.Math.log(deltaT[1] / deltaT[2]) + 0.0001);
		deltaTAve = (deltaT[1]+deltaT[2])/2;
		h_CO2[2] = CO2_port_b.h_outflow;
		h_HTF[2] = if m_sup then inStream(HTF_port_a.h_outflow) else h_HTF_design;
		h_CO2[1] = inStream(CO2_port_a.h_outflow);
		HTF_port_b.h_outflow = if m_sup then h_HTF[1] else inStream(HTF_port_a.h_outflow);
		m_HTF_bis = if m_sup then HTF_port_a.m_flow else m_des_HTF * 0.8;
		Q_HX_HTR = CO2_port_a.m_flow * (h_CO2[2] - h_CO2[1]);
		Q_HX_HTR = UA_HTR * deltaTAve * (1 / 2 * abs(m_HTF_bis / m_des_HTF + CO2_port_a.m_flow / m_des_CO2)) ^ 0.8;
		Q_HX_HTR = m_HTF_bis * (h_HTF[2] - h_HTF[1]);
		HTF_port_a.h_outflow = inStream(HTF_port_b.h_outflow);
		CO2_port_a.h_outflow = inStream(CO2_port_b.h_outflow);
//It is necessary to have one equation in a cycle that doesn't imply a circular equality on the mass flow rates
//CO2_port_b.m_flow + CO2_port_a.m_flow = 0;
		HTF_port_a.m_flow + HTF_port_b.m_flow = 0;
		CO2_port_a.m_flow = if m_sup then HTF_port_a.m_flow * MedRec.specificHeatCapacityCp(state_HTF[2]) / 1270 else m_des_CO2 * 0.8;
// Pressure equality
		CO2_port_b.p = CO2_port_a.p;
		HTF_port_a.p = HTF_port_b.p;
		annotation(
			Diagram(graphics = {Rectangle(origin = {1, 4}, extent = {{-57, 40}, {57, -40}}), Text(origin = {-1, 8}, extent = {{-47, 16}, {47, -16}}, textString = "Exchanger")}),
			experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
		annotation(
			Documentation(info = "<html>
			<p>The exchanger is a heat exchanger between the HTF and the CO2. It is a counterflow HX, based on a TLMD. The conductance UA has to be specified from the on-design.</p>
	<p>The conductance in off-design varies as UA_Off=UA_on*(m_flow/m_design)^0.8.&nbsp;<span >The average between the two mass flows is taken.</span></p>
	<p>A.T. Louis et T. Neises, analysis and optimization for Off-design performance of the recompression s-CO2 cycles for high temperature CSP applications, in The 5th International Symposium-Supercritical CO2 Power Cycles, 2016</p>
	<p>&nbsp;</p>
			</html>"));
	end Exchanger;
