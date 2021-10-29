within SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign;
model CompressorNVarying "Model 0D of a sCO2 compressor"
	extends SolarTherm.Media.CO2.PropCO2;
	replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {42, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	parameter Real eta_comp = 0.87 "isentropic efficiency of the compressor";
	parameter Real PR = 2.313 "Pressure ratio";
	parameter Modelica.SIunits.AbsolutePressure p_out = 250 * 10 ^ 5 "outlet pressure";
	parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 273.15 + 40 "Outlet temperature in Kelvin";
	parameter Real flowGuess = 1000;
	MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
	MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic compression";
	MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real compresssion";
	Modelica.SIunits.Power W_comp "power used for compression";
	SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
	Modelica.SIunits.SpecificEntropy s_entrance "exergy at the entrance of the compressor";
	Real d_entrance;
	parameter Real phi_opt = 0.0297035;
	parameter Real psi_opt = 0.461819;
	Real diam_rotor;
	Real tipSpeed;
	Real N_compressor;
	protected
	Real mFlow(start = flowGuess);
	equation
	state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
	s_entrance = MedPB.specificEntropy(state_a);
	state_isen = MedPB.setState_psX(p_out, s_entrance);
	state_b = MedPB.setState_phX(p_out, state_a.h + (state_isen.h - state_a.h) / eta_comp);
	port_b.p = state_b.p;
	port_b.h_outflow = state_b.h;
	mFlow = port_a.m_flow;
	W_comp = port_a.m_flow * (state_b.h - state_a.h);
	port_a.m_flow + port_b.m_flow = 0;
	ex_d = W_comp + port_a.m_flow * (state_a.h - T_amb * MedPB.specificEntropy(state_a)) + port_b.m_flow * (state_b.h - T_amb * MedPB.specificEntropy(state_b));
	d_entrance = MedPB.density(state_a);
	port_a.h_outflow = 0;
// Compressor on-design parameters to be calculated
	tipSpeed = diam_rotor * N_compressor / 2;
	phi_opt = port_a.m_flow / (d_entrance * tipSpeed * diam_rotor ^ 2);
	psi_opt = (state_isen.h - state_a.h) / tipSpeed ^ 2;
	annotation(
		Diagram(graphics = {Text(origin = {-20, 18}, extent = {{-28, 16}, {42, -46}}, textString = "COMPRESSOR"), Polygon(origin = {-12, 10}, points = {{-42, 40}, {-42, -44}, {42, -70}, {42, 70}, {-42, 40}, {-42, 40}})}, coordinateSystem(initialScale = 0.1)),
	Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-26, -2}, points = {{-40, 42}, {-42, -48}, {42, -78}, {42, 78}, {-40, 42}}), Text(origin = {-16, 11}, extent = {{-48, -31}, {24, 15}}, textString = "COMPRESSOR")}));
	annotation(
		Documentation(info = "<html>
		<p>This compressor is supposed to run on another shaft than the turbine's one. This model is not really satisfying in the off-design calculations: the convergence on the N_compressor is complicated.</p>
	<p>The compressor model comes from the thesis of J. Dyreby.</p>
	<p>Phi corresponds to the adimensionned mass flow rate and psi to the adimensioned head. Because of the difference in the shaft speed regarding Dyreby's thesis, it is necessary to compensate in the off-design model by the on-design head.</p>
	<p>Parameters to integrate in the off-design PB model are:</p>
	<p>
	<ul>
	<li>The rotor diameter</li>
	<li>The actual head (psi_actual)</li>
	<li>The isentropic efficiency at design point (chosen) </li>
	<li>
	</ul>
	</p>
	<p>J. J. Dyreby, &laquo;&nbsp;Modeling the supercritical
	carbon dioxide Brayton cycle with recompression&nbsp;&raquo;, The University of
	Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
		</html>"));
end CompressorNVarying;
