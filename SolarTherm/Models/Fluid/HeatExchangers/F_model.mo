within SolarTherm.Models.Fluid.HeatExchangers;
model F_model
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};

  parameter SI.Temperature T_Na1=740+273.15 "Sodium Hot Fluid Temperature";
  parameter SI.Temperature T_Na2(start=700+273.15) "Sodium Cold Fluid Temperature";
  parameter SI.Temperature T_MS1(start=500+273.15) "Molten Salts Cold Fluid Temperature";
  parameter SI.Temperature T_MS2(start=720+273.15) "Molten Salts Hot Fluid Temperature";
  parameter Real tol1=1e-2;
  parameter Real tol2=0.12;
  
  Real F(unit= "") "Temperature correction factor";
  Boolean F_problem;
  Real S(unit = "") "Non-dimensional factor for F calculation";
  Real R(unit = "") "Non-dimensional factor for F calculation";
  Real AA(unit = "") "Non-dimensional factor for F calculation";
  Real BB(unit = "") "Non-dimensional factor for F calculation";
  
equation
  S = (T_Na2 - T_Na1) / (T_MS1 - T_Na1);
  R = (T_MS1 - T_MS2) / (T_Na2 - T_Na1);
  AA = 2 / S - R - 1;
  BB = 2 / S * ((1 - S) * (1 - S * R)) ^ 0.5;
  if (AA + BB - (R ^ 2 + 1) ^ 0.5)<tol1 then
    F=0.1; //DON'T PUT EQUAL TO ZERO --> PROBLEM START UP
  else  
    F = (R ^ 2 + 1) ^ 0.5 / (2 * (R + 1)) * log((1 - S) / (1 - S * R)) / log((AA + BB + (R ^ 2 + 1) ^ 0.5) / (AA + BB - (R ^ 2 + 1) ^ 0.5));
  end if;
  
  if F<=tol2 then
    F_problem=true;
    //F:=0.1; //Try 0 with increasing flow rate
  else  
    F_problem=false;
  end if;
end F_model;