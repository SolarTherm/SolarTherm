within SolarTherm.Materials.Examples.Gan_Checker3_Constant;

function h_Tf "find specific enthalpy from Temperature"
  input SI.Temperature T "Absolute temperature (K)";
  input Real f "Liquid mass fraction";
  output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
algorithm
  h := 1221.31 * (T - 298.15);
end h_Tf;