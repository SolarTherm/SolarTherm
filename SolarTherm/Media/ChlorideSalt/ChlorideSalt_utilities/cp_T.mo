within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function cp_T "Specific heat capacity of liquid sodium at constant pressue as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
algorithm
	//From interpolation of NREL data
	cp :=-0.528*T+1538.7;
end cp_T;
