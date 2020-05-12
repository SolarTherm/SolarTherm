within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
model CompressorOnShaft "0D model of a compressor on the same shaft as the turbine"
	extends SolarTherm.Interfaces.Models.Compressor;
	import SI = Modelica.SIunits;
	import Modelica.SIunits.Conversions.*;

	replaceable package Medium = SolarTherm.Media.CarbonDioxide;

	parameter SI.Efficiency eta_design = 0.89 "Maximal isentropic efficiency of the compressor";
	parameter SI.AngularVelocity N_design = 40000 * 0.104 "Design rotationnal speed in rad/s";
	parameter SI.Efficiency PR = 3 "pressure ratio chosen";
	parameter SI.Power P_nom_des "nominal power at design point";
	parameter SI.ThermodynamicTemperature T_in_des = from_degC(45) "chosen inlet temperature of the compressor at design point";
	parameter SI.AbsolutePressure p_high_des = from_bar(250);
	parameter SI.Efficiency phi_opt = 0.0297035 "optimal adimensionned mass flow";
	parameter SI.Efficiency psi_des(fixed = false) "on-design adimensionned head";
	parameter SI.AngularVelocity tipSpeed(fixed = false, start = 500) "tip Speed of the rotor";
	parameter SI.Diameter diam_rotor(fixed = false) "on-design diameter of the rotor";
	parameter SI.SpecificEnthalpy h_in_des(fixed = false) "Inlet enthalpy of the compressor";
	parameter SI.SpecificEnthalpy h_out_des(fixed = false) "Outlet enthalpy of the compressor";
	parameter Medium.ThermodynamicState state_in_des(p.fixed = false, h.fixed = false, h.start = 550000);
	parameter Medium.ThermodynamicState state_isen_des(p.fixed = false, h.fixed = false);
	parameter SI.AbsolutePressure p_in_des(fixed = false);
	parameter SI.AbsolutePressure p_out_des(fixed = false);
	parameter SI.Power W_comp_des(fixed = false);
	parameter SI.MassFlowRate m_des(fixed = false, start = 3) "design mass flow rate in kg/s";

	SI.AbsolutePressure p_out(start = p_out_des) "outlet pressure";
	Medium.ThermodynamicState state_a "thermodynamic state at the entrance";
	Medium.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic compression";
	Medium.ThermodynamicState state_b "thermodynamic state at the end of the real compresssion";
	SI.Power W_comp "power used for compression";
	SI.SpecificEntropy s_entrance "entropy at the entrance of the compressor";
	SI.Density d_entrance(start = 267) "density at the inlet";
	SI.Efficiency eta_comp(start = eta_design) "isentropic efficiency of the compressor";
	SI.Efficiency phi "adimensionned mass flow rate";
	SI.Efficiency psi "adimensionned head";

initial equation
	2 * m_des = phi_opt * Medium.density(state_in_des) * N_design * diam_rotor ^ 3;
	psi_des = (state_isen_des.h - state_in_des.h) / tipSpeed ^ 2;
	W_comp_des = m_des * (h_out_des - state_in_des.h);
	p_out_des = p_high_des;
	state_in_des = Medium.setState_phX(p_in_des, h_in_des);
	state_isen_des = Medium.setState_psX(p_out_des, Medium.specificEntropy(state_in_des));
	tipSpeed = diam_rotor * N_design / 2;
	h_out_des = state_in_des.h + (state_isen_des.h - state_in_des.h) / eta_design;

equation
	state_a = Medium.setState_phX(port_a.p, inStream(port_a.h_outflow));
	s_entrance = Medium.specificEntropy(state_a);
	state_isen = Medium.setState_psX(p_out, s_entrance);
	state_b = Medium.setState_phX(p_out, state_a.h + (state_isen.h - state_a.h) / eta_comp);
	port_b.p = state_b.p;
	port_b.h_outflow = state_b.h;
	W_comp = port_a.m_flow * (state_b.h - state_a.h);
	port_a.h_outflow = 0;
	d_entrance = Medium.density(state_a);
	port_a.m_flow + port_b.m_flow = 0;
	phi = port_a.m_flow / (d_entrance * tipSpeed * diam_rotor ^ 2);
	psi = (state_isen.h - state_a.h) / tipSpeed ^ 2;
	psi = (0.04049 + 54.7 * phi - 2505 * phi ^ 2 + 53224 * phi ^ 3 - 498626 * phi ^ 4) * psi_des / 0.46181921979961293;
	eta_comp = eta_design / 0.677837 * ((-0.7069) + 168.6 * phi - 8089 * phi ^ 2 + 182725 * phi ^ 3 - 1.638 * 10 ^ 6 * phi ^ 4);

annotation(
	Icon(coordinateSystem(extent = {{-60, -60}, {60, 60}}, initialScale = 1)),
	Diagram(coordinateSystem(extent = {{-60, -60}, {60, 60}}, initialScale = 1)));
end CompressorOnShaft;
