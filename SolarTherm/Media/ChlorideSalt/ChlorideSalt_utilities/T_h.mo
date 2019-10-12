within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function T_h "Temperature of Chloride Salt as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	output Modelica.SIunits.Temperature T "Temperature";

algorithm
	//From h_T
	T:=(-1538.7+((1538.7)^2-2*0.528*h)^0.5)/(-0.528);
end T_h;
