within SolarTherm.Control;
block TankDispatch "Tank dispatch controller"
	// Takes
	parameter Real full_lb;
	parameter Real full_ub;
	parameter Real empty_lb;
	parameter Real empty_ub;
	parameter Real crit_lb;
	parameter Real crit_ub;

	input Real flow_in(min=0) "Flow into tank";
	input Real flow_tar(min=0) "Target dispatched flow";
	input Real level(min=0) "Level of tank";
	output Real flow_dis(min=0) "Dispatched flow";

	SolarTherm.Control.Trigger f_trig(
		low=full_lb,
		up=full_ub,
		y_0=true
		) "Full trigger";
	SolarTherm.Control.Trigger ne_trig(
		low=empty_lb,
		up=empty_ub,
		y_0=false
		) "Not empty trigger";
	SolarTherm.Control.Trigger nc_trig(
		low=crit_lb,
		up=crit_ub,
		y_0=false
		) "Not critically empty trigger";
	Boolean full "Tank full";
	Boolean empty "Tank empty";
	Boolean crit "Tank critically empty";
equation
	connect(level, f_trig.x);
	connect(level, ne_trig.x);
	connect(level, nc_trig.x);
	full = f_trig.y;
	empty = not ne_trig.y;
	crit = not nc_trig.y;
	if full then
		flow_dis = max(flow_in, flow_tar);
	elseif crit then
		flow_dis = 0;
	elseif empty then
		flow_dis = min(flow_in, flow_tar);
	else
		flow_dis = flow_tar;
	end if;
end TankDispatch;
