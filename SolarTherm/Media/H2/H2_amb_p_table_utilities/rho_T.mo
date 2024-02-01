within SolarTherm.Media.H2.H2_amb_p_table_utilities;
function rho_T "Density (kg/m3) of H2 at ambient pressure as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.Density rho "Density (kg/m3)";
protected
	constant Modelica.SIunits.Temperature T_data[26] = {100.00, 150.00, 200.00, 250.00, 298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 700.00, 800.00, 900.00, 1000.00, 1100.00, 1200.00, 1300.00, 1400.00, 1500.00, 1600.00, 1700.00, 1800.00, 1900.00, 2000.00};
	constant Modelica.SIunits.SpecificHeatCapacity rho_data[26] = {0.24255, 0.16156, 0.12115, 0.09693, 0.08138, 0.08078, 0.06924, 0.06059, 0.05386, 0.04848, 0.04407, 0.04040, 0.03463, 0.03030, 0.02694, 0.02424, 0.02204, 0.02020, 0.01865, 0.01732, 0.01616, 0.01520, 0.01430, 0.01350, 0.01280, 0.01210};

algorithm
	rho := Utilities.Interpolation.Interpolate1D(T_data,rho_data,T);
end rho_T;