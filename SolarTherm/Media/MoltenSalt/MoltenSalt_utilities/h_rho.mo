within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function h_rho "Specific enthalpy of molten salt as a function of density"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Density rho "Density";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
protected
	constant Real p1 = 39.713718745914576;
	constant Real p2 = 50.407945969307448;
	constant Real p3 = -1.228120420950819e02;
	constant Real p4 = -1.394940386838149e02;
	constant Real p5 = 1.134882498794937e02;
	constant Real p6 = 1.049937053496403e02;
	constant Real p7 = 9.752089378977765e02;
	constant Real p8 = -1.641079585719889e05;
	constant Real p9 = 1.019046845737454e06;

	constant Real rho_mean = 1817;
	constant Real rho_std = 69.27;
	Real x;
algorithm
	// Valid from 533.15K to 873.15K
	x := (rho - rho_mean) / rho_std;
	h := p1* x ^ 8 + p2 * x ^ 7 + p3 * x ^ 6 + p4 * x ^ 5 + p5 * x ^ 4 + p6 * x ^ 3 + p7 * x ^ 2 + p8 * x + p9;
end h_rho;
