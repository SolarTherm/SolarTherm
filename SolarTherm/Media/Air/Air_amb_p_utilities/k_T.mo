within SolarTherm.Media.Air.Air_amb_p_utilities;
function k_T "Thermal conductivity (W/mK) of air at ambient pressue as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.ThermalConductivity k "Thermal Conductivity (W/mK)";
protected
    Real T_data[35] = {100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000};
    Real k_data[35] = {0.00934,0.0138,0.0181,0.0223,0.0263,0.03,0.0338,0.0373,0.0407,0.0439,0.0469,0.0497,0.0524,0.0549,0.0573,0.0596,0.062,0.0643,0.0667,0.0715,0.0763,0.082,0.091,0.1,0.106,0.113,0.12,0.128,0.137,0.147,0.16,0.175,0.196,0.222,0.486};
algorithm
    k := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,k_data,T);
end k_T;