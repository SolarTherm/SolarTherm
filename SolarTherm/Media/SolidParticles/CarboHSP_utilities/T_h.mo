within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function T_h "Temperature of solid CarboHSP particle as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real p[9] = {-3.314988592207698, 10.677133047525592, -1.415598848192866, -19.011448089665809, 2.064569237745878, 29.513272067551512, -34.334097532945528, 2.901790403224514e02, 5.907377367121674e02};

	constant Real p1 = p[1];
	constant Real p2 = p[2];
	constant Real p3 = p[3];
	constant Real p4 = p[4];
	constant Real p5 = p[5];
	constant Real p6 = p[6];
	constant Real p7 = p[7];
	constant Real p8 = p[8];
	constant Real p9 = p[9];

	constant Real h_mean = 4.325e05;
	constant Real h_std = 3.209e05;

	Real x;
	Modelica.SIunits.Temp_C T_C "Temperature in degree Celsius";
algorithm
	// Based on h(T), a regression was done to develop a polynomial equation for T(h).
	x := (h - h_mean) / h_std; // h_norm

	T_C := p1*x^8 + p2*x^7 + p3*x^6 + p4*x^5 + p5*x^4 + p6*x^3 + p7*x^2 + p8*x + p9;
	T := Modelica.SIunits.Conversions.from_degC(T_C);

	annotation(derivative=T_h_der);
end T_h;
