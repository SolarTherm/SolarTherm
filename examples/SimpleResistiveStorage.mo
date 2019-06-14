within examples;
model SimpleResistiveStorage
	import SI = Modelica.SIunits;
	import FI = SolarTherm.Models.Analysis.Finances;

	extends Modelica.Icons.Example;

	// Input Parameters
	// *********************
	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Mildura_Real2010_Created20130430.motab") "Weather file";
	parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";

	parameter Boolean forecast_scheduler = false "Forecasted dispatch of energy";
	parameter String sch_disch_fixed_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if storage and not forecast_scheduler "Discharging schedule from a file";

	parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file"; // [AUD]

	// Heater:
	parameter Boolean fixed_us = false "true if the size of the upstream i.e heater is fixed";
	parameter SI.HeatFlowRate Q_flow_htr_des(fixed = if fixed_us then true else false) "Heater heat output at design";
	parameter SI.Efficiency eff_htr = 0.99 "Efficiency of heater at design point";

	parameter Real cq_htr[:] = {0, 1} "Polynomial coefficients for heat flow output from heater";
	parameter Real cp_htr[:] = {0, 1} "Polynomial coefficients for power input to heater";

	parameter Real t_chg_start = 10 * 3600 "Charging starting time in day"; // 10am
	parameter Real t_chg_end = 14 * 3600 "Charging ending time in day"; // 2pm

	parameter Real c_poly_chg[:] = {1.2, 0., -1.2} "Polynomial coefficients of charging profile pattern";
	parameter Real mean_chg = 4.32e04 "Mean value in the charging schedule profile"; // for 10-18: mean=5.04e04
	parameter Real std_chg = 7200 "Standard deviation in the charging schedule profiled"; // for 10-18: std=1.44e04

	parameter Boolean flat_chg = false "true if charging at a flat rate";
	parameter Real v_flat_chg = 1 if flat_chg "Constant charging rate if flat_chg is true";

	parameter Real fr_min_htr = 0.3 "Minimum allowed power input to start heater";
	parameter Real fr_max_htr = 1.2 "Maximum allowed power input";

	parameter SI.Time t_htr_on_delay = 3 * 60 "Delay until heater starts";
	parameter SI.Time t_htr_off_delay = 2 * 60 "Delay until heater shuts off";

	parameter Integer ramp_order_htr_cons(min = 0, max = 2) = 0 "ramping filter order for power input to heater";
	parameter Integer ramp_order_htr_prod(min = 0, max = 2) = 0 "ramping filter order for heat output to heater";

	parameter Real CM = 1.5 "Charging multiple";

	// Storage:
	parameter Boolean storage = true "Storage component present";
	parameter Real t_storage(unit = "h") = 4 "Hours of storage";
	parameter Real ini_frac(min = 0, max = 1) = 0.1 "Initial fraction charged";
	parameter Real tnk_min_start = 0.1 "Minimum fraction of tank to start dispatch";

	parameter SI.Temperature tnk_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter Real tnk_fr = 0.7 * 24 * 1e-3 "Tank loss fraction of tank in one day at design point";

	parameter Real tnk_cf[:] = {0, 1} "Tank coefficients";
	parameter Real tnk_ca[:] = {1} "Tank coefficients";

	parameter Real tnk_crit_lb(min = 0, max = 1) = 0.001;
	parameter Real tnk_crit_ub(min = 0, max = 1) = 0.02;
	parameter Real tnk_empty_lb(min = 0, max = 1) = 0.01;
	parameter Real tnk_empty_ub(min = 0, max = 1) = 0.02;
	parameter Real tnk_full_lb(min = 0, max = 1) = 0.98;
	parameter Real tnk_full_ub(min = 0, max = 1) = 0.99;

	// Power block:
	parameter SI.Power P_gro(fixed = if fixed_us then false else true) = 50e6 "Power block gross rating at design";
	parameter SI.Efficiency eff_cyc = 0.37 "Efficiency of power cycle including heat exchanger at design point";

	parameter Real t_blk_heat(unit = "h") = 0.5 "Hours to heat up power block at blk_heat";
	parameter Real t_blk_cool(unit = "h") = 1. "Hours to cool power block";
	parameter Real blk_disp = 0.2 "Min fraction of power to power block";
	parameter Real blk_heat = 0.2 "Fraction of power to block for heating";

	parameter SI.Temperature blk_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter SI.Temperature par_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter Real par_fr = 0.10 "Parasitics fraction of power block rating at design point";
	parameter Real par_fix_fr = 0.0055 "Fixed parasitics as fraction of net rating";

	parameter Real blk_cf[:] = {0.5628, 0.8685, -0.5164, 0.0844} "Power block coefficients";
	parameter Real blk_ca[:] = {1, -0.002} "Power block coefficients";
	parameter Real par_cf[:] = {0.0636, 0.803, -1.58, 1.7134} "Parasitics coefficients";
	parameter Real par_ca[:] = {1, 0.0025} "Parasitics coefficients";

	// Calculated Parameters
	parameter SI.HeatFlowRate Q_flow_pb_des = if fixed_us then Q_flow_htr_des / CM else P_gro / eff_cyc "Heat to power block at design";
	parameter SI.Power P_net = (1 - par_fr) * P_gro "Power block net rating at design";
	parameter SI.Power P_name = P_net "Nameplate power";

	parameter SI.Energy E_max = t_storage * 3600 * Q_flow_pb_des "Maximum tank stored energy";

	parameter SI.Power P_htr_des = Q_flow_htr_des / eff_htr "Power to heater at design";
	parameter SI.Power P_htr_min = fr_min_htr * P_htr_des "Minimum allowed power to heater";
	parameter SI.Power P_htr_max = fr_max_htr * P_htr_des "Maximum allowed power to heater";

	// Cost data
	parameter Real r_cur = 0.71 "The currency rate from AUD to USD"; // Valid for 2019. See https://www.rba.gov.au/
	parameter Real r_contg = 1.07 "Contingency rate";

	parameter FI.EnergyPrice pri_storage = (24 / (1e3 * 3600) * r_contg) / r_cur "Storage cost per energy capacity"; // [AUD]
	parameter FI.PowerPrice pri_block = (1100 / 1e3 * r_contg) / r_cur "Power block cost per gross rated power"; // [AUD]
	parameter FI.PowerPrice pri_bop = (340 / 1e3 * r_contg) / r_cur "Balance of plant cost per gross rated power"; // [AUD]

	parameter Real pri_om_name(unit = "$/W/year") = (66 / 1e3) / r_cur "O&M cost per nameplate per year"; // [AUD]
	parameter Real pri_om_prod(unit = "$/J/year") = (3.5 / (1e6 * 3600)) / r_cur "O&M cost per production per year"; // [AUD]

	parameter Real r_disc = 0.05 "Discount rate";
	parameter Integer t_life(unit = "year") = 25 "Lifetime of plant";
	parameter Integer t_cons(unit = "year") = 2 "Years of construction";

	parameter FI.Money C_heater(fixed = false) "Heater cost"; // [AUD]
	parameter FI.Money C_field = C_heater "Field cost"; // [AUD]
	parameter FI.Money C_site = 0 "Site improvements cost"; // [AUD]
	parameter FI.Money C_tower = 0 "Tower cost"; // [AUD]
	parameter FI.Money C_receiver = 0 "Receiver cost"; // [AUD]
	parameter FI.Money C_storage = E_max * pri_storage "Storage cost"; // [AUD]
	parameter FI.Money C_block = P_gro * pri_block "Power block cost"; // [AUD]
	parameter FI.Money C_bop = P_gro * pri_bop "Balance of plant cost"; // [AUD]
	parameter FI.Money C_land = 0 "Land cost"; // [AUD]

	parameter FI.Money C_cap = C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop + C_land "Capital costs"; // [AUD]

	parameter FI.MoneyPerYear C_year = P_name * pri_om_name "Cost per year"; // [AUD]
	parameter Real C_prod(unit = "$/J/year") = pri_om_prod "Cost per production per year"; // [AUD]

	// System components
	// *********************
	SolarTherm.Models.Sources.Weather.WeatherSource wea(file = wea_file, delay = wdelay) "Weather component";

	SolarTherm.Models.Sources.Date.SimpleDate date "Date and time calculator";

	SolarTherm.Models.Sources.Schedule.DailySchedPoly sch_chg(
		t_start = t_chg_start,
		t_end = t_chg_end,
		c_poly = c_poly_chg,
		mean = mean_chg,
		std = std_chg,
		flat = flat_chg,
		v_flat = v_flat_chg) "Charging schedule";

	SolarTherm.Models.Fluid.HeatExchangers.ResistiveHeater HTR(
		P_des = P_htr_des,
		P_min = P_htr_min,
		P_max = P_htr_max,
		Q_flow_des = Q_flow_htr_des,
		cq_htr = cq_htr,
		cp_htr = cp_htr,
		eff_htr = eff_htr,
		t_htr_on_delay = t_htr_on_delay,
		t_htr_off_delay = t_htr_off_delay,
		ramp_order_cons = ramp_order_htr_cons,
		ramp_order_prod = ramp_order_htr_prod) "Resistive heater";

	SolarTherm.Models.Storage.Tank.GenericST ST(
		E_max = E_max,
		E_0 = E_max * ini_frac,
		Q_flow_loss_des = tnk_fr * E_max / (24 * 3600),
		T_amb_des = tnk_T_amb_des,
		cf = tnk_cf,
		ca = tnk_ca) if storage "Storage tank";

	SolarTherm.Models.PowerBlocks.GenericStartPB PB(
		eff_des = eff_cyc,
		Q_flow_des = Q_flow_pb_des,
		T_amb_des = blk_T_amb_des,
		cf = blk_cf,
		ca = blk_ca,
		Q_flow_disp = blk_disp * Q_flow_pb_des,
		Q_flow_heat = blk_heat * Q_flow_pb_des,
		t_heat = t_blk_heat * 3600,
		t_cool = t_blk_cool * 3600) "Power block";

	SolarTherm.Models.PowerBlocks.GenericParasitics par(
		P_par_des = par_fr * P_gro,
		P_gross_des = P_gro,
		T_amb_des = par_T_amb_des,
		cf = par_cf,
		ca = par_ca) "Power block parasitics";

	SolarTherm.Models.Control.TankDispatch dis(
		full_lb = tnk_full_lb * E_max,
		full_ub = tnk_full_ub * E_max,
		empty_lb = tnk_empty_lb * E_max,
		empty_ub = tnk_empty_ub * E_max,
		crit_lb = tnk_crit_lb * E_max,
		crit_ub = tnk_crit_ub * E_max,
		level_start = tnk_min_start * E_max,
		disp_min = blk_disp * Q_flow_pb_des,
		heat_rate = blk_heat * Q_flow_pb_des) if storage "Dispatch controller";

	SolarTherm.Models.Sources.Schedule.Scheduler sch_disch_fixed(
		file = sch_disch_fixed_file,
		ndaily = 8,
		wmap = {{7, 7, 7, 7, 7, 7, 7}},
		mmap = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}) if storage and not forecast_scheduler "Fixed dispatch schedule";

	// Needs to be configured in instantiation if forecast_scheduler
	SolarTherm.Models.Sources.Schedule.ForecastScheduler sch_disch_fcst if storage and forecast_scheduler "Forecast dispatch schedule";

	SolarTherm.Models.Analysis.Performance per(schedule = true, pri_file = pri_file) "Plant energy/revenue calculator";

	// Variables
	// *********************
	Real sched if storage;

	SI.Power P_elec(displayUnit="MW") "Net electrical power out";
	SI.Energy E_elec(start=0) "Generated electricity";

	FI.Money R_spot(start=0) "Spot market revenue";

