within SolarTherm.Tests;

model PB_Cycle_Test2
  SolarTherm.Models.PowerBlocks.Correlation.sCO2NREL_31p5kWe_574C_290C Cycle;
  parameter SI.Temperature T_in_ref = 574.0 + 273.15;
  parameter SI.Temperature T_amb_ref = 35.0 + 273.15;
  SI.Temperature T_in(start=0.75*T_in_ref);
  SI.Temperature T_amb(start=T_amb_ref);
  Real load(start=1.0);
  Real T_ND(start=0.75);
  Real T_amb_ND(start=1.0);
  
  Real eta_gross;
equation
  if time < 120.0 then
    load = 1.00;
    T_amb = T_amb_ref;
  elseif time >= 120.0 and time < 240.0 then
    load = 0.75;
    T_amb = T_amb_ref;
  elseif time >= 240.0 and time < 360.0 then
    load = 0.50;
    T_amb = T_amb_ref;
  elseif time >= 360.0 and time < 480.0 then
    load = 1.00;
    T_amb = T_amb_ref - 10.0;
  else
    load = 1.00;
    T_amb = T_amb_ref + 10.0;
  end if;
    
  T_in = T_in_ref - 100.0 + rem(time,120.0);
  T_in = T_ND*T_in_ref;
  T_amb = T_amb_ND*T_amb_ref;
  Cycle.T_in = T_in;
  Cycle.T_amb = T_amb;
  Cycle.load = load;
  eta_gross = Cycle.k_q*Cycle.k_w;
  
  
  
annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end PB_Cycle_Test2;