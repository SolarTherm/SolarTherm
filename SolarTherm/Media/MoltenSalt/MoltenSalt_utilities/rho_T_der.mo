within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function rho_T_der "Derivative of the density of molten salt w.r.t. time"
	import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	input Real der_T "Derivative of temperature w.r.t time";
	output Real der_rho "Derivative of density w.r.t time";
algorithm
	der_rho := drho_dT_T(T) * der_T;
  end rho_T_der;
