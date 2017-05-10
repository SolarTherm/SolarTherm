within SolarTherm.Media.Sodium.Sodium_utilities;
function T_s "Temperature of liquid sodium as a function of Specific entropy"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.SpecificEntropy s "Specific entropy";
  output Modelica.SIunits.Temperature T "Temperature";
protected
  constant Real p1 = -4.737977188981058;
  constant Real p2 = 68.885740341495477;
  constant Real p3 = -4.089850875787481e+02;
  constant Real p4 = 1.280584884950551e+03;
  constant Real p5 = -2.319520741345022e+03;
  constant Real p6 = 2.557699525690630e+03;
  constant Real p7 = -1.531953413251885e+03;
  constant Real p8 = 7.574745864602652e+02;
  constant Real p9 = 2.234138410166426e+02;
algorithm
  T := p1 * (s / 1000) ^ 8 + p2 * (s / 1000) ^ 7 + p3 * (s / 1000) ^ 6 + p4 * (s / 1000) ^ 5 + p5 * (s / 1000) ^ 4 + p6 * (s / 1000) ^ 3 + p7 * (s / 1000) ^ 2 + p8 * (s / 1000) + p9;
end T_s;
