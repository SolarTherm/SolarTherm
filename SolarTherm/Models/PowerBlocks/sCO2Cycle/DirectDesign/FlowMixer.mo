within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
model FlowMixer
	replaceable package Medium = SolarTherm.Media.CarbonDioxide;
	
	Modelica.Fluid.Interfaces.FluidPort_a first_port_a(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {-100, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
	
	Modelica.Fluid.Interfaces.FluidPort_a second_port_a(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {0, 100}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
	
	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {100, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

equation
	port_b.m_flow = -(first_port_a.m_flow + second_port_a.m_flow);
	
	port_b.h_outflow = (first_port_a.m_flow * inStream(first_port_a.h_outflow) + second_port_a.m_flow * inStream(second_port_a.h_outflow)) / (first_port_a.m_flow + second_port_a.m_flow);
	port_b.p = (first_port_a.m_flow * first_port_a.p + second_port_a.m_flow * second_port_a.p) / (first_port_a.m_flow + second_port_a.m_flow);
	
	first_port_a.h_outflow = inStream(port_b.h_outflow);
	second_port_a.h_outflow = inStream(port_b.h_outflow);

annotation(Icon(coordinateSystem(
		preserveAspectRatio=true,
		extent={{-100,-100},{100,100}}), graphics={
		Rectangle(
			extent={{-100,44},{100,-44}},
			lineColor={0,0,0},
			fillPattern=FillPattern.HorizontalCylinder,
			fillColor={0,127,255}),
		Text(
			extent={{-150,-89},{150,-129}},
			lineColor={0,0,255},
			textString="%name"),
		Rectangle(
			extent={{-44,100},{44,44}},
			lineColor={0,0,0},
			fillPattern=FillPattern.VerticalCylinder,
			fillColor={0,127,255}),
		Rectangle(
			extent={{-22,82},{21,-4}},
			fillPattern=FillPattern.Solid,
			fillColor={0,128,255},
			pattern=LinePattern.None,
			lineColor={0,0,0})}));
end FlowMixer;
