model GenericSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;

	//parameter String weaFile = "resources/Alice_Springs_Real2000_Created20130430.motab";
	// Alice springs insolation looks out of time with altitude/azimuth
	// Also Mildura:
	parameter String weaFile = "resources/Mildura_Real2010_Created20130430.motab";
	// Might have to deactivate price calcs if not connected to NEM
	parameter String priFile = "resources/aemo_vic_2014.motab";
	parameter String fluxFile = "resources/field_flux.motab";

	parameter Real sm = 2.5 "Solar multiple";
	parameter SI.Power P_nom = 100e6 "Nominal power output";
	parameter SI.Efficiency eff_cyc = 0.37 "Efficiency of power cycle";
	parameter Real t_storage(unit="h") = 6 "Hours of storage";

	parameter SI.HeatFlowRate Q_flow_max = P_nom/eff_cyc "Max energy to power block";
	parameter SI.RadiantPower R_des = sm*Q_flow_max "Design power for receiver";
	parameter SI.Energy E_max = t_storage*3600*R_des "Maximum tank stored energy";

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
		Q_flow_loss_des=0.03*R_des,
		R_des=R_des,
		T_amb_des=293,
		ci0=4.75,
		ci1=-8,
		ci2=4.5,
		ci3=-0.25,
		ca0=1,
		ca1=0,
		ca2=0,
		ca3=0,
		cw0=1,
		cw1=0,
		cw2=0,
		cw3=0
		);
	SolarTherm.Storage.TankGeneric tnk(
		E_max=E_max,
		E_0=0,
		Q_flow_max=Q_flow_max
		);
	SolarTherm.PowerBlocks.PBGeneric blk(
		eff=eff_cyc
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
