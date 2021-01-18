within SolarTherm.Models.CSP.CRS.Receivers.Panel;
function gp
  input Real r;
  input Real n;
  input Real a;
  input Real Bi;
  output Real y;
algorithm
y := n*(r^(n-1) - a^(2*n)*(n - Bi)/(n + Bi)*r^(-n-1));
end gp;