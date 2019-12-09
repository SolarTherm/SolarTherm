within SolarTherm.Media.ChlorideSalt.ChlorideSalt_utilities;
function lamda_T "Thermal conductivity of Chloride Salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.ThermalConductivity lambda "Thermal conductivity";
algorithm
	//From interpolation of NREL data
	lambda :=-0.0001*T+0.5355;
end lamda_T;
