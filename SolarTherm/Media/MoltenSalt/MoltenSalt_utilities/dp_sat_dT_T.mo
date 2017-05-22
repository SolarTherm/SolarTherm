within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function dp_sat_dT_T "Derivative of the saturation pressure of molten salt w.r.t temperature"
	import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Real dp_sat "Derivative of the saturation pressure w.r.t temperature";
algorithm
	// Ref: Ferri, R., Cammi, A., & Mazzei, D. (2008). Molten salt mixture properties in RELAP5 code for thermodynamic solar applications. International Journal of Thermal Sciences, 47(12), 1676–1687, pp. 1679
	dp_sat := (-5523.9586 / (T ^ 2)) * p_sat_T(T);
end dp_sat_dT_T;
