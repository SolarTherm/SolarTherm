within SolarTherm.Models.PowerBlocks.sCO2_cycle;
model Cooler "simple cooler model"
	import SI = Modelica.SIunits;
	import Modelica.SIunits.Conversions.*;

	replaceable package Medium = SolarTherm.Media.CarbonDioxide;

	parameter String fluid = "R744";
	parameter SI.Temperature T_in_des = from_degC(715);
	parameter SI.Temperature T_out_des = from_degC(45);
	parameter SI.MassFlowRate m_flow_des = 1000;
	parameter SI.Pressure p_des = 8e6;
	parameter SI.SpecificEnthalpy h_in_des(fixed = false);
	parameter SI.SpecificEnthalpy h_out_des(fixed = false);

	SI.SpecificEnthalpy h_in(start = h_in_des);
	SI.SpecificEnthalpy h_out;
	SI.HeatFlowRate Q_cooler(start = m_flow_des*(h_in_des - h_out_des));

	Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
	Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
		Placement(visible = true, transformation(origin = {60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

initial algorithm
	h_in_des := SolarTherm.Utilities.CoolProp.stprops("H","T",T_in_des,"P",p_des,fluid);
	h_out_des := SolarTherm.Utilities.CoolProp.stprops("H","T",T_out_des,"P",p_des,fluid);

equation
	//Mass balance
	port_a.m_flow - port_b.m_flow = 0;

	//Inlet and outlet pressure
	port_a.p = port_b.p;

	//Inlet and outlet enthalpies
	h_in = inStream(port_a.h_outflow);
	h_out = SolarTherm.Utilities.CoolProp.stprops("H","T",T_out_des,"P",port_a.p,fluid);
	port_b.h_outflow = h_out;

	//Cooling input
	Q_cooler = port_a.m_flow * (h_in - h_out);

	//Should not have reverse flow
	port_a.h_outflow = 0.0;

annotation(
	Diagram(graphics = {Rectangle(origin = {-4, 7}, extent = {{-56, 53}, {64, -67}}), Text(origin = {-5, -2}, extent = {{-29, -8}, {41, 12}}, textString = "COOLER"), Line(origin = {0, 65}, points = {{0, 5}, {0, -5}, {0, -5}}), Line(origin = {0, -65}, points = {{0, 5}, {0, -5}, {0, -5}})}, coordinateSystem(initialScale = 0.1)),
	Icon(graphics = {Rectangle(origin = {2, 1}, extent = {{-62, 59}, {58, -61}}), Text(origin = {8, 5}, extent = {{-40, -15}, {26, 5}}, textString = "COOLER"), Line(origin = {0, 65}, points = {{0, 5}, {0, -5}, {0, -5}}), Line(origin = {0, -65}, points = {{0, 5}, {0, -5}, {0, -5}})}, coordinateSystem(initialScale = 0.1)),
	Documentation(info = "<html>
	<p>This compressor's model is based on the phD thesis of J. Dyreby.&nbsp;</p>
<p>The performance maps comes from the Sandia National Laboratory first compressor. It should be updated. The performance maps is compressed in three correlations, expressing the adimensionned head and the efficiency as functions of the adimensionned mass flow.&nbsp;</p>
<p>The same correlations are used; only the maximal values are changed.</p>
<p>J. J. Dyreby, &laquo; Modeling the supercritical carbon dioxide Brayton cycle with recompression &raquo;, The University of Wisconsin-Madison, 2014. Available at https://sel.me.wisc.edu/publications-theses.shtml</p>
</html>"));
end Cooler;
