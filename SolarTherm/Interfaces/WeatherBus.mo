within SolarTherm.Interfaces;
expandable connector WeatherBus "Bus for weather data"
	import SI = Modelica.SIunits;
	SI.Angle alt "Sun altitude";
	SI.Angle azi "Sun azimuth";
	SI.Irradiance ghi(min=0) "Global horizontal irradiance";
	SI.Irradiance dni(min=0) "Direct normal irradiance";
	SI.Temperature Tdry "Dry-bulb temperature";
	SI.Temperature Tdew "Dew point temperature";
	SI.Angle wdir "Wind direction";
	SI.Velocity wspd(min=0) "Wind speed";
end WeatherBus;

