within SolarTherm.Media.H2.H2_amb_p_table_utilities;
function cp_T "Specific heat capacity (J/kgK) of H2 at ambient pressure as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity (J/kgK)";
protected
	constant Modelica.SIunits.Temperature T_data[26] = {100.00, 150.00, 200.00, 250.00, 298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 700.00, 800.00, 900.00, 1000.00, 1100.00, 1200.00, 1300.00, 1400.00, 1500.00, 1600.00, 1700.00, 1800.00, 1900.00, 2000.00};
	constant Modelica.SIunits.SpecificHeatCapacity cp_data[26] = {11230.00, 12600.00, 13540.00, 14060.00, 14300.75, 14310.00, 14430.00, 14480.00, 14500.00, 14520.00, 14530.00, 14550.00, 14610.00, 14700.00, 14830.00, 14990.00, 15170.00, 15370.00, 15590.00, 15810.00, 16020.00, 16280.00, 16580.00, 16960.00, 17490.00, 18250.00};

algorithm
	cp := Utilities.Interpolation.Interpolate1D(T_data,cp_data,T);
end cp_T;