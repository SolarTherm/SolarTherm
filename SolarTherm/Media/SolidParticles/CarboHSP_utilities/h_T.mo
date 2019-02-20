within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function h_T "Specific enthalpy of solid CarboHSP 40/70 particle as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
protected
	constant Real a = 148.2;
	constant Real b = 0.3093;
	constant Real c = -196601.368854;

algorithm
	// h is obtained by integrating (cp dT). The integration constant was added such that the h value at T = 298.15K (i.e. 25 degC) becomes zero.
	h := a * ((T ^ (b+1))/(b+1)) + c;
	annotation(derivative=h_T_der);
end h_T;
