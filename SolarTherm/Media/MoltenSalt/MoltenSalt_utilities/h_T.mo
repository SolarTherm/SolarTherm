within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function h_T "Specific enthalpy of molten salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
algorithm
	// h is obtained by integrating (cp dT). The integration constant was added such that the h value at T = 0 K becomes zero.
	// Ref: Ferri, R., Cammi, A., & Mazzei, D. (2008). Molten salt mixture properties in RELAP5 code for thermodynamic solar applications. International Journal of Thermal Sciences, 47(12), 1676–1687, pp. 1678
	// Valid from 533.15K to 873.15K liquid on saturation curve
	h := 1396.0182 * T + 0.086 * T ^ 2;
	annotation(derivative=h_T_der);
end h_T;
