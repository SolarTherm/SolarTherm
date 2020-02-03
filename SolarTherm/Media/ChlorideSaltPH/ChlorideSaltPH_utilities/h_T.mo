within SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities;
function h_T "Specific enthalpy of Chloride Salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
protected
	constant Real a = -0.263995;
	constant Real b = 1538.8204685;
	constant Real c = 0.001;//-897243.412985412;

algorithm
	// h is obtained by integrating (cp dT). The integration constant was added such that the h value at T = 298.15K (i.e. 25 degC) becomes zero.
	h := a * T ^ 2 + b * T + c;
	annotation(derivative=h_T_der);
end h_T;
