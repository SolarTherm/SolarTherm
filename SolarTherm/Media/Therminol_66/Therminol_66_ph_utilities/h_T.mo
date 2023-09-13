within SolarTherm.Media.Therminol_66.Therminol_66_ph_utilities;
function h_T "Specific enthalpy (J/kg) of DownThermA saturated liquid as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
protected
    Real T_data[40] = {270.15, 273.15, 283.15, 293.15, 298.15, 303.15, 313.15, 323.15, 333.15, 343.15, 353.15, 363.15, 373.15, 383.15, 393.15, 403.15, 413.15, 423.15, 433.15, 443.15, 453.15, 463.15, 473.15, 483.15, 493.15, 503.15, 513.15, 523.15, 533.15, 543.15, 553.15, 563.15, 573.15, 583.15, 593.15, 603.15, 613.15, 623.15, 633.15, 643.15};
    Real h_data[40] = {-42500.00, -38500.00, -23300.00, -7900.00, 0.00, 7900.00, 24000.00, 40500.00, 57300.00, 74500.00, 92000.00, 109900.00, 128100.00, 146600.00, 165500.00, 184800.00, 204400.00, 224300.00, 244600.00, 265300.00, 286400.00, 307800.00, 329500.00, 351600.00, 374100.00, 397000.00, 420200.00, 443800.00, 467800.00, 492200.00, 516900.00, 542000.00, 567500.00, 593400.00, 619700.00, 646300.00, 673400.00, 700900.00, 728700.00, 757000.00};
algorithm
    h := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,h_data,T);
end h_T;
