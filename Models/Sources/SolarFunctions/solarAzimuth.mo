within SolarTherm.Models.Sources.SolarFunctions;
function solarAzimuth "Solar azimuth angle"
  extends Modelica.Icons.Function;
  input SI.Angle dec "Solar declination (+ve North of equator)";
  input SI.Angle hra "Solar hour angle (solar noon at 0)";
  input nSI.Angle_deg lat=-23.795 "Latitude (+ve North)";
  output SI.Angle azi;
protected
  SI.Angle zen;
algorithm
  zen:=solarZenith(dec,hra,lat=lat);
  azi:=sign(hra)*abs(acos((cos(zen)*sin(from_deg(lat))-sin(dec))/(sin(zen)*cos(from_deg(lat))))-pi);
  //  azi:=sign(hra)*abs(acos((cos(zen)*sin(from_deg(lat))-sin(dec))/(sin(zen)*cos(from_deg(lat)))));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end solarAzimuth;
