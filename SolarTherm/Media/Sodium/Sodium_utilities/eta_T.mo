within SolarTherm.Media.Sodium.Sodium_utilities;
function eta_T "Dynamic viscosity as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
algorithm
  //ref ANL/RE-95/2
  eta:=exp(-6.4406-(0.3958*log(T))+(556.835/T));
end eta_T;
