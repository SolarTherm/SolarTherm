block TestWeatherSource
	import SolarTherm.Sources.Weather.WeatherSource;
	parameter String weaFile = "resources/tests/weatherfile1.motab";
	WeatherSource wea(weaFile=weaFile);
end TestWeatherSource;
