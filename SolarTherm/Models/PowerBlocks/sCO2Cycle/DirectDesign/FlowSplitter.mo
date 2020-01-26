within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
	model FlowSplitter
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedRec = SolarTherm.Media.CO2.CO2_ph;
		parameter Real gamma;
		Real gamma_var;
		Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b gamma_port_b(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 60}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b one_gamma_port_b(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
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
			Icon(graphics = {Text(origin = {16, -12}, extent = {{-56, -16}, {24, 0}}, textString = "SPLITTER"), Rectangle(origin = {-2, 27}, extent = {{-58, 13}, {62, -67}}), Line(points = {{-80, 0}, {80, 0}, {80, 0}}), Line(origin = {0, 30}, points = {{0, 30}, {0, -30}, {0, -30}}), Polygon(origin = {0, 30}, points = {{-4, -4}, {4, -4}, {0, 4}, {-4, -4}, {-4, -4}}), Polygon(origin = {-32, 0}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}}), Polygon(origin = {28, 0}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
			Diagram(graphics = {Text(origin = {15, -14}, extent = {{-49, -16}, {21, 2}}, textString = "SPLITTER"), Rectangle(origin = {0, 10}, extent = {{-60, 30}, {60, -50}}), Line(points = {{80, 0}, {-80, 0}, {-80, 0}}), Line(origin = {0, 30}, points = {{0, -30}, {0, 30}, {0, 30}}), Polygon(origin = {0, 28}, points = {{-4, -4}, {4, -4}, {0, 4}, {0, 4}, {-4, -4}}), Polygon(origin = {-22, 0}, points = {{-4, 4}, {-4, -4}, {-12, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {38, 0}, points = {{-4, 4}, {-4, -4}, {-12, 0}, {-4, 4}, {-4, 4}}), Text(origin = {13, 28}, extent = {{-7, 6}, {7, -6}}, textString = "gamma"), Text(origin = {-25, 10}, extent = {{-17, 6}, {7, -6}}, textString = "1 - gamma")}, coordinateSystem(initialScale = 0.1)));
	end FlowSplitter;

