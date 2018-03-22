within SolarTherm.Media.Sodium.Sodium_utilities;
function drho_dT_T "Derivative of density of liquid sodium w.r.t temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Real drho "Derivative of density w.r.t temperature";
algorithm
	//Ref. ANL/RE-95/2, pp. 20
	drho :=- 25579 / (250370 * (1 - (10 * T) / 25037) ^ (1 / 2)) - 13766 / 125185;
end drho_dT_T;
