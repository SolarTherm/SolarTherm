within SolarTherm.Media.Sodium.Sodium_utilities;
function beta_T "Isobaric expansion coefficient of liquid sodium"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.Media.Interfaces.Types.IsobaricExpansionCoefficient beta_isb "Isobaric expansion coefficient";
algorithm
	//Ref. ANL/RE-95/2, pp. 96
	beta_isb := (-1/rho_T(T)) * drho_dT_T(T);
end beta_T;
