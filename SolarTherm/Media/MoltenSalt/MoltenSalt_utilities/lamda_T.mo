within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function lamda_T "Thermal conductivity of molten salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature K "Temperature";
	output Modelica.SIunits.ThermalConductivity lamda "Thermal conductivity";
protected
	Modelica.SIunits.Temp_C T = Modelica.SIunits.Conversions.to_degC(K) "Temperature in degCelsius";
algorithm
	// Ref: Zavoico, A. B. (2001). Solar Power Tower - Design Basis Document. Technical Report SAND2001-2100. Alburquerque, USA, pp. 23
	// Valid from 533.15K to 873.15K liquid on saturation curve:
	lamda := 0.443 + 1.9e-4 * T;
end lamda_T;
