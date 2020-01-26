within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function T_s "Temperature of solid CarboHSP 40/70 particle as a function of Specific entropy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEntropy s "Specific entropy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real a = 148.2;
	constant Real b = 0.3093;
	constant Real c = -2791.32863934;

algorithm
	// Based on inverse function of s(T).
	T := ((b/a) * (s-c)) ^ (1.0/b);
end T_s;
