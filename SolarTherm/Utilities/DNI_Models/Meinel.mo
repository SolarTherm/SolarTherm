within SolarTherm.Utilities.DNI_Models;

function Meinel
  input Real zenith_deg "Latitude of location in degrees";
  output Real DNI "Direct normal irradiance W/m2";
protected
  Real zenith_rad = zenith_deg*Modelica.Constants.pi/180.0 "Latitude in radians";
  Real AM = 1.0/Modelica.Math.cos(zenith_rad);
algorithm
  DNI := 1367.0*0.7^(AM^0.678);
end Meinel;