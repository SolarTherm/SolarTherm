within SolarTherm.Materials.Examples.Gan_Checker3_Constant;

function k_Tf "find thermal conductivity from temperature"
  input SI.Temperature T;
  input Real f;
  output SI.ThermalConductivity k;
algorithm
  k := 3.1631;
end k_Tf;