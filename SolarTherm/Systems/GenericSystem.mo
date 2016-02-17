within SolarTherm.Systems;
model GenericSystem
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FIN = SolarTherm.Utilities.Finances;

	// Input Parameters
	// ****************
	parameter String weaFile "Weather file";
	parameter String optFile "Optical efficiency file";
	parameter String priFile = "" "Electricity price file";

	parameter Real SM "Solar multiple";
	parameter SI.Power P_gro "Power block gross rating at design";
	parameter SI.Efficiency eff_cyc = 0.37 "Efficiency of power cycle at design point";
	parameter SI.Efficiency eff_opt = 1 "Efficiency of optics at design point (max in optFile)";
	parameter Real t_storage(unit="h") = 6 "Hours of storage";
	parameter Real ini_frac(min=0, max=1) = 0.0 "Initial fraction charged";
	parameter Boolean const_dispatch = true "Constant dispatch of energy";
	parameter nSI.Angle_deg deploy_angle = 0 "Altitude angle to start tracking";
	parameter nSI.Angle_deg stow_angle = 0 "Altitude angle to stop tracking";

	parameter SI.Temperature rec_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter SI.Temperature tnk_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter SI.Temperature blk_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter SI.Temperature par_T_amb_des = 298.15 "Ambient temperature at design point";
	parameter SI.Irradiance dni_des = 1000 "DNI at design point";
	parameter Real rec_fr = 0.01 "Receiver loss fraction of radiance at design point";
	parameter Real tnk_fr = 0.01 "Tank loss fraction of tank in one day at design point";
	parameter Real par_fr = 0.01 "Parasitics fraction of power block rating at design point";

	// If using SAM values for rec_cf, then convert according to:
	// {c0, c1, c2, c3} -> {0, c0, c1, c2, c3}
	parameter Real rec_cf[:] = {1} "Receiver coefficients";
	parameter Real rec_ca[:] = {1} "Receiver coefficients";
	parameter Real rec_cw[:] = {1} "Receiver coefficients";
	parameter Real tnk_cf[:] = {1} "Tank coefficients";
	parameter Real tnk_ca[:] = {1} "Tank coefficients";
	parameter Real blk_cf[:] = {1} "Power block coefficients";
	parameter Real blk_ca[:] = {1} "Power block coefficients";
	parameter Real par_cf[:] = {1} "Parasitics coefficients";
	parameter Real par_ca[:] = {1} "Parasitics coefficients";

	parameter Real tnk_crit_lb(min=0, max=1) = 0.01;
	parameter Real tnk_crit_ub(min=0, max=1) = 0.05;
	parameter Real tnk_empty_lb(min=0, max=1) = 0.03;
	parameter Real tnk_empty_ub(min=0, max=1) = 0.05;
	parameter Real tnk_full_lb(min=0, max=1) = 0.95;
	parameter Real tnk_full_ub(min=0, max=1) = 0.99;

	// Contingencies should be included
	parameter Real land_mult = 1 "Land area multiplier";
	parameter FIN.AreaPrice pri_field = 0 "Field cost per design aperture area";
	parameter FIN.AreaPrice pri_land = 0 "Land cost per area";
	parameter FIN.PowerPrice pri_receiver = 0 "Receiver cost per design power";
	parameter FIN.EnergyPrice pri_storage = 0 "Storage cost per energy capacity";
	parameter FIN.PowerPrice pri_block = 0 "Power block cost per gross rated power";

	parameter Real pri_om_name(unit="$/W/year") = 0 "O&M cost per nameplate per year";
	parameter Real pri_om_prod(unit="$/J/year") = 0 "O&M cost per production per year";

	parameter Real r_disc = 0.05 "Discount rate";
	parameter Integer t_life(unit="year") = 25 "Lifetime of plant";
	parameter Integer t_cons(unit="year") = 0 "Years of construction";

	// Calculated Parameters
	// *********************
	parameter SI.HeatFlowRate Q_flow_des = P_gro/eff_cyc "Heat to power block at design";
	parameter SI.RadiantPower R_des = SM*Q_flow_des/(1 - rec_fr) "Input power for receiver at design";
	parameter SI.Energy E_max = t_storage*3600*Q_flow_des "Maximum tank stored energy";
	parameter Boolean storage = (t_storage > 0) "Storage component present";

	parameter SI.Area A_field = (R_des/eff_opt)/dni_des "Field area";
	parameter SI.Area A_land = land_mult*A_field "Land area";

	parameter SI.Power P_net = (1 - par_fr)*P_gro "Power block net rating at design";
	parameter SI.Power P_name = P_net "Nameplate power";
	parameter FIN.Money C_cap = A_field*pri_field + A_land*pri_land
		+ R_des*pri_receiver + E_max*pri_storage + P_gro*pri_block
		"Capital cost";
	parameter FIN.MoneyPerYear C_year = P_name*pri_om_name "Cost per year";
	parameter Real C_prod(unit="$/W/year") = pri_om_prod "Cost per production per year";

	SolarTherm.Utilities.Weather.WeatherSource wea(weaFile=weaFile);
	SolarTherm.Optics.SteeredConc con(
		redeclare model OptEff=SolarTherm.Optics.OptEffFile(
			fileName=optFile,
			orient_north=if wea.lat < 0 then true else false
			),
		A_con=A_field,
		steer_rate=0.002, // ~8 minutes till fully on sun
		target_error=0.0001, // if large can be large source of missing energy
		actual_0=0.0
		);
	SolarTherm.Receivers.RecGeneric rec(
		Q_flow_loss_des=rec_fr*R_des,
		R_des=R_des,
		T_amb_des=rec_T_amb_des,
		cf=rec_cf,
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
		eff_des=eff_cyc,
		Q_flow_des=Q_flow_des,
		T_amb_des=blk_T_amb_des,
		cf=blk_cf,
		ca=blk_ca
		);
	SolarTherm.PowerBlocks.ParasiticsGeneric par(
		P_par_des=par_fr*P_gro,
		P_gross_des=P_gro,
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
	FIN.Money R_spot "Spot market revenue";
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
		dis.flow_tar = sched*Q_flow_des;
		connect(tnk.E, dis.level);
		connect(dis.flow_dis, tnk.Q_flow_set);
	else
		connect(rec.Q_flow, blk.Q_flow);
	end if;
	connect(blk.P, par.P_gen);

	P_elec = blk.P - par.P_par;
	connect(P_elec, per.P_elec);
	per.P_sch = sched*P_name;
	connect(per.E_elec, E_elec);
	connect(per.R_spot, R_spot);

	if (wea.wbus.azi <= 180 and wea.wbus.alt >= deploy_angle) or 
			(wea.wbus.azi > 180 and wea.wbus.alt >= stow_angle) then
		con.target = 1;
	else
		con.target = 0;
	end if;

	if const_dispatch then
		sched = 1;
	else
		sched = sch.v;
	end if;
end GenericSystem;
