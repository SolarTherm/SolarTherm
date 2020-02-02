within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
	model Exchanger
		extends SolarTherm.Media.CO2.PropCO2;

		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;

		import SI = Modelica.SIunits;
		import Modelica.SIunits.Conversions.*;

		parameter SI.ThermodynamicTemperature T_out_CO2_des = from_degC(715);

		parameter SI.Power P_nom_des = 164000;

		parameter Real ratio_m_des = 1 "ratio of m_CO2_des/m_HTF_des at design point";	

		parameter Integer N_exch = 8;

		parameter SI.HeatFlowRate Q_HX_des(fixed = false);

		parameter SI.MassFlowRate m_CO2_des(fixed = false);
		parameter SI.MassFlowRate m_HTF_des(fixed = false);

		parameter SI.ThermalConductance UA_HX(fixed = false) "on-design conductance of the overall exchanger";
		parameter SI.ThermalConductance[N_exch-1] UA_HX_dis(each fixed = false) "on-design conductance of the exchanger";

		parameter SI.SpecificEnthalpy h_in_HTF_des(fixed = false, start = 855e3);
		parameter SI.SpecificEnthalpy h_in_CO2_des(fixed = false, start = 9e5);

		parameter SI.SpecificEnthalpy h_out_HTF_des(fixed = false);
		parameter SI.SpecificEnthalpy h_out_CO2_des(fixed = false, start = 1.2e6);

		parameter Real[N_exch] deltaT_des(each fixed = false, each start = 75);

		parameter SI.AbsolutePressure p_in_CO2_des(fixed = false);
		parameter SI.AbsolutePressure p_in_HTF_des(fixed = false);

		parameter SI.AbsolutePressure p_out_CO2_des(fixed = false);
		parameter SI.AbsolutePressure p_out_HTF_des(fixed = false);

		parameter SI.ThermodynamicTemperature[N_exch] T_CO2_des(each fixed = false, start={from_degC(600) + 120*(i/N_exch) for i in 1:N_exch});
		parameter SI.ThermodynamicTemperature[N_exch] T_HTF_des(each fixed = false, start = {from_degC(650) + 120*(i/N_exch) for i in 1:N_exch});

		parameter MedPB.ThermodynamicState[N_exch] state_CO2_des(each p.fixed = false, each h.fixed = false, each p.start = 25e6, each h.start = 1e6);
		parameter MedPB.ThermodynamicState[N_exch] state_HTF_des(each p.fixed = false, each h.fixed = false, each p.start = 1e5, each h.start = 855004);

		MedPB.ThermodynamicState[N_exch] state_CO2;
		MedPB.ThermodynamicState[N_exch] state_HTF;

		SI.SpecificEnthalpy[N_exch] h_CO2(start = {9.9e5 + (i/N_exch)*2e5 for i in 1:N_exch});
		SI.SpecificEnthalpy[N_exch] h_HTF(start={6e5 + (i/N_exch)*2e5 for i in 1:N_exch});

		Real[N_exch] deltaT "Temperature difference in the heat exchangers";

		SI.HeatFlowRate Q_HX;

		SI.ThermodynamicTemperature T_CO2_out;
		SI.ThermodynamicTemperature T_HTF_out;

		//Real deltaT_lm;

		Real deltaTAve;

		SI.MassFlowRate m_HTF_bis (start=P_nom_des/1e5);

		Modelica.Fluid.Interfaces.FluidPort_a HTF_port_a(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
			iconTransformation(origin = {70, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_a CO2_port_a(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
			iconTransformation(origin = {-70, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b HTF_port_b(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
			iconTransformation(origin = {-70, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b CO2_port_b(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
			iconTransformation(origin = {70, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

		input Boolean m_sup "when m_sup=false, m_HTF=m_HTF_design and P_elec=0 -> allows switching off the PB";

	initial equation
		for i in 1:N_exch loop
			deltaT_des[i] = MedRec.temperature(state_HTF_des[i]) - MedPB.temperature(state_CO2_des[i]);
			state_CO2_des[i] = MedPB.setState_pTX(p_in_CO2_des, T_CO2_des[i]);
			state_HTF_des[i] = MedRec.setState_pTX(p_in_HTF_des, T_HTF_des[i]);
		end for;

		T_CO2_des[N_exch]=T_out_CO2_des;

		for i in 1:(N_exch-1) loop
			Q_HX_des = ratio_m_des * (state_CO2_des[i+1].h - state_CO2_des[i].h);
			Q_HX_des =	(state_HTF_des[i+1].h - state_HTF_des[i].h);
			m_HTF_des*Q_HX_des = UA_HX_dis[i] * (deltaT_des[i] + deltaT_des[i+1]) / 2;
		end for;

		UA_HX=sum(UA_HX_dis);

		p_in_CO2_des = p_out_CO2_des;
		p_in_HTF_des = p_out_HTF_des;
		h_in_HTF_des = MedRec.specificEnthalpy(state_HTF_des[N_exch]);
		h_out_HTF_des = MedRec.specificEnthalpy(state_HTF_des[1]);
		h_in_CO2_des = state_CO2_des[1].h;
		h_out_CO2_des = state_CO2_des[N_exch].h;
		m_CO2_des = ratio_m_des * m_HTF_des;

	equation

	// Asigning props to each node
	for i in 1:N_exch loop
		deltaT[i] = if m_sup then MedRec.temperature(state_HTF[i]) - MedPB.temperature(state_CO2[i]) else deltaT_des[i];
		state_CO2[i] = MedPB.setState_phX(CO2_port_a.p, h_CO2[i]);
		state_HTF[i] = MedRec.setState_phX(HTF_port_a.p, h_HTF[i]);
	end for;

	T_CO2_out = MedPB.temperature(state_CO2[N_exch]); // Cold outlet temperature at the last node
	T_HTF_out = MedRec.temperature(state_HTF[1]);     // Hot outlet temperature at the first node

	//deltaT_lm = if deltaT[2] * deltaT[1] < 0 then (abs(deltaT[1]) ^ (1 / 3) * sign(deltaT[1]) / 2 + abs(deltaT[2]) ^ (1 / 3) * sign(deltaT[2]) / 2) ^ 3 else (deltaT[1] - deltaT[2]) / (Modelica.Math.log(deltaT[1] / deltaT[2]) + 0.0001);

	deltaTAve = (deltaT[1] + deltaT[N_exch]) / 2; // Setting an average temperature difference

	h_CO2[N_exch] = CO2_port_b.h_outflow;
	h_HTF[N_exch] = if m_sup then inStream(HTF_port_a.h_outflow) else h_in_HTF_des;
	h_CO2[1] = inStream(CO2_port_a.h_outflow);
	HTF_port_b.h_outflow = if m_sup then h_HTF[1] else inStream(HTF_port_a.h_outflow);

	m_HTF_bis = if m_sup then HTF_port_a.m_flow else m_HTF_des;
	Q_HX = CO2_port_a.m_flow * (h_CO2[N_exch] - h_CO2[1]);

	for i in 1:(N_exch-1) loop 

		m_HTF_bis*(h_HTF[i+1]-h_HTF[i])=CO2_port_a.m_flow*(h_CO2[i+1]-h_CO2[i]);

		CO2_port_a.m_flow*(h_CO2[i+1]-h_CO2[i])=UA_HX_dis[i]* (1 / 2 * abs(m_HTF_bis / m_HTF_des + CO2_port_a.m_flow / m_CO2_des)) ^ 0.8* (deltaT[i] + deltaT[i+1]) / 2;

	end for;
	
	HTF_port_a.h_outflow = inStream(HTF_port_b.h_outflow);
	CO2_port_a.h_outflow = inStream(CO2_port_b.h_outflow);

	//It is necessary to have one equation in a cycle that doesn't imply a circular equality on the mass flow rates
	//CO2_port_b.m_flow + CO2_port_a.m_flow = 0;

	HTF_port_a.m_flow + HTF_port_b.m_flow = 0;
	//CO2_port_a.m_flow = if m_sup then HTF_port_a.m_flow else m_CO2_des * 0.8;

	// Pressure equality
	CO2_port_b.p = CO2_port_a.p;
	HTF_port_a.p = HTF_port_b.p;

		annotation(
			Diagram(graphics = {Rectangle(origin = {1, 4}, extent = {{-61, 56}, {59, -64}}), Text(origin = {-1, 8}, extent = {{-47, 16}, {47, -16}}, textString = "Exchanger"), Line(origin = {0, 40}, points = {{-70, 0}, {70, 0}, {70, 0}}), Line(origin = {0, -40}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {-1, 40}, points = {{5, 6}, {5, -6}, {-5, 0}, {5, 6}, {5, 6}}), Polygon(origin = {-1, 40}, points = {{5, 6}, {5, -6}, {-5, 0}, {5, 6}, {5, 6}}), Polygon(origin = {-9, -40}, points = {{5, 6}, {5, -6}, {15, 0}, {5, 6}, {5, 6}})}, coordinateSystem(initialScale = 0.1)),
			experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
			Documentation(info = "<html>
			<p>The exchanger is a heat exchanger between the HTF and the CO2. It is a counterflow HX, based on a TLMD. The conductance UA has to be specified from the on-design.</p>
	<p>The conductance in off-design varies as UA_Off=UA_on*(m_flow/m_design)^0.8.&nbsp;<span >The average between the two mass flows is taken.</span></p>
	<p>A.T. Louis et T. Neises, analysis and optimization for Off-design performance of the recompression s-CO2 cycles for high temperature CSP applications, in The 5th International Symposium-Supercritical CO2 Power Cycles, 2016</p>
	<p>&nbsp;</p>
			</html>"),
	Icon(graphics = {Rectangle(extent = {{-60, 60}, {60, -60}}), Line(origin = {0, 40}, points = {{-70, 0}, {70, 0}, {70, 0}}), Line(origin = {0, -40}, points = {{-70, 0}, {70, 0}}), Polygon(origin = {0, -39}, points = {{-4, 5}, {-4, -7}, {4, -1}, {4, -1}, {-4, 5}}), Polygon(origin = {0, -39}, points = {{-4, 5}, {-4, -7}, {4, -1}, {4, -1}, {-4, 5}}), Polygon(origin = {-2, 40}, points = {{4, 6}, {4, -6}, {-4, 0}, {4, 6}, {4, 6}}), Text(origin = {-3, 10}, extent = {{-31, 10}, {41, -34}}, textString = "HX"), Text(origin = {0, 52}, extent = {{-34, 4}, {34, -4}}, textString = "HTF"), Text(origin = {0, -52}, extent = {{-28, 4}, {28, -4}}, textString = "sCO2")}));
	end Exchanger;

