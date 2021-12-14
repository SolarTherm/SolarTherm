within examples;
model SimpleSystemOperation "High temperature Sodium-sCO2 system"
	extends Modelica.Icons.Example;
	// Imports
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import SI = Modelica.SIunits;
	import FI = SolarTherm.Models.Analysis.Finances;
	import SolarTherm.Utilities.*;
	import metadata = SolarTherm.Utilities.Metadata_Optics;
	import SolarTherm.Models.Sources.SolarFunctions.*;
	import Modelica.SIunits.Conversions.*;

	// Parameters
	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/solana_tmy_2008.motab");
	parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab");
	parameter Real pi = Modelica.Constants.pi;

	parameter nSI.Angle_deg lon = -112.9795 "Longitude (+ve East)";
	parameter nSI.Angle_deg lat = 32.9215 "Latitude (+ve North)";
	parameter nSI.Time_hour t_zone = -8 "Local time zone (UCT=0)";
	parameter Integer year = 2008 "Meteorological year";

	parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/gen3liq_350_MWth_150_m_2.0mrad.motab");
	parameter Real metadata_list[23] = metadata(opt_file);
	parameter Integer n_heliostat = integer(metadata_list[1]) "Number of heliostats";
	parameter SI.Area A_heliostat = metadata_list[2] "Heliostat module reflective area";
	parameter SI.Area A_field = n_heliostat * A_heliostat "Heliostat field reflective area";
	parameter Real SM = metadata_list[23] "Solar multiple";

	parameter SI.Efficiency ab_rec = 0.98 "Receiver coating absorptance";
	parameter SI.Efficiency em_rec = 0.91 "Receiver coating emissivity";
	parameter SI.Diameter D_receiver = metadata_list[4] "Receiver diameter";
	parameter SI.Length H_receiver = metadata_list[5] "Receiver height";
	parameter SI.HeatFlowRate Q_rec_out_des = Q_flow_des * SM "Heat from receiver at design";
	parameter Real[4] CL = {metadata_list[8],metadata_list[9],metadata_list[10],metadata_list[11]};
	parameter Real[4] C4L = {metadata_list[12],metadata_list[13],metadata_list[14],metadata_list[15]};
	parameter Real[5] CH = {metadata_list[16],metadata_list[17],metadata_list[18],metadata_list[19],metadata_list[20]};
	parameter SI.Temperature T_cold_set_CS = from_degC(500) "Cold tank target temperature";

	parameter SI.HeatFlowRate Q_flow_des = P_gross/eff_blk "Heat to power block at design, By product of PB initialisation, regardless which PB model is chosen e.g CEA or SAM";
	parameter Real par_fr = 0.1 "Parasitics fraction of power block rating at design point";
	parameter SI.Power P_gross = P_name / (1 - par_fr);

	parameter Real const_t = -dt;
	parameter Integer horizon = 120 "Forecast horizon of the receiver dispatch algorithm";
	parameter Real dt = 60 "Forecast time step, in seconds";
	parameter SI.Angle ele_min = from_deg(8) "Heliostat stow deploy angle";
	parameter Real nu_min = 0.25;
	parameter SI.HeatFlowRate Q_start = nu_min*Q_rec_out_des/eff_rec;
	parameter SI.HeatFlowRate Q_stop = nu_min*Q_rec_out_des/eff_rec;

	parameter SI.Area A_rec = pi*D_receiver*H_receiver "Area of receiver aperture";
	parameter SI.Efficiency eff_rec = 0.85 "Receiver efficiency";
	parameter SI.Efficiency eff_blk = 0.48 "Power block efficiency at design point";
	parameter SI.Power P_name = 50e6 "Nameplate rating of power block";
	parameter Real t_storage(unit="h") = 12 "Hours of storage";
	parameter SI.Energy E_max = P_name*t_storage*3600/eff_blk "Max stored energy";

	parameter SI.Energy E_up_u = 0.95*E_max "Upper energy limit";
	parameter SI.Energy E_up_l = 0.93*E_max "Upper energy limit";
	parameter SI.Energy E_low_u = 0.07*E_max "Lower energy limit";
	parameter SI.Energy E_low_l = 0.05*E_max "Lower energy limit";
	parameter SI.Irradiance dni_stop = 100 "DNI at which concentrator stops";
	parameter SI.Irradiance dni_start = 200 "DNI at which concentrator starts";

	parameter SI.Time t_con_up_min = 0 "Minimum operation time after concentrator starts";
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

	parameter FI.Money C_field = 120*A_field "Field cost";
	parameter FI.Money C_site = 0 "Site improvements cost";
	parameter FI.Money C_tower = 0 "Tower cost";
	parameter FI.Money C_receiver = 135*A_rec "Receiver cost";
	parameter FI.Money C_storage = (30/(1e3*3600))*E_max "Storage cost";
	parameter FI.Money C_block = (1440/1e3)*P_name "Power block cost";
	parameter FI.Money C_bop = 0 "Balance of plant cost";
	parameter FI.Money C_land = 0 "Land cost";
	parameter FI.Money C_cap = C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop + C_land "Capital costs";

	parameter FI.MoneyPerYear C_year =
			10*A_field // field cleaning/maintenance
			"Cost per year";
	parameter Real C_prod(unit="$/J/year") = 0 "Cost per production per year";
	parameter Real r_disc = 0.05 "Discount rate";
	parameter Integer t_life = 20 "Lifetime of plant";
	parameter Integer t_cons = 1 "Years of construction";

	parameter Boolean constrained = false "Constraint is present in optimisation if true";
		// If there is a constraint, then "constrained" must be a 'variable' Boolean
		// whose value is determined through an if statement with a constraint being the condition.
		// Note in this case the if block must be moved to the equation section.
	parameter Real distance = 0 "Distance to be added to a constant offset as added penalty when a constraint is not respected";
		// e.g. for euclidean distance: if T > T0 then constrained=true & distance=sqrt((T-T0)^2)
		// e.g. for quadratic distance: if T > T0 then constrained=true & distance=(T-T0)^2
		// e.g. for a constraint like T1 < T < T2, then T0 = (T1 + T2)/2

	SI.HeatFlowRate Q_flow_rec "Heat flow into receiver";
	FI.Money R_spot(start=0, fixed=true) "Spot market revenue";
	SI.Energy E_elec(start=0, fixed=true) "Generate electricity";

	// Models
	Modelica.Blocks.Types.ExternalCombiTable1D wea_table = Modelica.Blocks.Types.ExternalCombiTable1D(
		tableName = "weather",
		fileName = wea_file,
		table = fill(0.0, 0, 2),
		columns = 1:9,
		smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative);

	Modelica.Blocks.Types.ExternalCombiTable2D opt_table = Modelica.Blocks.Types.ExternalCombiTable2D(
		tableName = "optics", 
		fileName = opt_file, 
		table = fill(0.0, 0, 2), 
		smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative);

	SolarTherm.Models.Sources.SolarModel.Sun sun(lat = lat, lon = lon, t_zone = t_zone, year = year);
	SolarTherm.Models.Sources.Weather.WeatherSource wea(file=wea_file);
	Modelica.Blocks.Sources.RealExpression dni_input(y = wea.wbus.dni);

