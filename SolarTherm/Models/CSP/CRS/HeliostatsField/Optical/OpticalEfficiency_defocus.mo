within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
partial model OpticalEfficiency_defocus
  output SI.Efficiency nu "Total optical efficiency";
  output SI.Efficiency nu_100;
  output SI.Efficiency nu_124;
  output SI.Efficiency nu_76;
  output SI.Efficiency nu_52; 
  output SI.Efficiency nu_unavail_124; 
  output SI.Efficiency nu_unavail_100; 
  output SI.Efficiency nu_unavail_76; 
  output SI.Efficiency nu_unavail_52; 
  output SI.Efficiency nu_unavail;
  input SI.Angle dec;
  input SI.Angle hra;
  input Modelica.Blocks.Interfaces.RealInput dni;
  parameter nSI.Angle_deg lat "Latitude from heliostat field model" annotation(Dialog(group="Inner data",enable=false));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpticalEfficiency_defocus;
