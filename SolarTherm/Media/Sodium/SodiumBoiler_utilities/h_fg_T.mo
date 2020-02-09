within SolarTherm.Media.Sodium.SodiumBoiler_utilities;
function h_fg_T "Specific enthalpy of vaporization of sodium as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEnthalpy h_fg "Specific enthalpy";
algorithm
	//Ref. ANL/RE-95/2, pp. 65
	// Valid from 371K to 2503.7K
	h_fg := 1000 * (393.37 * (1- T / 2503.7) + 4398.6 * ((1 - T / 2503.7) ^ 0.29302));
end h_fg_T;