within SolarTherm.Pumps.Energy;
model Pump "Pumps power from inlet to outlet"
	import SI = Modelica.SIunits;
	parameter SI.Power P_max(min=0);
	input Real frac(min=0, max=1) "Fraction of maximum throughput";
	SolarTherm.Interfaces.Energy.Port p_i;
	SolarTherm.Interfaces.Energy.Port p_o;
equation
	p_i.P = frac*P_max;
	p_o.P = -frac*P_max;
end Pump;
