within SolarTherm.Models.CSP.CRS.Receivers.Panel;
function g
  input Real r;
  input Real n;
  input Real a;
  input Real Bi;
  output Real y;
algorithm
y := r^n + a^(2*n)*(n - Bi)/(n + Bi)*r^(-n);
end g;