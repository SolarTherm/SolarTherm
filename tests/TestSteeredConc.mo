block TestSteeredConc
	import CN = Modelica.Constants;
	import SolarTherm.Collectors.SteeredConc;
	import SolarTherm.Collectors.OptEffIdealInc;
	import SolarTherm.Sources.Weather.WeatherSource;

	parameter String weaFile = "resources/tests/weatherfile1.motab";
	WeatherSource wea(weaFile=weaFile);

	SteeredConc conc(
		redeclare model OptEff=OptEffIdealInc,
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
end TestSteeredConc;
