within SolarTherm.Test;
block TestWeatherTable
	import SolarTherm.Utilities.Weather.WeatherTable;
	parameter Real tab[:,:] = [{0, 1, 2, 3}, {3, 2, 2, 3}];
	WeatherTable linear(table=tab,
		smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments);
	WeatherTable cderiv(table=tab,
		smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative);
	WeatherTable cseg(table=tab,
		smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments);
end TestWeatherTable;
