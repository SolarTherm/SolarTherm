block TestSteeredCL
	import CN = Modelica.Constants;
	import SolarTherm.Collectors.SteeredCL;
	import SolarTherm.Collectors.IdealIncOE;
	import SolarTherm.Sources.Weather.WeatherSource;

	parameter String file = "resources/tests/weatherfile1.motab";
	WeatherSource wea(file=file);

	SteeredCL conc(
		redeclare model OptEff=IdealIncOE,
		A_con=100,
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
end TestSteeredCL;
