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
  T:=(-c2+(c2^2+4*c1*(h+c4))^0.5)/(2*c1);
  //T:=0.000932235142787*h + 215.167775245555; //This is just the linearization of the previous function. Error <0.5%
  
end T_h;
