within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
	model CompressorToDiscuss
		extends SolarTherm.Media.CO2.PropCO2;
		import SI= Modelica.SIunits;
		import CV = Modelica.SIunits.Conversions;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {42, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		parameter Real eta_design = 0.87 "Maximal isentropic efficiency of the compressor";
		parameter Real PR = 2.313 "Pressure ratio";
		parameter SI.AbsolutePressure p_high_des = 250 * 10 ^ 5 "outlet pressure";
		parameter Real phi_opt = 0.0297035 "optimal adimensionned mass flow";
		
		MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
		MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic compression";
		MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real compresssion";
		SI.Power W_comp "power used for compression";
		SI.AbsolutePressure p_out (start=p_out_des);
		SI.SpecificEntropy s_entrance "exergy at the entrance of the compressor";
		
		Real phi;
		Real psi;
		SI.Velocity tipSpeed (start=tipSpeed_des);
		
		parameter SI.AngularVelocity N_design (fixed=false);
		parameter SI.Velocity tipSpeed_des (fixed=false);
		SI.AngularVelocity N_compressor(start = N_design);
		Real d_entrance(start = 344);
		Real eta_comp(start = eta_design);
		parameter SI.SpecificEnthalpy h_out_des(fixed = false), h_in_des(fixed = false) "enthalpy at the outlet of the compressor";
		parameter MedPB.ThermodynamicState state_in_des(p.fixed = false, h.fixed = false);
		parameter MedPB.ThermodynamicState state_isen_des(p.fixed = false, h.fixed = false);
		parameter SI.AbsolutePressure p_in_des(fixed = false), p_out_des(fixed = false);
		parameter SI.Power W_comp_des(fixed = false);
		parameter SI.MassFlowRate m_des(fixed = false, start = 3) "design mass flow rate in kg/s";	
		parameter Real psi_des(fixed = false) "on-design adimensionned head";
		parameter SI.Diameter diam_rotor(fixed = false) "on-design diameter of the rotor";
		Real Nratio;
		Real deltaHi;
		parameter Real deltaHi_des (fixed=false);
	protected
		
	initial equation
		2 * m_des = phi_opt * MedPB.density(state_in_des) * N_design * diam_rotor ^ 3;
		psi_des = (state_isen_des.h - state_in_des.h) / tipSpeed_des ^ 2;
		W_comp_des = m_des * (h_out_des - state_in_des.h);
		state_in_des = MedPB.setState_phX(p_in_des, h_in_des);
		p_out_des = p_high_des;
		tipSpeed_des=diam_rotor*N_design/2;
		state_isen_des = MedPB.setState_psX(p_out_des, MedPB.specificEntropy(state_in_des));
		h_out_des = state_in_des.h + (state_isen_des.h - state_in_des.h) / eta_design;
		deltaHi_des=state_isen_des.h - state_in_des.h;
	equation
		state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
		s_entrance = MedPB.specificEntropy(state_a);
		state_isen = MedPB.setState_psX(p_out, s_entrance);
		state_b = MedPB.setState_phX(p_out, state_a.h + (state_isen.h - state_a.h) / eta_comp);
		port_b.p = state_b.p;
		port_b.h_outflow = state_b.h;
		port_a.h_outflow = 0;
		
		W_comp = port_a.m_flow * (state_b.h - state_a.h);
	port_a.m_flow + port_b.m_flow = 0;


	d_entrance = MedPB.density(state_a);
// Compressor on-design parameters to be calculated
	
	tipSpeed = diam_rotor * N_compressor / 2;
		
	
	phi = port_a.m_flow / (d_entrance * tipSpeed * diam_rotor ^ 2) * (N_compressor / N_design) ^ (1 / 5);
	psi = (state_isen.h - state_a.h)* (( N_compressor/N_design) ^ ((20 * phi) ^ 3)) / tipSpeed ^ 2 ;
Nratio=( N_compressor/N_design);
deltaHi=psi*tipSpeed^2/(( N_compressor/N_design) ^ ((20 * phi) ^ 3));
	psi = (0.04049 + 54.7 * phi - 2505 * phi ^ 2 + 53224 * phi ^ 3 - 498626 * phi ^ 4) * psi_des / 0.46181921979961293;
	eta_comp = eta_design / 0.677837 * (abs((-0.7069) + 168.6 * phi - 8089 * phi ^ 2 + 182725 * phi ^ 3 - 1.638 * 10 ^ 6 * phi ^ 4)) * (N_compressor/N_design) ^ ((20 * phi) ^ 5);

		annotation(
			Diagram(graphics = {Text(origin = {-20, 18}, extent = {{-28, 16}, {42, -46}}, textString = "COMPRESSOR"), Polygon(origin = {-12, 10}, points = {{-42, 40}, {-42, -44}, {42, -70}, {42, 70}, {-42, 40}, {-42, 40}})}, coordinateSystem(initialScale = 0.1)),
			Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-26, -2}, points = {{-40, 42}, {-42, -48}, {42, -78}, {42, 78}, {-40, 42}}), Text(origin = {-16, 11}, extent = {{-48, -31}, {24, 15}}, textString = "COMPRESSOR")}));
	end CompressorToDiscuss;

