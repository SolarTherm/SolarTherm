within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function h_T "Specific enthalpy of Chloride Salt as a function of temperature"
	extends Modelica.Icons.Function;
	import SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities.*;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
protected
	constant Real a = -0.2241891775;
	constant Real b = 1411.9325606493;
	constant Real c = -832203.52407882;
algorithm
	// h is obtained by integrating (cp dT). The integration constant was added such that the h value at T = 298.15K (i.e. 25 degC) becomes zero.
	h := a * T ^ 2 + b * T + c;
	annotation(derivative=h_T_der);
end h_T;
