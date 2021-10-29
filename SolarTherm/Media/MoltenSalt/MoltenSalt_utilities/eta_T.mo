within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function eta_T "Dynamic viscosity of molten salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature K "Temperature";
	output Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
protected
	Modelica.SIunits.Temp_C T = Modelica.SIunits.Conversions.to_degC(K) "Temperature in degCelsius";
algorithm
	// Ref: Zavoico, A. B. (2001). Solar Power Tower - Design Basis Document. Technical Report SAND2001-2100. Alburquerque, USA, pp. 23
	// Valid from 533.15K to 873.15K liquid on saturation curve:
	eta := 0.001 * (22.714 - 0.120 * T + 2.281e-4 * T ^ 2 - 1.474e-7 * T ^ 3);
end eta_T;












