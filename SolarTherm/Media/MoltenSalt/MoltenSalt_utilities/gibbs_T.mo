within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function gibbs_T "Specific Gibbs energy of molten salt"
	import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificGibbsFreeEnergy gibbs "Specific Gibbs energy";
algorithm
	gibbs := h_T(T) - T * s_T(T);
end gibbs_T;
