within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function h_T_der "Derivative of specific enthalpy of Chloride Salt w.r.t. time"
	import SolarTherm.Media.Sodium.Sodium_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	input Real der_T;
	output Real der_h "h derivative";
algorithm
	der_h:=cp_T(T)*der_T;
end h_T_der;
