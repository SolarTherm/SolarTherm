within SolarTherm.Valves.Energy;
model Shedder "Limits power flow from input to output by shedding"
	import SI = Modelica.SIunits;
	input Real frac(min=0, max=1);
	SolarTherm.Interfaces.Energy.Port p_i;
	SolarTherm.Interfaces.Energy.Port p_o;
	SI.Power pshed(max=0); // can only dump power, not draw
equation
	p_o.p = -frac*p_i.p;
	pshed = -(1 - frac)*p_i.p;
end Shedder;
