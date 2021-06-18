within SolarTherm.Media.Sodium.SodiumBoiler_utilities;
function s_T "Specific entropy of liquid sodium as a function of temperature"
	// Assumption: incompressible flow, so: cv=cp=c, and v*dp = 0, then T*ds= dh-v*dp=c*dT
	// Thus, by integrating (cp/T dT) from T0 to T, the entropy change can be obtained
	// Integration constant is added such that s is set to zero at T0 = 298.15 K

	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEntropy s "Specific entropy";
algorithm
	s := 1000 * (2.22705e-7 * T ^ 2 - 8.4790e-4 * T + 1.6582 * log(T) + 1496.3 / (T ^ 2) - 9.2315830149);
end s_T;