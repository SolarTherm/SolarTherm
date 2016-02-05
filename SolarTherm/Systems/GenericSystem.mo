within SolarTherm.Systems;
model GenericSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;

	parameter String weaFile "Weather file";
	parameter String fluxFile "Field flux file";

	parameter Real sm "Solar multiple";
	parameter SI.Power P_nom "Nominal power output";
	parameter SI.Efficiency eff_cyc "Efficiency of power cycle";
	parameter Real t_storage(unit="h") "Hours of storage";

	parameter Real rec_ci[:] "Receiver coefficients";
	parameter Real rec_ca[:] "Receiver coefficients";
	parameter Real rec_cw[:] "Receiver coefficients";
	parameter Real tnk_cf[:] "Tank coefficients";
	parameter Real tnk_ca[:] "Tank coefficients";
	parameter Real blk_cf[:] "Power block coefficients";
	parameter Real blk_ca[:] "Power block coefficients";

	parameter SI.HeatFlowRate Q_flow_max = P_nom/eff_cyc "Max energy to power block";
	parameter SI.RadiantPower R_des = sm*Q_flow_max "Design power for receiver";
	parameter SI.Energy E_max = t_storage*3600*R_des "Maximum tank stored energy";

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
		Q_flow_loss_des=0.03*R_des,
		R_des=R_des,
		T_amb_des=293,
		ci=rec_ci,
		ca=rec_ca,
		cw=rec_cw
		);
	SolarTherm.Storage.TankGeneric tnk(
		E_max=E_max,
		E_0=0,
		Q_flow_max=Q_flow_max,
		Q_flow_loss_des=0.05*E_max/(t_storage*3600),
		T_amb_des=293,
		cf=tnk_cf,
		ca=tnk_ca
		);
	SolarTherm.PowerBlocks.PBGeneric blk(
		eff_des=eff_cyc,
		Q_flow_max=Q_flow_max,
		T_amb_des=293,
		cf=blk_cf,
		ca=blk_ca
		);
	SolarTherm.Control.Trigger full_trig(
		low=0.9*E_max,
		up=0.95*E_max,
		y_0=true);
	SolarTherm.Control.Trigger not_empty_trig(
		low=0.05*E_max,
		up=0.1*E_max,
		y_0=false);
	SI.Power P_elec;
equation
	connect(wea.wbus, con.wbus);
	connect(wea.wbus, rec.wbus);
	connect(wea.wbus, tnk.wbus);
	connect(wea.wbus, blk.wbus);
	connect(con.R_foc, rec.R);
	connect(rec.Q_flow, tnk.Q_flow_in);
	connect(tnk.Q_flow_out, blk.Q_flow);
	connect(tnk.E, full_trig.x);
	connect(tnk.E, not_empty_trig.x);
	con.target = 1;
	tnk.fac_in = if full_trig.y then 0 else 1;
	tnk.fac_out = if not_empty_trig.y then 1 else 0;
	P_elec = blk.P_out;
end GenericSystem;
