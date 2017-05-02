within SolarTherm.Media.Sodium.Sodium_utilities;
function lamda_T "Thermal conductivity as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.ThermalConductivity lamda "Thermal conductivity";
algorithm
  //ref ANL/RE-95/2
  lamda:=124.67-(0.11381*T)+(5.5226e-5*T^2)-(1.1842e-8*T^3);
end lamda_T;
