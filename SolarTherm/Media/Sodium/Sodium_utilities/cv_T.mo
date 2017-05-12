within SolarTherm.Media.Sodium.Sodium_utilities;
function cv_T "Specific heat capacity of liquid sodium at constant volume as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.SpecificHeatCapacity cv "Specific heat capacity";
algorithm
  //Ref. ANL/RE-95/2
  //Incompressible flow assumption for liquid sodium
  cv := cp_T(T);
end cv_T;
