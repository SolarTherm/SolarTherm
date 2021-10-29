within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function eta_T "Dynamic viscosity of liquid sodium as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
protected
	parameter Real a = 3.12354312353038e-14;
	parameter Real b = -1.281501061896e-10;
	parameter Real c = 2.01613494565798e-7;
	parameter Real d = -0.0001466121;
	parameter Real e = 0.044260166;
algorithm
	//From interpolation of NREL data
	eta := a*T^4 + b*T^3 + c*T^2 + d*T + e;
end eta_T;
