within SolarTherm.Models.Sources.SolarFunctions;
partial function solarPosition
  extends Modelica.Icons.Function;
  input SI.Time t "Standard local time";
  input nSI.Angle_deg lon "Longitude (E>0, W<0)";
  input nSI.Angle_deg lat "Latitude (N>0, S<0)";
  input nSI.Time_hour t_zone=0 "Local time zone (UT=0)";
  input Integer year=1996 "Year";
  output SI.Angle dec "Solar declination (+ve North of equator)";
  output SI.Angle hra "Solar hour angle (solar noon at 0)";
  nSI.Time_hour t_zone_int=sign(t_zone)*integer(abs(t_zone)) "Integer local time zone";
end solarPosition;
