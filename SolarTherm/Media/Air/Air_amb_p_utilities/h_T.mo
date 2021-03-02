within SolarTherm.Media.Air.Air_amb_p_utilities;
function h_T "Specific enthalpy (J/kg) of air at ambient pressue as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
protected
    Real T_data[35] = {100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000};
    Real h_data[35] = {0,51100,101575,151900,202225,252625,303200,354075,405350,457100,509375,562225,615675,669725,724375,779600,835375,891675,962737.5,1063475,1180175,1298375,1418175,1540025,1663925,1789675,1917325,2046975,2179175,2314625,2454075,2598825,2750625,3078275,4009525};
algorithm
    h := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,h_data,T);
end h_T;