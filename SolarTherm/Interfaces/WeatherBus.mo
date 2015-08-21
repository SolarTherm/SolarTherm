within SolarTherm.Interfaces;
expandable connector WeatherBus "Bus for weather data"
	import SI = Modelica.SIunits;
	SI.Angle alt "Sun altitude";
	SI.Angle azi "Sun azimuth";
	SI.Irradiance ghi "Global horizontal irradiance";
	SI.Irradiance dni "Direct normal irradiance";
	SI.Temperature Tdry "Dry-bulb temperature";
	SI.Temperature Tdew "Dew point temperature";
end WeatherBus;

