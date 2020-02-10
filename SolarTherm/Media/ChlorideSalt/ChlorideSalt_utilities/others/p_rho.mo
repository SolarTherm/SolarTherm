within SolarTherm.Media.Sodium.Sodium_utilities;
function p_rho "Saturated vapour pressur of sodium as a function of density"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Density rho "Density";
	output Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
protected
	constant Real p1 = -0.022364729827730;
	constant Real p2 = -0.019083550459660;
	constant Real p3 = 0.276227267126739;
	constant Real p4 = 0.451030820437898;
	constant Real p5 = -1.762622925642699;
	constant Real p6 = -1.416551974201683;
	constant Real p7 = 6.996296205930227;
	constant Real p8 = -6.327749082136161;
	constant Real p9 = 1.833441651580609;

	constant Real rho_mean1 = 625.9;
	constant Real rho_std1 = 208.2;
	Real x1;

	constant Real q1 = 9.907386584416453e-04;
	constant Real q2 = -0.003142946646180;
	constant Real q3 = 0.006984713720396;
	constant Real q4 = -0.013344120532612;
	constant Real q5 = 0.013567395671080;
	constant Real q6 = -0.005992233375728;
	constant Real q7 = 9.603014441319628e-04;

	constant Real rho_mean2 = 827.1;
	constant Real rho_std2 = 64.09;
	Real x2;

algorithm
	//Bases on data in Ref. ANL/RE-95/2
	x1 := (rho - rho_mean1) / rho_std1; //rho_norm from 1200K to 2503.7K
	x2 := (rho - rho_mean2) / rho_std2; //rho_norm from 400K to 1200K
	if rho < 732 then
		// Valid for rho from 219 [kg/m3] to 732 [kg/m3] (T:1200K to 2503.7K)
		p := 1e6 * (p1 * x1 ^ 8 + p2 * x1 ^ 7 + p3 * x1 ^ 6 + p4 * x1 ^ 5 + p5 * x1 ^ 4 + p6 * x1 ^ 3 + p7 * x1 ^ 2 + p8 * x1 + p9);
	else
		// Valid for rho from 732[kg/m3] to 919[kg/m3] (T: 400K to 1200K):
		p := 1e6 * (q1 * x2 ^ 6 + q2 * x2 ^ 5 + q3 * x2 ^ 4 + q4 * x2 ^ 3 + q5 * x2 ^ 2 + q6 * x2 + q7);
	end if;
end p_rho;
