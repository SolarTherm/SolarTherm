within SolarTherm.Control;
block Trigger "Schmitt trigger"
	parameter Real low = -1 "Lower threshold";
	parameter Real up = 1 "Upper threshold";
	parameter Boolean y_0 = false "Start value for output when between";
	input Real x;
	//output Boolean y(start=y_0, fixed=true);
	output Boolean y;
initial algorithm
	assert(low < up, "Thresholds in wrong order");
	if x > up then
		y := true;
	elseif x < low then
		y := false;
	else
		y := y_0;
	end if;
algorithm
	when x > up then
		y := true;
	end when;
	when x < low then
		y := false;
	end when;
end Trigger;
