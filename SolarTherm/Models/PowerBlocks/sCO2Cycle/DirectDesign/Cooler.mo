within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
model Cooler
	extends SolarTherm.Icons.HeatExchangerIcon;
	import Modelica.SIunits.Conversions.*;
	input Boolean m_sup;
	input Modelica.SIunits.ThermodynamicTemperature T_amb "Ambiant temperature in Kelvin";

	replaceable package Medium = SolarTherm.Media.CarbonDioxide;

	parameter Modelica.SIunits.Temperature T_amb_des = from_degC(40) "Ambient temperature in Kelvin at design point";
	parameter Modelica.SIunits.ThermalConductance UA_cooler(fixed = false) "Conductance of the cooler in W/K";
	parameter Modelica.SIunits.Temperature T_low = from_degC(55);
	parameter Modelica.SIunits.Power P_nom_des = 164000;
	parameter Integer N_cool = 15;
	parameter Modelica.SIunits.TemperatureDifference deltaT_design = 15 "Difference between ambient and outlet CO2 temperature";
	parameter Modelica.SIunits.ThermalConductance UA_dis[N_cool - 1](each fixed = false) "Conductance of the cooler per sub-HX";
	parameter Modelica.SIunits.Power P_cool_des(fixed = false, start = 0.01 * P_nom_des) "power necessary to cool down at design point";
	parameter Modelica.SIunits.SpecificEnthalpy h_in_des(fixed = false), h_out_des(fixed = false);
	parameter Modelica.SIunits.AbsolutePressure p_in_des(fixed = false);
	parameter Modelica.SIunits.AbsolutePressure p_out_des(fixed = false);
	parameter Modelica.SIunits.MassFlowRate m_des(fixed = false);
	parameter Modelica.SIunits.HeatFlowRate Q_cooler_des(fixed = false, start = 1e6);
	parameter Medium.ThermodynamicState[N_cool] state_des(each p.fixed = false, each h.fixed = false) "Thermodynamic State at the i-th position";
	parameter Modelica.SIunits.SpecificEnthalpy[N_cool] h_CO2_des(each fixed = false, start = {600000 - i / N_cool * 150000 for i in 1:N_cool});
	parameter Real[N_cool] deltaT_des(each fixed = false, each start = 25) "difference with the ambiant air at the inlet and outlet";
	parameter Modelica.SIunits.HeatFlowRate Q_dis_des(fixed = false, start = 1e5) "Heat flow rate dispatched per sub-HX in the cooler";
	parameter Modelica.SIunits.Temperature[N_cool] T_CO2_des(each fixed = false, each start = from_degC(75));

	Medium.ThermodynamicState state_a "Thermodynamic State at the entrance";
	Medium.ThermodynamicState state_b "Thermodynamic State at the outlet";

	Modelica.SIunits.TemperatureDifference[2] deltaT;

	Modelica.SIunits.HeatFlowRate Q_cooler;
	Modelica.SIunits.Power P_cooling;
	
	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium, m_flow.start=P_nom_des/1e5) annotation(
		Placement(visible = true, transformation(origin = {-26, 38}, extent = {{-6, -6}, {6, 6}}, rotation = 0), 
		iconTransformation(origin = {-26, 38}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));

	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {-26, -38}, extent = {{-6, -6}, {6, 6}}, rotation = 0), 
		iconTransformation(origin = {-26, -38}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));

initial equation
	for i in 1:N_cool loop
		state_des[i] = Medium.setState_pTX(p_in_des, T_CO2_des[i]);
		h_CO2_des[i] = Medium.specificEnthalpy(state_des[i]);
		deltaT_des[i] = T_CO2_des[i] - T_amb_des;
	end for;

	T_CO2_des[N_cool] = T_low;
	h_CO2_des[1] = h_in_des;
	h_CO2_des[N_cool] = h_out_des;
	p_out_des = p_in_des;

	for i in 1:N_cool - 1 loop
		Q_dis_des = (h_CO2_des[i + 1] - h_CO2_des[i]);
		m_des * Q_dis_des = -UA_dis[i] * (deltaT_des[i] + deltaT_des[i + 1]) / 2;
	end for;

	UA_cooler = sum(UA_dis);
	Q_cooler_des = (N_cool - 1) * Q_dis_des*m_des;
	P_cool_des = 0.01 * P_nom_des;

equation
	deltaT = {Medium.temperature(state_a) - T_amb, Medium.temperature(state_b) - T_amb};

	state_a = Medium.setState_phX(port_a.p, inStream(port_a.h_outflow));
	state_b = Medium.setState_pTX(port_a.p, max(T_amb + 3, T_low));

	P_cooling=0;

	Q_cooler = port_a.m_flow * (state_b.h - state_a.h);

	port_a.m_flow + port_b.m_flow = 0;
	port_a.p = port_b.p;
	port_b.h_outflow = state_b.h;
	port_a.h_outflow = inStream(port_b.h_outflow);

annotation(
	Icon(coordinateSystem(extent = {{-40, -40}, {40, 40}}, initialScale = 1)),
	Diagram(coordinateSystem(extent = {{-40, -40}, {40, 40}}, initialScale = 1)));
end Cooler;
