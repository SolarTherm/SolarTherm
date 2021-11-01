within examples;
model SimpleSystem
	// Imports
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FI = SolarTherm.Models.Analysis.Finances;
	extends Modelica.Icons.Example;

	// Parameters
	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Mildura_Real2010_Created20130430.motab");
	parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab");


	parameter SI.Area A_col = 700 "Area of collector";
	parameter SI.Area A_rec = 1 "Area of receiver aperture";
	parameter Real C = 0.65*A_col/A_rec "Concentration ratio";
	parameter SI.Efficiency eff_rec = 0.9 "Receiver efficiency";
	parameter SI.Efficiency eff_blk = 0.48 "Power block efficiency";
	parameter SI.Power P_name = 100000 "Nameplate rating of power block";
	parameter Real t_storage(unit="h") = 5 "Hours of storage";
	parameter SI.Energy E_max = P_name*t_storage*3600/eff_blk "Max stored energy";

	parameter SI.Energy E_up_u = 0.95*E_max "Upper energy limit";
	parameter SI.Energy E_up_l = 0.93*E_max "Upper energy limit";
	parameter SI.Energy E_low_u = 0.07*E_max "Lower energy limit";
	parameter SI.Energy E_low_l = 0.05*E_max "Lower energy limit";
	parameter SI.Irradiance dni_stop = 100 "DNI at which concentrator stops";
	parameter SI.Irradiance dni_start = 200 "DNI at which concentrator starts";

	parameter SI.Time t_con_on_delay = 20*60 "Delay until concentrator starts";
	parameter SI.Time t_con_off_delay = 15*60 "Delay until concentrator shuts off";
	parameter SI.Time t_blk_on_delay = 15*60 "Delay until power block starts";
	parameter SI.Time t_blk_off_delay = 10*60 "Delay until power block shuts off";

	parameter Integer ramp_order = 1 "ramping filter order";

	parameter Integer n_sched_states = 1 "Number of schedule states";
	parameter Integer sch_state_start(min=1, max=n_sched_states) = 1 "Starting schedule state";
	parameter SI.Time t_sch_next_start = 0 "Time to next schedule change";
	parameter SI.HeatFlowRate Q_flow_sched_val[n_sched_states] = {
			P_name/eff_blk
			} "Heat flow at schedule states";
	parameter SI.Time t_delta[n_sched_states] = {
			24*3600
			} "Time differences between schedule states";
	//parameter Integer n_sched_states = 3;
	//parameter Integer sch_state_start(min=1, max=n_sched_states) = 3;
	//parameter SI.Time t_sch_next_start = 8*3600;
	//parameter SI.HeatFlowRate Q_flow_sched_val[n_sched_states] = {
	//		0.4*P_name/eff_blk,
	//		P_name/eff_blk,
	//		0.5*P_name/eff_blk
	//		};
	//parameter SI.Time t_delta[n_sched_states] = {
	//		9*3600,
	//		3*3600,
	//		12*3600
	//		};

	parameter FI.Money C_field = 120*A_col "Field cost";
	parameter FI.Money C_site = 0 "Site improvements cost";
	parameter FI.Money C_tower = 0 "Tower cost";
	parameter FI.Money C_receiver = 135*C*A_rec "Receiver cost";
	parameter FI.Money C_storage = (30/(1e3*3600))*E_max "Storage cost";
	parameter FI.Money C_block = (1440/1e3)*P_name "Power block cost";
	parameter FI.Money C_bop = 0 "Balance of plant cost";
	parameter FI.Money C_land = 0 "Land cost";
	parameter FI.Money C_cap = C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop + C_land "Capital costs";

	parameter FI.MoneyPerYear C_year =
			10*A_col // field cleaning/maintenance
			"Cost per year";
	parameter Real C_prod(unit="$/J/year") = 0 "Cost per production per year";

	parameter Real r_disc = 0.05 "Discount rate";
	parameter Integer t_life(unit="year") = 20 "Lifetime of plant";
	parameter Integer t_cons(unit="year") = 1 "Years of construction";

	parameter Boolean constrained = false "Constraint is present in optimisation if true";
		// If there is a constraint, then "constrained" must be a 'variable' Boolean
		// whose value is determined through an if statement with a constraint being the condition.
		// Note in this case the if block must be moved to the equation section.
	parameter Real distance = 0 "Distance to be added to a constant offset as added penalty when a constraint is not respected";
		// e.g. for euclidean distance: if T > T0 then constrained=true & distance=sqrt((T-T0)^2)
		// e.g. for quadratic distance: if T > T0 then constrained=true & distance=(T-T0)^2
		// e.g. for a constraint like T1 < T < T2, then T0 = (T1 + T2)/2

	// Variables/Models
	SolarTherm.Models.Sources.Weather.WeatherSource wea(file=wea_file);
	FI.SpotPriceTable pri(file=pri_file);

	SI.HeatFlowRate Q_flow_rec "Heat flow into receiver";
	SI.HeatFlowRate Q_flow_chg "Heat flow into tank";
	SI.HeatFlowRate Q_flow_dis "Heat flow out of tank";
	SI.Power P_elec "Output power of power block";

	Real fr_dfc(min=0, max=1) "Target energy fraction of the heliostat fistateld at the defocused state";
	Boolean full "True if the storage tank is full";

	SolarTherm.Utilities.Transition.Ramp ramp_up_con(ramp_order=ramp_order, t_dur= t_con_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_con(ramp_order=ramp_order, t_dur= t_con_off_delay, up=false);
	Real fr_ramp_con (min=0.0, max=1.0) "ramping transition rate for the concentrator";
	SolarTherm.Utilities.Transition.Ramp ramp_up_blk(ramp_order=ramp_order, t_dur= t_blk_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_blk(ramp_order=ramp_order, t_dur= t_blk_off_delay, up=false);
	Real fr_ramp_blk (min=0.0, max=1.0) "ramping transition rate for the power block";

	SI.Energy E(min=0, max=E_max) "Stored energy";

	SI.HeatFlowRate Q_flow_sched "Discharge schedule";

	Integer con_state(min=1, max=5) "Concentrator state";
	Integer blk_state(min=1, max=4) "Power block state";
	Integer sch_state(min=1, max=n_sched_states) "Schedule state";

	SI.Time  t_con_w_now "Time of concentrator current warm-up event";
	SI.Time  t_con_w_next "Time of concentrator next warm-up event";
	SI.Time  t_con_c_now "Time of concentrator current cool-down event";
	SI.Time  t_con_c_next "Time of concentrator next cool-down event";
	SI.Time  t_blk_w_now "Time of power block current warm-up event";
	SI.Time  t_blk_w_next "Time of power block next warm-up event";
	SI.Time  t_blk_c_now "Time of power block current cool-down event";
	SI.Time  t_blk_c_next "Time of power block next cool-down event";
	SI.Time  t_sch_next "Time of next schedule change";

	FI.Money R_spot(start=0, fixed=true)
		"Spot market revenue";
	SI.Energy E_elec(start=0, fixed=true) "Generate electricity";
initial equation
	E = E_low_l;
	Q_flow_sched = Q_flow_sched_val[sch_state_start];
	con_state = 1;
	blk_state = 1;
	sch_state = sch_state_start;
	t_con_w_now = 0;
	t_con_w_next = 0;
	t_con_c_now = 0;
	t_con_c_next = 0;
	t_blk_w_now = 0;
	t_blk_w_next = 0;
	t_blk_c_now = 0;
	t_blk_c_next = 0;
	t_sch_next = t_sch_next_start;

	if E > E_up_u then
		full = true;
	elseif E < E_up_l then
		full = false;
	else
		full = true;
	end if;

algorithm
	// Discrete equation system not yet supported (even though correct)
	// Putting in algorithm section instead
	when con_state == 2 and (wea.wbus.dni <= dni_stop or E >= E_up_u) then
		con_state := 1; // off sun
	elsewhen con_state == 3 and (wea.wbus.dni <= dni_stop) and t_con_off_delay > 0 then
		con_state := 5; // ramp down
	elsewhen con_state == 3 and (wea.wbus.dni <= dni_stop) and t_con_off_delay <= 0 then
		con_state := 1; // off sun(no ramp-down)
	elsewhen con_state == 3 and full then
		con_state := 4; // on sun at part load
	elsewhen con_state == 4 and not full then
		con_state := 3; // on sun at full load
	elsewhen con_state == 4 and (wea.wbus.dni <= dni_stop) and t_con_off_delay > 0 then
		con_state := 5; // ramp down
	elsewhen con_state == 4 and (wea.wbus.dni <= dni_stop) and t_con_off_delay <= 0 then
		con_state := 1; // off sun (no ramp-down)
	elsewhen con_state == 1 and wea.wbus.dni >= dni_start and E <= E_up_l and t_con_on_delay > 0 then
		con_state := 2; // start onsteering (i.e. ramp up)
	elsewhen con_state == 1 and wea.wbus.dni >= dni_start and E <= E_up_l and t_con_on_delay <= 0 then
		con_state := 3; // on sun at full (no ramp-up)
	elsewhen con_state == 2 and time >= t_con_w_next then
		con_state := 3; // on sun at full load
	elsewhen con_state == 5 and time >= t_con_c_next then
		con_state := 1; // off sun
	end when;

	when blk_state == 2 and Q_flow_sched <= 0 then
		blk_state := 1; // turn off (or stop ramping) due to no demand
	elsewhen blk_state == 2 and E <= E_low_l then
		blk_state := 1; // turn off (or stop ramping) due to empty tank
	elsewhen blk_state == 3 and Q_flow_sched <= 0 and t_blk_off_delay > 0 then
		blk_state := 4; // ramp down due to no demand
	elsewhen blk_state == 3 and Q_flow_sched <= 0 and t_blk_off_delay <= 0 then
		blk_state := 1; // turn off (no ramp-down) due to no demand
	elsewhen blk_state == 3 and E <= E_low_l and t_blk_off_delay > 0 then
		blk_state := 4; // ramp down due to empty tank
	elsewhen blk_state == 3 and E <= E_low_l and t_blk_off_delay <= 0 then
		blk_state := 1; // turn off (no ramp down) due to empty tank
	elsewhen blk_state == 2 and time >= t_blk_w_next then
		blk_state := 3; // operational, ramp-up completed
	elsewhen blk_state == 1 and Q_flow_sched > 0 and E >= E_low_u  and t_blk_on_delay > 0 then
		blk_state := 2; // ramp up, demand and tank has capacity
	elsewhen blk_state == 1 and Q_flow_sched > 0 and E >= E_low_u  and t_blk_on_delay <= 0 then
		blk_state := 3; // operational (no ramp-up)
	elsewhen blk_state == 4 and time >= t_blk_c_next then
		blk_state := 1; // turn off after the ramp-down is complete
	end when;

	when time >= t_sch_next then
		sch_state := mod(pre(sch_state), n_sched_states) + 1;
	end when;

	when con_state == 2 then
		t_con_w_now := time;
		t_con_w_next := time + t_con_on_delay;
	end when;

	when con_state == 5 then
		t_con_c_now := time;
		t_con_c_next := time + t_con_off_delay;
	end when;

	when blk_state == 2 then
		t_blk_w_now := time;
		t_blk_w_next := time + t_blk_on_delay;
	end when;

	when blk_state == 4 then
		t_blk_c_now := time;
		t_blk_c_next := time + t_blk_off_delay;
	end when;

	for i in 1:n_sched_states loop
		when sch_state == i then
			Q_flow_sched := Q_flow_sched_val[i];
			t_sch_next := time + t_delta[i];
		end when;
	end for;

	when E > E_up_u then
		full := true;
	elsewhen E < E_up_l then
		full := false;
	end when;

	if con_state == 2 then
		fr_ramp_con := if ramp_order == 0 then 0.0 else abs(ramp_up_con.y);
	elseif con_state == 5 then
		fr_ramp_con := if ramp_order == 0 then 0.0 else abs(ramp_down_con.y);
	else
		fr_ramp_con := 0;
	end if;


	if blk_state == 2 then
		fr_ramp_blk := if ramp_order == 0 then 0.0 else abs(ramp_up_blk.y);
	elseif blk_state == 4 then
		fr_ramp_blk := if ramp_order == 0 then 0.0 else abs(ramp_down_blk.y);
	else
	 fr_ramp_blk := 0;
	end if;

equation
	ramp_up_con.x = t_con_w_now;
	ramp_down_con.x = t_con_c_now;

	ramp_up_blk.x = t_blk_w_now;
	ramp_down_blk.x = t_blk_c_now;

	Q_flow_chg = eff_rec*Q_flow_rec;

	der(E) = Q_flow_chg - Q_flow_dis;

	if con_state <= 1 then
		Q_flow_rec = 0;
		fr_dfc = 0;
	elseif con_state == 2 then
		Q_flow_rec = fr_ramp_con * max(C*wea.wbus.dni*A_rec, 0);
		fr_dfc = if ramp_order == 0 then 0 else 1;
	elseif con_state == 5 then
		Q_flow_rec = fr_ramp_con * max(C*wea.wbus.dni*A_rec, 0);
		fr_dfc = if ramp_order == 0 then 0 else 1;
	else
		if full then
			if eff_rec*(C*wea.wbus.dni*A_rec) > Q_flow_dis then
				Q_flow_rec = min(Q_flow_dis/eff_rec, max(C*wea.wbus.dni*A_rec, 0));
				fr_dfc = Q_flow_dis / (max(C*wea.wbus.dni*A_rec, 0) + 1e-10);
			else
				Q_flow_rec = max(C*wea.wbus.dni*A_rec, 0);
				fr_dfc = 1;
			end if;
		else
			Q_flow_rec = max(C*wea.wbus.dni*A_rec, 0);
			fr_dfc = 1;
		end if;
	end if;

	if blk_state <=1 then
		Q_flow_dis = 0;
		P_elec = 0;
	elseif blk_state == 2 then
		Q_flow_dis = if ramp_order == 0 then Q_flow_sched else fr_ramp_blk * Q_flow_sched;
		P_elec = eff_blk*Q_flow_dis;
	elseif blk_state == 4 then
		Q_flow_dis = fr_ramp_blk * Q_flow_sched;
		P_elec = eff_blk*Q_flow_dis;
	else
		Q_flow_dis = Q_flow_sched;
		P_elec = eff_blk*Q_flow_dis;
	end if;

	der(E_elec) = P_elec;
	der(R_spot) = P_elec*pri.price;
	annotation(experiment(StartTime=0.0, StopTime=31536000.0, Interval=60, Tolerance=1e-06));
end SimpleSystem;
