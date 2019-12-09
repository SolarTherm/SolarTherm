within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function p_sat_T "Saturation pressure of molten salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
algorithm
	// Ref: Ferri, R., Cammi, A., & Mazzei, D. (2008). Molten salt mixture properties in RELAP5 code for thermodynamic solar applications. International Journal of Thermal Sciences, 47(12), 1676–1687, pp. 1679
	p := exp(17.69185 - 5523.9586 / T);
	annotation(derivative = p_sat_T_der);
end p_sat_T;


