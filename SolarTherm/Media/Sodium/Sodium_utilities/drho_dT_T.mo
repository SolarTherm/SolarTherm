within SolarTherm.Media.Sodium.Sodium_utilities;
function drho_dT_T "Density as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Real drho "Density";
algorithm
  //ref ANL/RE-95/2
  drho :=- 25579/(250370*(1 - (10*T)/25037)^(1/2)) - 13766/125185;
end drho_dT_T;
