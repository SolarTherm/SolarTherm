within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
partial model OpticalEfficiency
  output SI.Efficiency nu "Total optical efficiency";
  input SI.Angle dec;
  input SI.Angle hra;
  parameter nSI.Angle_deg lat "Latitude from heliostat field model" annotation(Dialog(group="Inner data",enable=false));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpticalEfficiency;
