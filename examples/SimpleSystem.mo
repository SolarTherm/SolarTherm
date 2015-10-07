model SimpleSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import Modelica.Math.cos;

	parameter String weaFile = "resources/weatherfile1.motab";

	parameter Real C = 300/1 "Concentration ratio";
	parameter SI.Area A_rec = 1 "Area of receiver aperture";
	parameter SI.Efficiency eff_rec = 0.9 "Receiver efficiency";
	parameter SI.Efficiency eff_blk = 0.2 "Power block efficiency";
	parameter SI.Power P_nom = 50000 "Power block nominal power";
	parameter SI.Time t_storage = 5*3600 "Time to empty tank at nominal";
	parameter SI.Energy E_max = P_nom*t_storage/eff_blk "Maximum amount of stored energy";
	parameter SI.Energy E_up_u = 0.95*E_max "Upper energy limit";
	parameter SI.Energy E_up_l = 0.93*E_max "Upper energy limit";
	parameter SI.Energy E_low_u = 0.07*E_max "Lower energy limit";
	parameter SI.Energy E_low_l = 0.05*E_max "Lower energy limit";
	parameter SI.Irradiance dni_stop = 100;
	parameter SI.Irradiance dni_start = 200;

	parameter SI.Time t_con_on_delay = 20*60;
	parameter SI.Time t_blk_on_delay = 15*60;
	parameter Integer n_sched_states = 3;
	
	SolarTherm.Utilities.Weather.WeatherSource wea(weaFile=weaFile);

	SI.HeatFlowRate Q_flow_rec "Heat flow into receiver";
	SI.HeatFlowRate Q_flow_chg "Heat flow into tank";
	SI.HeatFlowRate Q_flow_dis "Heat flow out of tank";
	SI.Power P_blk "Output power of power block";

	SI.Energy E(min=0, max=E_max) "Stored energy";

	SI.HeatFlowRate Q_flow_sched "Discharge schedule";

	Integer con_state(min=1, max=3) "Concentrator state";
	Integer blk_state(min=1, max=3) "Power block state";
	Integer sch_state(min=1, max=n_sched_states) "Schedule state";

	Real t_con_next "time of next concentrator event";
	Real t_blk_next "time of next power block event";
	Real t_sch_next "time of next schedule change";

initial equation
	E = 0;
	Q_flow_sched = 0;
	con_state = 1;
	blk_state = 1;
	sch_state = 3;
	t_con_next = 0;
	t_blk_next = 0;
	t_sch_next = 8*3600;
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

	when sch_state == 1 then
		Q_flow_sched := 0.4*P_nom/eff_blk;
		t_sch_next := time + 9*3600;
	elsewhen sch_state == 2 then
		Q_flow_sched := P_nom/eff_blk;
		t_sch_next := time + 3*3600;
	elsewhen sch_state == 3 then
		Q_flow_sched := 0.5*P_nom/eff_blk;
		t_sch_next := time + 12*3600;
	end when;
equation
	//Q_flow_sched = 200000;
	Q_flow_chg = eff_rec*Q_flow_rec;

	der(E) = Q_flow_chg - Q_flow_dis;

	Q_flow_rec = if con_state <= 2 then 0 else C*wea.wbus.dni*A_rec;

	Q_flow_dis = if blk_state <= 1 then 0 else Q_flow_sched;

	P_blk = if blk_state <= 2 then 0 else eff_blk*Q_flow_dis;
end SimpleSystem;


