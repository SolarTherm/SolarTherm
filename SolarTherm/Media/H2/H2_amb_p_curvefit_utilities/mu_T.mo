within SolarTherm.Media.H2.H2_amb_p_curvefit_utilities;
function mu_T "Dynamic viscosity (Ns/m2) of H2 at ambient pressure as a function of temperature"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.DynamicViscosity mu "Dynamic Viscosity (Ns/m2)";
algorithm
    mu := (1.735E-15)*T*T*T - (8.308E-12)*T*T + (2.458E-08)*T + 2.132E-6; //R^2=0.99986 between 100 and 1300K 
end mu_T;