protected
	// Variables
	SI.HeatFlux dni_horizon[horizon] "DNI for the next horizon";
	SI.Efficiency eta_op_horizon[horizon] "Optical efficiency for the next horizon";
	SI.Angle dec_horizon[horizon] "Forecast declination angle";
	SI.Angle hra_horizon[horizon] "Forecast hour angle";
	SI.Time time_simul "Current simulation second";
	Real counter(start = const_t);
public
	SI.HeatFlowRate Q_raw "Raw field output";
	SI.Time t_forecast "Startup time forecast";
	SI.Efficiency eta_opt "Field optical efficiency";
	SI.Angle ele "Elevation angle";

	FI.SpotPriceTable pri(file=pri_file);

	SI.HeatFlowRate Q_flow_chg "Heat flow into tank";
	SI.HeatFlowRate Q_flow_dis "Heat flow out of tank";
	SI.Power P_elec "Output power of power block";

	Real fr_dfc(min=0, max=1) "Target energy fraction of the heliostat fistateld at the defocused state";
	Boolean full "True if the storage tank is full";

	Real fr_ramp_con (min=0.0, max=1.0) "ramping transition rate for the concentrator";
	SolarTherm.Utilities.Transition.Ramp ramp_up_blk(ramp_order=ramp_order, t_dur= t_blk_on_delay, up=true);
	SolarTherm.Utilities.Transition.Ramp ramp_down_blk(ramp_order=ramp_order, t_dur= t_blk_off_delay, up=false);
	Real fr_ramp_blk (min=0.0, max=1.0) "ramping transition rate for the power block";

	SI.Energy E(min=0, max=E_max) "Stored energy";

	SI.HeatFlowRate Q_flow_sched "Discharge schedule";

	Integer con_state(min=1, max=5) "Concentrator state";
	Integer blk_state(min=1, max=4) "Power block state";
	Integer sch_state(min=1, max=n_sched_states) "Schedule state";

