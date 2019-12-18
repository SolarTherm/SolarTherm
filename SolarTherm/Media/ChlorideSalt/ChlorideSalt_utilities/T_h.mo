within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function T_h "Temperature of Chloride Salt as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	output Modelica.SIunits.Temperature T "Temperature";
	
	protected
	parameter Real c1 = -0.2640;
	parameter Real c2 = 1538.7;
	parameter Real c3 = 298.15;
	parameter Real c4 = 435295.541460;
    
algorithm
	//From h_T
  //	T:=(-1538.7+(1538.7^2+2*0.528*(-435295.54146-h))^0.5)/(-0.528);
    T:=(-c2+(c2^2+4*c1*(h+c4))^0.5)/(2*c1);
end T_h;
