within SolarTherm.Media.Sodium.Sodium_Poly_utilities;
function lamda_T "Thermal conductivity vs T (polynomial simplification)"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.ThermalConductivity lambda "Thermal conductivity";
algorithm
	//Ref. ANL/RE-95/2, pp. 181
	lambda := 1.170364e2 - (8.701093e-2*T)+((2.420647e-5)*(T^2));
end lamda_T;