within SolarTherm.PowerBlocks.Energy;
model Generator "Generator with fixed efficiency"
	import SI = Modelica.SIunits;
	parameter SI.Efficiency eff = 1.0 "Efficiency of generator";
	parameter SI.Power P_max "Generator maximum electrical power";
	SolarTherm.Interfaces.Energy.Port p;
	output SI.Power P_ele(min=0, max=P_max);
equation
	P_ele = eff*p.P;
end Generator;
