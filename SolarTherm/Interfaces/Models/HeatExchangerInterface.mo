within SolarTherm.Interfaces.Models;
partial model HeatExchangerInterface
	extends SolarTherm.Icons.HeatExchangerIcon;
	replaceable package Medium_h = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph constrainedby
	Modelica.Media.Interfaces.PartialMedium "Medium in hot side";
	replaceable package Medium_c = SolarTherm.Media.CarbonDioxide constrainedby
	Modelica.Media.Interfaces.PartialMedium "Medium in cold side";
	// Hot fluid inlet
	Modelica.Fluid.Interfaces.FluidPort_a port_h_in(redeclare package Medium = Medium_h)
		annotation (Placement(visible = true,transformation(origin = {-26, 35}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0),
		iconTransformation(origin = {-26, 35}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
	// Hot fluid outlet
	Modelica.Fluid.Interfaces.FluidPort_b port_h_out(redeclare package Medium = Medium_h)
		annotation (Placement(visible = true,transformation(origin = {-26, -35}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0),
		iconTransformation(origin = {-26, -35}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
	// Cold fluid inlet
	Modelica.Fluid.Interfaces.FluidPort_a port_c_in(redeclare package Medium = Medium_c)
		annotation (Placement(visible = true,transformation(origin = {44, -21}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0),
		iconTransformation(origin = {44, -21}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
	// Cold fluid outlet
	Modelica.Fluid.Interfaces.FluidPort_b port_c_out(redeclare package Medium = Medium_c)
		annotation (Placement(visible = true,transformation(origin = {44, 21}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0),
		iconTransformation(origin = {44, 21}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
	// Variables
	Modelica.SIunits.HeatFlowRate Q_flow;
	annotation(
	Icon(coordinateSystem(extent = {{-40, -40}, {40, 40}})),
	Diagram(coordinateSystem(extent = {{-40, -40}, {40, 40}})));
end HeatExchangerInterface;
