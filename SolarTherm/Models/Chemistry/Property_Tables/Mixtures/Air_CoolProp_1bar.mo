within SolarTherm.Models.Chemistry.Property_Tables.Mixtures;

record Air_CoolProp_1bar "78mol% N2, 21mol% O2, 1mol% Ar"
  constant Modelica.SIunits.Temperature T_table[16] = {298.15, 300.00, 400.00, 500.00, 600.00, 700.00, 800.00, 900.00, 1000.00, 1100.00, 1200.00, 1300.00, 1400.00, 1500.00, 1600.00, 1700.00} "Absolute temperature (K)";
  
  constant Modelica.SIunits.SpecificEnthalpy h_table[16] = {298266.93, 300127.95, 401045.95, 503148.93, 607130.53, 713390.74, 822039.63, 932991.58, 1046059.73, 1161021.03, 1277653.20, 1395752.52, 1515140.51, 1635664.50, 1757195.57, 1879625.36} "Specific enthalpy (J/kg)";
  
  constant Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp_table[16] = {1005.93, 1005.99, 1013.76, 1029.49, 1050.81, 1074.56, 1098.26, 1120.46, 1140.53, 1158.33, 1173.98, 1187.71, 1199.79, 1210.47, 1219.97, 1228.48} "Specific heat capacity at constant pressure (J/kgK)";
  
  constant Modelica.SIunits.Density rho_table[16] = {1.1690, 1.1617, 0.8709, 0.6966, 0.5805, 0.4976, 0.4354, 0.3870, 0.3483, 0.3167, 0.2903, 0.2679, 0.2488, 0.2322, 0.2177, 0.2049} "Density (kg/m3)";
  
  constant Modelica.SIunits.ThermalConductivity k_table[16] = {0.02586, 0.02600, 0.03296, 0.03934, 0.04529, 0.05091, 0.05628, 0.06144, 0.06644, 0.07131, 0.07607, 0.08073, 0.08532, 0.08984, 0.09431, 0.09873} "Thermal conductivity (W/mK)";
  
  constant Modelica.SIunits.DynamicViscosity mu_table[16] = {0.00001839, 0.00001848, 0.00002298, 0.00002701, 0.00003068, 0.00003407, 0.00003726, 0.00004028, 0.00004316, 0.00004592, 0.00004859, 0.00005119, 0.00005371, 0.00005618, 0.00005860, 0.00006097} "Dynamic Viscosity (Pa.s)";
  
  constant Modelica.SIunits.SpecificEntropy s_table[16] = {6861.82, 6868.04, 7158.31, 7386.08, 7575.61, 7739.36, 7884.41, 8015.06, 8134.17, 8243.73, 8345.20, 8439.73, 8528.20, 8611.34, 8689.78, 8764.00} "Specific entropy (J/kgK)";
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end Air_CoolProp_1bar;