within SolarTherm.Models.CSP.CRS.Receivers.Panel;
function Tinner
	extends Modelica.Icons.Function;
	import SI = Modelica.SIunits;
	import Modelica.Constants.*;
	import Modelica.Math.*;
	input Modelica.SIunits.Temperature Tinf1 "Fluid temperature";
	input Modelica.SIunits.HeatFlux q0 "Heat flux over the receiver element surface";
	input Modelica.SIunits.Efficiency Bi1 "Inner Biot number";
	input Modelica.SIunits.Efficiency Bi2 "Outer Biot number";
	input Modelica.SIunits.Efficiency ab "Receiver absorptance";
	input Modelica.SIunits.Length R1 "Inner radius";
	input Modelica.SIunits.Length R2 "Outer radius";
	input Modelica.SIunits.ThermalConductivity k "Pipe thermal conductivity";
	input Modelica.SIunits.Efficiency Tinf2 "Receiver absorptance";
	output Modelica.SIunits.Temperature Tin "Pipe inner temperature";
protected
	Real T;
	Real gp1;
	Real gp2;
	Real gp3;
	Real g1;
	Real g2;
	Real g3;
	Real A0;
	Real A1;
	Real A2;
	Real A3;
algorithm
	//gpn = n*(1 - (R1/R2)^(2*n)*(n - Bi1)/(n + Bi1));
	//gn = (R1/R2)^n + (R1/R2)^(2*n)*(n - Bi1)/(n + Bi1)*(R1/R2)^(-n);
	//An := 2*cos(n*pi/2)/(pi*(1 - n^2)*(gpn + Bi2*gn));
	
	gp1 := (1 - (R1/R2)^(2*1)*(1 - Bi1)/(1 + Bi1));
	gp2 := 2*(1 - (R1/R2)^(2*2)*(2 - Bi1)/(2 + Bi1));
	gp3 := 3*(1 - (R1/R2)^(2*3)*(3 - Bi1)/(3 + Bi1));
	
	g1 := (R1/R2)^1 + (R1/R2)^(2*1)*(1 - Bi1)/(1 + Bi1)*(R1/R2)^(-1);
	g2 := (R1/R2)^2 + (R1/R2)^(2*2)*(2 - Bi1)/(2 + Bi1)*(R1/R2)^(-2);
	g3 := (R1/R2)^3 + (R1/R2)^(2*3)*(3 - Bi1)/(3 + Bi1)*(R1/R2)^(-3);
	
	A0 := (1 + pi*Bi2*Tinf2)/(pi*(Bi1 + Bi2*(1 - Bi1*log(R1/R2))));
	A1 := 1/(2*(gp1 + Bi2*g1));
	A2 := 2*cos(2*pi/2)/(pi*(1 - 2^2)*(gp2 + Bi2*g2));
	A3 := 2*cos(3*pi/2)/(pi*(1 - 3^2)*(gp3 + Bi2*g3));
	
	T := A0*(1 + Bi1*log(1)) + A1*g1 + A2*g2 + A3*g3;

	Tin := Tinf1 + ab*q0*R2/k*T;

end Tinner;
//within SolarTherm.Models.CSP.CRS.Receivers.Panel;
//function Tinner
//	extends Modelica.Icons.Function;
//	import SI = Modelica.SIunits;
//	import Modelica.Constants.*;
//	import Modelica.Math.*;
//	input Modelica.SIunits.Temperature Tf "Fluid temperature";
//	input Modelica.SIunits.HeatFlux Q_rcv "Heat flux over the receiver element surface";
//	input Modelica.SIunits.Efficiency Bi1 "Inner Biot number";
//	input Modelica.SIunits.Efficiency Bi2 "Outer Biot number";
//	input Modelica.SIunits.Efficiency ab "Receiver absorptance";
//	input Modelica.SIunits.Length a "Inner radius";
//	input Modelica.SIunits.Length b "Outer radius";
//	input Modelica.SIunits.ThermalConductivity kt "Pipe thermal conductivity";
//	input Modelica.SIunits.Efficiency Ta "Receiver absorptance";
//	output Modelica.SIunits.Temperature Tin "Pipe inner temperature";
//protected
//	Real A0;
//	Real A1;
//	Real A2;
//	Real B0;
//	Real B1;
//	Real B2;
//algorithm
//	A0 := (1 + pi*Bi2*Ta)*(1 - Bi1*log(a/b))/(pi*(Bi1 + Bi2*(1 - Bi1*log(a/b))));
//	A1 := 0.5/((1 - (a/b)^2*(1 - Bi1)/(1 + Bi1)) + Bi2*(1 + (a/b)^2*(1 - Bi1)/(1 + Bi1)));
//	A2 := 2*(-1)/(pi*(1-4)*((2*(1 - (a/b)^4*(2 - Bi1)/(2 + Bi1))) + Bi2*(1 + (a/b)^4*(2 - Bi1)/(2 + Bi1))));
//	B0 := A0*Bi1/(1 - Bi1*log(a/b));
//	B1 := A1*(a/b)^2*(1 - Bi1)/(1 + Bi1);
//	B2 := A2*(a/b)^4*(2 - Bi1)/(2 + Bi1);
//	Tin := Tf + ab*Q_rcv*b/kt*(A0 + A1*(a/b) + A2*(a/b)^2 + B1*(b/a) + B2*(b/a));

//end Tinner;
//
