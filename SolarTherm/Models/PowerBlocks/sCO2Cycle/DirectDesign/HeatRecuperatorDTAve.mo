within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
model HeatRecuperatorDTAve "The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation."

replaceable package Medium = SolarTherm.Media.CarbonDioxide;

	parameter Integer N_q = 15 "Number of subdivision of the HX";
	parameter Real ratio_m_des = 1 "ratio of m_comp_des/m_turb_des; we suppose m_turb_des=1, and then scale-up";
	parameter Real pinchRecuperator = 5 "pinch of the recuperator. Imposed as a closing equation for on-design";
	parameter Modelica.SIunits.ThermalConductance UA_HTR(fixed = false) "Conductance of the overall HX";
	parameter Modelica.SIunits.Power P_nom_des = 1e5;
	parameter Modelica.SIunits.ThermalConductance UA_dis[N_q - 1](each fixed = false, each start = 0.04 * P_nom_des) "on-design conductance of the heat recuperator";
	parameter Medium.ThermodynamicState[N_q] state_turb_des(each p.fixed = false, each h.fixed = false,h.start = {530000 + i / N_q * 500000 for i in 1:N_q});
	parameter Medium.ThermodynamicState[N_q] state_comp_des(each p.fixed = false, each h.fixed = false, h.start = {500000 + i / N_q * 500000 for i in 1:N_q});
	parameter Medium.Temperature[N_q] T_turb_des(each fixed = false, start = {140 + 273.15 + i / N_q * 300 for i in 1:N_q});
	parameter Medium.Temperature[N_q] T_comp_des(each fixed = false, start = {120 + 273.15 + i / N_q * 300 for i in 1:N_q});
	parameter Modelica.SIunits.TemperatureDifference[N_q] deltaT_des(each fixed = false, each start = 25);
	parameter Modelica.SIunits.MassFlowRate m_comp_des(fixed = false, start = P_nom_des / 1e5) "on-design mass flow from the compressor";
	parameter Modelica.SIunits.MassFlowRate m_turb_des(fixed = false, start = P_nom_des / 1e5) "on-design mass flow from the turbine";
	parameter Modelica.SIunits.HeatFlowRate Q_HX_des(fixed = false);
	parameter Modelica.SIunits.HeatFlowRate Q_dis_des(fixed = false, start=18600);
	parameter Modelica.SIunits.SpecificEnthalpy h_in_turb_des(fixed = false);
	parameter Modelica.SIunits.SpecificEnthalpy h_out_turb_des(fixed = false, start=5.5e5);
	parameter Modelica.SIunits.SpecificEnthalpy h_in_comp_des(fixed = false);
	parameter Modelica.SIunits.SpecificEnthalpy h_out_comp_des(fixed = false, start=8e5);
	parameter Modelica.SIunits.AbsolutePressure p_in_turb_des(fixed = false, start=8e6);
	parameter Modelica.SIunits.AbsolutePressure p_out_turb_des(fixed = false, start=8e6);
	parameter Modelica.SIunits.AbsolutePressure p_in_comp_des(fixed = false, start=22e6);
	parameter Modelica.SIunits.AbsolutePressure p_out_comp_des(fixed = false, start=22e6);

	Modelica.Fluid.Interfaces.FluidPort_a from_comp_port_a(redeclare package Medium = Medium) 
		annotation (Placement(visible = true,transformation(origin = {-8, 25}, extent = {{-6, -6}, {6, 6}}, rotation = 0),
		iconTransformation(origin = {-8, 25}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_a from_turb_port_a(redeclare package Medium = Medium, m_flow.start=P_nom_des/1e5) 
		annotation (Placement(visible = true,transformation(origin = {26, -11}, extent = {{-6, -6}, {6, 6}}, rotation = 0),
		iconTransformation(origin = {26, -11}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b from_comp_port_b(redeclare package Medium = Medium) 
		annotation (Placement(visible = true,transformation(origin = {8, -27}, extent = {{-6, -6}, {6, 6}}, rotation = 0),
		iconTransformation(origin = {8, -27}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b from_turb_port_b(redeclare package Medium = Medium)		 
		annotation (Placement(visible = true,transformation(origin = {-26, 11}, extent = {{-6, -6}, {6, 6}}, rotation = 0),
		iconTransformation(origin = {-26, 11}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));

	Modelica.SIunits.SpecificEnthalpy[N_q] h_from_turb(start = {500000 + (i - 1) / N_q * 200000 for i in 1:N_q});

	Medium.Temperature[N_q] T_from_turb(start = {350 + (i - 1) / N_q * 150 for i in 1:N_q});
	Medium.Temperature[N_q] T_from_comp(start = {320 + (i - 1) / N_q * 150 for i in 1:N_q});

	Modelica.SIunits.SpecificEnthalpy[N_q] h_from_comp(start = {480000 + (i - 1) / N_q * 200000 for i in 1:N_q});

	Real[N_q] deltaT(start = {150 for i in 1:N_q});

	Modelica.SIunits.HeatFlowRate Q_HX;

protected
	Medium.ThermodynamicState[N_q] state_from_turb, state_from_comp;

initial equation
	for i in 1:N_q loop
	deltaT_des[i] = T_turb_des[i] - T_comp_des[i];
	state_turb_des[i] = Medium.setState_pTX(p_in_turb_des, T_turb_des[i]);
	state_comp_des[i] = Medium.setState_pTX(p_in_comp_des, T_comp_des[i]);
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
	state_from_turb[i] = Medium.setState_phX(from_turb_port_a.p, h_from_turb[i]);
	state_from_comp[i] = Medium.setState_phX(from_comp_port_a.p, h_from_comp[i]);
	T_from_turb[i] = Medium.temperature(state_from_turb[i]);
	T_from_comp[i] = Medium.temperature(state_from_comp[i]);
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
	Icon(
		coordinateSystem(extent = {{-30, -30}, {30, 30}}, initialScale = 1), 
		graphics = {
			Rectangle(
			origin = {10, 10}, 
			fillColor = {85, 85, 255}, 
			fillPattern = FillPattern.HorizontalCylinder, 
			extent = {{-24, 10}, {6, -32}}), 
			Ellipse(
			origin = {-24, 0}, 
			fillColor = {85, 85, 255}, 
			pattern = LinePattern.None, 
			fillPattern = FillPattern.HorizontalCylinder, 
			extent = {{-4, 20}, {22, -22}}, 
			endAngle = 360), 
			Rectangle(
			origin = {-8, 23}, 
			fillPattern = FillPattern.Solid, 
			extent = {{-2, 3}, {2, -3}}), 
			Rectangle(
			origin = {8, -25}, 
			fillPattern = FillPattern.Solid, 
			extent = {{-2, 3}, {2, -3}}), 
			Ellipse(
			origin = {24, 0}, 
			fillColor = {85, 85, 255}, 
			pattern = LinePattern.None, 
			fillPattern = FillPattern.HorizontalCylinder, 
			extent = {{-20, 20}, {4, -22}}, 
			endAngle = 360), 
			Line(
			points = {{24.8675, -12.1325}, {-19.1325, -12.1325}, {-19.1325, 0}, {20.8675, 0}, {20.8675, 11.8675}, {-25.1325, 11.8675}}, 
			color = {255, 0, 0}, 
			thickness = 1), 
			Text(
			origin = {27, 27}, 
			lineColor = {0, 0, 255}, 
			extent = {{-27, 5}, {13, -5}}, 
			textString = "%name")}),
	Diagram(
		coordinateSystem(
		extent = {{-30, -30}, {30, 30}}, initialScale = 1)));
end HeatRecuperatorDTAve;
