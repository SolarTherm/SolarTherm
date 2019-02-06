within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function h_T "Specific enthalpy of solid CarboHSP particle as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
protected
	constant Real p1 = -1.12e-3;
	constant Real p2 = 2.07;
	constant Real p3 = 264.;
	constant Real p4 = -7241.04166667;

	Modelica.SIunits.Temp_C T_C = Modelica.SIunits.Conversions.to_degC(T) "Temperature in degree Celsius";
algorithm
	// h is obtained by integrating (cp dT). The integration constant was added such that the h value at T = 298.15K (i.e. 25 degC) becomes zero.
	h := (p1/3)*(T_C ^ 3) + (p2/2)*(T_C ^ 2) + p3*T_C + p4;
	annotation(derivative=h_T_der);
end h_T;
