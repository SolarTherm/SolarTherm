within SolarTherm.Models.Sources.SolarFunctions;
function aparentSolarZenith "Solar zenith angle"
  extends Modelica.Icons.Function;
  input SI.Angle dec "Solar declination (+ve North of equator)";
  input SI.Angle hra "Solar hour angle (solar noon at 0)";
  input nSI.Angle_deg lat=-23.795 "Latitude (+ve North)";
  output SI.Angle zen_ap "Solar zenith";

  //Real parallax;
protected
  SI.Angle zen "Solar zenith";
  //constant Real earthmeanradius = 6371.01;
  //constant Real astronomicalunit = 149597890;
  constant Real A= +0.004013327;
  constant Real B= +0.06476916;
  constant Real C= -0.66956539;
  constant Real D= +0.019276169;
  constant Real E= -0.00051297;

algorithm
  zen:=acos(cos(from_deg(lat))*cos(dec)*cos(hra)+sin(from_deg(lat))*sin(dec));

  //parallax := earthmeanradius / astronomicalunit * sin(zen);
  zen_ap := min(pi/2,zen-((A*(zen/B)^(C+D*zen))-E));
  //min(pi/2,zen + parallax);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>DELSOL 3</p>
</html>"));
end aparentSolarZenith;
