within SolarTherm.Models.Sources.SolarFunctions;
function eclipticLongitude "Sun position"
  extends Modelica.Icons.Function;
  input SI.Angle dec "Solar declination (+ve North of equator)";
  output SI.Angle elo;
protected
  parameter SI.Angle axial_tilt=from_deg(23.4556);
algorithm
 elo :=asin(sin(dec)/sin(axial_tilt));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end eclipticLongitude;
