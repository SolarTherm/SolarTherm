within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
partial model OpticalEfficiency
  output SI.Efficiency nu "Total optical efficiency";
  output SI.Efficiency nu_cos;
  output SI.Efficiency nu_ref;  
  output SI.Efficiency nu_sb;  
  output SI.Efficiency nu_att;  
  output SI.Efficiency nu_spi;    
  input SI.Angle dec;
  input SI.Angle hra;
  parameter nSI.Angle_deg lat "Latitude from heliostat field model" annotation(Dialog(group="Inner data",enable=false));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpticalEfficiency;
