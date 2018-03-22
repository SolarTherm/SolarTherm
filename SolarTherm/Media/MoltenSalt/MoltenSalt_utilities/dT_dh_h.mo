within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function dT_dh_h "Derivative of temperature of molten salt w.r.t specific enthalpy"
	extends Modelica.Icons.Function;
	import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	output Real dT "Derivative of temperature w.r.t specific enthalpy";
protected
	Modelica.SIunits.Temperature T;
algorithm
	// Ref: Ferri, R., Cammi, A., & Mazzei, D. (2008). Molten salt mixture properties in RELAP5 code for thermodynamic solar applications. International Journal of Thermal Sciences, 47(12), 1676–1687, pp. 1678
	// Valid from 533.15K to 873.15K liquid on saturation curve
	T:=T_h(h);
	dT := 1 / dh_dT_T(T);
end dT_dh_h;
