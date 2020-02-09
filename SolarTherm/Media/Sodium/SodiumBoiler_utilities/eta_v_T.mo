within SolarTherm.Media.Sodium.SodiumBoiler_utilities;
function eta_v_T "Dynamic viscosity of vapour sodium as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.DynamicViscosity eta_g "Dynamic viscosity";
protected
	constant Real p1 = 7.670352421272374e-08;
	constant Real p2 = -1.013685486531908e-07;
	constant Real p3 = -3.058015819964534e-07;
	constant Real p4 = 7.173018256913402e-06;
	constant Real p5 = 2.580480049362403e-05;

	constant Real T_mean = 1200;
	constant Real T_std = 389.4;
	Real x;
algorithm
	//Ref: https://www.thermalfluidscentral.org/encyclopedia/index.php/Thermophysical_Properties:_Sodium
	// Valid from 600K to 1800K
	x := (T - T_mean) / T_std; //T_norm
	eta_g := p1 * x ^ 4 + p2 * x ^ 3 + p3 * x ^ 2 + p4 * x + p5;
end eta_v_T;