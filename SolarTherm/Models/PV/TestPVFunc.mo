within SolarTherm.Models.PV;

model TestPVFunc
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  parameter Integer N_parallel_final = 136;
  parameter Integer N_series = 11;
  parameter Real DHI = 108;
  parameter Real albedo = 0.216;
  parameter SI.Velocity Wspd = 4.4;
  parameter SI.Temperature Tdry = 283.15;
  parameter SI.Power PV_Target = 2e8;
  parameter nSI.Angle_deg azi_s = 180;
  parameter nSI.Angle_deg ele_s = 30;
  parameter nSI.Angle_deg lat = 34.8667;
  parameter SI.Angle ele_min = 0.0872665;
  parameter Real dni = 676;
  parameter SI.Angle delta = -0.401582;
  // = sun.dec "Solar declination angle";
  parameter SI.Angle hra = 0.302494;
  // "Solar hour angle";
  parameter SI.Angle zen = 1.05012;
  // "Solar zenith angle";
  parameter SI.Angle ele = 0.520679;
  // "Solar elevation angle";
  parameter SI.Angle azi = 3.4632;
  SI.Power P_net;
equation
  P_net = SolarTherm.Utilities.PVArray_func(N_parallel_final, N_series, DHI, albedo, Wspd, Tdry, PV_Target, azi_s, ele_s, lat, ele_min, dni, delta, hra, zen, ele, azi);
equation

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end TestPVFunc;