within SolarTherm.Models.CSP.CRS.Receivers.Panel;
function Stress
	extends Modelica.Icons.Function;
	import SI = Modelica.SIunits;
	import Modelica.Constants.*;
	import Modelica.Math.*;
	input Modelica.SIunits.Temperature Tf "Fluid temperature";
	input Modelica.SIunits.HeatFlux Q_rcv "Heat flux over the receiver element surface";
	input Modelica.SIunits.Efficiency Bi1 "Inner Biot number";
	input Modelica.SIunits.Efficiency Bi2 "Outer Biot number";
	input Modelica.SIunits.Efficiency ab "Receiver absorptance";
	input Modelica.SIunits.Length a "Inner radius";
	input Modelica.SIunits.Length b "Outer radius";
	input Modelica.SIunits.ThermalConductivity kt "Pipe thermal conductivity";
	input SI.LinearExpansionCoefficient lambda "Coefficient of linear thermal expansion receiver tube material";
	input SI.Stress E "Young's Modulus receiver tube material";
	input SI.Efficiency poisson "Poisson ratio of receiver tube material";
	input Modelica.SIunits.HeatFlowRate Q_htf "Heat absorbed by the heat transfer fluid";
	input SI.Length dz "Element length";
	
	output Modelica.SIunits.Stress sigma_eq "Von-Mises Stress";

protected
	SI.Efficiency A1;
	SI.Efficiency A2;
	SI.Efficiency B1;
	SI.Efficiency B2;
	SI.Efficiency T_theta;
	Real K2(unit = "K/m");
	Real K1(unit = "K/m");	
	Modelica.SIunits.TemperatureDifference DT;
	Modelica.SIunits.Stress sigma_theta "Von-Mises Stress";
	Modelica.SIunits.Stress sigma_z "Von-Mises Stress";
algorithm
	A1 := 0.5/((1 - (a/b)^2*(1 - Bi1)/(1 + Bi1)) + Bi2*(1 + (a/b)^2*(1 - Bi1)/(1 + Bi1)));
	A2 := 2*(-1)/(pi*(1-4)*((2*(1 - (a/b)^4*(2 - Bi1)/(2 + Bi1))) + Bi2*(1 + (a/b)^4*(2 - Bi1)/(2 + Bi1))));
	B1 := A1*(a/b)^2*(1 - Bi1)/(1 + Bi1);
	B2 := A2*(a/b)^4*(2 - Bi1)/(2 + Bi1);
	DT := Q_htf*log(b/a)/(pi*kt*dz);
	K1 := DT/log(b/a);
	K2 := (B1*ab*Q_rcv*b^2/kt)*b/(a^2 + b^2);	
	T_theta := A1 + B1 + A2 + B2;
	sigma_theta := lambda*E/(2*(1-poisson))*(K1*(1 - 2*a^2/(b^2 - a^2)*log(b/a)) + K2*(2 - 2*a^2/b^2));
	sigma_z := poisson*(sigma_theta) + lambda*E*T_theta*ab*Q_rcv*b/kt;
	sigma_eq := (((sigma_theta - sigma_z)^2 + (sigma_theta)^2 + (sigma_z)^2)/2)^0.5;
end Stress;
