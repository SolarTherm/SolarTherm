within SolarTherm.Test;
block TestEnergySystem
	import Modelica.Constants.pi;
	import SolarTherm.Utilities.Weather.WeatherSource;
	import SolarTherm.Optics.IdealAzi;
	import SolarTherm.Receivers.Energy.FixedEff;
	import SolarTherm.Valves.Energy.Shedder;
	parameter String weaFile = "resources/weatherfile1.motab";
	parameter Real A_rec = 1;
	WeatherSource wea(weaFile=weaFile);
	IdealAzi con(A_con=1, A_foc=A_rec, alt=45*pi/180);
	FixedEff rec(A=A_rec, eff=0.8);
	Shedder shd;
equation
	connect(wea.wbus, con.wbus);
	connect(wea.wbus, rec.wbus);
	connect(con.R_foc, rec.R);
	connect(rec.p, shd.p_i);
	// Leave shd.frac floating so as to not overconstrain
end TestEnergySystem;
