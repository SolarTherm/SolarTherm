within SolarTherm.Media.Sodium.Sodium_utilities;
function s_T "Specific entropy as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.SpecificEntropy s "Specific heat capacity";
algorithm
  s:=0;
end s_T;
