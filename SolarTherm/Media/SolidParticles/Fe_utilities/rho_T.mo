within SolarTherm.Media.SolidParticles.Fe_utilities;
function rho_T "Density of Fe as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.Density rho "Density (kg/m3)";
protected
	constant Modelica.SIunits.Temperature T_data[32] = {130.00, 140.00, 150.00, 200.00, 250.00, 293.15, 300.00, 400.00, 500.00, 600.00, 700.00, 800.00, 900.00, 1000.00, 1010.00, 1020.00, 1030.00, 1040.00, 1041.00, 1042.00, 1042.70, 1043.00, 1044.00, 1045.00, 1046.00, 1047.00, 1048.00, 1049.00, 1050.00, 1100.00, 1150.00, 1180.00};
	constant Modelica.SIunits.Density rho_data[32] = {7913.00, 7912.00, 7910.00, 7899.00, 7887.00, 7875.00, 7873.00, 7844.00, 7812.00, 7777.00, 7741.00, 7703.00, 7665.00, 7628.00, 7625.00, 7622.00, 7619.00, 7615.00, 7615.00, 7615.00, 7615.00, 7615.00, 7614.00, 7614.00, 7614.00, 7613.00, 7613.00, 7613.00, 7612.00, 7596.00, 7579.00, 7568.00};
algorithm
	rho := Utilities.Interpolation.Interpolate1D(T_data,rho_data,T);
end rho_T;