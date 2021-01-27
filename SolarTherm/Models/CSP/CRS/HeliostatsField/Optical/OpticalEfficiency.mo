within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
partial model OpticalEfficiency
  output SI.Efficiency nu "Total optical efficiency";
  output SI.Efficiency nu_100;
  //output SI.Efficiency nu_120;
  output SI.Efficiency nu_110;
  output SI.Efficiency nu_90;
  output SI.Efficiency nu_80;
  output SI.Efficiency nu_70; 
  input SI.Angle dec;
  input SI.Angle hra;
  input Modelica.Blocks.Interfaces.RealInput dni;
  parameter nSI.Angle_deg lat "Latitude from heliostat field model" annotation(Dialog(group="Inner data",enable=false));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpticalEfficiency;
