within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
model Turbine "OD model of a turbine"
	extends SolarTherm.Interfaces.Models.Turbine;
	import Modelica.SIunits.Conversions.*;
	replaceable package Medium = SolarTherm.Media.CarbonDioxide;

	parameter Modelica.SIunits.Efficiency eta_design = 0.9 "isentropic efficiency of the turbine";
	parameter Modelica.SIunits.Efficiency PR = 3 "Pressure ratio";
	parameter Modelica.SIunits.Temperature T_amb = from_degC(40) "Outlet temperature";
	parameter Modelica.SIunits.Area A_nozzle(fixed = false);
	parameter Modelica.SIunits.AngularVelocity N_shaft = 3358;
	parameter Modelica.SIunits.Diameter diam_turb(fixed = false);
	parameter Modelica.SIunits.Velocity tipSpeed_des(fixed = false);

	Modelica.SIunits.Efficiency eta_turb "efficiency of the turbine";
	Modelica.SIunits.Density d_outlet;
	Modelica.SIunits.Velocity C_spouting(start = C_spouting_des);
	Medium.ThermodynamicState state_a (h.start=h_in_des) "thermodynamic state at the entrance";
	Medium.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic decompression";
	Medium.ThermodynamicState state_b "thermodynamic state at the end of the real decompresssion";

	parameter Medium.ThermodynamicState state_in_des(p.fixed = false, h.fixed = false, h.start = 1.2e6);
	parameter Medium.ThermodynamicState state_isen_des(p.fixed = false, h.fixed = false);
	parameter Medium.ThermodynamicState state_out_des(p.fixed = false, h.fixed = false, h.start = 9e5);
	parameter Modelica.SIunits.SpecificEnthalpy h_in_des(fixed = false);
	parameter Modelica.SIunits.SpecificEnthalpy h_out_des(fixed = false);
	parameter Modelica.SIunits.AbsolutePressure p_in_des(fixed = false);
	parameter Modelica.SIunits.AbsolutePressure p_out_des(fixed = false, start = 80e5);
	parameter Modelica.SIunits.Velocity C_spouting_des(fixed = false, start = 500);
	parameter Modelica.SIunits.MassFlowRate m_des(fixed = false);
	parameter Modelica.SIunits.Power W_turb_des(fixed = false);

	Modelica.SIunits.Power W_turb "Outlet power";
	Modelica.SIunits.AbsolutePressure p_out(start = p_out_des);
	Modelica.SIunits.SpecificEntropy s_entrance " entropy at the entrance of the turbine";

initial equation
	state_in_des = Medium.setState_phX(p_in_des, h_in_des);
	state_isen_des = Medium.setState_psX(p_in_des / PR, Medium.specificEntropy(state_in_des));

	h_out_des = state_in_des.h + (state_isen_des.h - state_in_des.h) * eta_design;
	p_out_des = p_in_des / PR;

	state_out_des.p = p_out_des;
	state_out_des.h = h_out_des;

	C_spouting_des ^ 2 = 2 * (state_in_des.h - state_isen_des.h);
	m_des = C_spouting_des * A_nozzle * Medium.density(state_out_des);

	W_turb_des = m_des * (h_out_des - state_in_des.h);
	tipSpeed_des = N_shaft * diam_turb / 2;
	tipSpeed_des / C_spouting_des = 0.707;

equation
	state_a = Medium.setState_phX(port_a.p, inStream(port_a.h_outflow));
	s_entrance = Medium.specificEntropy(state_a);

	state_isen = Medium.setState_psX(p_out, s_entrance);
	state_b = Medium.setState_phX(p_out, state_a.h + (state_isen.h - state_a.h) * eta_turb);

	port_b.p = state_b.p;
	port_a.h_outflow = inStream(port_b.h_outflow);
	port_b.h_outflow = state_b.h;

	W_turb = port_a.m_flow * (state_b.h - state_a.h);

	port_a.m_flow + port_b.m_flow = 0;
	d_outlet = Medium.density(state_b);
	port_a.m_flow = C_spouting * A_nozzle * d_outlet;
	C_spouting ^ 2 = 2 * (state_a.h - state_isen.h);

	eta_turb = eta_design * 2 * (tipSpeed_des / C_spouting) * sqrt(1 - (tipSpeed_des / C_spouting) ^ 2);

annotation(
	Icon(coordinateSystem(initialScale = 1, extent = {{-60, -60}, {60, 60}})),
	Diagram(coordinateSystem(initialScale = 1, extent = {{-60, -60}, {60, 60}})));
end Turbine;
