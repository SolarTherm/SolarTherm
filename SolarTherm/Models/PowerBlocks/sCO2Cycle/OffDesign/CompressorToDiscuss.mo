within SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign;
	model CompressorToDiscuss
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {42, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		parameter Real eta_design = 0.87 "Maximal isentropic efficiency of the compressor";
		parameter Real PR = 2.313 "Pressure ratio";
		parameter Modelica.SIunits.AbsolutePressure p_out = 250 * 10 ^ 5 "outlet pressure";
		parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 273.15 + 40 "Outlet temperature in Kelvin";
		parameter Real flowGuess = 1000;
		MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
		MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic compression";
		MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real compresssion";
		Modelica.SIunits.Power W_comp "power used for compression";
		//SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
		Modelica.SIunits.SpecificEntropy s_entrance "exergy at the entrance of the compressor";
		//	Real phi;
		//	Real psi;
		parameter Real diam_rotor = 0.18;
		parameter Real N_design = 3358;
		//	Real tipSpeed;
		//	Real N_compressor(start = 3358);
		//	Real d_entrance(start = 344);
		Real eta_comp(start = eta_design);
	protected
		Real mFlow(start = flowGuess);
	equation
		state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
		s_entrance = MedPB.specificEntropy(state_a);
		state_isen = MedPB.setState_psX(p_out, s_entrance);
		state_b = MedPB.setState_phX(p_out, state_a.h + (state_isen.h - state_a.h) / eta_comp);
		port_b.p = state_b.p;
		port_b.h_outflow = state_b.h;
		port_a.h_outflow = 0;
		mFlow = port_a.m_flow;
		W_comp = port_a.m_flow * (state_b.h - state_a.h);
//port_a.m_flow + port_b.m_flow = 0;
//port_a.m_flow = 123.5*(1-time/2);
//ex_d =W_comp + port_a.m_flow*(state_a.h-T_amb*MedPB.specificEntropy(state_a))+port_b.m_flow*(state_b.h-T_amb*MedPB.specificEntropy(state_b));
//d_entrance = MedPB.density(state_a);
// Compressor on-design parameters to be calculated
//tipSpeed = diam_rotor * N_compressor / 2;
		eta_comp = eta_design;
//N_compressor=4000*(1-time/1.5);
//	phi = port_a.m_flow / (d_entrance * tipSpeed * diam_rotor ^ 2) * (N_compressor / N_design) ^ (1 / 5);
//	psi = (state_isen.h - state_a.h) / tipSpeed ^ 2 * (N_design / N_compressor) ^ ((20 * phi) ^ 3);
//	//phi = port_a.m_flow / (d_entrance * tipSpeed * diam_rotor ^ 2);
//	//psi = (state_isen.h - state_a.h) / tipSpeed ^ 2;
//	psi = 0.04049 + 54.7 * phi - 2505 * phi ^ 2 + 53224 * phi ^ 3 - 498626 * phi ^ 4;
//	eta_comp = eta_design / 0.677837 * (abs((-0.7069) + 168.6 * phi - 8089 * phi ^ 2 + 182725 * phi ^ 3 - 1.638 * 10 ^ 6 * phi ^ 4)) * (N_design / N_compressor) ^ ((20 * phi) ^ 5);
//	//eta_comp = eta_design / 0.677837 * ((-0.7069) + 168.6 * phi - 8089 * phi ^ 2 + 182725 * phi ^ 3 - 1.638 * 10 ^ 6 * phi ^ 4);
		annotation(
			Diagram(graphics = {Text(origin = {-20, 18}, extent = {{-28, 16}, {42, -46}}, textString = "COMPRESSOR"), Polygon(origin = {-12, 10}, points = {{-42, 40}, {-42, -44}, {42, -70}, {42, 70}, {-42, 40}, {-42, 40}})}, coordinateSystem(initialScale = 0.1)),
			Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-26, -2}, points = {{-40, 42}, {-42, -48}, {42, -78}, {42, 78}, {-40, 42}}), Text(origin = {-16, 11}, extent = {{-48, -31}, {24, 15}}, textString = "COMPRESSOR")}));
	end CompressorToDiscuss;
