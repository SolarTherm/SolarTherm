within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function h_s "Specific enthalpy of molten salt as a function of Specific entropy"
	import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEntropy s "Specific entropy";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
protected
	constant Real p1 = -4.207915256284852e-06;
	constant Real p2 = -4.252960376115911e-04;
	constant Real p3 = -0.007372023879740;
	constant Real p4 = 0.235040918858859;
	constant Real p5 = 18.671039765272749;
	constant Real p6 = 6.228064419983780e02;
	constant Real p7 = 1.292193798421334e04;
	constant Real p8 = 1.646825778116541e05;
	constant Real p9 = 1.008137894767280e06;

	constant Real s_mean = 9250;
	constant Real s_std = 237.8;
	Real x;
algorithm
	// Valid from 533.15K to 873.15K
	x := (s - s_mean) / s_std;
	h := p1 * x ^ 8 + p2 * x ^ 7 + p3 * x ^ 6 + p4 * x ^ 5 + p5 * x ^ 4 + p6 * x ^ 3 + p7 * x ^ 2 + p8 * x + p9;
end h_s;
