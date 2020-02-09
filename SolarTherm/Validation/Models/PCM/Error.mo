within SolarTherm.Validation.Models.PCM;

function Error "input lambda, Stefan numbers and diffusivity ratios, outputs absolute error of lambda"
  input Real lamb;
  input Real St_s;
  input Real St_l;
  input Real v;
  output Real error;
protected 
  Real pi;
algorithm
  pi := 2*Modelica.Math.asin(1.0);
  error := abs((St_l/(exp(lamb*lamb)*erf(lamb)))-(St_s/(v*exp(v*v*lamb*lamb)*erfc(v*lamb)))-(lamb*sqrt(pi)));
end Error;