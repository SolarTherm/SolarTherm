within SolarTherm.Utilities.Transition;
block Ramp "Ramp transition model"
	import SI = Modelica.SIunits;

	parameter Integer ramp_order(min=0, max=2) "Ramping filter order";  // e.g. 0: step function, 1: linear, 2: second order, etc.
	parameter SI.Time t_dur(min=0) "Duration of the ramp event";
	parameter Boolean up = true "true if a ramp-up and false if a ramp-down";

	input SI.Time x "Start time of the ramp event";
	output Real y "Ramping transition rate";

equation
	if up then
		if t_dur == 0 then
			y = 1; // i.e. no ramp-up and go to full operation
		else
			y = abs(((time - x) / t_dur) ^ ramp_order);
		end if;
	else
		if t_dur == 0 then
			y = 0; // i.e. no ramp-down and shut off straight away
		else
			y = abs((1 - ((time - x) / t_dur)) ^ ramp_order);
		end if;
	end if;
end Ramp;
