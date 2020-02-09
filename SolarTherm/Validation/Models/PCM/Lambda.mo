within SolarTherm.Validation.Models.PCM;
function Lambda "input Stefan numbers and diffusivity ratios, outputs lambda correct to 1.0e9"
  input Real St_s;
  input Real St_l;
  input Real v;
  output Real lamb;
protected
  Real x0;
  Real slope;
  Real error;
  Real delx;
  Real i;
  Real pi;
algorithm
  pi := 2*Modelica.Math.asin(1.0);
  x0 := (0.5*(-1.0*St_s)/(v*sqrt(pi)))+sqrt(2.0*St_l+(St_s/(v*sqrt(pi)))^2);
  //lamb := 1.6;
  error := Error(x0,St_s,St_l,v);
  i := 0;
  while error > 1.0e-9 and i < 50 loop
    slope := (Error(x0+1.0e-12,St_s,St_l,v)-Error(x0-1.0e-12,St_s,St_l,v))/2.0e-12;
    delx := -1.0*Error(x0,St_s,St_l,v)/slope;
    x0 := x0 + delx;
    error := Error(x0,St_s,St_l,v);
    i := i+1;
  end while;
  lamb := x0;
end Lambda;