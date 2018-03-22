within SolarTherm.Media.Sodium.Sodium_utilities;
function T_h "Temperature of liquid sodium as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real[8] p={ -0.009242628114334224, -0.2256606342363793, 0.6441022075255126, 2.609381245065044, -12.17897142894775, -21.99755753201832, 498.300362679127, 1204.309372258783};
	constant Real p1= p[1];
	constant Real p2= p[2];
	constant Real p3= p[3];
	constant Real p4= p[4];
	constant Real p5= p[5];
	constant Real p6= p[6];
	constant Real p7= p[7];
	constant Real p8= p[8];

	constant Real h_mean=1173255.929754884;
	constant Real h_std=638348.3064134347;
	Real x;
algorithm
	//correlation based on Ref. ANL/RE-95/2
	x := (h - h_mean) / h_std; //h_norm
	T := p1 * x ^ 7 + p2 * x ^ 6 + p3 * x ^ 5 + p4 * x ^ 4 + p5 * x ^ 3 + p6 * x ^ 2 + p7 * x + p8;
end T_h;
