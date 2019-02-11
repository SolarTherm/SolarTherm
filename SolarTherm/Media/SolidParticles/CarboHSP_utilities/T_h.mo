within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function T_h "Temperature of solid CarboHSP particle as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real p[4] = {12.137122959950746, -11.344263682573480, 2.979672523883171e02, 8.359506159756688e02};

	constant Real p1 = p[1];
	constant Real p2 = p[2];
	constant Real p3 = p[3];
	constant Real p4 = p[4];

	constant Real h_mean = 5.635e05;
	constant Real h_std = 3.637e05;

	Real x;

algorithm
	// Based on h(T), a regression was done to develop a polynomial equation for T(h).
	x := (h - h_mean) / h_std; // h_norm

	T := p1*x^3 + p2*x^2 + p3*x + p4;

	annotation(derivative=T_h_der);
end T_h;
