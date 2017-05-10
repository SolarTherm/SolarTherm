within SolarTherm.Media.Sodium.Sodium_utilities;
function s_rho "Specific entropy of liquid sodium as a function of density"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Density rho "Density";
  output Modelica.SIunits.SpecificEntropy s "Specific entropy";
protected
  constant Real p1 = -0.002225092601524;
  constant Real p2 = -0.013184548402316;
  constant Real p3 = -0.026922540456200;
  constant Real p4 = -0.041175360948712;
  constant Real p5 = -0.045069181456097;
  constant Real p6 = -0.136838776718132;
  constant Real p7 = -0.672290225395830;
  constant Real p8 = 2.215825188281317;
  
  constant Real rho_mean = 625.9;
  constant Real rho_std = 208.2;
  Real x;
algorithm 
  // 400K to 2500K liquid on saturation curve:
  x := (rho - rho_mean) / rho_std; //rho_norm
  s := 1000 * (p1 * x ^ 7 + p2 * x ^ 6 + p3 * x ^ 5 + p4 * x ^ 4 + p5 * x ^ 3 + p6 * x ^ 2 + p7 * x + p8);
end s_rho;









  


