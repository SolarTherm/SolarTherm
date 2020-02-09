within SolarTherm.Media.Sodium.SodiumBoiler_utilities;
function lamda_v_T "Thermal conductivity of vapour sodium as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.ThermalConductivity lambda_g "Thermal conductivity";
protected
	constant Real A = -0.07317;
	constant Real B = 2.537e-04;
	constant Real C = -1.768e-07;
	constant Real D = 4.162e-11;

algorithm
	//Ref. ANL/RE-95/2 Curve fit
	lambda_g := A + B*T + C*(T^2) + D*(T^3);
end lamda_v_T;