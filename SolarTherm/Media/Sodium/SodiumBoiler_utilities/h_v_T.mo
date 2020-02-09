within SolarTherm.Media.Sodium.SodiumBoiler_utilities;
function h_v_T "Specific enthalpy of gas sodium as a function of temperature"
	import SolarTherm.Media.Sodium.SodiumBoiler_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
algorithm
	//Ref. ANL/RE-95/2, pp. 4
	// 371K to 2000K liquid on saturation curve:
	h := h_T(T) + h_fg_T(T);
	//annotation(derivative=h_v_T_der);
end h_v_T;