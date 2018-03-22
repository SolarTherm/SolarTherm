within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function beta_T "Isobaric expansion coefficient of molten salt"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.Media.Interfaces.Types.IsobaricExpansionCoefficient beta_isb "Isobaric expansion coefficient";
algorithm
	// Ref: Ferri, R., Cammi, A., & Mazzei, D. (2008). Molten salt mixture properties in RELAP5 code for thermodynamic solar applications. International Journal of Thermal Sciences, 47(12), 1676–1687, pp. 1678
	// Valid from 533.15K to 873.15K liquid on saturation curve
	beta_isb := 0.636 / (2263.72 - 0.636 * T);
end beta_T;

