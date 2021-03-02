within SolarTherm.Media.Air.Air_amb_p_utilities;
function mu_T "Dynamic viscosity (Ns/m2) of air at ambient pressue as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.DynamicViscosity mu "Dynamic Viscosity (Ns/m2)";
protected
    Real T_data[35] = {100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000};
    Real mu_data[35] = {0.00000711,0.00001034,0.00001325,0.00001596,0.00001846,0.00002082,0.00002301,0.00002507,0.00002701,0.00002884,0.00003058,0.00003225,0.00003388,0.00003546,0.00003698,0.00003843,0.00003981,0.00004113,0.00004244,0.0000449,0.0000473,0.0000496,0.000053,0.0000557,0.0000584,0.0000611,0.0000637,0.0000663,0.0000689,0.0000715,0.000074,0.0000766,0.0000792,0.0000818,0.0000955};
algorithm
    mu := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,mu_data,T);
end mu_T;