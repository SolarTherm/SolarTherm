within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function T_h "Temperature of solid CarboHSP 40/70 particle as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real a = 148.2;
	constant Real b = 0.3093;
	constant Real c = -196601.368854;

algorithm
	// Based on inverse function of h(T).
	T := (((b+1)/a) * (h-c)) ^ (1.0/(b+1));
	annotation(derivative=T_h_der);
end T_h;
