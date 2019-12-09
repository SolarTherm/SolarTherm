within SolarTherm.Models.PowerBlocks.Cooling;
function Energy_nu_w
	extends Modelica.Icons.Function;

	input SI.Temperature T_amb;
	input SI.Temperature T_co;

	output Real f;
protected
	Real x;
	Real y;
	final parameter Real p[:] = {-12783.94001192, 167.90985301423, 279.4906764848, 1.4061966736757, -0.094678085818565, -8.5348512615156E-5, 1393.2628381637, -528.94397635619, -23.850140679655,
		0.28422596136293, 0.0023782539866181, 174.85171425712, 40.803968027213, 0.17505944339285, -0.007325134085093, -16.607207146646, -0.75592078803495, 0.0049630268870799, 0.37110642430633,
		0.0024014761809283, -0.0022411042933267};

	final parameter Real p00 = p[1];//%   53.45;%  [53.43, 53.47]
	final parameter Real p01 = p[2];//%  -17.21;%  [-17.24, -17.18]
	final parameter Real p02 = p[3];//%   24.11;%  [24.08, 24.15]
	final parameter Real p03 = p[4];//%   6.393;%  [6.342, 6.445]
	final parameter Real p04 = p[5];//%  -15.96;%  [-16.04, -15.89]
	final parameter Real p05 = p[6];//%   10.02;%  [9.96, 10.08]
	final parameter Real p10 = p[7];//% -0.9817;%  [-1.011, -0.9519]
	final parameter Real p11 = p[8];//%   3.766;%  [3.705, 3.828]
	final parameter Real p12 = p[9];//%  -2.141;%  [-2.203, -2.079]
	final parameter Real p13 = p[10];//% -0.4846;%  [-0.5234, -0.4459]
	final parameter Real p14 = p[11];//%  0.6912;%  [0.6647, 0.7177]
	final parameter Real p20 = p[12];//% -0.4297;%  [-0.4942, -0.3653]
	final parameter Real p21 = p[13];//%  -3.714;%  [-3.802, -3.627]
	final parameter Real p22 = p[14];//%   5.661;%  [5.592, 5.73]
	final parameter Real p23 = p[15];//%  -2.136;%  [-2.176, -2.096]
	final parameter Real p30 = p[16];//% -0.7195;%  [-0.7289, -0.7101]
	final parameter Real p31 = p[17];//%  0.8453;%  [0.8099, 0.8807]
	final parameter Real p32 = p[18];//%   1.939;%  [1.874, 2.005]
	final parameter Real p40 = p[19];//%  -3.142;%  [-3.209, -3.076]
	final parameter Real p41 = p[20];//%   1.121;%  [1.083, 1.159]
	final parameter Real p50 = p[21];//%-0.04159;%  [-0.05564, -0.02754]

	algorithm
	x := T_amb-273.5;
	y := T_co-273.15;

	f:=p00 + p10*x + p01*y + p20*x^2 + p11*x*y + p02*y^2 + p30*x^3 + p21*x^2*y + p12*x*y^2 + p03*y^3 + p40*x^4 + p31*x^3*y + p22*x^2*y^2 + p13*x*y^3 + p04*y^4 +
	p50*x^5 + p41*x^4*y + p32*x^3*y^2 + p23*x^2*y^3 + p14*x*y^4 + p05*y^5;

end Energy_nu_w;
