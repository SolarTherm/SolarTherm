within SolarTherm.Media.Sodium.Sodium_utilities;
function kappa_T "Isothermal compressibility of lquid sodium"
	import SolarTherm.Media.Sodium.Sodium_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.IsothermalCompressibility kappa_ist "Isothermal compressibility";
algorithm
	//Ref. ANL/RE-95/2, pp. 99
	kappa_ist := (kappa_s_T(T) * cs_T(T) + (T / rho_T(T)) * beta_T(T) * (beta_T(T) + kappa_s_T(T) * gamma_T(T))) / (cs_T(T) - (T / rho_T(T)) * gamma_T(T) * (beta_T(T) + kappa_s_T(T) * gamma_T(T)));
end kappa_T;
