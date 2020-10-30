within SolarTherm.Interfaces.Models;
partial model Turbine
	extends SolarTherm.Icons.Turbine;
	replaceable package Medium = SolarTherm.Media.CarbonDioxide;
	// Inlet fluid port
	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {-40, 30}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
	// Outlet fluid port
	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {40, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), 
		iconTransformation(origin = {40, -60}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
annotation(
	Diagram(	coordinateSystem(extent = {{-40, -60}, {40, 60}})),
	Icon(coordinateSystem(extent = {{-40, -60}, {40, 60}})));
end Turbine;
