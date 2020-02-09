within SolarTherm.Media.Sodium.SodiumBoiler_utilities;
function kappa_s_T "Adiabatic compressibility of liquid sodium"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature";
	output Modelica.SIunits.Compressibility kappa_s "Adiabatic compressibility";
protected
	constant Modelica.SIunits.Compressibility kappa_sm = 1.717e-10 "Adiabatic compressibility at the melting point";
	constant Real b = 3.2682;
	constant Modelica.SIunits.Temperature T_m = 371 "Melting temperature";
	constant Modelica.SIunits.Temperature T_c = 2503.7 "Critical temperature";
	Real theta "Temperature ratio";
algorithm
	//Ref. ANL/RE-95/2, pp. 122
	theta := (T - T_m) /(T_c - T_m);
	kappa_s := kappa_sm * (1 + theta / b) / (1 - theta);
end kappa_s_T;