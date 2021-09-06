block TestWeatherFileChecker
	import SolarTherm.Models.Sources.Weather.weatherFileChecker;
	parameter String fn1 = weatherFileChecker("Resources/tests/weatherfile1.motab");
	parameter String fn2 = weatherFileChecker("Resources/tests/weatherfile2.csv");
	parameter Boolean fn1_correct = fn1 == "Resources/tests/weatherfile1.motab";
	parameter Boolean fn2_correct = fn2 == "Resources/tests/weatherfile2.motab";
	//annotation(experiment(StartTime=0.0, StopTime=1.0, Interval=0.01, Tolerance=1e-06));
end TestWeatherFileChecker;
