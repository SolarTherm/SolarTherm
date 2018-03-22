within SolarTherm.Models.Sources;
package SolarFunctions 
  extends Modelica.Icons.VariantsPackage;

  function solarZenith "Solar zenith angle"
    extends Modelica.Icons.Function;
    input SI.Angle dec "Solar declination (+ve North of equator)";
    input SI.Angle hra "Solar hour angle (solar noon at 0)";
    input nSI.Angle_deg lat=-23.795 "Latitude (+ve North)";
    output SI.Angle zen "Solar zenith";

    //Real parallax;
    //constant Real earthmeanradius = 6371.01;
    //constant Real astronomicalunit = 149597890;
  algorithm
    zen:=acos(cos(from_deg(lat))*cos(dec)*cos(hra)+sin(from_deg(lat))*sin(dec));

    //parallax := earthmeanradius / astronomicalunit * sin(zen);
    //zen := min(pi/2,zen + parallax);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end solarZenith;
end SolarFunctions;
