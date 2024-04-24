within SolarTherm.Models.Storage.Tank;
model GenericST "Generic energy storage tank"
	extends SolarTherm.Icons.StorageModel;
	import SI = Modelica.SIunits;
	parameter SI.Energy E_max = 1000 "Maximum energy";
	parameter SI.Energy E_0 = 0 "Starting energy";
	parameter SI.HeatFlowRate Q_flow_loss_des "Design point heat loss";
	parameter SI.Temperature T_amb_des "Design point ambient temperature";

	parameter Real cf[:] "Fraction charge factor coefficients";
	parameter Real ca[:] "Ambient temperature factor coefficients";

	Modelica.Blocks.Interfaces.RealInput Q_in "Thermal power input" 
		annotation(
		Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), 
		iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Interfaces.RealOutput Q_out "Thermal power output" 
		annotation(
		Placement(visible = true, transformation(origin = {80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), 
		iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	Modelica.Blocks.Interfaces.RealInput T_amb annotation (
		Placement(transformation(extent={{-16,-16},{16,16}},rotation=-90,origin={0,108}), 
		iconTransformation(extent={{-10,-10},{10,10}},rotation=-90,origin={-41,97})));

	Modelica.Blocks.Interfaces.RealOutput Level annotation(
		Placement(visible = true, transformation(origin = {80, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), 
		iconTransformation(origin = {100, 60}, extent = {{-10,-10},{10, 10}}, rotation = 0)));

	input SI.HeatFlowRate Q_flow_set "Target output heat flow";
	SI.Energy E(start=E_0, fixed=true, min=0, max=E_max) "Energy in tank";
	SI.HeatFlowRate Q_flow_loss "Heat loss";
protected
	SolarTherm.Utilities.Polynomial.Poly fac_fra(c=cf);
	SolarTherm.Utilities.Polynomial.Poly fac_amb(c=ca);
initial equation
	Level = E_0/E_max*100;
equation
	der(E) = Q_in - Q_out - Q_flow_loss;
//	Q_out = Q_flow_set;
	Q_flow_loss = Q_flow_loss_des*fac_fra.y*fac_amb.y;
	fac_fra.x = E/E_max;
	fac_amb.x = T_amb - T_amb_des;
	Level = E/E_max*100;

	annotation(
    Icon(graphics = {
    Text(
		origin = {-10, -30}, 
		lineColor = {0, 0, 255}, 
		extent = {{-250, -114}, {250, -154}}, 
		textString = "%name")}));
end GenericST;
