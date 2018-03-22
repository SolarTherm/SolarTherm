within SolarTherm.Media.MoltenSalt.MoltenSalt_utilities;
function rho_T "Density of molten salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature K "Temperature";
	output Modelica.SIunits.Density rho "Density";
protected
	Modelica.SIunits.Temp_C T = Modelica.SIunits.Conversions.to_degC(K) "Temperature in degCelsius";
algorithm
	// Ref: Zavoico, A. B. (2001). Solar Power Tower - Design Basis Document. Technical Report SAND2001-2100. Alburquerque, USA, pp. 23
	// Valid from 533.15K to 873.15K liquid on saturation curve:
	rho := 2090 - 0.636 * T;
	annotation(derivative=rho_T_der);
end rho_T;


