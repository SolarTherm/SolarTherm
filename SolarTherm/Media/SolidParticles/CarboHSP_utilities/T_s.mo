within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function T_s "Temperature of solid CarboHSP particle as a function of Specific entropy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEntropy s "Specific entropy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real p[4] = {12.606766933416871, 61.774293949392764, 3.148631357988567e02, 7.690878128877895e02};

	constant Real p1 = p[1];
	constant Real p2 = p[2];
	constant Real p3 = p[3];
	constant Real p4 = p[4];

	constant Real s_mean = 949.3;
	constant Real s_std = 483.2;

	Real x;

algorithm
	// Based on s(T), a regression was done to develop a polynomial equation for T(s).
	x := (s - s_mean) / s_std;

	T := p1*x^3 + p2*x^2 + p3*x + p4;
end T_s;
