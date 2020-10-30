within SolarTherm.Interfaces.Models;
partial model Compressor
	extends SolarTherm.Icons.Compressor;
	replaceable package Medium = SolarTherm.Media.CarbonDioxide;
	// Inlet fluid port
	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {-40, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { -40,-60}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
	// Outlet fluid port
	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 30}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

end Compressor;
