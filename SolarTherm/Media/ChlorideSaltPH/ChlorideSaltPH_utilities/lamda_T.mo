within SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities;
function lamda_T "Thermal conductivity of Chloride Salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.ThermalConductivity lamda "Thermal conductivity";
protected
	Modelica.SIunits.Temp_C T_C = Modelica.SIunits.Conversions.to_degC(T) "Temperature in degree Celsius";
	constant Real a = -0.0001;
	constant Real b = 0.535515;
algorithm
	lamda := a*T + b; // Constant thermal conductivity
end lamda_T;
