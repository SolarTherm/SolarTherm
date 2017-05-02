within SolarTherm.Media.Sodium.Sodium_utilities;
function h_T "Specific enthalpy as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
algorithm
  //ref ANL/RE-95/2
  h:=(-365.77 + 1.6582*T- 4.2395e-4*T^2 + 1.4847e-7*T^3 + 2992.6*T^(-1) - 104.90817873321107)*1000;
  annotation(derivative=h_T_der);
end h_T;
