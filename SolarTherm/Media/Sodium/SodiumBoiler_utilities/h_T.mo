within SolarTherm.Media.Sodium.SodiumBoiler_utilities;
function h_T "Specific enthalpy of liquid sodium as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
algorithm
	//Ref. ANL/RE-95/2, pp. 4
	// 371K to 2000K liquid on saturation curve:
	h := 1000 * (-365.77 + 1.6582 * T - 4.2395e-4 * T ^ 2 + 1.4847e-7 * T ^ 3 + 2992.6 / T);
	annotation(derivative=h_T_der);
end h_T;