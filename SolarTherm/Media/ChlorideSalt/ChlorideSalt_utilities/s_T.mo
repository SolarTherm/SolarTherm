within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function s_T "Specific entropy of Chloride Salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEntropy s "Specific entropy";
protected
	constant Real a = -0.448;
	constant Real b = 1411.6156444445;
	constant Real c = -7909.245459;
algorithm
	// s is obtained by integrating (cp/T dT). The integration constant was added such that the s value at T = 298.15 K (i.e. 25 degC) becomes zero.
	s := a*T^2 + b*log(T) + c;
end s_T;
