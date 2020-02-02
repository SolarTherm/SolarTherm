within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
	model HeatRecuperatorDTAve "The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation."
		extends SolarTherm.Media.CO2.PropCO2;

		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;

		import SI = Modelica.SIunits;

		parameter Integer N_q = 15 "Number of subdivision of the HX";
		parameter Real ratio_m_des = 1 "ratio of m_comp_des/m_turb_des; we suppose m_turb_des=1, and then scale-up";
		parameter Real pinchRecuperator = 5 "pinch of the recuperator. Imposed as a closing equation for on-design";

		parameter SI.ThermalConductance UA_HTR(fixed = false) "Conductance of the overall HX";

		parameter SI.Power P_nom_des = 1e5;

		parameter SI.ThermalConductance UA_dis[N_q - 1](each fixed = false, each start = 0.04 * P_nom_des) "on-design conductance of the heat recuperator";

		parameter MedPB.ThermodynamicState[N_q] state_turb_des(each p.fixed = false, each h.fixed = false,	h.start = {530000 + i / N_q * 500000 for i in 1:N_q});
		parameter MedPB.ThermodynamicState[N_q] state_comp_des(each p.fixed = false, each h.fixed = false, h.start = {500000 + i / N_q * 500000 for i in 1:N_q});

		parameter MedPB.Temperature[N_q] T_turb_des(each fixed = false, start = {140 + 273.15 + i / N_q * 300 for i in 1:N_q});
		parameter MedPB.Temperature[N_q] T_comp_des(each fixed = false, start = {120 + 273.15 + i / N_q * 300 for i in 1:N_q});

		parameter SI.TemperatureDifference[N_q] deltaT_des(each fixed = false, each start = 25);

		parameter SI.MassFlowRate m_comp_des(fixed = false, start = P_nom_des / 1e5) "on-design mass flow from the compressor";
		parameter SI.MassFlowRate m_turb_des(fixed = false, start = P_nom_des / 1e5) "on-design mass flow from the turbine";

		parameter SI.HeatFlowRate Q_HX_des(fixed = false);
		parameter SI.HeatFlowRate Q_dis_des(fixed = false, start=18600);

		parameter SI.SpecificEnthalpy h_in_turb_des(fixed = false);
		parameter SI.SpecificEnthalpy h_out_turb_des(fixed = false, start=550000);

		parameter SI.SpecificEnthalpy h_in_comp_des(fixed = false);
		parameter SI.SpecificEnthalpy h_out_comp_des(fixed = false, start=800000);

		parameter SI.AbsolutePressure p_in_turb_des(fixed = false, start=8e6);
		parameter SI.AbsolutePressure p_out_turb_des(fixed = false, start=8e6);

		parameter SI.AbsolutePressure p_in_comp_des(fixed = false, start=22e6);
		parameter SI.AbsolutePressure p_out_comp_des(fixed = false, start=22e6);

		Modelica.Fluid.Interfaces.FluidPort_a from_comp_port_a(redeclare package Medium = MedPB) annotation(
				Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
				iconTransformation(origin = {-70, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_a from_turb_port_a(redeclare package Medium = MedPB, m_flow.start=P_nom_des/10^5) annotation(
				Placement(visible = true, transformation(origin = {70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
				iconTransformation(origin = {70, -30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b from_comp_port_b(redeclare package Medium = MedPB) annotation(
				Placement(visible = true, transformation(origin = {70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
				iconTransformation(origin = {70, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b from_turb_port_b(redeclare package Medium = MedPB) annotation(
				Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0),
				iconTransformation(origin = {-70, -30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

		SI.SpecificEnthalpy[N_q] h_from_turb(start = {500000 + (i - 1) / N_q * 200000 for i in 1:N_q});

		MedPB.Temperature[N_q] T_from_turb(start = {350 + (i - 1) / N_q * 150 for i in 1:N_q});
		MedPB.Temperature[N_q] T_from_comp(start = {320 + (i - 1) / N_q * 150 for i in 1:N_q});

		SI.SpecificEnthalpy[N_q] h_from_comp(start = {480000 + (i - 1) / N_q * 200000 for i in 1:N_q});

		Real[N_q] deltaT(start = {150 for i in 1:N_q});

		SI.HeatFlowRate Q_HX;

	protected

	 MedPB.ThermodynamicState[N_q] state_from_turb, state_from_comp;

	initial equation

		for i in 1:N_q loop
			deltaT_des[i] = T_turb_des[i] - T_comp_des[i];
			state_turb_des[i] = MedPB.setState_pTX(p_in_turb_des, T_turb_des[i]);
			state_comp_des[i] = MedPB.setState_pTX(p_in_comp_des, T_comp_des[i]);
		end for;

		min(deltaT_des) = pinchRecuperator;

		state_turb_des[N_q].h = h_in_turb_des;
		state_turb_des[1].h = h_out_turb_des;
		state_comp_des[1].h = h_in_comp_des;
		state_comp_des[N_q].h = h_out_comp_des;

		p_out_comp_des = p_in_comp_des;
		p_out_turb_des = p_in_turb_des;

		Q_HX_des = m_turb_des*Q_dis_des * (N_q - 1);

		UA_HTR = sum(UA_dis);

		for i in 1:N_q - 1 loop
			Q_dis_des = ratio_m_des * (state_comp_des[i + 1].h - state_comp_des[i].h);
			m_turb_des*Q_dis_des = UA_dis[i] * (deltaT_des[i + 1] + deltaT_des[i]) / 2;
			Q_dis_des = (state_turb_des[i + 1].h - state_turb_des[i].h);
		end for;

	equation

	for i in 1:N_q loop
		deltaT[i] = T_from_turb[i] - T_from_comp[i];
		state_from_turb[i] = MedPB.setState_phX(from_turb_port_a.p, h_from_turb[i]);
		state_from_comp[i] = MedPB.setState_phX(from_comp_port_a.p, h_from_comp[i]);
		T_from_turb[i] = MedPB.temperature(state_from_turb[i]);
		T_from_comp[i] = MedPB.temperature(state_from_comp[i]);
	end for;

	h_from_turb[N_q] = inStream(from_turb_port_a.h_outflow);
	h_from_comp[1] = inStream(from_comp_port_a.h_outflow);

	from_turb_port_b.h_outflow = h_from_turb[1];
	from_comp_port_b.h_outflow = h_from_comp[N_q];

	Q_HX=from_turb_port_a.m_flow*(h_from_turb[N_q]-h_from_turb[1]);

	for i in 2:N_q loop

		from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]) = from_comp_port_a.m_flow * (h_from_comp[i] - h_from_comp[i - 1]);
		from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]) = UA_dis[i - 1] * (abs(from_comp_port_a.m_flow / m_comp_des + from_turb_port_a.m_flow / m_turb_des) ^ 0.8)/ (2 ^ 0.8 )* (T_from_turb[i - 1] - T_from_comp[i - 1] + T_from_turb[i] - T_from_comp[i]) / 2;

	end for;

	from_turb_port_b.m_flow + from_turb_port_a.m_flow = 0;
	from_comp_port_b.m_flow + from_comp_port_a.m_flow = 0;

	from_turb_port_b.p = from_turb_port_a.p;
	from_comp_port_b.p = from_comp_port_a.p;

	from_turb_port_a.h_outflow = inStream(from_turb_port_b.h_outflow);
	from_comp_port_a.h_outflow = inStream(from_comp_port_b.h_outflow);

		annotation(
			Diagram(graphics = {Rectangle(origin = {-1, 9}, extent = {{-59, 31}, {61, -49}}), Text(origin = {1, 1}, extent = {{-53, -17}, {51, 17}}, textString = "RECUPERATOR"), Line(origin = {0, -30}, points = {{70, 0}, {-70, 0}, {-70, 0}}), Line(origin = {0, 30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {0, -30}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
			Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-57, 49}, {63, -31}}), Text(origin = {0, 1}, extent = {{-48, -15}, {48, 15}}, textString = "RECUPERATOR"), Line(origin = {0, 30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Line(origin = {0, -30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {-2, -30}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
			Documentation(info = "<html>
			<p>This heat recuperator is a counter-flow HX. Closure equations are based on the equality of m_flow*delta_H for both sides and m_flow*delta_H= UA_i*DTAve_i, DTAve being the average of the temperature difference between the inlet and the outlet of the sub-HX.</p>
	<p>The UA_i must be given as parameters from the on-design analysis.&nbsp;</p>
			
			</html>"));
	end HeatRecuperatorDTAve;

