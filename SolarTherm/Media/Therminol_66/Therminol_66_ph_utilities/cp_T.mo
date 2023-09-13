within SolarTherm.Media.Therminol_66.Therminol_66_ph_utilities;
function cp_T "Specific heat capacity (J/kgK) of DowthermA saturated liquid as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity (J/kgK)";
protected
    Real T_data[40] = {270.15, 273.15, 283.15, 293.15, 298.15, 303.15, 313.15, 323.15, 333.15, 343.15, 353.15, 363.15, 373.15, 383.15, 393.15, 403.15, 413.15, 423.15, 433.15, 443.15, 453.15, 463.15, 473.15, 483.15, 493.15, 503.15, 513.15, 523.15, 533.15, 543.15, 553.15, 563.15, 573.15, 583.15, 593.15, 603.15, 613.15, 623.15, 633.15, 643.15};
    Real cp_data[40] = {1490.0, 1490.0, 1530.0, 1560.0, 1580.0, 1600.0, 1630.0, 1660.0, 1700.0, 1730.0, 1770.0, 1800.0, 1840.0, 1870.0, 1910.0, 1940.0, 1980.0, 2010.0, 2050.0, 2090.0, 2120.0, 2160.0, 2190.0, 2230.0, 2270.0, 2300.0, 2340.0, 2380.0, 2420.0, 2450.0, 2490.0, 2530.0, 2570.0, 2610.0, 2650.0, 2690.0, 2730.0, 2770.0, 2810.0, 2850.0};
algorithm
    cp := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,cp_data,T);
end cp_T;
