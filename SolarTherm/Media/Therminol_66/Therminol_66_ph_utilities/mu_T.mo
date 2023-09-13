within SolarTherm.Media.Therminol_66.Therminol_66_ph_utilities;
function mu_T "Dynamic viscosity (Ns/m2) of DowthermA saturated liquid as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.DynamicViscosity mu "Dynamic Viscosity (Ns/m2)";
protected
    Real T_data[40] = {270.15, 273.15, 283.15, 293.15, 298.15, 303.15, 313.15, 323.15, 333.15, 343.15, 353.15, 363.15, 373.15, 383.15, 393.15, 403.15, 413.15, 423.15, 433.15, 443.15, 453.15, 463.15, 473.15, 483.15, 493.15, 503.15, 513.15, 523.15, 533.15, 543.15, 553.15, 563.15, 573.15, 583.15, 593.15, 603.15, 613.15, 623.15, 633.15, 643.15};
    Real mu_data[40] = {2.0500000, 1.3200000, 0.3440000, 0.1230000, 0.0893000, 0.0556000, 0.0295000, 0.0176000, 0.0115000, 0.0080600, 0.0059300, 0.0045500, 0.0036000, 0.0029200, 0.0024200, 0.0020500, 0.0017500, 0.0015200, 0.0013300, 0.0011800, 0.0010600, 0.0009500, 0.0008600, 0.0007840, 0.0007180, 0.0006610, 0.0006110, 0.0005670, 0.0005290, 0.0004950, 0.0004640, 0.0004370, 0.0004130, 0.0003910, 0.0003710, 0.0003530, 0.0003360, 0.0003210, 0.0003080, 0.0002950};
algorithm
    mu := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,mu_data,T);
end mu_T;
