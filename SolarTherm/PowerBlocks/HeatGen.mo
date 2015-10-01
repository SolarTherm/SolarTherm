within SolarTherm.PowerBlocks;
model HeatGen "Basic power block that takes input heat at a temperature"
	import SI = Modelica.SIunits;

	parameter SI.Efficiency eff_adj "Adjustment factor for Chambadal-Novikov eff";

	input SolarTherm.Interfaces.WeatherBus wbus;
	input SI.HeatFlowRate Q_flow "Input heat";
	input SI.Temperature T "Delivered temperature";

	output SI.Power P_out;
equation
	// Chambadal-Novikov efficiency (Endoreversible)
	P_out = Q_flow*(1 - sqrt(wbus.Tdry/T));
end HeatGen;
