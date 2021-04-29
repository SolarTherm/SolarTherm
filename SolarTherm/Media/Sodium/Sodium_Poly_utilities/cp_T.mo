within SolarTherm.Media.Sodium.Sodium_Poly_utilities;
function cp_T "Specific heat capacity vs T (polynomial simplification)"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
algorithm
	//Ref. ANL/RE-95/2, pp. 29
	// 371K to 2000K liquid on saturation curve
	cp := 1.309928e3 - (6.066438e-2)*T;
end cp_T;