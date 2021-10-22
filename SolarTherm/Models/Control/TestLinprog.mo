within SolarTherm.Models.Control;

model TestLinprog
  parameter String filepathDNI = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab");
  parameter String filepathPrice = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014_hourly_manipulated.motab") "Electricity price file";
  parameter Integer horison = 24;
  parameter Real dt = 1;
  parameter Real etaC = 0.6;
  parameter Real etaG = 0.4;
  parameter Real t_stg = 14.;
  parameter Real DEmax = 120 / etaG;
  parameter Real SLmax = t_stg * DEmax;
  parameter Real SLinit = 0.2 * SLmax;
  parameter Real SLminrel = 0.1;
  parameter Real Ahelio = 900000.0;
  parameter Real const_t = -dt * 3600;
  Real optimalDispatch;
  Real counter(start = const_t);
  Real time_simul(start = 0);
equation
  der(counter) = 1;
  when counter > 0 then
    time_simul = floor(time);
    optimalDispatch = SolarTherm.Utilities.LinProgFunc(filepathDNI, filepathPrice, horison, dt, time_simul, etaC, etaG, t_stg, DEmax, SLmax, SLinit, SLminrel, Ahelio);
    reinit(counter, const_t);
  end when;
  annotation(
    experiment(StartTime = 0, StopTime = 90000, Tolerance = 1e-06, Interval = 3600));
end TestLinprog;
