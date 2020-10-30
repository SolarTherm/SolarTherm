within SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign;
	model Turbine "OD model of a turbine"
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {-32, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-38, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
			Placement(visible = true, transformation(origin = {60, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
		parameter Real eta_design = 0.9 "isentropic efficiency of the turbine";
		parameter Real PR = 2.313 "Pressure ratio";
		parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 273.15 + 40 "Outlet temperature in Kelvin";
		MedPB.ThermodynamicState state_a "thermodynamic state at the entrance";
		MedPB.ThermodynamicState state_isen "thermodynamic state at the end of the isentropic decompression";
		MedPB.ThermodynamicState state_b "thermodynamic state at the end of the real decompresssion";
		Modelica.SIunits.Power W_turb "Outlet power";
		Modelica.SIunits.AbsolutePressure p_out(start = 83.3 * 10 ^ 5);
		//SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
		Modelica.SIunits.SpecificEntropy s_entrance " entropy at the entrance of the turbine";
		parameter Modelica.SIunits.Area A_nozzle = 0.00257;
		parameter Real N_shaft = 10000 * 5 / 6 * 2 * 3.14159 / 60;
		Real d_outlet;
		Real C_spouting(start = 577);
		parameter Real diam_turb = 0.9;
		Real tipSpeed(start = 440);
		Real eta_turb;
	equation
		state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
		s_entrance = MedPB.specificEntropy(state_a);
		state_isen = MedPB.setState_psX(p_out, s_entrance);
		state_b = MedPB.setState_phX(p_out, state_a.h + (state_isen.h - state_a.h) * eta_turb);
		port_b.p = state_b.p;
		port_a.h_outflow = inStream(port_b.h_outflow);
		port_b.h_outflow = state_b.h;
		W_turb = port_a.m_flow * (state_b.h - state_a.h);
		port_a.m_flow + port_b.m_flow = 0;
		d_outlet = MedPB.density(state_b);
		port_a.m_flow = C_spouting * A_nozzle * d_outlet;
		C_spouting ^ 2 = 2 * (state_a.h - state_isen.h);
		tipSpeed = N_shaft * diam_turb / 2;
		eta_turb = eta_design * 2 * (tipSpeed / C_spouting) * sqrt(abs(1 - (tipSpeed / C_spouting) ^ 2));
		annotation(
			Documentation(info = "<html>
			<p>This turbine's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
	<p>The isentropic efficiency is calculated as a function of the tip speed ration between the tip speed of the rotor and the spouting velocity. It is said to be functionnal for any size.</p>
	<p>The outlet pressure goes beyond the critical pressure for a mass flow too small. The cycle calculation should therefore not be performed below this pressure.</p>
	<p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
			</html>"));
		annotation(
			Diagram(graphics = {Text(origin = {-36, -28}, extent = {{18, 80}, {78, 16}}, textString = "TURBINE"), Polygon(origin = {15, 20}, points = {{-35, 44}, {-35, -52}, {35, -68}, {35, 68}, {-35, 44}, {35, 68}, {-35, 44}})}, coordinateSystem(initialScale = 0.1)),
			Icon(graphics = {Text(origin = {-10, 26}, extent = {{-10, 12}, {52, -34}}, textString = "TURBINE"), Ellipse(extent = {{56, 58}, {56, 58}}, endAngle = 360), Polygon(origin = {11, 17}, points = {{-37, 49}, {-37, -51}, {37, -71}, {37, 71}, {-37, 49}})}, coordinateSystem(initialScale = 0.1)));
	end Turbine;

