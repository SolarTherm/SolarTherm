within SolarTherm.Media.Sodium.Sodium_utilities;
function vs_T "Velocity of sound of liquid sodium as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.VelocityOfSound vs "Velocity of sound";
algorithm
	//Ref. ANL/RE-95/2 pp. 21
	// 371K to 1773K liquid on saturation curve
	vs := 2660.7 - 0.37667 * T - 9.0356e-5 * T ^ 2;
end vs_T;
