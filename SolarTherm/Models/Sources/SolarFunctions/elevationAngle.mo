within SolarTherm.Models.Sources.SolarFunctions;
function elevationAngle
  extends Modelica.Icons.Function;
  input SI.Angle dec "Solar declination (+ve North of equator)";
  input SI.Angle hra "Solar hour angle (solar noon at 0)";
  input nSI.Angle_deg lat=-23.795 "Latitude (+ve North)";
  output SI.Angle ele "Solar elevation angle";
algorithm
  ele :=max(0,asin(sin(from_deg(lat))*sin(dec) + cos(from_deg(lat))*cos(dec)*cos(hra)));
end elevationAngle;
