within SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities;
function s_T "Specific entropy of Chloride Salt as a function of temperature"
	extends Modelica.Icons.Function;
	import Modelica.Math.*;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEntropy s "Specific entropy";
protected
	constant Real a = -0.52799;
	constant Real b = 1538.8204685;
	constant Real c = -8610.1582286761;

algorithm
	// s is obtained by integrating (cp/T dT). The integration constant was added such that the s value at T = 298.15 K (i.e. 25 degC) becomes zero.
	s := a*T^2 + b*log(T) + c;
end s_T;
