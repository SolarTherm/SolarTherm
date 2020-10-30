within SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign;
model FlowSplitter "Split the flow for the cycles with redirection"
	extends SolarTherm.Media.CO2.PropCO2;
	replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
	parameter Real gamma;
	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b gamma_port_b(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {0, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b one_gamma_port_b(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	equation
	gamma_port_b.m_flow = -gamma * port_a.m_flow;
	one_gamma_port_b.m_flow = -(1 - gamma) * port_a.m_flow;
	gamma_port_b.p = port_a.p;
	one_gamma_port_b.p = port_a.p;
	gamma_port_b.h_outflow = inStream(port_a.h_outflow);
	one_gamma_port_b.h_outflow = inStream(port_a.h_outflow);
	port_a.h_outflow = inStream(one_gamma_port_b.h_outflow);
	annotation(
		Icon(graphics = {Text(origin = {0, 10}, extent = {{-56, -16}, {56, 16}}, textString = "SPLITTER")}),
		Diagram(graphics = {Text(origin = {7, 8}, extent = {{-49, -16}, {49, 16}}, textString = "SPLITTER")}));
end FlowSplitter;
