within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function h_T_der "Derivative of specific enthalpy of solid CarboHSP particle w.r.t. time"
	import SolarTherm.Media.SolidParticles.CarboHSP_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	input Real der_T;
	output Real der_h "Time derivative of specific enthalpy";
algorithm
	der_h := dh_dT_T(T) * der_T;
end h_T_der;
