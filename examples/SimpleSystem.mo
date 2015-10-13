model SimpleSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;

	parameter String weaFile = "resources/weatherfile1.motab";
	parameter String priFile = "resources/aemo_vic_2014.motab";

	parameter SI.Area A_con = 700 "Area of concentrator";
	parameter SI.Area A_rec = 1 "Area of receiver aperture";
	parameter Real C = 0.65*A_con/A_rec "Concentration ratio";
	parameter SI.Efficiency eff_rec = 0.9 "Receiver efficiency";
	parameter SI.Efficiency eff_blk = 0.48 "Power block efficiency";
	parameter SI.Power P_rate = 100000 "Power block nominal power";
	parameter Real t_storage(unit="hour") = 5 "Hours of storage";
	parameter SI.Energy E_max = P_rate*t_storage*3600/eff_blk "Max stored energy";
	parameter SI.Energy E_up_u = 0.95*E_max "Upper energy limit";
	parameter SI.Energy E_up_l = 0.93*E_max "Upper energy limit";
	parameter SI.Energy E_low_u = 0.07*E_max "Lower energy limit";
	parameter SI.Energy E_low_l = 0.05*E_max "Lower energy limit";
	parameter SI.Irradiance dni_stop = 100 "DNI at which concentrator stops";
	parameter SI.Irradiance dni_start = 200 "DNI at which concentrator starts";

	parameter SI.Time t_con_on_delay = 20*60 "Delay until concentrator starts";
	parameter SI.Time t_blk_on_delay = 15*60 "Delay until power block starts";

	parameter Integer n_sched_states = 1;
	parameter Integer sch_state_start(min=1, max=n_sched_states) = 1;
	parameter SI.Time t_sch_next_start = 0;
	parameter SI.HeatFlowRate Q_flow_sched_val[n_sched_states] = {
			P_rate/eff_blk
			};
	parameter SI.Time t_delta[n_sched_states] = {
			24*3600
			};
	//parameter Integer n_sched_states = 3;
	//parameter Integer sch_state_start(min=1, max=n_sched_states) = 3;
	//parameter SI.Time t_sch_next_start = 8*3600;
	//parameter SI.HeatFlowRate Q_flow_sched_val[n_sched_states] = {
	//		0.4*P_rate/eff_blk,
	//		P_rate/eff_blk,
	//		0.5*P_rate/eff_blk
	//		};
	//parameter SI.Time t_delta[n_sched_states] = {
	//		9*3600,
	//		3*3600,
	//		12*3600
	//		};

	parameter SolarTherm.Utilities.Finances.Money C_cap =
			120*A_con // field cost
			+ 135*C*A_rec // receiver cost
			+ (30/(1e3*3600))*E_max // storage cost
			+ (1440/1e3)*P_rate // power block cost
			;
	parameter SolarTherm.Utilities.Finances.MoneyPerYear C_main =
			10*A_con // field cleaning/maintenance
			;
	parameter Real r_disc = 0.05;
	parameter Integer t_life(unit="year") = 20;

	SolarTherm.Utilities.Weather.WeatherSource wea(weaFile=weaFile);
	SolarTherm.Utilities.Finances.SpotPriceTable pri(fileName=priFile);

	SI.HeatFlowRate Q_flow_rec "Heat flow into receiver";
	SI.HeatFlowRate Q_flow_chg "Heat flow into tank";
	SI.HeatFlowRate Q_flow_dis "Heat flow out of tank";
	SI.Power P_elec "Output power of power block";

	SI.Energy E(min=0, max=E_max) "Stored energy";

	SI.HeatFlowRate Q_flow_sched "Discharge schedule";

	Integer con_state(min=1, max=3) "Concentrator state";
	Integer blk_state(min=1, max=3) "Power block state";
	Integer sch_state(min=1, max=n_sched_states) "Schedule state";

	Real t_con_next "time of next concentrator event";
	Real t_blk_next "time of next power block event";
	Real t_sch_next "time of next schedule change";

	SolarTherm.Utilities.Finances.Money R_spot(start=0, fixed=true)
		"Spot market revenue";
	SI.Energy E_elec(start=0, fixed=true) "Generate electricity";

initial equation
	E = E_low_l;
	Q_flow_sched = Q_flow_sched_val[sch_state_start];
	con_state = 1;
	blk_state = 1;
	sch_state = sch_state_start;
	t_con_next = 0;
	t_blk_next = 0;
	t_sch_next = t_sch_next_start;
algorithm
	// Discrete equation system not yet supported (even though correct)
	// Putting in algorithm section instead
	when con_state >= 2 and (wea.wbus.dni <= dni_stop or E >= E_up_u) then
		con_state := 1; // off sun
	elsewhen con_state == 1 and wea.wbus.dni >= dni_start and E <= E_up_l then
		con_state := 2; // start onsteering
	elsewhen con_state == 2 and time >= t_con_next then
		con_state := 3; // on sun
	end when;

	when blk_state >= 2 and (Q_flow_sched <= 0 or E <= E_low_l) then
		blk_state := 1; // off
	elsewhen blk_state == 1 and Q_flow_sched > 0 and E >= E_low_u  then
		blk_state := 2; // starting
	elsewhen blk_state == 2 and time >= t_blk_next then
		blk_state := 3; // on
	end when;

	when time >= t_sch_next then
		sch_state := mod(pre(sch_state), n_sched_states) + 1;
	end when;

	when con_state == 2 then
		t_con_next := time + t_con_on_delay;
	end when;

	when blk_state == 2 then
		t_blk_next := time + t_blk_on_delay;
	end when;

	for i in 1:n_sched_states loop
		when sch_state == i then
			Q_flow_sched := Q_flow_sched_val[i];
			t_sch_next := time + t_delta[i];
		end when;
	end for;
equation
	Q_flow_chg = eff_rec*Q_flow_rec;

	der(E) = Q_flow_chg - Q_flow_dis;

	Q_flow_rec = if con_state <= 2 then 0 else C*wea.wbus.dni*A_rec;

	Q_flow_dis = if blk_state <= 1 then 0 else Q_flow_sched;

	P_elec = if blk_state <= 2 then 0 else eff_blk*Q_flow_dis;

	der(E_elec) = P_elec;
	der(R_spot) = P_elec*pri.price;
end SimpleSystem;
