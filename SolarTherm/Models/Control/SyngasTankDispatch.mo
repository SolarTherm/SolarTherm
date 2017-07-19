within SolarTherm.Models.Control;
block SyngasTankDispatch "Syngas Tank dispatch controller"
	// The tank is in one of 4 states, full, empty, critically empty or nominal.
	// When nominal or full, the tank is dispatched at the target flow rate.
	// When empty, the tank is dispatched at either the tank input
	// flow or the target flow, whichever is smaller.
	// The critically empty state completely shuts off all dispatch.

	parameter Real full_lb;
	parameter Real full_ub;
	parameter Real empty_lb;
	parameter Real empty_ub;
	parameter Real crit_lb;
	parameter Real crit_ub;

	parameter Real level_start "Min tank level before run attempt";
	parameter Real disp_min "Min dispatch level";

	parameter Real cr_sg[:] "Radiation power coefficients";

	input Real flow_in(min=0) "Flow into tank";
	input Real flow_tar(min=0) "Target dispatched flow";
	input Real level(min=0) "Level of tank";
	output Real flow_dis(min=-1e20) "Dispatched flow"; // slight numerical overshoot

	SolarTherm.Utilities.Polynomial.Poly rp_cal(c=cr_sg) "Radiation power";
	output SI.RadiantPower R_tar "The target radiation power at the defocused state";

	SolarTherm.Models.Control.Trigger f_trig(
		low=full_lb,
		up=full_ub,
		y_0=true) "Full trigger";
	SolarTherm.Models.Control.Trigger ne_trig(
		low=empty_lb,
		up=empty_ub,
		y_0=false) "Not empty trigger";
	SolarTherm.Models.Control.Trigger nc_trig(
		low=crit_lb,
		up=crit_ub,
		y_0=false) "Not critically empty trigger";

	Boolean full "Tank full";
	Boolean empty "Tank empty";
	Boolean crit "Tank critically empty";
	Boolean run "Run dispatch";
	Real flow_set(min=0) "Set point for dispatched flow"; // slight

initial algorithm
	assert(level_start > empty_ub, " Starting level is lower than empty");
	if level > level_start then
		run := true;
	else
		run := false;
	end if;

algorithm
	when level > level_start and flow_tar > disp_min then
		run := true;
	elsewhen flow_dis < disp_min then
		run := false;
	end when;

equation
	connect(level, f_trig.x);
	connect(level, ne_trig.x);
	connect(level, nc_trig.x);

	full = f_trig.y;
	empty = not ne_trig.y;
	crit = not nc_trig.y;

	if full then
		flow_dis = flow_set;
	elseif crit then
		flow_dis = 0;
	elseif not run then
		flow_dis = 0;
	elseif empty then
		flow_dis = min(flow_in, flow_set);
	else
		flow_dis = flow_set;
	end if;

	flow_set = flow_tar;

	rp_cal.x = flow_set / 1e6;
	R_tar = rp_cal.y * 1e6;

end SyngasTankDispatch;
