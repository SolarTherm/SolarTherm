within SolarTherm.Media.Sodium.Sodium_utilities;
function h_s "Specific enthalpy of liquid sodium as a function of Specific entropy"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.SpecificEntropy s "Specific entropy";
  output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
protected
  constant Real p1 = 88.104318809257066;
  constant Real p2 = -24.209744356889288;
  constant Real p3 = 4.043724883367241e+02;
  constant Real p4 = -29.809188756415743;
algorithm
  // 400K to 2500K liquid on saturation curve:
  h := 1000 * (p1 * (s / 1000) ^ 3 + p2 * (s / 1000) ^ 2 + p3 * (s / 1000) + p4);
end h_s;
