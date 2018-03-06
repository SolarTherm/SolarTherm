block TestWeatherTable
	import SolarTherm.Models.Sources.Weather.WeatherTable;
	parameter Real tab[:,:] = [{0, 1, 2, 3}, {3, 2, 2, 3}];
	WeatherTable linear(table=tab,
		smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments);
	WeatherTable cderiv(table=tab,
		smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative);
	WeatherTable cseg(table=tab,
		smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments);
	annotation(experiment(StartTime=0.0, StopTime=3.0, Interval=0.01, Tolerance=1e-06));
end TestWeatherTable;
