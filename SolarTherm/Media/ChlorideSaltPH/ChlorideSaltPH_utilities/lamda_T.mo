within SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities;
function lamda_T "Thermal conductivity of Chloride Salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.ThermalConductivity lamda "Thermal conductivity";
protected
	Modelica.SIunits.Temp_C T_C = Modelica.SIunits.Conversions.to_degC(T) "Temperature in degree Celsius";
	constant Real a = 7.06493506493493e-7;
	constant Real b = -0.0014404163;
	constant Real c = 1.1483003444;
algorithm
	lamda := a*T^2 + b*T + c; // Constant thermal conductivity
end lamda_T;
