within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function cp_T "Specific heat capacity of molten salt at constant pressue as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
algorithm
	//Ref: Zavoico, A. B. (2001). Solar Power Tower - Design Basis Document. Technical Report SAND2001-2100. Alburquerque, USA, pp. 23
	// Valid from 533.15K to 873.15K liquid on saturation curve:
	cp := 1396.0182 + 0.172 * T;
end cp_T;
