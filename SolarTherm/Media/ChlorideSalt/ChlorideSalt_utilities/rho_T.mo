within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function rho_T "Density of Chloride Salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.Density rho "Density";
algorithm
	//From interpolation of NREL data
	rho := 1992.9-0.406*T;
	annotation(derivative = rho_T_der);
end rho_T;
