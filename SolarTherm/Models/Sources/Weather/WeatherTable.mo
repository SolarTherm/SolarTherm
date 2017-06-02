within SolarTherm.Models.Sources.Weather;
block WeatherTable "Weather data stored in table"
	extends Modelica.Blocks.Tables.CombiTable1D(verboseRead=false);
	// The interpolation for things like wdir can be bad
	parameter SI.Time delay[:] = zeros(size(columns, 1)) "Delay in table time";
equation
	for i in 1:size(columns, 1) loop
		u[i] = time + delay[i];
	end for;
end WeatherTable;
