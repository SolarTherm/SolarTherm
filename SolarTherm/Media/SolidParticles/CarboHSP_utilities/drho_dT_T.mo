within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function drho_dT_T "Derivative of density of solid CarboHSP particle w.r.t temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Real drho "Derivative of density w.r.t temperature";
algorithm
	drho := 0; // Constant density
end drho_dT_T;
