within SolarTherm.Media.Sodium.SodiumBoiler_utilities;
function dp_v_dT_T "Derivative of vapour pressure of saturated sodium w.r.t temperature"
	import SolarTherm.Media.Sodium.SodiumBoiler_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Real dp_v "Derivative of vapor pressure w.r.t temperature";
protected
	constant Real b = -12633.7;
	constant Real c = -0.4672;
algorithm
	//Ref. ANL/RE-95/2, pp. 55
	dp_v := (-b / (T ^ 2) + c / T) * p_v(T);
end dp_v_dT_T;