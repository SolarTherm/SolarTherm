within SolarTherm.Systems;
model GenericSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;

	parameter String weaFile "Weather file";
	parameter String fluxFile "Field flux file";
	parameter String priFile "Electricity price file";

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
	SolarTherm.Utilities.Finances.SpotPriceTable pri(fileName=priFile);

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
	SolarTherm.Control.Trigger full_trig(
		low=tnk_full_lb*E_max,
		up=tnk_full_ub*E_max,
		y_0=true
		) if storage;
	SolarTherm.Control.Trigger not_empty_trig(
		low=tnk_empty_lb*E_max,
		up=tnk_empty_ub*E_max,
		y_0=false
		) if storage;
	SolarTherm.Control.Trigger not_crit_trig(
		low=tnk_crit_lb*E_max,
		up=tnk_crit_ub*E_max,
		y_0=false
		) if storage;
	// Needs to be configured in instantiation if not const_dispatch
	SolarTherm.Utilities.Schedule.Scheduler sch if not const_dispatch;
	
	Real sched;
	SI.HeatFlowRate Q_flow_sch "Scheduled heat flow";
	Boolean full if storage;
	Boolean empty if storage;
	Boolean crit if storage;
	SI.Power P_elec "Net electrical power out";
	SI.Energy E_elec(start=0, fixed=true) "Generated electricity";
	SolarTherm.Utilities.Finances.Money R_spot(start=0, fixed=true)
		"Spot market revenue";
protected
	SolarTherm.Utilities.Polynomial.Poly par_fac_fra(c=par_cf);
	SolarTherm.Utilities.Polynomial.Poly par_fac_amb(c=par_ca);
equation
	connect(wea.wbus, con.wbus);
	connect(wea.wbus, rec.wbus);
	if storage then
		connect(wea.wbus, tnk.wbus);
	end if;
	connect(wea.wbus, blk.wbus);
	connect(con.R_foc, rec.R);
	if storage then
		connect(rec.Q_flow, tnk.Q_flow_in);
		connect(tnk.Q_flow_out, blk.Q_flow);
		connect(tnk.E, full_trig.x);
		connect(tnk.E, not_empty_trig.x);
		connect(tnk.E, not_crit_trig.x);
	else
		connect(rec.Q_flow, blk.Q_flow);
	end if;

	par_fac_fra.x = blk.P_out/P_gross;
	par_fac_amb.x = wea.wbus.Tdry - par_T_amb_des;
	P_elec = blk.P_out - par_fr*P_gross*par_fac_fra.y*par_fac_amb.y;
	der(E_elec) = P_elec;
	der(R_spot) = P_elec*pri.price;

	con.target = 1;

	if const_dispatch then
		sched = 1;
	else
		sched = sch.v;
	end if;

	Q_flow_sch = sched*Q_flow_rate;

	if storage then
		full = full_trig.y;
		empty = not not_empty_trig.y;
		crit = not not_crit_trig.y;
		if full then
			tnk.Q_flow_out = max(tnk.Q_flow_in, Q_flow_sch);
		elseif crit then
			tnk.Q_flow_out = 0;
		elseif empty then
			tnk.Q_flow_out = min(tnk.Q_flow_in, Q_flow_sch);
		else
			tnk.Q_flow_out = Q_flow_sch;
		end if;
	end if;
end GenericSystem;
