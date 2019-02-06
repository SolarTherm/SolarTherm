within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function rho_T "Density of solid CarboHSP particle as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.Density rho "Density";
protected
	Modelica.SIunits.Temp_C T_C = Modelica.SIunits.Conversions.to_degC(T) "Temperature in degree Celsius";
algorithm
	rho := 2e3; // Constant density
	annotation(derivative=rho_T_der);
end rho_T;
