within SolarTherm.Models.CSP.CRS.HeliostatsField;

model WashingFrequencyCalculator
  extends SolarTherm.Icons.ToDo;
  // model valid for C_target 94 % - 100 % and based on Source : Heliostat Cost Reduction Study Gregory J. Kolb, Scott A. Jones, Matthew W. Donnelly, David Gorman, Robert Thomas, Roger Davenport, and Ron Lumia page 130-134
  parameter Real C_tw = 98. "cleanliness after washing using method Mr.Twister";
  parameter Real C_dl = 96.5 "cleanliness after wahing using method deluge";
  parameter Real R_soil = 0.49 "soiling effect";
  parameter Real P_w = 12 "month in a year that is used for washing";
  parameter Real omega_n = 1.5 "natural washing by rain";
  parameter Real C_target = 94 "Average annual cleanliness target";
  //Intermediate variables
  Real C1;
  Real C2;
  Real dt;
  Real tc;
  Real omega(start = 5, min = 0) "Supplementary washing";
equation
  dt = (C_tw - C_dl) / R_soil;
  C1 = (C_tw + C_dl) / 2;
  C2 = C_dl - R_soil / 6 * (tc - dt);
  C_target = (C1 * dt + C2 * (tc - dt)) / tc;
  tc = 365 * P_w / (12 * (omega + omega_n));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end WashingFrequencyCalculator;