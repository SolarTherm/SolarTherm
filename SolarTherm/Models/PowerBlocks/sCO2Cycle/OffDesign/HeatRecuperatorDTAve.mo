within SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign;
	model HeatRecuperatorDTAve "The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation."
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		parameter Integer N_q = 15 "Number of subdivision of the HX";
		parameter Modelica.SIunits.MassFlowRate m_des_comp = 1.5 "on-design mass flow from the compressor";
		parameter Modelica.SIunits.MassFlowRate m_des_turb = 1.5 "on-design mass-flow from the turbine";
		parameter SolarTherm.Types.Conductance UA_dis[N_q - 1] "on-design conductance of the heat recuperator";
		Modelica.Fluid.Interfaces.FluidPort_a from_comp_port_a(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_a from_turb_port_a(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b from_comp_port_b(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b from_turb_port_b(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.SIunits.SpecificEnthalpy[N_q] h_from_turb(start = {500000 + (i - 1) / N_q * 200000 for i in 1:N_q});
		Modelica.SIunits.ThermodynamicTemperature[N_q] T_from_turb(start = {350 + (i - 1) / N_q * 150 for i in 1:N_q});
		Modelica.SIunits.SpecificEnthalpy[N_q] h_from_comp(start = {480000 + (i - 1) / N_q * 200000 for i in 1:N_q});
		Modelica.SIunits.ThermodynamicTemperature[N_q] T_from_comp(start = {320 + (i - 1) / N_q * 150 for i in 1:N_q});
		Real[N_q] deltaT(start = {150 for i in 1:N_q});
	protected
		MedPB.ThermodynamicState[N_q] state_from_turb;
		MedPB.ThermodynamicState[N_q] state_from_comp;
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
		for i in 2:N_q loop
			from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]) = from_comp_port_a.m_flow * (h_from_comp[i] - h_from_comp[i - 1]);
			from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]) = UA_dis[i - 1] * abs(from_comp_port_a.m_flow / m_des_comp + from_turb_port_a.m_flow / m_des_turb) ^ 0.8 / 2 ^ 0.8 * (T_from_turb[i - 1] - T_from_comp[i - 1] + T_from_turb[i] - T_from_comp[i]) / 2;
		end for;
		from_turb_port_b.m_flow + from_turb_port_a.m_flow = 0;
		from_comp_port_b.m_flow + from_comp_port_a.m_flow = 0;
		from_turb_port_b.p = from_turb_port_a.p;
		from_comp_port_b.p = from_comp_port_a.p;
		from_turb_port_a.h_outflow = inStream(from_turb_port_b.h_outflow);
		from_comp_port_a.h_outflow = inStream(from_comp_port_b.h_outflow);
		annotation(
			Diagram(graphics = {Rectangle(origin = {1, 7}, extent = {{-61, 31}, {61, -31}}), Text(origin = {5, 1}, extent = {{-53, -17}, {53, 17}}, textString = "RECUPERATOR")}),
			Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-65, 33}, {65, -33}}), Text(origin = {-2, -5}, extent = {{-46, -15}, {46, 15}}, textString = "RECUPERATOR")}),
			Documentation(info = "<html>
				<p>This heat recuperator is a counter-flow HX. Closure equations are based on the equality of m_flow*delta_H for both sides and m_flow*delta_H= UA_i*DTAve_i, DTAve being the average of the temperature difference between the inlet and the outlet of the sub-HX.</p>
				<p>The UA_i must be given as parameters from the on-design analysis.&nbsp;</p>
				</html>"));
	end HeatRecuperatorDTAve;
