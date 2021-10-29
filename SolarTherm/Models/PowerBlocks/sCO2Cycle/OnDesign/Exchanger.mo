within SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign;
model Exchanger "0D model of a heat exchanger between the HTF and the CO2"
	extends SolarTherm.Media.CO2.PropCO2;
	replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
	replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
	outer Modelica.Fluid.System system;
	parameter Real pinch = 10;
	parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 40 + 273.15;
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
	Modelica.SIunits.SpecificEnthalpy[2] h_CO2 (start={1000000,1200000});
	Modelica.SIunits.SpecificEnthalpy[2] h_HTF;
	SolarTherm.Types.Conductance UA_TLMD "Conductance of the overall HX";
	Real[2] deltaT "Temperature difference in the heat exchangers";
	Real deltaT_lm;
	Modelica.SIunits.HeatFlowRate Q_HX_HTR;
	Modelica.SIunits.ThermodynamicTemperature T_CO2_out;
	Modelica.SIunits.ThermodynamicTemperature T_HTF_out;
	SolarTherm.Types.SpecificExergy ex_d;
	protected
	equation
	for i in 1:2 loop
		deltaT[i] = MedRec.temperature(state_HTF[i]) - MedPB.temperature(state_CO2[i]);
		state_CO2[i] = MedPB.setState_phX(CO2_port_a.p, h_CO2[i]);
		state_HTF[i] = MedRec.setState_phX(HTF_port_a.p, h_HTF[i]);
	end for;
	h_CO2[2] = CO2_port_b.h_outflow;
	h_HTF[2] = inStream(HTF_port_a.h_outflow);
	h_CO2[1] = inStream(CO2_port_a.h_outflow);
	h_HTF[1] = HTF_port_b.h_outflow;
	T_CO2_out = MedPB.temperature(state_CO2[2]);
	T_CO2_out=690+273.15;
	T_HTF_out = MedRec.temperature(state_HTF[1]);
	//min(deltaT) = pinch;
	deltaT_lm = if deltaT[2] * deltaT[1] < 0 then (abs(deltaT[1]) ^ (1 / 3) * sign(deltaT[1]) / 2 + abs(deltaT[2]) ^ (1 / 3) * sign(deltaT[2]) / 2) ^ 3 else (deltaT[1] - deltaT[2]) / (Modelica.Math.log(deltaT[1] / deltaT[2]) + 0.0001);
	Q_HX_HTR = CO2_port_a.m_flow * (h_CO2[2] - h_CO2[1]);
	Q_HX_HTR = UA_TLMD * deltaT_lm;
	Q_HX_HTR = HTF_port_a.m_flow * (h_HTF[2] - h_HTF[1]);
	CO2_port_a.p = CO2_port_b.p;
	HTF_port_a.p = HTF_port_b.p;
	CO2_port_a.h_outflow = inStream(CO2_port_b.h_outflow);
	HTF_port_a.h_outflow = inStream(HTF_port_b.h_outflow);
//Closure equation on the mass flow
	CO2_port_a.m_flow = HTF_port_a.m_flow*MedRec.specificHeatCapacityCp(state_HTF[2])/1270;
//CO2_port_a.m_flow+CO2_port_b.m_flow=0;
	HTF_port_a.m_flow + HTF_port_b.m_flow = 0;
	ex_d = HTF_port_a.m_flow * (MedRec.specificEnthalpy(state_HTF[2]) - T_amb * MedRec.specificEntropy(state_HTF[2])) + HTF_port_b.m_flow * (MedRec.specificEnthalpy(state_HTF[1]) - T_amb * MedRec.specificEntropy(state_HTF[1])) + CO2_port_b.m_flow * (MedPB.specificEnthalpy(state_CO2[2]) - T_amb * MedPB.specificEntropy(state_CO2[2])) + CO2_port_a.m_flow * (MedPB.specificEnthalpy(state_CO2[1]) - T_amb * MedPB.specificEntropy(state_CO2[1]));
	annotation(
		Documentation(info = "<html>
		<p>The exchanger is not divided in sub-HX, as the Cp of the CO2 is almost constant in this area (high pressure, high T).&nbsp;</p>
	<p>Closure equations are based on the equality of the energy exchanged and by imposing a pinch.</p>
	<p>Parameter to integrate in the off-design PB is the UA_TLMD.</p>
		</html>"));
	annotation(
		Diagram(graphics = {Rectangle(origin = {1, 4}, extent = {{-57, 40}, {57, -40}}), Text(origin = {-1, 8}, extent = {{-47, 16}, {47, -16}}, textString = "Exchanger")}),
	experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
	Icon(graphics = {Rectangle(origin = {-8, -7}, extent = {{-62, 39}, {62, -39}}), Text(origin = {-6, -13}, extent = {{-48, 21}, {48, -21}}, textString = "Exchanger")}));
end Exchanger;
