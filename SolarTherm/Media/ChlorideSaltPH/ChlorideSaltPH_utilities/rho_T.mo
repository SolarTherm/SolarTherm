within SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities;
function rho_T "Density of Chloride Salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.Density rho "Density";
protected
	Modelica.SIunits.Temp_C T_C = Modelica.SIunits.Conversions.to_degC(T) "Temperature in degree Celsius";
	constant Real a = -0.406;
	constant Real b = 1992.9989;
algorithm
	rho := a*T + b; // Constant bulk density
	annotation(derivative=rho_T_der);
end rho_T;
