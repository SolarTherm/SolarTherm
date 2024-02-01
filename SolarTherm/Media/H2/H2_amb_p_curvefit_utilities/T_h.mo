within SolarTherm.Media.H2.H2_amb_p_curvefit_utilities;
function T_h "Temperature (K) of H2 at ambient pressure as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
	output Modelica.SIunits.Temperature T "Temperature (K)";
algorithm
    T := (-2.584E-13)*h*h + (7.282E-5)*h + 1.058E2; //R^2 = 0.99998 from 100K to 2000K
end T_h;
