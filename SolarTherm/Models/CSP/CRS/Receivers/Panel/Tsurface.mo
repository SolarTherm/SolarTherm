within SolarTherm.Models.CSP.CRS.Receivers.Panel;
function Tsurface
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
	input Modelica.SIunits.Efficiency Ta "Receiver absorptance";
	output Modelica.SIunits.Temperature Ts "Pipe crown temperature";
	
protected
	SI.Efficiency A0;
	SI.Efficiency A1;
	SI.Efficiency A2;
	SI.Efficiency B1;
	SI.Efficiency B2;
algorithm
	A0 := (1 + pi*Bi2*Ta)*(1 - Bi1*log(a/b))/(pi*(Bi1 + Bi2*(1 - Bi1*log(a/b))));
	A1 := 0.5/((1 - (a/b)^2*(1 - Bi1)/(1 + Bi1)) + Bi2*(1 + (a/b)^2*(1 - Bi1)/(1 + Bi1)));
	A2 := 2*(-1)/(pi*(1-4)*((2*(1 - (a/b)^4*(2 - Bi1)/(2 + Bi1))) + Bi2*(1 + (a/b)^4*(2 - Bi1)/(2 + Bi1))));
	B1 := A1*(a/b)^2*(1 - Bi1)/(1 + Bi1);
	B2 := A2*(a/b)^4*(2 - Bi1)/(2 + Bi1);
	Ts := Tf + ab*Q_rcv*b/kt*(A0 + A1 + A2 + B1 + B2);
end Tsurface;
