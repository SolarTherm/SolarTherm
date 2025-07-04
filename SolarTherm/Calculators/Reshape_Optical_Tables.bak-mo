within SolarTherm.Calculators;

model Reshape_Optical_Tables
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.Conversions;
  import MA = Modelica.Blocks.Math;

  parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/DRI_test.motab") "Misshapened Optical efficiency lookup table file";
  
  parameter Integer n_heliostat = 9426 "Number of heliostats";
  parameter SI.Angle lat = -24.1668*CN.pi/180.0 "Latitude (rad)";
  parameter SI.Angle lon = 119.44336*CN.pi/180.0 "Longitude (rad)";
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle (rad)";
  parameter Boolean use_wind = false "Do we use wind data to operate the collector?";
  parameter SI.Velocity Wspd_max = 15.0 "Wind speed at which field must be stowed away";
  
  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table Table(angles = SolarTherm.Types.Solar_angles.dec_hra, file = opt_file);
  
  Real dec_deg;
  Real hra_deg;

equation
  dec_deg = 23.50;
  hra_deg = -180.0 + time*15.0;
  Table.dec = dec_deg*CN.pi/180.0;
  Table.hra = hra_deg*CN.pi/180.0;

annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),experiment(StopTime = 24, StartTime = 0, Tolerance = 1.0e-5, Interval = 1, maxStepSize = 1, initialStepSize = 1));
end Reshape_Optical_Tables;