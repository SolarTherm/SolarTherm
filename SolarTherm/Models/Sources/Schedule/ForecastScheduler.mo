within SolarTherm.Models.Sources.Schedule;
block ForecastScheduler "Forecast Scheduler"
	// Parameters
	parameter Integer n_sched_states = 2 "Number of schedule states";
	parameter Integer sch_state_start(min=1, max=n_sched_states) = 2 "Starting schedule state";
	parameter SI.Time t_sch_next_start = 8*3600 "Time to next schedule change"; // That is, schedule 1 won't start until 8 am given that sch_state_start=2
	parameter SI.Time t_delta[n_sched_states] = {
			10*3600, // 8am to 6pm
			14*3600 // outside 8am-6pm
			} "Time differences between schedule states";
	parameter SI.EnergyFlowRate E_flow_des "Dispatched energy flow at design point";
	parameter Real fr_min = 0.2 "Minium dispatched energy fraction";
	parameter SI.Energy E_max "Maximum energy in the tank";

	// Calculated parameters
	parameter SI.Energy E_used_dly = t_delta[1] * E_flow_des "Energy used during the daily schedule";

	// Variables
	input Real level(min=0) "Level of tank";
	input Real forecast_prod(min=0) "Reactor energy production forecast of the next day";
	output Real v(min=fr_min, max=1) "value at time";

	Integer sch_state(min=1, max=n_sched_states) "Schedule state";
	Real t_sch_next "Time of next schedule change";
	SI.Energy E_stored_fcst "Forecasted energy to be stored in tank during the day";
	SI.Energy E_remain "Energy should remain in tank over night";

initial equation
	E_stored_fcst = 0;
	E_remain = 0;
	v = fr_min;
	sch_state = sch_state_start;
	t_sch_next = t_sch_next_start;

algorithm
	when time >= t_sch_next then
		sch_state := mod(pre(sch_state), n_sched_states) + 1;
	end when;

	when sch_state == 1 then
		E_stored_fcst := 0;
		E_remain := 0;
		v := 1;
		t_sch_next := time + t_delta[1];
	end when;

	when sch_state == 2 then
		E_stored_fcst := if forecast_prod > E_used_dly then (forecast_prod - E_used_dly) else 0;
		E_remain := if E_stored_fcst < E_max then (E_max - E_stored_fcst) else 0;
		v := if level > E_remain then min(max(((level - E_remain) / t_delta[2]) / E_flow_des,fr_min),1.0) else fr_min;
		t_sch_next := time + t_delta[2];
	end when;

end ForecastScheduler;
