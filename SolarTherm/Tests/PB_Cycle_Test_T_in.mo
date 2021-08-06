within SolarTherm.Tests;

model PB_Cycle_Test_T_in
  SolarTherm.Models.PowerBlocks.Correlation.sCO2NREL_100MWe_720C_500C Cycle;
  parameter SI.Temperature T_in_ref = 720.0 + 273.15;
  parameter SI.Temperature T_amb_ref = 35.0 + 273.15;
  
  parameter Real load_fixed = 1.0;
  parameter SI.Temperature T_amb_fixed = 50.0 + 273.15;
  parameter SI.Temperature T_in_start = 660.0 + 273.15;
  
  SI.Temperature T_in(start=T_in_start);
  SI.Temperature T_amb(start=T_amb_fixed);
  
  Real load(start=1.0);

  Real eta_q;
  Real eta_w;
  Real eta_gross;
  Real T_in_degC;
equation
  T_in = T_in_start + time;
  T_amb = T_amb_fixed;
  load = load_fixed;
  T_in_degC = T_in - 273.15;
  
  Cycle.T_in = T_in;
  Cycle.T_amb = T_amb;
  Cycle.load = load;
  eta_gross = Cycle.k_q*Cycle.k_w;
  eta_q = Cycle.k_q;
  eta_w = Cycle.k_w;
  
  
  
annotation(
    experiment(StopTime = 100.0, StartTime = 0, Tolerance = 0.0001, Interval = 1),Diagram(coordinateSystem(preserveAspectRatio = false)));
end PB_Cycle_Test_T_in;