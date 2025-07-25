within SolarTherm.Materials.Examples.Gan_Checker3_Constant;

model State "A model which calculates state and properties"
  SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
  SI.Temperature T "Temperature (K)";
  Real f "Liquid Mass Fraction";
  SI.Density rho "Density (kg/m3)";
  SI.ThermalConductivity k "Thermal conductivity (W/mK)";
equation
  (T, f) = Tf_h(h);
  rho = rho_Tf(T, 0.0);
  k = k_Tf(T, 0.0);
end State;