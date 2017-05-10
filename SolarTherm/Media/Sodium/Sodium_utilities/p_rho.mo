within SolarTherm.Media.Sodium.Sodium_utilities;
function p_rho "Saturated vapour pressur of sodium as a function of density"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Density rho "Density";
  output Modelica.Media.Interfaces.Types.AbsolutePressure p "Pressure";
protected
  constant Real p1 = -0.022364729827730;
  constant Real p2 = -0.019083550459660;
  constant Real p3 = 0.276227267126739;
  constant Real p4 = 0.451030820437898;
  constant Real p5 = -1.762622925642699;
  constant Real p6 = -1.416551974201683;
  constant Real p7 = 6.996296205930227;
  constant Real p8 = -6.327749082136161;
  constant Real p9 = 1.833441651580609;
  
  constant Real rho_mean = 625.9;
  constant Real rho_std = 208.2;
  Real x;
algorithm
  //Bases on data in Ref. ANL/RE-95/2
  // Valid for rho from 219 [kg/m3] to 732 [kg/m3] (T:1200K to 2503.7)
  x := (rho - rho_mean) / rho_std; //rho_norm;
  p := 1e6 * (p1 * x ^ 8 + p2 * x ^ 7 + p3 * x ^ 6 + p4 * x ^ 5 + p5 * x ^ 4 + p6 * x ^ 3 + p7 * x ^ 2 + p8 * x + p9);
end p_rho;


