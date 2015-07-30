within SolarTherm.Test;
block TestWeatherFileChecker
	import SolarTherm.Utilities.Weather.weatherFileChecker;
	parameter String fn1 = weatherFileChecker("weather1.mo");
	parameter String fn2 = weatherFileChecker("weather2.cat");
	parameter Boolean fn1_correct = fn1 == "weather1.mo";
	parameter Boolean fn2_correct = fn2 == "weather2.mo";
end TestWeatherFileChecker;
