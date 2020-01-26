within SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities;
function cp_T "Specific heat capacity of Chloride Salt as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
protected
	constant Real a = -0.52799;
	constant Real b = 1538.8204685;

algorithm
	cp := a * T + b;
end cp_T;
