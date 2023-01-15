within SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB;
	model CompressorOnShaft "0D model of a compressor on the same shaft as the turbine"
		extends SolarTherm.Media.CO2.PropCO2;
		import SI = Modelica.SIunits;
		import CV = Modelica.SIunits.Conversions;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		parameter Real eta_design = 0.89 "Maximal isentropic efficiency of the compressor";
		parameter SI.AngularVelocity N_design = 40000 * 0.104 "Design rotationnal speed in rad/s";
		parameter Real PR = 3 "pressure ratio chosen";
		parameter SI.Power P_nom_des "nominal power at design point";
		parameter SI.ThermodynamicTemperature T_in_des = CV.from_degC(45) "chosen inlet temperature of the compressor at design point";
		parameter SI.AbsolutePressure p_high_des = CV.from_bar(250);
		MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
		MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic compression";
		MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real compresssion";
		SI.Power W_comp "power used for compression";
		SI.SpecificEntropy s_entrance "entropy at the entrance of the compressor";
		Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {42, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		parameter SI.SpecificEnthalpy h_out_des(fixed = false), h_in_des(fixed = false) "enthalpy at the outlet of the compressor";
		parameter MedPB.ThermodynamicState state_in_des(p.fixed = false, h.fixed = false, h.start = 550000);
		parameter MedPB.ThermodynamicState state_isen_des(p.fixed = false, h.fixed = false);
		parameter SI.AbsolutePressure p_in_des(fixed = false), p_out_des(fixed = false);
		parameter SI.Power W_comp_des(fixed = false);
		parameter SI.MassFlowRate m_des(fixed = false, start = 3) "design mass flow rate in kg/s";
	initial equation
		W_comp_des = m_des * (h_out_des - state_in_des.h);
		state_in_des = MedPB.setState_phX(p_in_des, h_in_des);
		p_out_des = p_high_des;
		state_isen_des = MedPB.setState_psX(p_out_des, MedPB.specificEntropy(state_in_des));
		h_out_des = state_in_des.h + (state_isen_des.h - state_in_des.h) / eta_design;
	equation
		state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
		s_entrance = MedPB.specificEntropy(state_a);
		state_isen = MedPB.setState_psX(p_out_des, s_entrance);
		state_b = MedPB.setState_phX(p_out_des, state_a.h + (state_isen.h - state_a.h) / eta_design);
		port_b.p = state_b.p;
		port_b.h_outflow = state_b.h;
		W_comp = port_a.m_flow * (state_b.h - state_a.h);
		port_a.h_outflow = 0;
		port_a.m_flow + port_b.m_flow = 0;
		annotation(
			Documentation(info = "<html>
			<p>This compressor's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
			<p>The performance maps comes from the Sandia National Laboratory first compressor. It should be updated. The performance maps is compressed in three correlations, expressing the adimensionned head and the efficiency as functions of the adimensionned mass flow.&nbsp;</p>
			<p>The same correlations are used; only the maximal values are changed.</p>
			<p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
			</html>"),
			Diagram(graphics = {Text(origin = {-20, 18}, extent = {{-28, 16}, {42, -46}}, textString = "COMPRESSOR"), Polygon(origin = {-12, 10}, points = {{-42, 40}, {-42, -44}, {42, -70}, {42, 70}, {-42, 40}, {-42, 40}})}, coordinateSystem(initialScale = 0.1)),
			Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-26, -2}, points = {{-40, 42}, {-42, -48}, {42, -78}, {42, 78}, {-40, 42}}), Text(origin = {-16, 11}, extent = {{-48, -31}, {24, 15}}, textString = "COMPRESSOR")}));
	end CompressorOnShaft;


