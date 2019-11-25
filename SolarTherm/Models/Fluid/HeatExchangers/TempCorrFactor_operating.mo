within SolarTherm.Models.Fluid.HeatExchangers;

function TempCorrFactor_operating
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  input SI.Temperature T_Na1(start = 740 + 273.15) "Sodium Hot Fluid Temperature";
  input SI.Temperature T_Na2(start = 700 + 273.15) "Sodium Cold Fluid Temperature";
  input SI.Temperature T_MS1(start = 500 + 273.15) "Molten Salts Cold Fluid Temperature";
  input SI.Temperature T_MS2(start = 720 + 273.15) "Molten Salts Hot Fluid Temperature";
  input Boolean low_flow = false;
  output Real F(unit = "") "Temperature correction factor";
  output Boolean F_problem;
  
protected
  Real S(unit = "") "Non-dimensional factor for F calculation";
  Real R(unit = "") "Non-dimensional factor for F calculation";
  Real AA(unit = "") "Non-dimensional factor for F calculation";
  Real BB(unit = "") "Non-dimensional factor for F calculation";
  Real F_calc(unit = "") "Temperature correction factor";
  
  parameter Real tol1 = 1e-3;
  parameter Real tol2 = 0.12;
  parameter Real tol3 = 1e-8;
  
algorithm
  S := (T_Na2 - T_Na1) / (T_MS1 - T_Na1);
  R := (T_MS1 - T_MS2) / (T_Na2 - T_Na1);
  AA := 2 / S - R - 1;
  BB := 2 / S * ((1 - S) * (1 - S * R)) ^ 0.5;
  if AA + BB - (R ^ 2 + 1) ^ 0.5 < tol1 then
    F_calc := 0.1; //DON'T PUT EQUAL TO ZERO --> PROBLEM START UP
  else
    F_calc := (R ^ 2 + 1) ^ 0.5 / (2 * (R + 1)) * log((1 - S) / (1 - S * R)) / log((AA + BB + (R ^ 2 + 1) ^ 0.5) / (AA + BB - (R ^ 2 + 1) ^ 0.5));
  end if;
  
  if noEvent(S==0) then
    F := 0.1;
  else
    F := F_calc;
  end if;

  if noEvent(F <= tol2) or noEvent(F>0.9) then
    F_problem := true;
    F := 0.1;
  else
    F_problem := false;
  end if;

end TempCorrFactor_operating;