protected
	SI.Time  t_con_w_now "Time of concentrator current warm-up event";
	SI.Time  t_con_w_next "Time of concentrator next warm-up event";
	SI.Time  t_con_c_now "Time of concentrator current cool-down event";
	SI.Time  t_con_c_next "Time of concentrator next cool-down event";
	SI.Time  t_blk_w_now "Time of power block current warm-up event";
	SI.Time  t_blk_w_next "Time of power block next warm-up event";
	SI.Time  t_blk_c_now "Time of power block current cool-down event";
	SI.Time  t_blk_c_next "Time of power block next cool-down event";
	SI.Time  t_sch_next "Time of next schedule change";

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
	when con_state == 2 and E >= E_up_u then
		con_state := 1; // off sun
	elsewhen con_state == 3 and (Q_raw <= Q_stop) and t_con_off_delay > 0 then
		con_state := 5; // ramp down
	elsewhen con_state == 3 and (Q_raw <= Q_stop) and t_con_off_delay <= 0 then
		con_state := 1; // off sun(no ramp-down)
	elsewhen con_state == 3 and full then
		con_state := 4; // on sun at part load
	elsewhen con_state == 4 and not full then
		con_state := 3; // on sun at full load
	elsewhen con_state == 4 and (Q_raw <= Q_stop) and t_con_off_delay > 0 then
		con_state := 5; // ramp down
	elsewhen con_state == 4 and (Q_raw <= Q_stop) and t_con_off_delay <= 0 then
		con_state := 1; // off sun (no ramp-down)
	elsewhen con_state == 1 and t_forecast >= (t_con_on_delay + t_con_up_min) and E <= E_up_l and t_con_on_delay > 0 then
		con_state := 2; // start onsteering (i.e. ramp up)
	elsewhen con_state == 1 and t_forecast >= (t_con_on_delay + t_con_up_min) and E <= E_up_l and t_con_on_delay <= 0 then
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
		fr_ramp_con := if ramp_order == 0 then 0.0 else abs(((time - t_con_w_now) / t_con_on_delay));
	elseif con_state == 5 then
		fr_ramp_con := if ramp_order == 0 then 0.0 else abs(((time - t_con_c_now) / t_con_off_delay));
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
	der(counter) = 1;
	connect(sun.dni, dni_input.y);
	
	when counter> 0 then
		time_simul = floor(time);
		for i in 1:horizon loop
			(dec_horizon[i],hra_horizon[i]) = PSA_Algorithm(if time_simul + i * dt < 31536000 then time_simul + i * dt else time_simul + i * dt - 31536000, lon, lat, t_zone, year);
			dni_horizon[i] = horizon_function(if time_simul + i * dt < 31536000 then time_simul + i * dt else time_simul + i * dt - 31536000, 3, wea_table);
			eta_op_horizon[i] = opt_eff_horizon(to_deg(dec_horizon[i]), to_deg(hra_horizon[i]), opt_table);
		end for;
		reinit(counter,const_t);
	end when;
	ele = SolarTherm.Models.Sources.SolarFunctions.elevationAngle(sun.dec,sun.hra,lat);
	eta_opt = opt_eff_horizon(to_deg(sun.dec), to_deg(sun.hra), opt_table);
	Q_raw = wea.wbus.dni*eta_opt*A_field;
	t_forecast = if ele > ele_min then ReceiverStartupTime(horizon,dni_horizon,eta_op_horizon,A_field,dt,Q_start) else 0;

	ramp_up_blk.x = t_blk_w_now;
	ramp_down_blk.x = t_blk_c_now;

	Q_flow_chg = eff_rec*Q_flow_rec;

	der(E) = Q_flow_chg - Q_flow_dis;

	if con_state <= 1 then
		Q_flow_rec = 0;
		fr_dfc = 0;
	elseif con_state == 2 then
		Q_flow_rec = fr_ramp_con * max(eta_opt*wea.wbus.dni*A_field, 0);
		fr_dfc = if ramp_order == 0 then 0 else 1;
	elseif con_state == 5 then
		Q_flow_rec = fr_ramp_con * max(eta_opt*wea.wbus.dni*A_field, 0);
		fr_dfc = if ramp_order == 0 then 0 else 1;
	else
		if full then
			if eff_rec*(eta_opt*wea.wbus.dni*A_field) > Q_flow_dis then
				Q_flow_rec = min(Q_flow_dis/eff_rec, max(eta_opt*wea.wbus.dni*A_field, 0));
				fr_dfc = Q_flow_dis / (max(eta_opt*wea.wbus.dni*A_field, 0) + 1e-10);
			else
				Q_flow_rec = max(eta_opt*wea.wbus.dni*A_field, 0);
				fr_dfc = 1;
			end if;
		else
			Q_flow_rec = max(eta_opt*wea.wbus.dni*A_field, 0);
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
end SimpleSystemOperation;
