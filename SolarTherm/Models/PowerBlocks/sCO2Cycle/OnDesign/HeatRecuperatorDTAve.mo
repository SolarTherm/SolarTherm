within SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign;
	model HeatRecuperatorDTAve "1D model of the heat recuperator. "
	extends SolarTherm.Media.CO2.PropCO2;
	replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
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
	SolarTherm.Types.Conductance UA_dis[N_q - 1] "Conductance per sub-heat exchanger";
	SolarTherm.Types.Conductance UA_HTR "Conductance of the overall HX";
	//Real deltaT_TLMD "overall logarithmic temperature difference for the price estiamtes";
	Modelica.SIunits.HeatFlowRate Q_HX_HTR;
	Modelica.SIunits.HeatFlowRate Q_HX_HTR_dis;
	// gives a start value to the mass flow, taken as P_nom/10⁵; allows easier convergence
	SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
	protected
	MedPB.ThermodynamicState[N_q] state_from_turb;
	MedPB.ThermodynamicState[N_q] state_from_comp;
	Real m_flowStart(start = flowGuess);
	equation
	for i in 1:N_q loop
		deltaT[i] = T_from_turb[i] - T_from_comp[i];
		state_from_turb[i] = MedPB.setState_phX(from_turb_port_b.p + (i - 1) / (N_q - 1) * (from_turb_port_a.p - from_turb_port_b.p), h_from_turb[i]);
		state_from_comp[i] = MedPB.setState_phX(from_comp_port_a.p + (i - 1) / (N_q - 1) * (from_comp_port_b.p - from_comp_port_a.p), h_from_comp[i]);
		T_from_turb[i] = MedPB.temperature(state_from_turb[i]);
		T_from_comp[i] = MedPB.temperature(state_from_comp[i]);
	end for;
	h_from_turb[N_q] = inStream(from_turb_port_a.h_outflow);
	h_from_comp[1] = inStream(from_comp_port_a.h_outflow);
	from_turb_port_b.h_outflow = h_from_turb[1];
	from_comp_port_b.h_outflow = h_from_comp[N_q];
	min(deltaT) = pinchRecuperator;
	Q_HX_HTR = Q_HX_HTR_dis * (N_q - 1);
	UA_HTR = sum(UA_dis);
	//deltaT_TLMD= if deltaT[1] * deltaT[N_q] <= 0 then (abs(deltaT[1]) ^ (1 / 3) * sign(deltaT[1]) / 2 + abs(deltaT[N_q]) ^ (1 / 3) * sign(deltaT[N_q]) / 2) ^ 3 else (deltaT[1] - deltaT[N_q]) / (Modelica.Math.log(deltaT[1] / deltaT[N_q]) + 0.0001);
	for i in 2:N_q loop
		Q_HX_HTR_dis = from_comp_port_a.m_flow * (h_from_comp[i] - h_from_comp[i - 1]);
		Q_HX_HTR_dis = UA_dis[i - 1] * (T_from_turb[i - 1] - T_from_comp[i - 1] + T_from_turb[i] - T_from_comp[i]) / 2;
		Q_HX_HTR_dis = from_turb_port_a.m_flow * (h_from_turb[i] - h_from_turb[i - 1]);
	end for;
	from_turb_port_b.m_flow + from_turb_port_a.m_flow = 0;
	from_comp_port_b.m_flow + from_comp_port_a.m_flow = 0;
	m_flowStart = from_turb_port_a.m_flow;
	from_comp_port_a.h_outflow = 0;
	from_turb_port_a.h_outflow = inStream(from_turb_port_b.h_outflow);
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
	<p> The conductance in each sub-HX is calculated with Q=UA*DTAverage, DTAverage being the average between the inlet and outlet delta T.
	<p>The parameters to integrate in the off-design PB are the UA_dis, which can be done with the CSV button.&nbsp;</p>
	<p>&nbsp;</p>
		</html>"));
	end HeatRecuperatorDTAve;
