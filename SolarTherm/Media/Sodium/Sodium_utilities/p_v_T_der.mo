within SolarTherm.Media.Sodium.Sodium_utilities;
function p_v_T_der "Derivative of the vapour pressue of saturated sodium w.r.t. time"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  input Real der_T "Derivative of T w.r.t. time";
  output Real der_p_v "Derivative of vapour pressure w.r.t time";
algorithm
  der_p_v := dp_v_dT_T(T)*der_T;
end p_v_T_der;
