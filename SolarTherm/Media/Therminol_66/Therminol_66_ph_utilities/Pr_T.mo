within SolarTherm.Media.Therminol_66.Therminol_66_ph_utilities;
function Pr_T "Prandtl number of air at ambient pressure as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.ThermalDiffusivity Pr "Prandtl Number";
protected
    Real T_data[40] = {270.15, 273.15, 283.15, 293.15, 298.15, 303.15, 313.15, 323.15, 333.15, 343.15, 353.15, 363.15, 373.15, 383.15, 393.15, 403.15, 413.15, 423.15, 433.15, 443.15, 453.15, 463.15, 473.15, 483.15, 493.15, 503.15, 513.15, 523.15, 533.15, 543.15, 553.15, 563.15, 573.15, 583.15, 593.15, 603.15, 613.15, 623.15, 633.15, 643.15};
    Real Pr_data[40] = {25885.593, 16625.528, 4464.122, 1631.633, 1201.823, 759.044, 412.039, 251.212, 168.826, 121.040, 91.509, 71.779, 58.361, 48.408, 41.233, 35.700, 31.301, 27.800, 24.991, 22.772, 20.924, 19.268, 17.835, 16.714, 15.732, 14.818, 14.086, 13.441, 12.892, 12.350, 11.911, 11.541, 11.220, 10.938, 10.686, 10.481, 10.272, 10.116, 10.006, 9.891};
algorithm
    Pr := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,Pr_data,T);
end Pr_T;
