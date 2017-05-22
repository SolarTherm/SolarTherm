within SolarTherm.Media.Sodium.Sodium_utilities;
function T_p "Temperature of saturated sodium as a function of saturated vapour pressure"
	extends Modelica.Icons.Function;
	input Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real a = 170.194;
	constant Real b = 0.477502;
	constant Real c = 1005.25;
	constant Real d = 0.10164;
	constant Real e = 301.561;
algorithm
	//Ref. ANL/RE-95/2, Table 1.2-1, pp. 56
	// Valid from 1.80 x 10-10 MPa to 25.64MPa liquid on saturation curve:
	T := a * (p / 1000000) ^ b + c * (p / 1000000) ^ d + e;
end T_p;
