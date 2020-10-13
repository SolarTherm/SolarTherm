within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
partial model OpticalEfficiency_3Apertures
  output SI.Efficiency nu_1 "Total optical efficiency";
  output SI.Efficiency nu_2 "Total optical efficiency";
  output SI.Efficiency nu_3 "Total optical efficiency";
  input SI.Angle dec;
  input SI.Angle hra;
  parameter nSI.Angle_deg lat "Latitude from heliostat field model" annotation(Dialog(group="Inner data",enable=false));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpticalEfficiency_3Apertures;