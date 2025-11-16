within SolarTherm.Materials;

package HighSilica_26pct_porosity_50K_intervals
  //Mullite properties 298.15 < T (K) < 1700. Stoichiometry of 3Al2O3.2SiO2 ~72wt% is assumed which is typical of sintered mullite. Unit costs have been indexed to year 2022.
  extends SolarTherm.Materials.PartialMaterial(MM = 426.0524e-3, T_melt = 1840.0 + 273.15, cost = 0.56446);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  redeclare model State "A model which calculates state and properties"
    SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
    SI.Temperature T "Temperature (K)";
    Real f "Liquid Mass Fraction";
    SI.Density rho "Density (kg/m3)";
    SI.ThermalConductivity k "Thermal conductivity (W/mK)";
  equation
    f = 0.0;
    h = h_Tf(T, 0);
    rho = rho_Tf(T, 0);
    k = k_Tf(T, 0);
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  protected
    Real T_data[30] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 650.00, 700.00, 750.00, 800.00, 850.00, 900.00, 950.00, 1000.00, 1050.00, 1100.00, 1150.00, 1200.00, 1250.00, 1300.00, 1350.00, 1400.00, 1450.00, 1500.00, 1550.00, 1600.00, 1650.00, 1700.00};
    Real h_data[30] = {-50.96809603, 1324.706731, 40593.30836, 83454.9174, 129348.8154, 177818.8132, 228513.5569, 281186.6809, 335696.8903, 392008.0078, 450189.0021, 510414.0054, 584639.3281, 640974.7547, 697727.6612, 754898.2319, 812486.5828, 870492.781, 928916.8588, 987758.8241, 1047018.668, 1106696.373, 1166791.913, 1227305.264, 1288236.402, 1349585.305, 1411351.959, 1473536.356, 1536138.498, 1599158.395};
  algorithm
    h := Modelica.Math.Vectors.interpolate(T_data, h_data, T);
  end h_Tf;

  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 1715.10;
  end rho_Tf;

  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  protected
    Real T_data[30] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 650.00, 700.00, 750.00, 800.00, 850.00, 900.00, 950.00, 1000.00, 1050.00, 1100.00, 1150.00, 1200.00, 1250.00, 1300.00, 1350.00, 1400.00, 1450.00, 1500.00, 1550.00, 1600.00, 1650.00, 1700.00};
    Real k_data[30] = {1.2227, 1.2239, 1.2570, 1.2886, 1.3189, 1.3483, 1.3770, 1.4054, 1.4338, 1.4624, 1.4916, 1.5217, 1.5529, 1.5855, 1.6200, 1.6565, 1.6953, 1.7368, 1.7813, 1.8291, 1.8804, 1.9355, 1.9948, 2.0586, 2.1272, 2.2008, 2.2797, 2.3644, 2.4550, 2.5518};
  algorithm
    k := Modelica.Math.Vectors.interpolate(T_data, k_data, T);
  end k_Tf;

  function Tf_h "Find temperature and liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absoulte temperature (K)";
    output Real f "mass liquid fraction";
  protected
    Real T_data[30] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 650.00, 700.00, 750.00, 800.00, 850.00, 900.00, 950.00, 1000.00, 1050.00, 1100.00, 1150.00, 1200.00, 1250.00, 1300.00, 1350.00, 1400.00, 1450.00, 1500.00, 1550.00, 1600.00, 1650.00, 1700.00};
    Real h_data[30] = {-50.96809603, 1324.706731, 40593.30836, 83454.9174, 129348.8154, 177818.8132, 228513.5569, 281186.6809, 335696.8903, 392008.0078, 450189.0021, 510414.0054, 584639.3281, 640974.7547, 697727.6612, 754898.2319, 812486.5828, 870492.781, 928916.8588, 987758.8241, 1047018.668, 1106696.373, 1166791.913, 1227305.264, 1288236.402, 1349585.305, 1411351.959, 1473536.356, 1536138.498, 1599158.395};
  algorithm
    T := Modelica.Math.Vectors.interpolate(h_data, T_data, h);
    f := 0.0;
  end Tf_h;
end HighSilica_26pct_porosity_50K_intervals;