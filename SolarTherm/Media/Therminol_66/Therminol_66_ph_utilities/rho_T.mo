within SolarTherm.Media.Therminol_66.Therminol_66_ph_utilities;
function rho_T "Density (kg/m3) of DowthermA saturated liquid as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.Density rho "Density (kg/m3)";
protected
    Real T_data[40] = {270.15, 273.15, 283.15, 293.15, 298.15, 303.15, 313.15, 323.15, 333.15, 343.15, 353.15, 363.15, 373.15, 383.15, 393.15, 403.15, 413.15, 423.15, 433.15, 443.15, 453.15, 463.15, 473.15, 483.15, 493.15, 503.15, 513.15, 523.15, 533.15, 543.15, 553.15, 563.15, 573.15, 583.15, 593.15, 603.15, 613.15, 623.15, 633.15, 643.15};
    Real rho_data[40] = {1023.0, 1021.0, 1015.0, 1008.0, 1005.0, 1002.0, 995.0, 989.0, 982.0, 975.0, 969.0, 962.0, 955.0, 948.0, 941.0, 934.0, 928.0, 921.0, 914.0, 907.0, 899.0, 892.0, 885.0, 878.0, 870.0, 863.0, 856.0, 848.0, 840.0, 832.0, 825.0, 817.0, 809.0, 800.0, 792.0, 783.0, 775.0, 766.0, 757.0, 748.0};
algorithm
    rho := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,rho_data,T);
end rho_T;
