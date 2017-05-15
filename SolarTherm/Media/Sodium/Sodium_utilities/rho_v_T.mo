within SolarTherm.Media.Sodium.Sodium_utilities;
function rho_v_T "Density of vapour sodium as a function of temperature"
  extends Modelica.Icons.Function;
  import SolarTherm.Media.Sodium.Sodium_utilities.*;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.Density rho_g "Density";
algorithm
  //Ref. ANL/RE-95/2, pp. 86
  // Valid from 371K to 2503.7K
  rho_g := 1 / (((1 * h_fg_T(T)) / (T * gamma_T(T))) + (1 / rho_T(T)));
end rho_v_T;





























