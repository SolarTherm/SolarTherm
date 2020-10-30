within SolarTherm.Models.PowerBlocks.sCO2Cycle;
model SinkFlow
	extends SolarTherm.Media.CO2.PropCO2;
	replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
	Modelica.Fluid.Interfaces.FluidPort_a port_a (redeclare package Medium=MedPB) annotation(
		Placement(visible = true, transformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
	
equation
	port_a.h_outflow=0;
	
end SinkFlow;
