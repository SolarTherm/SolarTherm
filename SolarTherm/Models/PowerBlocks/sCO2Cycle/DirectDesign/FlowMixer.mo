within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
	model FlowMixer "This model is useful for the recompression cycle cycle, as it allows to mix two different fluid. The pressure in both should entrance should be the same; in case it is not, we ponderated it by the mass flows: as it is the same molar mass, the resulting pressure should look like that."
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedRec = SolarTherm.Media.CO2.CO2_ph;
		Modelica.Fluid.Interfaces.FluidPort_a first_port_a(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_a second_port_a(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {4.44089e-16, 60}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
		Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = MedRec) annotation(
			Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, -8.88178e-16}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
	equation
		port_b.m_flow = -(first_port_a.m_flow + second_port_a.m_flow);
		port_b.h_outflow = (first_port_a.m_flow * inStream(first_port_a.h_outflow) + second_port_a.m_flow * inStream(second_port_a.h_outflow)) / (first_port_a.m_flow + second_port_a.m_flow);
		port_b.p = (first_port_a.m_flow * first_port_a.p + second_port_a.m_flow * second_port_a.p) / (first_port_a.m_flow + second_port_a.m_flow);
		first_port_a.h_outflow = inStream(port_b.h_outflow);
		second_port_a.h_outflow = inStream(port_b.h_outflow);
		annotation(
			Diagram(graphics = {Text(origin = {11, -13}, extent = {{-39, -17}, {19, 3}}, textString = "MIXER"), Rectangle(origin = {1, 10}, extent = {{-61, 30}, {59, -50}}), Line(origin = {0, 30}, points = {{0, 30}, {0, -30}, {0, -30}}), Line(points = {{-80, 0}, {80, 0}, {80, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {4, 4}, {0, -4}, {-4, 4}, {-4, 4}}), Polygon(origin = {-30, 0}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {30, -1}, points = {{-4, 5}, {-4, -3}, {4, 1}, {4, 1}, {-4, 5}})}, coordinateSystem(initialScale = 0.1)),
			Icon(graphics = {Text(origin = {-4, -14}, extent = {{-22, -16}, {30, 4}}, textString = "MIXER"), Rectangle(extent = {{-60, 40}, {60, -40}}), Line(points = {{-80, 0}, {80, 0}, {80, 0}}), Line(origin = {0, 30}, points = {{0, 30}, {0, -30}, {0, -30}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {4, 4}, {0, -4}, {-4, 4}, {-4, 4}}), Polygon(origin = {-30, 0}, points = {{-4, 4}, {-4, -4}, {4, 0}, {4, 0}, {-4, 4}}), Polygon(origin = {30, 0}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}})}, coordinateSystem(initialScale = 0.1)));
	end FlowMixer;
