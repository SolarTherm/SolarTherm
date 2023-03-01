within SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign;
	model Heater "Simple heater model"
	extends SolarTherm.Media.CO2.PropCO2;
	replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
	parameter Modelica.SIunits.ThermodynamicTemperature T_high = 273.15 + 715 "Outlet temperature in Kelvin";
	parameter Modelica.SIunits.ThermodynamicTemperature T_amb = 273.15 + 40 "Outlet temperature in Kelvin";
	Modelica.SIunits.HeatFlowRate Q_heater "heat transfer in the heater";
	MedPB.ThermodynamicState state_a "Thermodynamic State at the entrance";
	MedPB.ThermodynamicState state_b "Thermodynamic State at the outlet";
	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {-2, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	SolarTherm.Types.SpecificExergy ex_d "destroyed exergy";
	equation
	state_a = MedPB.setState_phX(port_a.p, inStream(port_a.h_outflow));
	state_b = MedPB.setState_pTX(port_a.p, T_high);
	Q_heater = port_a.m_flow * (MedPB.specificEnthalpy(state_b) - MedPB.specificEnthalpy(state_a));
	//port_a.m_flow + port_b.m_flow = 0;
	port_b.p = port_a.p;
	port_b.h_outflow = MedPB.specificEnthalpy(state_b);
	port_a.h_outflow = inStream(port_b.h_outflow);
	ex_d = Q_heater * (1 - T_amb / T_high) + port_a.m_flow * (state_a.h - T_amb * MedPB.specificEntropy(state_a)) + port_b.m_flow * (state_b.h - T_amb * MedPB.specificEntropy(state_b));
	annotation(
		Documentation(info = "<html>
			<p> This heater is useful to perform quicker on-design analysis of the cycles. </p>
			</html>"),
		Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {0, -2}, extent = {{-48, 62}, {48, -62}}), Text(origin = {2, -2}, extent = {{-36, 12}, {36, -12}}, textString = "HEATER")}),
		Diagram(graphics = {Rectangle(origin = {2, 6}, extent = {{-44, 64}, {44, -64}}), Text(origin = {-30, 1}, extent = {{0, -1}, {64, 25}}, textString = "HEATER", fontSize = 15)}),
		__OpenModelica_commandLineOptions = "");
end Heater;
