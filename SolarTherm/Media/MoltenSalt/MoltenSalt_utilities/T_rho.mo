within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function T_rho "Temperature of molten salt as a function of density"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Density rho "Density";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real p1 = 0.026694736413680;
	constant Real p2 = 0.033883173706630;
	constant Real p3 = -0.082551702426422;
	constant Real p4 = -0.093764993849291;
	constant Real p5 = 0.076284443065688;
	constant Real p6 = 0.070574586765291;
	constant Real p7 = -0.021388297459061;
	constant Real p8 = -1.082235011008968e02;
	constant Real p9 = 6.997982926924665e02;

	constant Real rho_mean = 1817;
	constant Real rho_std = 69.27;
	Real x;
algorithm
	// Valid from 533.15K to 873.15K
	x := (rho - rho_mean) / rho_std;
	T := p1 * x ^ 8 + p2 * x ^ 7 + p3 * x ^ 6 + p4 * x ^ 5 + p5 * x ^ 4 + p6 * x ^ 3 + p7 * x ^ 2 + p8 * x + p9;
end T_rho;
