within SolarTherm.Media.Sodium.Sodium_utilities;
function lamda_v_T "Thermal conductivity of vapour sodium as a function of temperature"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.ThermalConductivity lambda_g "Thermal conductivity";
protected
  constant Real p1 = -1.260801088007033e-04;
  constant Real p2 = 2.265624999999752e-04;
  constant Real p3 = 1.069770620126767e-04;
  constant Real p4 = -4.671474358973460e-04;
  constant Real p5 = 0.001173894960486;
  constant Real p6 = -0.002735622571873;
  constant Real p7 = 0.009016230552265;
  constant Real p8 = 0.049212509712510;
  
  constant Real T_mean = 1100;
  constant Real T_std = 273.9;
  Real x;
  
algorithm
  //Ref: https://www.thermalfluidscentral.org/encyclopedia/index.php/Thermophysical_Properties:_Sodium
  // Valid from 700K to 1500K
  x := (T - T_mean) / T_std; //T_norm
  lambda_g := p1 * x ^ 7 + p2 * x ^ 6 + p3 * x ^ 5 + p4 * x ^ 4 + p5 * x ^ 3 + p6 * x ^ 2 + p7 * x + p8;
end lamda_v_T;



