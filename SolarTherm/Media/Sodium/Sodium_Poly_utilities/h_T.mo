within SolarTherm.Media.Sodium.Sodium_Poly_utilities;
function h_T "Specific enthalpy vs T (Polynomial Simplification)"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
algorithm
	//Ref. ANL/RE-95/2, pp. 4
	// 371K to 2000K liquid on saturation curve:
	h :=  ((-3.033219e-2)*(T^2)) + ((1.309928e3)*(T)) - 3.644153e5;
end h_T;