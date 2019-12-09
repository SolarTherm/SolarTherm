within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function s_T "Specific entropy of Chloride Salt as a function of temperature"
	// Assumption: incompressible flow, so: cv=cp=c, and v*dp = 0, then T*ds= dh-v*dp=c*dT
	// Thus, by integrating (cp/T dT) from T0 to T, the entropy change can be obtained
	// Integration constant is added such that s is set to zero at T0 = 298.15 K

	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEntropy s "Specific entropy";
algorithm
	s := -0.528*log(T/298.15)+1538.7*(T-298.15);
end s_T;
