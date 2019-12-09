within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function h_fg_p "Specific enthalpy of vaporization of molten salt as a function of pressure"
	extends Modelica.Icons.Function;
	input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
	output Modelica.SIunits.SpecificEnthalpy h_fg "Specific enthalpy";
algorithm
	// Ref: Ferri, R., Cammi, A., & Mazzei, D. (2008). Molten salt mixture properties in RELAP5 code for thermodynamic solar applications. International Journal of Thermal Sciences, 47(12), 1676–1687, pp. 1679
	h_fg := 0.0507 * (1e7 - p);
end h_fg_p;




