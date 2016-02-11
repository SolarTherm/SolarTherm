within SolarTherm.PowerBlocks;
model PBGeneric "Generic power block model"
	import SI = Modelica.SIunits;

	parameter SI.Efficiency eff_cyc = 0.5 "Power cycle design efficiency";
	parameter SI.HeatFlowRate Q_flow_rate "Rated heat of power block";
	parameter SI.Temperature T_amb_des "Design point ambient temperature";

	parameter Real cf[:] "Fraction operation factor coefficients";
	parameter Real ca[:] "Ambient temperature factor coefficients";

	input SI.HeatFlowRate Q_flow "Heat flow entering power block";
	input SolarTherm.Interfaces.WeatherBus wbus;
	input SI.HeatFlowRate Q_flow_cyc "Heat flow to power cycle";
	SI.Power P_gen "Electrical output power";
protected
	SolarTherm.Utilities.Polynomial.Poly fac_fra(c=cf);
	SolarTherm.Utilities.Polynomial.Poly fac_amb(c=ca);
equation
	Q_flow_cyc = min(Q_flow, Q_flow_rate);
	P_gen = Q_flow_cyc*eff_cyc*fac_fra.y*fac_amb.y;
	fac_fra.x = Q_flow_cyc/Q_flow_rate;
	fac_amb.x = wbus.Tdry - T_amb_des;
end PBGeneric;
