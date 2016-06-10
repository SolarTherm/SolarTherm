within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
partial model OpticalEfficiency
  output SI.Efficiency nu "Total optical efficiency";
  input SI.Angle dec;
  input SI.Angle hra;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpticalEfficiency;
