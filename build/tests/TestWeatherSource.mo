block TestWeatherSource
	import SolarTherm.Models.Sources.Weather.WeatherSource;
	parameter String file = "resources/tests/weatherfile1.motab";
	WeatherSource wea(file=file);
	//annotation(experiment(StartTime=0.0, StopTime=86400.0, Interval=40, Tolerance=1e-06));
end TestWeatherSource;
