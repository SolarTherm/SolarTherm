within SolarTherm.Media.Sodium.Sodium_Poly_utilities;
function rho_T "Density vs temperature (Polynomial Simplification)"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.Density rho "Density";
algorithm
	//Ref. ANL/RE-95/2, pp. 20
	// 371K to 2503.7K liquid on saturation curve:
	rho := 1002.974-((0.2026727)*(T))-((0.00001948939)*(T^2));
end rho_T;