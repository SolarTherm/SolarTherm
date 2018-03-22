within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function dh_dT_T "Derivative of specific enthalpy of molten salt w.r.t temperature"
	import SolarTherm.Media.Sodium.Sodium_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Real dh "Derivative of specific enthalpy w.r.t temperature";
algorithm
	dh := cp_T(T);
end dh_dT_T;
