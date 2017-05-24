model EnergySystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FI = SolarTherm.Models.Analysis.Finances;
	
	parameter String wea_file = "resources/weather/Mildura_Real2010_Created20130430.motab";
	parameter SI.Area A_col = 1 "Collector area";
	parameter SI.Energy E_max = 1*3600*1000 "Max stored energy";
	SolarTherm.Models.Sources.Weather.WeatherSource wea(file=wea_file);
	SolarTherm.Models.CSP.CRS.HeliostatsField.SwitchedCL CL(
		redeclare model OptEff=SolarTherm.Models.CSP.CRS.HeliostatsField.IdealIncOE(alt_fixed=45),
		A=A_col
		);
	SolarTherm.Models.CSP.CRS.Receivers.FixedEffRC RC(eff=0.8);
	SolarTherm.Models.Fluid.Valves.EnergySplitter spl;
	SolarTherm.Models.Fluid.Sources.EnergySourceSink ess;
	SolarTherm.Models.Storage.Tank.EnergyST ST(E_max=E_max, E_0=0.1*E_max);
	SolarTherm.Models.PowerBlocks.EnergyPB PB(eff=0.9, P_max=500);
	SolarTherm.Models.Fluid.Pumps.EnergyPump pmp(P_max=0.7*PB.P_max);
	SolarTherm.Models.Control.Trigger ltrig(low=0.1*ST.E_max, up=0.2*ST.E_max);
	SolarTherm.Models.Control.Trigger utrig(low=0.8*ST.E_max, up=0.9*ST.E_max);
equation
	connect(wea.wbus, CL.wbus);
	connect(wea.wbus, RC.wbus);
	connect(CL.R_foc, RC.R);
	connect(RC.p, spl.p_i);
	connect(spl.p_o1, ST.p);
	connect(spl.p_o2, ess.p);
	connect(ST.p, pmp.p_i);
	connect(pmp.p_o, PB.p);

	CL.track = true;

	connect(ltrig.x, ST.E);
	connect(utrig.x, ST.E);
	spl.frac = if utrig.y then 0.0 else 1.0; // Dump energy if hit top of tank
	pmp.frac = if ltrig.y then 1.0 else 0.0; // Turn off gen when tank low
end EnergySystem;
