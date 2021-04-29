within SolarTherm.Media.Sodium.Sodium_utilities;
function h_T "Specific enthalpy of liquid sodium as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
algorithm
	//Ref. ANL/RE-95/2, pp. 4
	// 371K to 2000K liquid on saturation curve, but reference is now 298.15K liquid phase, unlike Fink & Leibowitz who measures it from solid 298.15K:
	h := 1000 * (-365.77 + 1.6582 * T - 4.2395e-4 * T ^ 2 + 1.4847e-7 * T ^ 3 + 2992.6 / T - 104.90817873321107);
	annotation(derivative=h_T_der);
end h_T;
