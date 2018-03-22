within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function T_h "Temperature of molten salt as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	Real delta;
algorithm
	// Ref: Ferri, R., Cammi, A., & Mazzei, D. (2008). Molten salt mixture properties in RELAP5 code for thermodynamic solar applications. International Journal of Thermal Sciences, 47(12), 1676–1687, pp. 1678
	// Valid from 533.15K to 873.15K liquid on saturation curve
	delta := abs(1396.0182 ^ 2 + 4 * 0.086 * h);
	T := (-1396.0182 + sqrt(delta)) / (2 * 0.086);
	annotation(derivative=T_h_der);
end T_h;
