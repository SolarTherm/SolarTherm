within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function drho_dT_T "Derivative of density of liquid sodium w.r.t temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Real drho "Derivative of density w.r.t temperature";
algorithm
	//From interpolation of NREL data
	drho :=-0.406;
end drho_dT_T;
