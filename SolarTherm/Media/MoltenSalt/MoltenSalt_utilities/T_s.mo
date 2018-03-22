within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function T_s "Temperature of molten salt as a function of Specific entropy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEntropy s "Specific entropy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real p1 = 1.504093438015698e-08;
	constant Real p2 = -1.334046332876201e-07;
	constant Real p3 = -1.257773555936631e-05;
	constant Real p4 = -1.860482246373618e-04;
	constant Real p5 = 0.004942593053630;
	constant Real p6 = 0.314097262254148;
	constant Real p7 = 7.857963064919012;
	constant Real p8 = 1.086909242328156e02;
	constant Real p9 = 6.926012804626644e02;

	constant Real s_mean = 9250;
	constant Real s_std = 237.8;
	Real x;
algorithm
	// Valid from 533.15K to 873.15K
	x := (s - s_mean) / s_std;
	T := p1 * x ^ 8 + p2 * x ^ 7 + p3 * x ^ 6 + p4 * x ^ 5 + p5 * x ^ 4 + p6 * x ^ 3 + p7 * x ^ 2 + p8 * x + p9;
end T_s;
