within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function p_sat_T_der "Derivative of the saturation pressure of molten salt w.r.t. time"
	import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	input Real der_T "Derivative of T w.r.t. time";
	output Real der_p_sat "Derivative of saturation pressure w.r.t time";
algorithm
	der_p_sat := dp_sat_dT_T(T) * der_T;
end p_sat_T_der;
