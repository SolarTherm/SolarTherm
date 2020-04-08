within SolarTherm.Models.PowerBlocks.sCO2_cycle;
model Compressor "zero dimmensional compressor model"
	import SI = Modelica.SIunits;
	import Modelica.SIunits.Conversions.*;

	replaceable package Medium = SolarTherm.Media.CarbonDioxide;

	parameter String fluid = "R744" "Compressor working fluid";
	parameter SI.Efficiency eta_design = 0.89 "Maximal isentropic efficiency of the compressor";
	parameter SI.AngularVelocity n_shaft = 40000 * 0.104 "Compressor rotational speed at design";
	parameter SI.Efficiency phi_des = 0.0297035 "Optimal dimmensionless mass flow rate at design";
	parameter SI.Efficiency psi_des(fixed = false) "Dimmensionless head at design";
	parameter SI.Efficiency PR = 3 "Compressor pressure ratio";

	parameter SI.MassFlowRate m_flow_des = 1000 "design mass flow rate in kg/s";
	parameter SI.Power W_comp_des(fixed = false) "Compressor power input at design";
	parameter SI.Diameter D_rotor(fixed = false) "Compressor rotor diameter";
	parameter SI.Velocity v_tip_des(fixed = false) "Compressor tip velocity at design";

	parameter SI.Pressure p_out_des = 24e6 "Outlet pressure at design";
	parameter SI.SpecificEnthalpy h_out_des(fixed = false) "Outlet enthalpy of the compressor";
	parameter SI.SpecificEnthalpy h_out_isen_des(fixed = false) "Outlet isentropic enthalpy of the compressor";

	parameter SI.Pressure p_in_des = p_out_des/PR "Compressor inlet pressure at design";
	parameter SI.Temperature T_in_des = from_degC(40) "Compressor inlet temperature at design";
	parameter SI.SpecificEnthalpy h_in_des(fixed = false) "Inlet enthalpy of the compressor";
	parameter SI.SpecificEntropy s_in_des(fixed = false) "Inlet entropy at design";
	parameter SI.Density rho_in_des(fixed = false) "Inlet Density at design";

	SI.Efficiency eta_comp(start = eta_design) "Compressor isentropic efficiency";
	SI.Efficiency phi(start = phi_des) "Dimmensionless mass flow rate";
	SI.Efficiency psi(start = psi_des) "Dimmensionless head";
	SI.Power W_comp "Compressor power input";
	SI.Pressure p_out(start = p_out_des) "Compressor outlet pressure";
	SI.SpecificEnthalpy h_out_isen(start = h_out_isen_des) "Compressor outlet insentropic entropy";
	SI.SpecificEnthalpy h_out(start = h_out_des) "Compressor outlet enthalpy";
	SI.Pressure p_in(start = p_in_des) "Compressor inlet pressure";
	SI.SpecificEnthalpy h_in(start = h_in_des) "Compressor inlet enthalpy";
	SI.SpecificEntropy s_in(start = s_in_des) "Compressor inlet entropy";
	SI.Density rho_in(start = rho_in_des) "Compressor inlet density";
	
	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

initial algorithm
	h_in_des := SolarTherm.Utilities.CoolProp.stprops("H","T",T_in_des,"P",p_in_des,fluid);
	s_in_des := SolarTherm.Utilities.CoolProp.stprops("S","T",T_in_des,"P",p_in_des,fluid);
	h_out_isen_des := SolarTherm.Utilities.CoolProp.stprops("H","P",p_out_des,"S",s_in_des,fluid);
	h_out_des := h_in_des + (h_out_isen_des - h_in_des)/eta_design;
	rho_in_des := SolarTherm.Utilities.CoolProp.stprops("D","T",T_in_des,"P",p_in_des,fluid);
	W_comp_des := m_flow_des*(h_in_des - h_out_des);
	D_rotor := (2*m_flow_des/(phi_des*rho_in_des*n_shaft))^(1/3);
	v_tip_des := 0.5*D_rotor*n_shaft;
	psi_des := (h_out_isen_des - h_in_des)/v_tip_des^2;

equation
	//Mass balance
	port_a.m_flow - port_b.m_flow = 0;

	//Inlet and outlet pressure
	p_in = port_a.p;
	p_out = port_b.p;

	//Inlet and outlet enthalpies
	h_in = inStream(port_a.h_outflow);
	s_in = SolarTherm.Utilities.CoolProp.stprops("S","P",p_in,"H",h_in,fluid);
	rho_in = SolarTherm.Utilities.CoolProp.stprops("D","P",p_in,"H",h_in,fluid);	
	p_out = SolarTherm.Utilities.CoolProp.stprops("P","H",h_out_isen,"S",s_in,fluid);
	h_out = h_in + (h_out_isen - h_in)/eta_comp;
	port_b.h_outflow = h_out;

	//Dimmensionless mass flow rate and head
	phi = port_a.m_flow / (rho_in * v_tip_des * D_rotor ^ 2);
	psi = (0.04049 + 54.7*phi - 2505*phi^2 + 53224*phi^3 - 498626*phi^4) * psi_des / 0.46181921979961293;
	eta_comp = (-0.7069 + 168.6*phi - 8089*phi^2 + 182725*phi^3 - 1.638e6*phi^4) * eta_design / 0.677837;
	h_out_isen = h_in + psi * v_tip_des ^ 2;
	W_comp = port_a.m_flow * (h_out - h_in);

	//Should not have reverse flow
	port_a.h_outflow = 0.0;
	
annotation(
	Diagram(graphics = {Text(origin = {-8, 16}, extent = {{-28, 16}, {42, -46}}, textString = "Compressor"), Polygon(origin = {-2, 10}, rotation = 180, points = {{-42, 40}, {-42, -20}, {38, -50}, {38, 70}, {-42, 40}, {-42, 40}}), Line(origin = {50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {-50, -40.1649}, points = {{10, 0}, {-10, 0}, {-10, 0}})}, coordinateSystem(initialScale = 0.1)),
	Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {0, 2}, rotation = 180, points = {{-40, 32}, {-40, -28}, {40, -58}, {40, 62}, {-40, 32}}), Text(origin = {22, 17}, extent = {{-48, -31}, {4, -3}}, textString = "COMPRES"), Line(origin = {50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {-50, -40.1649}, points = {{10, 0}, {-10, 0}, {-10, 0}})}),
	Documentation(info = "<html>
	<p>This compressor's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
<p>The performance maps comes from the Sandia National Laboratory first compressor. It should be updated. The performance maps is compressed in three correlations, expressing the adimensionned head and the efficiency as functions of the adimensionned mass flow.&nbsp;</p>
<p>The same correlations are used; only the maximal values are changed.</p>
<p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
</html>"));
end Compressor;
