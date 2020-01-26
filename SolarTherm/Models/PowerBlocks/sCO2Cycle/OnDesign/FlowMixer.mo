within SolarTherm.Models.PowerBlocks.sCO2Cycle.OnDesign;
model FlowMixer "Mixes the flows at the inlet. Thermodynamic values are calculated through a ponderation with the mass flows."
	extends SolarTherm.Media.CO2.PropCO2;
	replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
	Modelica.Fluid.Interfaces.FluidPort_a first_port_a(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {0, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_a second_port_a(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedPB) annotation(
		Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	equation
	port_b.m_flow = -(first_port_a.m_flow + second_port_a.m_flow);
	port_b.h_outflow = (first_port_a.m_flow * inStream(first_port_a.h_outflow) + second_port_a.m_flow * inStream(second_port_a.h_outflow)) / (first_port_a.m_flow + second_port_a.m_flow);
	port_b.p = (first_port_a.m_flow * first_port_a.p + second_port_a.m_flow * second_port_a.p) / (first_port_a.m_flow + second_port_a.m_flow);
	first_port_a.h_outflow = inStream(port_b.h_outflow);
	second_port_a.h_outflow = inStream(port_b.h_outflow);
	annotation(
		Diagram(graphics = {Text(origin = {3, 13}, extent = {{-39, -17}, {39, 17}}, textString = "MIXER")}),
		Icon(graphics = {Text(origin = {6, 14}, extent = {{-44, -28}, {44, 28}}, textString = "MIXER")}));
end FlowMixer;
