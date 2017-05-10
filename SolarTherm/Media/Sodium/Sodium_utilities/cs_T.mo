within SolarTherm.Media.Sodium.Sodium_utilities;
function cs_T "Specific heat capacity of liquid sodium along the saturation curve"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificHeatCapacity cs "Specific heat capacity along the saturation curve";
algorithm		
	//Ref. ANL/RE-95/2, pp. 19
	cs := cp_T(T) - gamma_T(T) / rho_T(T);
end cs_T;



