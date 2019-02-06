within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function lamda_T "Thermal conductivity of solid CarboHSP particle as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.ThermalConductivity lamda "Thermal conductivity";
protected
	Modelica.SIunits.Temp_C T_C = Modelica.SIunits.Conversions.to_degC(T) "Temperature in degree Celsius";
algorithm
	lamda := 2; // Constant thermal conductivity
end lamda_T;
