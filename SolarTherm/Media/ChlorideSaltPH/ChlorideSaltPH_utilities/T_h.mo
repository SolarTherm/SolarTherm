within SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities;
function T_h "Temperature of Chloride Salt as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real a = 0.0009227334;
	constant Real b = 650.0337520883;

algorithm
	T := a*h + b;
	annotation(derivative=T_h_der);
end T_h;