initial equation
		if fixed_us then
			P_gro = Q_flow_pb_des * eff_cyc;
		else
			Q_flow_htr_des = CM * Q_flow_pb_des;
		end if;

	C_heater = 1e6 * FI.resistiveHeaterCost_P(P_htr_des / 1e6) * r_contg; // AUD

equation
	if storage then
		connect(wea.wbus, ST.wbus);
	end if;

	connect(wea.wbus, PB.wbus);
	connect(wea.wbus, par.wbus);

	HTR.grid = true;
	date.tod = sch_chg.t;

	if sch_chg.v <=1e-4 then // slight numerical overshoot
		HTR.P = 0;
	else
		HTR.P = sch_chg.v * P_htr_des;
	end if;

	if storage then
		connect(HTR.Q_flow, ST.Q_flow_in);
		connect(ST.Q_flow_out, PB.Q_flow);
		connect(ST.Q_flow_in, dis.flow_in);
		dis.flow_tar = sched * Q_flow_pb_des;
		connect(ST.E, dis.level);
		connect(PB.heated, dis.heated);
		connect(dis.flow_dis, ST.Q_flow_set);
		connect(dis.full, HTR.derate);
		connect(dis.flow_set, HTR.Q_flow_dr);
	else
		connect(HTR.Q_flow, PB.Q_flow);
		HTR.derate = false;
		HTR.Q_flow_dr = 0;
	end if;

	connect(PB.P, par.P_gen);
	P_elec = PB.P - par.P_par - par_fix_fr * P_net;
	connect(P_elec, per.P_elec);
	per.P_sch = sched * P_name;
	connect(per.E_elec, E_elec);
	connect(per.R_spot, R_spot);

	if forecast_scheduler then
		sched = 1; // Needs to be updatd based on sch_disch_fcst once it is implemented.
	else
		connect(wea.wbus, sch_disch_fixed.wbus);
		sched = sch_disch_fixed.v;
	end if;

	annotation(
	experiment(StartTime = 0, StopTime = 31536000.0, Tolerance = 1e-06, Interval = 60),
	__OpenModelica_simulationFlags(s = "rungekutta"),
	Documentation(revisions="<html>
		<p>Developed by<b>A. Shirazi</b></p>
		</html>"
		));
end SimpleResistiveStorage;
