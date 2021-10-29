within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function dT_sat_dp_p "Derivative of the saturation temperature of molten salt w.r.t pressure"


	import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;




	extends Modelica.Icons.Function;
	input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
	output Real dT_sat "Derivative of the saturation temperature w.r.t pressure";
algorithm
	// Ref: Ferri, R., Cammi, A., & Mazzei, D. (2008). Molten salt mixture properties in RELAP5 code for thermodynamic solar applications. International Journal of Thermal Sciences, 47(12), 1676–1687, pp. 1679
	dT_sat := (T_sat_p(p) ^ 2) / (5523.9586 * p);
end dT_sat_dp_p;
