within SolarTherm.Media.Sodium.Sodium_utilities;
function cp_T "Specific heat capacity as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
algorithm
  //ref ANL/RE-95/2
  cp:=(+ 1.6582- 4.2395e-4*(T/2)+ 1.4847e-7*(T^2/2)-2992.6*T^(-2))*1000;
end cp_T;
