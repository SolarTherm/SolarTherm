within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function s_T "Specific entropy of solid CarboHSP particle as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEntropy s "Specific entropy";
protected
	constant Real p1 = -1.12e-3;
	constant Real p2 = 2.07;
	constant Real p3 = 264.;
	constant Real p4 = -2071.55571631;

algorithm
	// s is obtained by integrating (cp/T dT). The integration constant was added such that the s value at T = 298.15 K (i.e. 25 degC) becomes zero.
	s := (p1/2)*(T ^ 2) + p2*T + p3*log(T) + p4;
end s_T;
