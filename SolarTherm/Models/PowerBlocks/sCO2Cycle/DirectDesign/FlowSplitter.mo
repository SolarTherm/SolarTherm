within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
model FlowSplitter
	replaceable package MedRec = SolarTherm.Media.CarbonDioxide;
	parameter Modelica.SIunits.Efficiency gamma;
	Modelica.SIunits.Efficiency gamma_var;
	
	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedRec) annotation(
		Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b gamma_port_b(redeclare package Medium = MedRec) annotation(
		Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {0, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b one_gamma_port_b(redeclare package Medium = MedRec) annotation(
		Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
	gamma_var = gamma;
	gamma_port_b.m_flow = -gamma_var * port_a.m_flow;
	one_gamma_port_b.m_flow = -(1 - gamma_var) * port_a.m_flow;
	gamma_port_b.p = port_a.p;
	one_gamma_port_b.p = port_a.p;
	gamma_port_b.h_outflow = inStream(port_a.h_outflow);
	one_gamma_port_b.h_outflow = inStream(port_a.h_outflow);
	port_a.h_outflow = inStream(gamma_port_b.h_outflow);
annotation(
	Diagram(
		coordinateSystem(extent={{-60, -60}, {60, 60}})), 
	Icon(graphics={
			Polygon(origin = {0, 0}, fillPattern = FillPattern.Solid, points = {{0, 0}, {50, 30}, {50, -30}, {0, 0}}), 
			Polygon(origin = {0, 0}, fillPattern = FillPattern.Solid, points = {{0, 0}, {-50, 30}, {-50, -30}, {0, 0}}), 
			Polygon(origin = {0, 0}, fillPattern = FillPattern.Solid, points = {{0, 0}, {-30, 50}, {30, 50}, {0, 0}}),
			Text(origin = {0, -60}, extent={{-150, 20},{150, -20}}, lineColor={0, 0, 255}, textString="%name"),
			Line(origin = {0.439738, -63.9183}, points = {{0, 100}, {0, 70}})},
		coordinateSystem(extent={{-60, -80}, {60, 60}}, preserveAspectRatio=false)));
end FlowSplitter;

