within SolarTherm.Interfaces.Models;
partial model PartialFourPort "Partial model with four ports"

	import CN = Modelica.Constants;
	import SI = Modelica.SIunits;

	replaceable package Medium1 = SolarTherm.Media.MoltenSalt.MoltenSalt_ph constrainedby
		Modelica.Media.Interfaces.PartialMedium "Medium in one side"
		annotation (choicesAllMatching = true,Dialog(group="Working fluid"));

	replaceable package Medium2 = SolarTherm.Media.MoltenSalt.MoltenSalt_ph constrainedby
		Modelica.Media.Interfaces.PartialMedium "Medium in the other side"
		annotation (choicesAllMatching = true,Dialog(group="Working fluid"));

	parameter Boolean allowFlowReversal1 = false
		"= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1"
		annotation(Dialog(tab="Assumptions"), Evaluate=true);

	parameter Boolean allowFlowReversal2 = false
		"= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 2"
		annotation(Dialog(tab="Assumptions"), Evaluate=true);

	Modelica.Fluid.Interfaces.FluidPort_a port_1a(
		redeclare final package Medium = Medium1,
		m_flow(min=if allowFlowReversal1 then -CN.inf else 0),
		h_outflow(start = Medium1.h_default, nominal = Medium1.h_default))
		"Fluid connector 1a (positive design flow direction is from port_1a to port_1b)"
		annotation (Placement(transformation(extent={{-110,50},{-90,70}})));

	Modelica.Fluid.Interfaces.FluidPort_b port_1b(
		redeclare final package Medium = Medium1,
		m_flow(max=if allowFlowReversal1 then +CN.inf else 0),
		h_outflow(start = Medium1.h_default, nominal = Medium1.h_default))
		"Fluid connector 1b (positive design flow direction is from port_1a to port_1b)"
		annotation (Placement(transformation(extent={{110,50},{90,70}})));

	Modelica.Fluid.Interfaces.FluidPort_a port_2a(
		redeclare final package Medium = Medium2,
		m_flow(min=if allowFlowReversal2 then -CN.inf else 0),
		h_outflow(start = Medium2.h_default, nominal = Medium2.h_default))
		"Fluid connector 2a (positive design flow direction is from port_2a to port_2b)"
		annotation (Placement(transformation(extent={{90,-70},{110,-50}})));

	Modelica.Fluid.Interfaces.FluidPort_b port_2b(
		redeclare final package Medium = Medium2,
		m_flow(max=if allowFlowReversal2 then +CN.inf else 0),
		h_outflow(start = Medium2.h_default, nominal = Medium2.h_default))
		"Fluid connector 2b (positive design flow direction is from port_2a to port_2b)"
		annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));

	annotation(
		Documentation(info="<html>
			</html>", revisions="<html>
			<ul>
			<li>A. Shirazi:<br>Released first version. </li>
			</ul>
			</html>"),
		Icon(coordinateSystem(
			grid={1,1}, initialScale = 0.1), graphics={Text(lineColor = {0, 0, 255}, fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-151, 147}, {149, 107}}, 				textString = "%name"), Rectangle(origin = {-8,1}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-87, 61}, {107, -66}})}),
		Diagram(coordinateSystem(
			preserveAspectRatio=false)));

end PartialFourPort;
