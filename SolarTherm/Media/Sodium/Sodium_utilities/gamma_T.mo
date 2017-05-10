within SolarTherm.Media.Sodium.Sodium_utilities;
function gamma_T "The temperature derivative of the vapour pressure of sodium along the saturation curve"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Real gamma "Derivative of vapor pressure w.r.t temperature along the saturation curve";
algorithm
  //Ref. ANL/RE-95/2, pp. 19
  gamma := dp_v_dT_T(T);
end gamma_T;



