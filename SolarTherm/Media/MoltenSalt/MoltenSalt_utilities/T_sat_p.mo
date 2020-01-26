within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function T_sat_p "Saturation temperature of molten salt as a function of saturated pressure"
	extends Modelica.Icons.Function;
	input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
	output Modelica.SIunits.Temperature T "Temperature";
algorithm
		// Ref: Ferri, R., Cammi, A., & Mazzei, D. (2008). Molten salt mixture properties in RELAP5 code for thermodynamic solar applications. International Journal of Thermal Sciences, 47(12), 1676–1687, pp. 1679
	T := 5523.9586 / (17.69185 - log(p));
	annotation(derivative = T_sat_p_der);
end T_sat_p;

