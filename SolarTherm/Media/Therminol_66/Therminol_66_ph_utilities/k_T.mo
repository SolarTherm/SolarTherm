within SolarTherm.Media.Therminol_66.Therminol_66_ph_utilities;
function k_T "Thermal conductivity (W/mK) of DowthermA saturated liquid as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.ThermalConductivity k "Thermal Conductivity (W/mK)";
protected
    Real T_data[40] = {270.15, 273.15, 283.15, 293.15, 298.15, 303.15, 313.15, 323.15, 333.15, 343.15, 353.15, 363.15, 373.15, 383.15, 393.15, 403.15, 413.15, 423.15, 433.15, 443.15, 453.15, 463.15, 473.15, 483.15, 493.15, 503.15, 513.15, 523.15, 533.15, 543.15, 553.15, 563.15, 573.15, 583.15, 593.15, 603.15, 613.15, 623.15, 633.15, 643.15};
    Real k_data[40] = {0.1180, 0.1183, 0.1179, 0.1176, 0.1174, 0.1172, 0.1167, 0.1163, 0.1158, 0.1152, 0.1147, 0.1141, 0.1135, 0.1128, 0.1121, 0.1114, 0.1107, 0.1099, 0.1091, 0.1083, 0.1074, 0.1065, 0.1056, 0.1046, 0.1036, 0.1026, 0.1015, 0.1004, 0.0993, 0.0982, 0.0970, 0.0958, 0.0946, 0.0933, 0.0920, 0.0906, 0.0893, 0.0879, 0.0865, 0.0850};
algorithm
    k := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,k_data,T);
end k_T;
