within SolarTherm.Media.Sodium.Sodium_utilities;
function h_rho "Specific enthalpy of liquid sodium as a function of density"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Density rho "Density";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
protected
	constant Real p1 = -5.536057019701200e-06;
	constant Real p2 = 0.010494809843506;
	constant Real p3 = -11.546781589757524;
	constant Real p4 = 6.177799728765503e03;
algorithm
	// 400K to 2500K liquid on saturation curve:
	h := 1000 * (p1 * rho ^ 3 + p2 * rho ^ 2 + p3 * rho + p4);
end h_rho;
