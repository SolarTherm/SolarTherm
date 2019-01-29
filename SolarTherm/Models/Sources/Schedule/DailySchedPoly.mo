within SolarTherm.Models.Sources.Schedule;
block DailySchedPoly "Daily schedule from a polynomial"
	extends SolarTherm.Models.Sources.Schedule.DailySched;

	parameter Real t_start "Strating time in day";
	parameter Real t_end "Ending time in day";

	parameter Real c_poly[:] = {1} "Polynomial coefficients";
	parameter Real mean = 0 "Mean value in the polynomial centre and scale method";
	parameter Real std = 1 "Standard deviation in the polynomial centre and scale method";

	parameter Boolean flat = false "Constant schedule if true";
	parameter Real v_flat = 0 if flat "Constant schedule output";

	SolarTherm.Utilities.Polynomial.Poly poly(c=c_poly) if not flat;

equation
	if flat then
		if (t >= t_start and t <= t_end) then
			v = v_flat;
		else
			v = 0;
		end if;
	else
		if (t >= t_start and t <= t_end) then
			poly.x = (t - mean) / std;
			v = poly.y;
		else
			poly.x = 0;
			v = 0;
		end if;
	end if;
end DailySchedPoly;
