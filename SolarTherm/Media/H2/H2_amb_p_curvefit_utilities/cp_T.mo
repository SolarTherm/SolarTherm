within SolarTherm.Media.H2.H2_amb_p_curvefit_utilities;
function cp_T "Specific heat capacity (J/kgK) of H2 at ambient pressure as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity (J/kgK)";
algorithm
    cp := 1.8332*T+1.334E4; //Derivative of h-T
end cp_T;
