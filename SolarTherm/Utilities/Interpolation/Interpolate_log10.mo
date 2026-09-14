within SolarTherm.Utilities.Interpolation;

function Interpolate_log10 "Inputs: y1, y2, x where 0 <= x <= 1 and output y is calculated based on linear interpolation between log10(y1) and log10(y2)"
  input Real y1;
  input Real y2;
  input Real x;
  output Real y;
algorithm
  y := 10.0^((log10(y2)-log10(y1))*x + log10(y1));
end Interpolate_log10;