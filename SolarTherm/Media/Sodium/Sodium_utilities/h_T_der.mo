within SolarTherm.Media.Sodium.Sodium_utilities;
function h_T_der "derivative of specific enthalpy"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  input Real der_T;
  output Real der_h "Temperature";
algorithm
  der_h:=cp_T(T)*der_T;
end h_T_der;
