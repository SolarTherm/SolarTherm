within SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities;
function T_s "Temperature of Chloride Salt as a function of Specific entropy"
	extends Modelica.Icons.Function;
	import Modelica.Math.*;
	input Modelica.SIunits.SpecificEntropy s "Specific entropy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real a = 257.5497198499;
	constant Real b = 0.0009728881;

algorithm
	// Based on inverse function of s(T).
	T := a*exp(b*s);
end T_s;
