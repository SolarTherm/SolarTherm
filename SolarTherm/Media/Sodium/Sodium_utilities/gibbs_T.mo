within SolarTherm.Media.Sodium.Sodium_utilities;
function gibbs_T "Specific Gibbs energy of liquid sodium"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificGibbsFreeEnergy gibbs "Specific Gibbs energy";
algorithm
	gibbs := h_T(T) - T * s_T(T);
end gibbs_T;
