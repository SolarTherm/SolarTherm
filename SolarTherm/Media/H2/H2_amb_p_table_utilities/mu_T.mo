within SolarTherm.Media.H2.H2_amb_p_table_utilities;

function mu_T "Dynamic viscosity (Ns/m2) of H2 at ambient pressure as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature (K)";
  output Modelica.SIunits.DynamicViscosity mu "Dynamic Viscosity (Ns/m2)";
protected
	constant Modelica.SIunits.Temperature T_data[26] = {100.00, 150.00, 200.00, 250.00, 298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 700.00, 800.00, 900.00, 1000.00, 1100.00, 1200.00, 1300.00, 1400.00, 1500.00, 1600.00, 1700.00, 1800.00, 1900.00, 2000.00};
	constant Modelica.SIunits.SpecificHeatCapacity mu_data[26] = {0.00000421, 0.00000560, 0.00000681, 0.00000789, 0.00000892, 0.00000896, 0.00000988, 0.00001082, 0.00001172, 0.00001264, 0.00001343, 0.00001424, 0.00001578, 0.00001724, 0.00001865, 0.00002013, 0.00002130, 0.00002262, 0.00002385, 0.00002507, 0.00002627, 0.00002737, 0.00002849, 0.00002961, 0.00003072, 0.00003182};

algorithm
	mu := Utilities.Interpolation.Interpolate1D(T_data,mu_data,T);

end mu_T;