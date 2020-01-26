within SolarTherm.Models.Fluid.HeatExchangers;
function Find_min_TNa2

  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  
  input SI.Temperature T_Na1(start = 740 + 273.15) "Sodium Hot Fluid Temperature";
  input SI.Temperature T_MS1(start = 500 + 273.15) "Molten Salts Cold Fluid Temperature";
  input SI.Temperature T_MS2(start = 720 + 273.15) "Molten Salts Hot Fluid Temperature";
  output SI.Temperature T_Na2_min "Guess Sodium Minimum Cold Fluid Temperature";
  
protected
  parameter Real term_target = 4e-2;
  
  SI.Temperature T_Na2_min_guess "Guess Sodium Minimum Cold Fluid Temperature";
  SI.Temperature T_Na2_min_new "Guess Sodium Minimum Cold Fluid Temperature";
  Real term(unit = "") "Non-dimensional factor for F calculation";
  Real S_min(unit = "") "Non-dimensional factor for F calculation";
  Real R_min(unit = "") "Non-dimensional factor for F calculation";
  Real AA_min(unit = "") "Non-dimensional factor for F calculation";
  Real BB_min(unit = "") "Non-dimensional factor for F calculation";
  
algorithm
  T_Na2_min_guess := T_Na1 - 1;
  term := 100;
  T_Na2_min := T_Na2_min_guess;
  while term > term_target or term < 0 loop
    T_Na2_min_new := T_Na2_min + (term_target - term) / abs(term_target - term) * 10 ^ (-3);
    S_min := (T_Na2_min_new - T_Na1) / (T_MS1 - T_Na1);
    R_min := (T_MS1 - T_MS2) / (T_Na2_min_new - T_Na1);
    AA_min := 2 / S_min - R_min - 1;
    BB_min := 2 / S_min * ((1 - S_min) * (1 - S_min * R_min)) ^ 0.5;
    term := AA_min + BB_min - (R_min ^ 2 + 1) ^ 0.5;
    T_Na2_min := T_Na2_min_new;
  end while;
  
end Find_min_TNa2;