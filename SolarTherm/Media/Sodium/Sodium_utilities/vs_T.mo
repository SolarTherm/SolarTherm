within SolarTherm.Media.Sodium.Sodium_utilities;
function vs_T "Speed sound as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.Velocity vs "Density";
algorithm
  //ref ANL/RE-95/2
  vs := 2660.7+0.37667*T-9.0356e-5*T^2
  annotation(derivative=rho_T_der);
end vs_T;
