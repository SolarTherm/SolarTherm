within SolarTherm.Media.H2.H2_amb_p_curvefit_utilities;
function rho_T "Density (kg/m3) of H2 at ambient pressure as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.Density rho "Density (kg/m3)";
algorithm
    rho := 24.24342/T; //R^2 = 0.9999998 from 100 to 2000K (force intercept of 1/T vs rho to 0)
end rho_T;
