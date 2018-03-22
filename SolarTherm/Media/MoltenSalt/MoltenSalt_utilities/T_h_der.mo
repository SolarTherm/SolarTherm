within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function T_h_der "Derivative of temperature of molten salt w.r.t. time"
	import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	input Real der_h "Derivative of specific enthalpy w.r.t. time";
	output Real der_T "Derivative of Temperature w.r.t. time";
algorithm
	// Ref: Ferri, R., Cammi, A., & Mazzei, D. (2008). Molten salt mixture properties in RELAP5 code for thermodynamic solar applications. International Journal of Thermal Sciences, 47(12), 1676–1687, pp. 1678
	// Valid from 533.15K to 873.15K liquid on saturation curve
	der_T := dT_dh_h(h) * der_h;
end T_h_der;
