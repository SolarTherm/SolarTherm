within SolarTherm.PowerBlocks;
model HeatGen "Basic power block that takes input heat at a temperature"
	import SI = Modelica.SIunits;

	parameter SI.Power P_rate = 1e3 "Rated power of power block";
	parameter SI.Efficiency eff_adj = 1 "Adjustment factor for Chambadal-Novikov eff";

	input SolarTherm.Interfaces.WeatherBus wbus;
	input SI.HeatFlowRate Q_flow "Input heat";
	input SI.Temperature T "Delivered temperature";

	output SI.Power P_elec;
equation
	// Chambadal-Novikov efficiency (Endoreversible)
	// Limited at rated power
	P_elec = min(eff_adj*(1 - sqrt(wbus.Tdry/T))*Q_flow, P_rate);
end HeatGen;
