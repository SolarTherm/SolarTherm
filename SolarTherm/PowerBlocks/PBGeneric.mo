within SolarTherm.PowerBlocks;
model PBGeneric "Generic power block model"
	import SI = Modelica.SIunits;

	parameter SI.Efficiency eff_des = 0.5 "Power cycle efficiency at design";
	parameter SI.HeatFlowRate Q_flow_des "Heat of power block at design (max value)";
	parameter SI.Temperature T_amb_des "Ambient temperature at design";

	parameter Real cf[:] "Fraction operation factor coefficients";
	parameter Real ca[:] "Ambient temperature factor coefficients";

	input SI.HeatFlowRate Q_flow "Heat flow entering power block";
	input SolarTherm.Interfaces.WeatherBus wbus;
	output SI.Power P "Electrical output power";
	SI.HeatFlowRate Q_flow_cyc "Heat flow to power cycle";
protected
	SolarTherm.Utilities.Polynomial.Poly fac_fra(c=cf);
	SolarTherm.Utilities.Polynomial.Poly fac_amb(c=ca);
equation
	Q_flow_cyc = min(Q_flow, Q_flow_des); // Discard heat above design
	P = Q_flow_cyc*eff_des*fac_fra.y*fac_amb.y;
	fac_fra.x = Q_flow_cyc/Q_flow_des;
	fac_amb.x = wbus.Tdry - T_amb_des;
end PBGeneric;
