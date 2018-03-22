within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function kappa_T "Isothermal compressibility of molten salt"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.IsothermalCompressibility kappa_ist "Isothermal compressibility";
algorithm
	// Ref: Ferri, R., Cammi, A., & Mazzei, D. (2008). Molten salt mixture properties in RELAP5 code for thermodynamic solar applications. International Journal of Thermal Sciences, 47(12), 1676–1687, pp. 1678
	// Valid from 533.15K to 873.15K liquid on saturation curve
	// A correlation of specific volume versus pressure was not available. Instead, the following correlation as a function of temperature typical of liquid metals was found in the literature:
	kappa_ist := 3.97e-11 * exp(1.37e-3 * (T - 293.15));
end kappa_T;
