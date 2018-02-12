within SolarTherm.Utilities.Transition;
block Ramp "Ramp transition model"
	import SI = Modelica.SIunits;

	parameter Integer ramp_order = 1 "Ramping filter order";  // e.g. 0: step function, 1: linear, 2: second order, etc.
	parameter SI.Time t_dur "Duration of the ramp event";
	parameter Boolean up = true "true if a ramp-up and false if a ramp-down";

	input SI.Time x "Start time of the ramp event";
	output Real y "Ramping transition rate";

equation
	if up then
		y = abs(((time - x) / t_dur) ^ ramp_order);
	else
		y = abs((1 - ((time - x) / t_dur)) ^ ramp_order);
	end if;
end Ramp;
