block TestSteeredCL
	import CN = Modelica.Constants;
	import SolarTherm.Models.CSP.CRS.HeliostatsField.SteeredCL;
	import SolarTherm.Models.CSP.CRS.HeliostatsField.IdealIncOE;
	import SolarTherm.Models.Sources.Weather.WeatherSource;

	parameter String file = "../resources/tests/weatherfile1.motab";
	WeatherSource wea(file=file);

	SteeredCL conc(
		redeclare model OptEff=IdealIncOE,
		A=100,
		steer_rate=0.01,
		target_error=0.001
		);
initial equation
	conc.target = 0;
equation
	connect(wea.wbus, conc.wbus);
	when time >= 1 then
		conc.target = 0.5;
	elsewhen time >= 100 then
		conc.target = 0.2;
	end when;
	//annotation(experiment(StartTime=0.0, StopTime=200.0, Interval=0.1, Tolerance=1e-06));
end TestSteeredCL;
