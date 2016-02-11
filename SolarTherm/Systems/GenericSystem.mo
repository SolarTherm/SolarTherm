within SolarTherm.Systems;
model GenericSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;

	parameter String weaFile "Weather file";
	parameter String fluxFile "Field flux file";
	parameter String priFile = "" "Electricity price file";

	parameter Real SM "Solar multiple";
	parameter SI.Power P_gross "Gross rating of power block";
	parameter SI.Power P_rate "Net rating of power block";
	parameter SI.Efficiency eff_cyc = 0.37 "Efficiency of power cycle at design point";
	parameter Real t_storage(unit="h") = 6 "Hours of storage";
	parameter Real ini_frac(min=0, max=1) = 0.0 "Initial fraction charged";
	parameter Boolean const_dispatch = true "Constant dispatch of energy";

	parameter SI.Temperature rec_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter SI.Temperature tnk_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter SI.Temperature blk_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter SI.Temperature par_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter Real rec_fr = 0.01 "Receiver loss fraction of radiance at design point";
	parameter Real tnk_fr = 0.01 "Tank loss fraction of tank in one day at design point";
	parameter Real par_fr = 0.01 "Parasitics fraction of power block rating at design point";
	// If using SAM values for rec_ci, then convert according to:
	// {c0, c1, c2, c3} -> {0, c0, c1, c2, c3}
	parameter Real rec_ci[:] = {1} "Receiver coefficients";
	parameter Real rec_ca[:] = {1} "Receiver coefficients";
	parameter Real rec_cw[:] = {1} "Receiver coefficients";
	parameter Real tnk_cf[:] = {1} "Tank coefficients";
	parameter Real tnk_ca[:] = {1} "Tank coefficients";
	parameter Real blk_cf[:] = {1} "Power block coefficients";
	parameter Real blk_ca[:] = {1} "Power block coefficients";
	parameter Real par_cf[:] = {1} "Parasitics coefficients";
	parameter Real par_ca[:] = {1} "Parasitics coefficients";

	parameter SolarTherm.Utilities.Finances.Money C_cap "Capital costs";
	parameter SolarTherm.Utilities.Finances.MoneyPerYear C_main
		"Maintenance costs for each year";
	parameter Real r_disc = 0.05 "Discount rate";
	parameter Integer t_life(unit="year") = 20 "Lifetime of plant";
	parameter Integer t_cons(unit="year") = 1 "Years of construction";

	parameter Real tnk_crit_lb(min=0, max=1) = 0.01;
	parameter Real tnk_crit_ub(min=0, max=1) = 0.05;
	parameter Real tnk_empty_lb(min=0, max=1) = 0.03;
	parameter Real tnk_empty_ub(min=0, max=1) = 0.05;
	parameter Real tnk_full_lb(min=0, max=1) = 0.95;
	parameter Real tnk_full_ub(min=0, max=1) = 0.99;

	parameter SI.HeatFlowRate Q_flow_rate = P_gross/eff_cyc "Rated heat to power block";
	parameter SI.RadiantPower R_des = SM*Q_flow_rate "Design power for receiver";
	parameter SI.Energy E_max = t_storage*3600*Q_flow_rate "Maximum tank stored energy";
	parameter Boolean storage = (t_storage > 0) "Storage component present";

	SolarTherm.Utilities.Weather.WeatherSource wea(weaFile=weaFile);
	SolarTherm.Optics.SteeredConc con(
		redeclare model FluxMap=SolarTherm.Optics.FluxMapFile(
			fileName=fluxFile,
			R_des=R_des
			),
		steer_rate=0.001,
		target_error=0.001,
		actual_0=1.0
		);
	SolarTherm.Receivers.RecGeneric rec(
		Q_flow_loss_des=rec_fr*R_des,
		R_des=R_des,
		T_amb_des=rec_T_amb_des,
		ci=rec_ci,
		ca=rec_ca,
		cw=rec_cw
		);
	SolarTherm.Storage.TankGeneric tnk(
		E_max=E_max,
		E_0=E_max*ini_frac,
		Q_flow_loss_des=tnk_fr*E_max/(24*3600),
		T_amb_des=tnk_T_amb_des,
		cf=tnk_cf,
		ca=tnk_ca
		) if storage;
	SolarTherm.PowerBlocks.PBGeneric blk(
		eff_cyc=eff_cyc,
		Q_flow_rate=Q_flow_rate,
		T_amb_des=blk_T_amb_des,
		cf=blk_cf,
		ca=blk_ca
		);
	SolarTherm.PowerBlocks.ParasiticsGeneric par(
		P_par_des=par_fr*P_gross,
		P_gross_des=P_gross,
		T_amb_des=par_T_amb_des,
		cf=par_cf,
		ca=par_ca
		);
	SolarTherm.Control.TankDispatch dis(
		full_lb=tnk_full_lb*E_max,
		full_ub=tnk_full_ub*E_max,
		empty_lb=tnk_empty_lb*E_max,
		empty_ub=tnk_empty_ub*E_max,
		crit_lb=tnk_crit_lb*E_max,
		crit_ub=tnk_crit_ub*E_max
		) if storage;
	// Needs to be configured in instantiation if not const_dispatch
	SolarTherm.Utilities.Schedule.Scheduler sch if not const_dispatch;
	SolarTherm.Utilities.Performance.EnergyPerf per(
		schedule=true,
		priFile=priFile
		);
	
	Real sched;
	SI.Power P_elec "Net electrical power out";
	SI.Energy E_elec "Generated electricity";
	SolarTherm.Utilities.Finances.Money R_spot "Spot market revenue";
equation
	connect(wea.wbus, con.wbus);
	connect(wea.wbus, rec.wbus);
	if storage then
		connect(wea.wbus, tnk.wbus);
	end if;
	connect(wea.wbus, blk.wbus);
	connect(wea.wbus, par.wbus);

	connect(con.R_foc, rec.R);
	if storage then
		connect(rec.Q_flow, tnk.Q_flow_in);
		connect(tnk.Q_flow_out, blk.Q_flow);

		connect(tnk.Q_flow_in, dis.flow_in);
		dis.flow_tar = sched*Q_flow_rate;
		connect(tnk.E, dis.level);
		connect(dis.flow_dis, tnk.Q_flow_set);
	else
		connect(rec.Q_flow, blk.Q_flow);
	end if;
	connect(blk.P_gen, par.P_gen);

	P_elec = blk.P_gen - par.P_par;
	connect(P_elec, per.P_elec);
	per.P_sch = sched*P_rate;
	connect(per.E_elec, E_elec);
	connect(per.R_spot, R_spot);

	con.target = 1;

	if const_dispatch then
		sched = 1;
	else
		sched = sch.v;
	end if;
end GenericSystem;
