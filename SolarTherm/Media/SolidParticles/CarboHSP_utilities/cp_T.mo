within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function cp_T "Specific heat capacity of solid CarboHSP 40/70 particle as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
protected
	constant Real a = 148.2;
	constant Real b = 0.3093;

algorithm
	cp := a * (T ^ b);
end cp_T;
