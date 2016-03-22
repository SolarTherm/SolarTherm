model EnergySystem
	import Modelica.Constants.pi;
	parameter String wea_file = "resources/weather/Mildura_Real2010_Created20130430.motab";
	parameter Real A_con = 1;
	parameter Real E_max = 1*3600*1000;
	SolarTherm.Sources.Weather.WeatherSource wea(file=wea_file);
	SolarTherm.Collectors.SwitchedCL con(
		redeclare model OptEff=SolarTherm.Collectors.IdealIncOE(alt_fixed=45),
		A_con=A_con
		);
	SolarTherm.Receivers.FixedEffRC rec(eff=0.8);
	SolarTherm.Fluid.Valves.EnergySplitter spl;
	SolarTherm.Fluid.Sources.EnergySourceSink ess;
	SolarTherm.Storage.EnergyST tnk(E_max=E_max, E_0=0.1*E_max);
	SolarTherm.Fluid.Pumps.EnergyPump pmp(P_max=0.7*blk.P_max);
	SolarTherm.PowerBlocks.EnergyPB blk(eff=0.9, P_max=500);
	SolarTherm.Control.Trigger ltrig(low=0.1*tnk.E_max, up=0.2*tnk.E_max);
	SolarTherm.Control.Trigger utrig(low=0.8*tnk.E_max, up=0.9*tnk.E_max);
equation
	connect(wea.wbus, con.wbus);
	connect(wea.wbus, rec.wbus);
	connect(con.R_foc, rec.R);
	connect(rec.p, spl.p_i);
	connect(spl.p_o1, tnk.p);
	connect(spl.p_o2, ess.p);
	connect(tnk.p, pmp.p_i);
	connect(pmp.p_o, blk.p);

	con.track = true;

	connect(ltrig.x, tnk.E);
	connect(utrig.x, tnk.E);
	spl.frac = if utrig.y then 0.0 else 1.0; // Dump energy if hit top of tank
	pmp.frac = if ltrig.y then 1.0 else 0.0; // Turn off gen when tank low
end EnergySystem;
