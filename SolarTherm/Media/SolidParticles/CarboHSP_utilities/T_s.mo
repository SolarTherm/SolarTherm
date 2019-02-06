within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function T_s "Temperature of solid CarboHSP particle as a function of Specific entropy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEntropy s "Specific entropy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real p[9] = {0.073136547821648, 0.517464372934254, 0.926649723713928, 0.767914039690263, 4.667482222591930, 9.016815648280970, 65.365873038901128, 3.461512774565298e02, 4.811711054021069e02};

	constant Real p1 = p[1];
	constant Real p2 = p[2];
	constant Real p3 = p[3];
	constant Real p4 = p[4];
	constant Real p5 = p[5];
	constant Real p6 = p[6];
	constant Real p7 = p[7];
	constant Real p8 = p[8];
	constant Real p9 = p[9];

	constant Real s_mean = 1596;
	constant Real s_std = 720;

	Real x;
	Modelica.SIunits.Temp_C T_C "Temperature in degree Celsius";
algorithm
	// Based on s(T), a regression was done to develop a polynomial equation for T(s).
	x := (s - s_mean) / s_std;

	T_C := p1*x^8 + p2*x^7 + p3*x^6 + p4*x^5 + p5*x^4 + p6*x^3 + p7*x^2 + p8*x + p9;
	T := Modelica.SIunits.Conversions.from_degC(T_C);

end T_s;




