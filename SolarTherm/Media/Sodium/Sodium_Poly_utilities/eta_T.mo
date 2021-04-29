within SolarTherm.Media.Sodium.Sodium_Poly_utilities;
function eta_T "Dynamic viscosity vs T (polynomial simplification)"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
algorithm
	//Ref. ANL/RE-95/2, pp. 207
	eta := 1.143734e-3 - 2.378539e-6*T + 2.041116e-9*(T^2) - 6.253271e-13*(T^3);
end eta_T;