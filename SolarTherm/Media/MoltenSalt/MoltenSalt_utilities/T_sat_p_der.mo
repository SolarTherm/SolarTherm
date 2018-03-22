within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function T_sat_p_der "Derivative of the saturation pressure of molten salt w.r.t. time"
	import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
	input Real der_p "Derivative of p w.r.t. time";
	output Real der_T_sat "Derivative of saturation temperature w.r.t time";
algorithm
	der_T_sat := dT_sat_dp_p(p) * der_p;
end T_sat_p_der;
