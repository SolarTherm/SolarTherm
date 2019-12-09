within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function p_rho "Saturated vapour pressur of molten salt as a function of density"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Density rho "Density";
	output Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
protected
	constant Real p1 = 0.733446745332821;
	constant Real p2 = 0.653577028271395;
	constant Real p3 = -1.254638858135562;
	constant Real p4 = 23.599040313108496;
	constant Real p5 = 16.841697526950028;
	constant Real p6 = -1.832200683871549e03;
	constant Real p7 = 1.001166286167321e04;
	constant Real p8 = -2.197288709140443e04;
	constant Real p9 = 1.800126936525206e04;

	constant Real rho_mean = 1817;
	constant Real rho_std = 69.27;
	Real x;
algorithm
	// Valid from 533.15K to 873.15K
	x := (rho - rho_mean) / rho_std;
	p := p1 * x ^ 8 + p2 * x ^ 7 + p3 * x ^ 6 + p4 * x ^ 5 + p5 * x ^ 4 + p6 * x ^ 3 + p7 * x ^ 2 + p8 * x + p9;
end p_rho;



















