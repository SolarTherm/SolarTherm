within SolarTherm.Media.Sodium.Sodium_utilities;
function T_rho "Temperature of liquid sodium as a function of density"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Density rho "Density";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real p1 = 2.531e-06;
	constant Real p2 = -0.007111;
	constant Real p3 = 2.319;
	constant Real p4 = 2317;
algorithm
	//Ref. ANL/RE-95/2, Table 1.3-1, pp. 87
	// 400K to 2503.7K liquid on saturation curve:
	T := p1 * rho ^ 3 + p2 * rho ^ 2 + p3 * rho + p4;
end T_rho;
