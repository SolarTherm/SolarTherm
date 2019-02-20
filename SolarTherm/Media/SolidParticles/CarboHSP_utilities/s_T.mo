within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function s_T "Specific entropy of solid CarboHSP 40/70 particle as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEntropy s "Specific entropy";
protected
	constant Real a = 148.2;
	constant Real b = 0.3093;
	constant Real c = -2791.32863934;

algorithm
	// s is obtained by integrating (cp/T dT). The integration constant was added such that the s value at T = 298.15 K (i.e. 25 degC) becomes zero.
	s := a*((T ^ b)/b) + c;
end s_T;
