within SolarTherm.Media.Sodium.Sodium_utilities;
function rho_T_der "Density as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  input Real der_T;
  output Real der_rho "Density";
algorithm
  der_rho := drho_dT_T(T)*der_T;
end rho_T_der;
