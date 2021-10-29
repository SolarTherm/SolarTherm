within SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign;
model HeatRecuperatorTLMD "The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation. The system of equation is closed by imposing a pinch. "
	extends SolarTherm.Media.CO2.PropCO2;
	replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
	outer Modelica.Fluid.System system;
	parameter Integer N_q = 15 "Number of discretisation of the heat exchanger";
	parameter Real flowGuess = 100 "guess value for the mass flow; given as Pnom/10^5 in the cycles";
	parameter Real pinchRecuperator = 5 "pinch of the recuperator. Imposed as a closing equation";
	parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 40 + 273.15;
	Modelica.Fluid.Interfaces.FluidPort_a from_comp_port_a(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_a from_turb_port_a(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b from_comp_port_b(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b from_turb_port_b(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.SIunits.SpecificEnthalpy[N_q] h_from_turb(start = {500000 for i in 1:N_q});
	Modelica.SIunits.ThermodynamicTemperature[N_q] T_from_turb(start = {500 for i in 1:N_q});
	Modelica.SIunits.SpecificEnthalpy[N_q] h_from_comp(start = {500000 for i in 1:N_q});
	Modelica.SIunits.ThermodynamicTemperature[N_q] T_from_comp(start = {500 for i in 1:N_q});
	Real[N_q] deltaT "Temperature difference in the heat exchangers";
	Real deltaT_lmBis "Overall logarithmic temperature difference";
	SolarTherm.Types.Conductance UA_HTR "Overall conductance from the overall LMTD";
	SolarTherm.Types.Conductance[N_q - 1] UA_dis "Conductance per sub-heat exchanger";
	Modelica.SIunits.HeatFlowRate Q_T_HTR "Overall exchanged energy";
	Modelica.SIunits.HeatFlowRate Q_HX_HTR_dis(start = flowGuess * 10 ^ 4) "Constant energy exchanged in each sub-heat exchanger";
	// gives a start value to the mass flow, taken as P_nom/10⁵; allows easier convergence
	SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
	Real[N_q - 1] deltaT_lm;
	protected
	MedPB.ThermodynamicState[N_q] state_from_turb;
	MedPB.ThermodynamicState[N_q] state_from_comp;
	Real m_flowStart(start = flowGuess);
	equation
	for i in 1:N_q loop
		deltaT[i] = T_from_turb[i] - T_from_comp[i];
		state_from_turb[i] = MedPB.setState_phX(from_turb_port_b.p, h_from_turb[i]);
		state_from_comp[i] = MedPB.setState_phX(from_comp_port_a.p, h_from_comp[i]);
		T_from_turb[i] = MedPB.temperature(state_from_turb[i]);
		T_from_comp[i] = MedPB.temperature(state_from_comp[i]);
	end for;
	h_from_turb[N_q] = inStream(from_turb_port_a.h_outflow);
	h_from_comp[1] = inStream(from_comp_port_a.h_outflow);
	from_turb_port_b.h_outflow = h_from_turb[1];
	from_comp_port_b.h_outflow = h_from_comp[N_q];
	min(deltaT) = pinchRecuperator;
	deltaT_lmBis * Modelica.Math.log((T_from_turb[1] - T_from_comp[1]) / (T_from_turb[N_q] - T_from_comp[N_q])) = T_from_turb[1] - T_from_comp[1] - (T_from_turb[N_q] - T_from_comp[N_q]);
	UA_HTR * deltaT_lmBis = Q_T_HTR;
	Q_HX_HTR_dis = Q_T_HTR / (N_q - 1);
	for i in 2:N_q loop
		deltaT_lm[i - 1] = if deltaT[i] * deltaT[i - 1] <= 0 then (abs(deltaT[i - 1]) ^ (1 / 3) * sign(deltaT[i - 1]) / 2 + abs(deltaT[i]) ^ (1 / 3) * sign(deltaT[i]) / 2) ^ 3 else (deltaT[i - 1] - deltaT[i]) / (Modelica.Math.log(deltaT[i - 1] / deltaT[i]) + 0.0001);
		Q_HX_HTR_dis = from_comp_port_a.m_flow * (h_from_comp[i] - h_from_comp[i - 1]);
		Q_HX_HTR_dis = UA_dis[i - 1] * deltaT_lm[i - 1];
		Q_HX_HTR_dis = from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]);
	end for;
	from_turb_port_a.h_outflow = inStream(from_turb_port_b.h_outflow);
	from_comp_port_a.h_outflow = inStream(from_comp_port_b.h_outflow);
	from_turb_port_b.m_flow + from_turb_port_a.m_flow = 0;
	from_comp_port_b.m_flow + from_comp_port_a.m_flow = 0;
	m_flowStart = from_turb_port_a.m_flow;
	from_turb_port_b.p = from_turb_port_a.p;
	from_comp_port_b.p = from_comp_port_a.p;
	ex_d = from_turb_port_a.m_flow * (state_from_turb[N_q].h - T_amb * MedPB.specificEntropy(state_from_turb[N_q])) + from_turb_port_b.m_flow * (state_from_turb[1].h - T_amb * MedPB.specificEntropy(state_from_turb[1])) + from_comp_port_b.m_flow * (state_from_comp[N_q].h - T_amb * MedPB.specificEntropy(state_from_comp[N_q])) + from_comp_port_a.m_flow * (state_from_comp[1].h - T_amb * MedPB.specificEntropy(state_from_comp[1]));
	annotation(
		Diagram(graphics = {Rectangle(origin = {1, 7}, extent = {{-61, 31}, {61, -31}}), Text(origin = {5, 1}, extent = {{-53, -17}, {53, 17}}, textString = "RECUPERATOR")}),
	Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-65, 33}, {65, -33}}), Text(origin = {-2, -5}, extent = {{-46, -15}, {46, 15}}, textString = "RECUPERATOR")}));
	annotation(
		Documentation(info = "<html>
		<p>&nbsp;</p>
		<p> The heat recuperator is subdivised in N_q segments in order to accurately represent the CO2 properties variation.</p>
	<p>This subdivision is based on the heat exchanged between both sides: it is even for all subdivision (Q_HX_HTR_dis).&nbsp;</p>
	<p>The closure equations are first the equality of the heat exchanged in every sub-HX and by imposing a pinch (of 5&deg;C in general).</p>
	<p> The conductance in each sub-HX is calculated with Q=UA*TLMD, TLMD being the logarithmic temperature difference. </p>
	<p>The parameters to integrate in the off-design PB are the UA_dis, which can be done with the CSV button.&nbsp;</p>
	<p>&nbsp;</p>
		</html>"));
end HeatRecuperatorTLMD;


