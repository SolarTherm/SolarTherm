within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function s_T "Specific entropy of molten salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEntropy s "Specific entropy";
algorithm
	// Ref: Ferri, R., Cammi, A., & Mazzei, D. (2008). Molten salt mixture properties in RELAP5 code for thermodynamic solar applications. International Journal of Thermal Sciences, 47(12), 1676–1687, pp. 1678
	// Valid from 533.15K to 873.15K liquid on saturation curve
	s := 1396.0182 * log(T) + 0.172 * T;
end s_T;


























