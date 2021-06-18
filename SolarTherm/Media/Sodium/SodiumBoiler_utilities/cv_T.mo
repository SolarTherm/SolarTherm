within SolarTherm.Media.Sodium.SodiumBoiler_utilities;
function cv_T "Specific heat capacity of liquid sodium at constant volume as a function of temperature"
	import SolarTherm.Media.Sodium.SodiumBoiler_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificHeatCapacity cv "Specific heat capacity";
algorithm
	//Ref. ANL/RE-95/2, pp. 17
	cv := cp_T(T) * (kappa_s_T(T) / kappa_T(T));
end cv_T;