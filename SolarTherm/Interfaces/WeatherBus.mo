within SolarTherm.Interfaces;
expandable connector WeatherBus "Bus for weather data"
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	nSI.Angle_deg alt "Sun altitude";
	nSI.Angle_deg azi "Sun azimuth (Clockwise from North=0)";
	nSI.Angle_deg elo "Ecliptic longitude (reduced to range [-90, 90])";
	nSI.Angle_deg hra "Solar hour angle (solar noon at 0)";
	SI.Irradiance ghi(min=0) "Global horizontal irradiance";
	SI.Irradiance dni(min=0) "Direct normal irradiance";
	SI.Temperature Tdry "Dry-bulb temperature";
	SI.Temperature Tdew "Dew point temperature";
	nSI.Angle_deg wdir "Wind direction";
	SI.Velocity wspd(min=0) "Wind speed";
	SI.Time t "Time of year";
	SI.Time tod "Time of day";
	SolarTherm.Utilities.Date.DayOfWeek dow "Day of week";
	SolarTherm.Utilities.Date.MonOfYear moy "Month of year";
end WeatherBus;

