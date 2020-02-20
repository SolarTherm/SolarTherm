within SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities;
function eta_T "Dynamic viscosity of liquid sodium as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
algorithm
	//From interpolation of NREL data
	eta := 1.685018802997650e-13*T^4 - 6.577418711267250e-10*T^3+ 9.763523744306470e-7*T^2 - 6.590412997491650e-4*T + 0.174497322937481;
end eta_T;

