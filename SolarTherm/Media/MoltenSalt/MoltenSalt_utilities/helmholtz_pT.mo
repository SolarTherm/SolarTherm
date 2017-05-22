within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function helmholtz_pT "Specific Helmholtz energy of molten salt"
	import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	input Modelica.SIunits.AbsolutePressure p "Pressure";
	output Modelica.SIunits.SpecificHelmholtzFreeEnergy helmholtz "Specific Helmholtz energy";
algorithm
	helmholtz := h_T(T) - p / rho_T(T) - T * s_T(T);
end helmholtz_pT;



