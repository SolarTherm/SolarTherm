within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function T_h "Temperature of Chloride Salt as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real a = 0.0009793714;
	constant Real b = 651.8423145829;
algorithm
	T := a*h + b;
end T_h;
