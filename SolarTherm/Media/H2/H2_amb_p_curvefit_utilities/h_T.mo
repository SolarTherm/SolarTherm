within SolarTherm.Media.H2.H2_amb_p_curvefit_utilities;
function h_T "Specific enthalpy (J/kg) of H2 at ambient pressure as a function of temperature (reference 0 J/kg at 100K)"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
algorithm
    h := (9.166E-1)*T*T + (1.334E4)*T - 1.395E6; //R^2=0.999973 between 100 and 2000K 
end h_T;
