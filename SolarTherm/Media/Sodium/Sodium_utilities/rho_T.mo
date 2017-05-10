within SolarTherm.Media.Sodium.Sodium_utilities;
function rho_T "Density of liquid sodium as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.Density rho "Density";
algorithm
  //Ref. ANL/RE-95/2, pp. 20
  // 371K to 2503.7K liquid on saturation curve:
  rho := 219 + 275.32 * (1 - T / 2503.7) + 511.58 * sqrt(1 - T / 2503.7);
  annotation(derivative = rho_T_der);
end rho_T;
