within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function drho_dT_T "Derivative of density of molten salt w.r.t temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Real drho "Derivative of density w.r.t temperature";
algorithm
	// Ref: Zavoico, A. B. (2001). Solar Power Tower - Design Basis Document. Technical Report SAND2001-2100. Alburquerque, USA, pp. 23
	// Valid from 533.15K to 873.15K liquid on saturation curve:
	drho := -0.636;
  end drho_dT_T;
