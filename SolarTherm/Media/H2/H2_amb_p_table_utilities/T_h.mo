within SolarTherm.Media.H2.H2_amb_p_table_utilities;
function T_h "Temperature (K) of H2 at ambient pressure as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
	output Modelica.SIunits.Temperature T "Temperature (K)";
protected
    constant Modelica.SIunits.Temperature T_data[26] = {100.00, 150.00, 200.00, 250.00, 298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 700.00, 800.00, 900.00, 1000.00, 1100.00, 1200.00, 1300.00, 1400.00, 1500.00, 1600.00, 1700.00, 1800.00, 1900.00, 2000.00};
	constant Modelica.SIunits.SpecificHeatCapacity h_data[26] = {-2550585.68, -2023505.58, -1375409.94, -683715.92, 74.04, 26544.03, 745267.70, 1467919.48, 2192409.14, 2917843.35, 3643958.20, 4370835.42, 5828081.07, 7292749.45, 8768432.89, 10258612.12, 11766013.68, 13292979.48, 14841021.20, 16410750.10, 18002203.80, 19615050.50, 21248721.09, 22902497.29, 24575571.84, 26267090.80};

algorithm
	T := Utilities.Interpolation.Interpolate1D(h_data,T_data,h);
end T_h;