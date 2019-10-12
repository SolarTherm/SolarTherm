within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function eta_T "Dynamic viscosity of liquid sodium as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
algorithm
	//From interpolation of NREL data
	eta := 1.685018802997650*(10^(-13))*(T^4) - 6.577418711267250*((10)^(-10))*(T^3)+ 9.763523744306470*((10)^(-7))*(T^2) - 6.590412997491650*((10)^(-4))*T + 0.174497322937481;
end eta_T;
