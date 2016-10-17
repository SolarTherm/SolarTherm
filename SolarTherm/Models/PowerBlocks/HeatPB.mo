within SolarTherm.Models.PowerBlocks;
model HeatPB "Basic power block that takes input heat at a temperature"
 extends SolarTherm.Models.PowerBlocks.PowerBlock;
 import SI = Modelica.SIunits;

 replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;

 parameter SI.Power P_rate = 1e3 "Rated power of power block";
 parameter SI.Efficiency eff_adj = 1
    "Adjustment factor for Chambadal-Novikov eff";

  input SolarTherm.Interfaces.Connectors.WeatherBus wbus;
 input SI.HeatFlowRate Q_flow "Input heat";
 input Medium.Temperature T "Delivered temperature";
equation
 // Chambadal-Novikov efficiency (Endoreversible)
 // Limited at rated power
 P = min(eff_adj*(1 - sqrt(wbus.Tdry/T))*Q_flow, P_rate);
end HeatPB;
