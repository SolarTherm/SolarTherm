within SolarTherm.Materials.Examples.Gan_Checker3_Constant;

function Tf_h "Find temperature and liquid fraction from temperature"
  input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  output SI.Temperature T "Absoulte temperature (K)";
  output Real f "mass liquid fraction";
algorithm
  T := 298.15 + h / 1221.31;
  f := 0.0;
end Tf_h;