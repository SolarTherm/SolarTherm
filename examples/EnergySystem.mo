model EnergySystem
	import Modelica.Constants.pi;
	parameter String weaFile = "resources/Mildura_Real2010_Created20130430.motab";
	parameter Real A_con = 1;
	parameter Real A_rec = 1;
	parameter Real E_max = 1*3600*1000;
	SolarTherm.Utilities.Weather.WeatherSource wea(weaFile=weaFile);
	SolarTherm.Optics.IdealInc con(A_con=A_con, A_foc=A_rec, alt=45*pi/180);
	SolarTherm.Receivers.Energy.FixedEff rec(A=A_rec, eff=0.8);
	SolarTherm.Valves.Energy.Splitter spl;
	SolarTherm.Storage.Energy.Infinite inf;
	SolarTherm.Storage.Energy.Tank tnk(E_max=E_max, E_0=0.1*E_max);
	SolarTherm.Pumps.Energy.Pump pmp(P_max=0.7*gen.P_max);
	SolarTherm.PowerBlocks.Energy.Generator gen(eff=0.9, P_max=500);
	SolarTherm.Control.Trigger ltrig(low=0.1*tnk.E_max, up=0.2*tnk.E_max);
	SolarTherm.Control.Trigger utrig(low=0.8*tnk.E_max, up=0.9*tnk.E_max);
equation
	connect(wea.wbus, con.wbus);
	connect(wea.wbus, rec.wbus);
	connect(con.R_foc, rec.R);
	connect(rec.p, spl.p_i);
	connect(spl.p_o1, tnk.p);
	connect(spl.p_o2, inf.p);
	connect(tnk.p, pmp.p_i);
	connect(pmp.p_o, gen.p);

	con.track = true;

	connect(ltrig.x, tnk.E);
	connect(utrig.x, tnk.E);
	spl.frac = if utrig.y then 0.0 else 1.0; // Dump energy if hit top of tank
	pmp.frac = if ltrig.y then 1.0 else 0.0; // Turn off gen when tank low
	// When run whole year data looks weird after some point...
	// Even for just dni
	// Is this something wrong with plotting function?
end EnergySystem;
