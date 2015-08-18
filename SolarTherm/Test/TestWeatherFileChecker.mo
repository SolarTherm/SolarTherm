within SolarTherm.Test;
block TestWeatherFileChecker
	import SolarTherm.Utilities.Weather.weatherFileChecker;
	parameter String fn1 = weatherFileChecker("resources/weatherfile1.motab");
	parameter String fn2 = weatherFileChecker("resources/weatherfile2.csv");
	parameter Boolean fn1_correct = fn1 == "resources/weatherfile1.motab";
	parameter Boolean fn2_correct = fn2 == "resources/weatherfile2.motab";
end TestWeatherFileChecker;
