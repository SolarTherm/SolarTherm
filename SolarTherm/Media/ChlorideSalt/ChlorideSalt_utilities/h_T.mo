within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function h_T "Specific enthalpy of Chloride Salt as a function of temperature"
	extends Modelica.Icons.Function;
	import SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities.*;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
algorithm
	// h is obtained by integrating (cp dT). The integration constant was added such that the h value at T = 298.15 K becomes zero.	
	// Integration from cp
	h :=T*(-0.528/2*T+1538.7)-298.15*(-0.264*298.15+1538.7);
	annotation(derivative=h_T_der);
end h_T;
