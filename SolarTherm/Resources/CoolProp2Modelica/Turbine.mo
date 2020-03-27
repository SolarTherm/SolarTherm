model Turbine "Off-design turbine model"
	import Modelica.SIunits.Conversions.*;
	import SI = Modelica.SIunits;

	replaceable package Medium = CarbonDioxide_ph;

	//Design Parameters
	parameter String fluid = "R744" "Turbine working fluid (default: CO2)";
	parameter SI.Power W_turb_des = 100e6 "Turbine power output at design";
	parameter SI.Temperature T_in_des = from_degC(715) "Turbine inlet temperature at design";
	parameter SI.Pressure p_in_des = 24e6 "Turbine inlet pressure at design";
	parameter SI.Pressure p_out_des = p_in_des/PR "Turbine outlet pressure at design";
	parameter SI.Efficiency eta_design = 0.9 "Turbine isentropic efficiency at design";
	parameter SI.Efficiency PR = 3 "Turbine pressure ratio at design";
	parameter SI.AngularVelocity n_shaft = 3358 "Turbine rotational speed at design";
	parameter SI.Area A_nozzle(fixed = false) "Turbine nozzle area";
	parameter SI.Diameter d_turb(fixed = false) "Turbine diameter";
	parameter SI.Velocity v_tip_des(fixed = false) "Turbine tip velocity at design";
	parameter SI.SpecificEnthalpy h_in_des(fixed = false) "Turbine inlet enthalpy at design";
	parameter SI.SpecificEntropy s_in_des(fixed = false) "Turbine inlet entropy at design";
	parameter SI.SpecificEnthalpy h_out_des(fixed = false) "Turbine outlet enthalpy at design";
	parameter SI.SpecificEnthalpy h_out_isen_des(fixed = false) "Turbine outlet isentropic enthalpy at design";
	parameter SI.Density rho_out_des(fixed = false) "Turbine outlet density at design";
	parameter SI.Velocity C_spouting_des(fixed = false) "Turbine spouting velocity at design";
	parameter SI.MassFlowRate m_flow_des(fixed = false) "Turbine mass flow rate at design";

	//Dynamic variables
	SI.AbsolutePressure p_in(start = p_in_des) "Turbine inlet pressure";
	SI.AbsolutePressure p_out(start = p_out_des) "Turbine outlet pressure";
	SI.SpecificEnthalpy h_in "Turbine inlet enthalpy";
	SI.SpecificEntropy s_in "Turbine inlet entropy";
	SI.SpecificEnthalpy h_out_isen "Turbine outlet isentropic enthalpy";
	SI.SpecificEnthalpy h_out "Turbine outlet enthalpy";
	SI.Density rho_out "Turbine outlet density";
	SI.Velocity C_spouting(start = C_spouting_des) "Turbine spouting velocity";
	SI.Efficiency eta_turb "Turbine efficiency";
	SI.Power W_turb "Turbine power output";

	//Inlet and outlet fluid ports
	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {-60, 20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

initial algorithm
	h_in_des := stprops("H","T",T_in_des,"P",p_in_des,fluid);
	s_in_des := stprops("S","T",T_in_des,"P",p_in_des,fluid);
	h_out_isen_des := stprops("H","P",p_out_des,"S",s_in_des,fluid);
	h_out_des := h_in_des - (h_in_des - h_out_isen_des) * eta_design;
	rho_out_des := stprops("D","P",p_out_des,"H",h_out_des,fluid);
	m_flow_des := W_turb_des/(h_in_des - h_out_des);
	C_spouting_des := sqrt(2 * (h_in_des - h_out_isen_des));
	A_nozzle := m_flow_des/(C_spouting_des*rho_out_des);
	v_tip_des := 0.707*C_spouting_des;
	d_turb := v_tip_des/(0.5*n_shaft);

equation
	//Mass balance
	port_a.m_flow - port_b.m_flow = 0;
	//port_b.m_flow = C_spouting * A_nozzle * rho_out;

	//Inlet and outlet pressure
	p_in = port_a.p;
	p_out = port_b.p;
	p_out = p_in/PR;

	//Inlet and outlet enthalpies
	h_in = inStream(port_a.h_outflow);
	s_in = stprops("S","P",p_in,"H",h_in,fluid);
	h_out_isen = stprops("H","P",p_out,"S",s_in,fluid);
	h_out = h_in - (h_in - h_out_isen) * eta_turb;
	port_b.h_outflow = h_out;
	rho_out = stprops("D","P",p_in,"H",h_out,fluid);

	//Spouting velocity and turbine power output
	C_spouting = sqrt(2 * (h_in - h_out_isen));
	eta_turb = 2*eta_design*(v_tip_des/C_spouting)*sqrt(1 - (v_tip_des/C_spouting)^2);
	W_turb = port_a.m_flow * (h_in - h_out);
	
	//Should not have reverse flow
	port_a.h_outflow = 0.0;

annotation(
	Documentation(info = "<html>
	<p>This turbine's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
	<p>The isentropic efficiency is calculated as a function of the tip speed ration between the tip speed of the rotor and the spouting velocity. It is said to be functionnal for any size.</p>
	<p>The outlet pressure goes beyond the critical pressure for a mass flow too small. The cycle calculation should therefore not be performed below this pressure.</p>
	<p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>

	</html>"),
	Diagram(graphics = {Text(origin = {-48, -48}, extent = {{18, 80}, {78, 16}}, textString = "TURBINA"), Polygon(origin = {0, -10}, points = {{-40, 40}, {-40, -20}, {40, -50}, {40, 70}, {-40, 40}, {-40, 40}}), Line(origin = {-50, 20}, points = {{-10, 0}, {10, 0}, {10, 0}}), Line(origin = {50.111, -40.1649}, points = {{-10, 0}, {10, 0}, {10, 0}})}, coordinateSystem(initialScale = 0.1)),
	Icon(graphics = {Text(origin = {-20, 12}, extent = {{-10, 12}, {52, -34}}, textString = "TURBINA"), Ellipse(extent = {{56, 58}, {56, 58}}, endAngle = 360), Polygon(origin = {11, 7}, points = {{-51, 23}, {-51, -37}, {29, -67}, {29, 53}, {-51, 23}}), Line(origin = {-50, 20}, points = {{10, 0}, {-10, 0}, {-10, 0}}), Line(origin = {50, -39.8501}, points = {{-10, 0}, {10, 0}, {10, 0}})}, coordinateSystem(initialScale = 0.1)));
end Turbine;

