within SolarTherm.Calculators;

model Reshape_Optical_Tables
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.Conversions;
  import MA = Modelica.Blocks.Math;

  parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/RP2017/Polar_526MW.csv") "Misshapened Optical efficiency lookup table file";
  
  parameter Integer n_heliostat = 9426 "Number of heliostats";
  parameter SI.Angle lat = -24.1668*CN.pi/180.0 "Latitude (rad)";
  parameter SI.Angle lon = 119.44336*CN.pi/180.0 "Longitude (rad)";
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle (rad)";
  parameter Boolean use_wind = false "Do we use wind data to operate the collector?";
  parameter SI.Velocity Wspd_max = 15.0 "Wind speed at which field must be stowed away";
  
  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table Table_1(angles = SolarTherm.Types.Solar_angles.dec_hra, file = opt_file);
  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table Table_2(angles = SolarTherm.Types.Solar_angles.dec_hra, file = opt_file);
  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table Table_3(angles = SolarTherm.Types.Solar_angles.dec_hra, file = opt_file);
  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table Table_4(angles = SolarTherm.Types.Solar_angles.dec_hra, file = opt_file);
  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table Table_5(angles = SolarTherm.Types.Solar_angles.dec_hra, file = opt_file);
  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table Table_6(angles = SolarTherm.Types.Solar_angles.dec_hra, file = opt_file);
  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table Table_7(angles = SolarTherm.Types.Solar_angles.dec_hra, file = opt_file);
  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table Table_8(angles = SolarTherm.Types.Solar_angles.dec_hra, file = opt_file);
  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table Table_9(angles = SolarTherm.Types.Solar_angles.dec_hra, file = opt_file);
  
  Real opt_eff_1;
  Real opt_eff_2;
  Real opt_eff_3;
  Real opt_eff_4;
  Real opt_eff_5;
  Real opt_eff_6;
  Real opt_eff_7;
  Real opt_eff_8;
  Real opt_eff_9;
  
  //Real dec_deg;
  Real hra_deg;

equation
  //dec_deg_1 = 23.500; //-23.500, -17.625, -11.750, -5.875, 0.000, 5.875, 11.750, 17.625, 23.500
  hra_deg = -180.0 + time*15.0;
  Table_1.dec = -23.500*CN.pi/180.0;
  Table_2.dec = -17.625*CN.pi/180.0;
  Table_3.dec = -11.750*CN.pi/180.0;
  Table_4.dec = -5.875*CN.pi/180.0;
  Table_5.dec = 0.000*CN.pi/180.0;
  Table_6.dec = 5.875*CN.pi/180.0;
  Table_7.dec = 11.750*CN.pi/180.0;
  Table_8.dec = 17.625*CN.pi/180.0;
  Table_9.dec = 23.500*CN.pi/180.0;
  
  Table_1.hra = hra_deg*CN.pi/180.0;
  Table_2.hra = hra_deg*CN.pi/180.0;
  Table_3.hra = hra_deg*CN.pi/180.0;
  Table_4.hra = hra_deg*CN.pi/180.0;
  Table_5.hra = hra_deg*CN.pi/180.0;
  Table_6.hra = hra_deg*CN.pi/180.0;
  Table_7.hra = hra_deg*CN.pi/180.0;
  Table_8.hra = hra_deg*CN.pi/180.0;
  Table_9.hra = hra_deg*CN.pi/180.0;
  
  opt_eff_1 = Table_1.nu;
  opt_eff_2 = Table_2.nu;
  opt_eff_3 = Table_3.nu;
  opt_eff_4 = Table_4.nu;
  opt_eff_5 = Table_5.nu;
  opt_eff_6 = Table_6.nu;
  opt_eff_7 = Table_7.nu;
  opt_eff_8 = Table_8.nu;
  opt_eff_9 = Table_9.nu;

annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),experiment(StopTime = 24, StartTime = 0, Tolerance = 1.0e-5, Interval = 1, maxStepSize = 1, initialStepSize = 1));
end Reshape_Optical_Tables;