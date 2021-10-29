within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function s_rho "Specific entropy of molten salt as a function of density"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Density rho "Density";
	output Modelica.SIunits.SpecificEntropy s "Specific entropy";
protected
	constant Real p1 = 0.074442895162941;
	constant Real p2 = 0.094105565955424;
	constant Real p3 = -0.233574614812304;
	constant Real p4 = -0.286315713014475;
	constant Real p5 = 0.013365595797011;
	constant Real p6 = -1.523616571400823;
	constant Real p7 = -16.749820096832305;
	constant Real p8 = -2.345160845000009e02;
	constant Real p9 = 9.265390905220705e03;
  
  constant Real rho_mean = 1817;
  constant Real rho_std = 69.27;
  Real x;
algorithm 
  // 400K to 2500K liquid on saturation curve:
  x := (rho - rho_mean) / rho_std; //rho_norm
  s :=  p1 * x ^ 8 + p2 * x ^ 7 + p3 * x ^ 6 + p4 * x ^ 5 + p5 * x ^ 4 + p6 * x ^ 3 + p7 * x ^ 2 + p8 * x + p9;
end s_rho;








