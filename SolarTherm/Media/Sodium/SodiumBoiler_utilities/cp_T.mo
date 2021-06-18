within SolarTherm.Media.Sodium.SodiumBoiler_utilities;
function cp_T "Specific heat capacity of liquid sodium at constant pressue as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
algorithm
	//Ref. ANL/RE-95/2, pp. 29
	// 371K to 2000K liquid on saturation curve
	cp := 1000 * (1.6582 - 8.4790e-4 * T + 4.4541e-7 * T ^ 2 - 2992.6 * T ^ (-2));
end cp_T;