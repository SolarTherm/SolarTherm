within SolarTherm.Media.H2.H2_amb_p_curvefit_utilities;
function k_T "Thermal conductivity (W/mK) of H2 at ambient pressure as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.ThermalConductivity k "Thermal Conductivity (W/mK)";
algorithm
    k := (5.988E-11)*T*T*T - (1.793E-7)*T*T + (5.496E-4)*T + 2.602E-2; //R^2=0.99985 between 100 and 2000K 
end k_T;
