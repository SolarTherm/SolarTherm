within SolarTherm.Media.Air.Air_amb_p_utilities;
function rho_T "Thermal conductivity (W/mK) of air at ambient pressue as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.Density rho "Density (kg/m3)";
protected
    Real T_data[35] = {100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000};
    Real rho_data[35] = {3.5562,2.3364,1.7458,1.3947,1.1614,0.995,0.8711,0.774,0.6964,0.6329,0.5804,0.5356,0.4975,0.4643,0.4354,0.4097,0.3868,0.3666,0.3482,0.3166,0.2902,0.2679,0.2488,0.2322,0.2177,0.2049,0.1935,0.1833,0.1741,0.1658,0.1582,0.1513,0.1448,0.1389,0.1135};
algorithm
    rho := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,rho_data,T);
end rho_T;