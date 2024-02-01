within SolarTherm.Media.H2.H2_amb_p_table_utilities;

function k_T "Thermal conductivity (W/mK) of H2 at ambient pressure as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature (K)";
  output Modelica.SIunits.ThermalConductivity k "Thermal Conductivity (W/mK)";
protected
	constant Modelica.SIunits.Temperature T_data[26] = {100.00, 150.00, 200.00, 250.00, 298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 700.00, 800.00, 900.00, 1000.00, 1100.00, 1200.00, 1300.00, 1400.00, 1500.00, 1600.00, 1700.00, 1800.00, 1900.00, 2000.00};
	constant Modelica.SIunits.SpecificHeatCapacity k_data[26] = {0.0670, 0.1010, 0.1310, 0.1570, 0.1820, 0.1830, 0.2040, 0.2260, 0.2470, 0.2660, 0.2850, 0.3050, 0.3420, 0.3780, 0.4120, 0.4480, 0.4880, 0.5280, 0.5680, 0.6100, 0.6550, 0.6970, 0.7420, 0.7860, 0.8350, 0.8780};
	
algorithm
	k := Utilities.Interpolation.Interpolate1D(T_data,k_data,T);
end k_T;