block TestWeatherFileChecker
	import SolarTherm.Models.Sources.Weather.weatherFileChecker;
	parameter String fn1 = weatherFileChecker("resources/tests/weatherfile1.motab");
	parameter String fn2 = weatherFileChecker("resources/tests/weatherfile2.csv");
	parameter Boolean fn1_correct = fn1 == "resources/tests/weatherfile1.motab";
	parameter Boolean fn2_correct = fn2 == "resources/tests/weatherfile2.motab";
	//annotation(experiment(StartTime=0.0, StopTime=1.0, Interval=0.01, Tolerance=1e-06));
end TestWeatherFileChecker;
