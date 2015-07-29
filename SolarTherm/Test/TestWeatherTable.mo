within SolarTherm.Test;
block TestWeatherTable
	parameter Real tab[:,:] = [{0, 1, 2, 3}, {3, 2, 2, 3}];
	SolarTherm.Utilities.WeatherTable linear(table=tab,
		smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments);
	SolarTherm.Utilities.WeatherTable cderiv(table=tab,
		smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative);
	SolarTherm.Utilities.WeatherTable cseg(table=tab,
		smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments);
end TestWeatherTable;
