within SolarTherm.Test;
block TestWeatherSource
	import SolarTherm.Utilities.Weather.WeatherSource;
	parameter String weaFile = "resources/weatherfile1.motab";
	WeatherSource wea(weaFile=weaFile);
end TestWeatherSource;
