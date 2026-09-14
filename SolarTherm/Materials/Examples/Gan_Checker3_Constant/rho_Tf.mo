within SolarTherm.Materials.Examples.Gan_Checker3_Constant;

function rho_Tf "find density from temperature"
  input SI.Temperature T "Absolute temperature (K)";
  input Real f "Liquid mass fraction";
  output SI.Density rho "Density (kg/m3)";
algorithm
  rho := 2560.0;
end rho_Tf;