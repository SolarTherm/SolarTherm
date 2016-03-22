within SolarTherm.Storage;
model GenericST "Generic energy storage tank"
	import SI = Modelica.SIunits;
	parameter SI.Energy E_max = 1000 "Maximum energy";
	parameter SI.Energy E_0 = 0 "Starting energy";
	parameter SI.HeatFlowRate Q_flow_loss_des "Design point heat loss";
	parameter SI.Temperature T_amb_des "Design point ambient temperature";

	parameter Real cf[:] "Fraction charge factor coefficients";
	parameter Real ca[:] "Ambient temperature factor coefficients";

	input SI.HeatFlowRate Q_flow_in "Heat flow entering tank";
	input SI.HeatFlowRate Q_flow_set "Target output heat flow";
	input SolarTherm.Interfaces.WeatherBus wbus;
	output SI.HeatFlowRate Q_flow_out "Heat flow leaving tank";
	SI.Energy E(start=E_0, fixed=true, min=0, max=E_max) "Energy in tank";
	SI.HeatFlowRate Q_flow_loss "Heat loss";
protected
	SolarTherm.Utilities.Polynomial.Poly fac_fra(c=cf);
	SolarTherm.Utilities.Polynomial.Poly fac_amb(c=ca);
equation
	der(E) = Q_flow_in - Q_flow_out - Q_flow_loss;
	Q_flow_out = Q_flow_set;
	Q_flow_loss = Q_flow_loss_des*fac_fra.y*fac_amb.y;
	fac_fra.x = E/E_max;
	fac_amb.x = wbus.Tdry - T_amb_des;
end GenericST;
