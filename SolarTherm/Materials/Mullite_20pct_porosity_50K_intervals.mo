within SolarTherm.Materials;

package Mullite_20pct_porosity_50K_intervals
  //Mullite properties 298.15 < T (K) < 1700. Stoichiometry of 3Al2O3.2SiO2 ~72wt% is assumed which is typical of sintered mullite.
  extends SolarTherm.Materials.PartialMaterial(MM = 426.0524e-3, T_melt = 1840.0 + 273.15, cost = 0.55);
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
    Real h_data[30] = {-597.5, 818.1, 41527.7, 86044.2, 133440.7, 183123.0, 234680.6, 287812.6, 342287.7, 397920.9, 454560.3, 512078.1, 570365.3, 629328.0, 688884.7, 748964.7, 809506.5, 870457.5, 931772.7, 993414.5, 1055352.3, 1117562.0, 1180026.2, 1242733.5, 1305678.6, 1368862.3, 1432291.2, 1495977.8, 1559940.3, 1624202.4};
  algorithm
    h := Modelica.Math.Vectors.interpolate(T_data, h_data, T);
  end h_Tf;

  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 2560.0;
  end rho_Tf;

  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  protected
    Real T_data[30] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 650.00, 700.00, 750.00, 800.00, 850.00, 900.00, 950.00, 1000.00, 1050.00, 1100.00, 1150.00, 1200.00, 1250.00, 1300.00, 1350.00, 1400.00, 1450.00, 1500.00, 1550.00, 1600.00, 1650.00, 1700.00};
    Real k_data[30] = {5.2299, 5.2206, 4.9696, 4.7186, 4.4676, 4.2615, 4.0941, 3.9268, 3.7594, 3.6370, 3.5533, 3.4696, 3.3859, 3.3247, 3.2829, 3.2410, 3.1992, 3.1573, 3.1155, 3.0737, 3.0319, 3.0125, 3.0125, 3.0125, 3.0125, 3.0125, 3.0125, 3.0125, 3.0125, 3.0125};
  algorithm
    k := Modelica.Math.Vectors.interpolate(T_data, k_data, T);
  end k_Tf;

  function Tf_h "Find temperature and liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absoulte temperature (K)";
    output Real f "mass liquid fraction";
  protected
    Real T_data[30] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 650.00, 700.00, 750.00, 800.00, 850.00, 900.00, 950.00, 1000.00, 1050.00, 1100.00, 1150.00, 1200.00, 1250.00, 1300.00, 1350.00, 1400.00, 1450.00, 1500.00, 1550.00, 1600.00, 1650.00, 1700.00};
    Real h_data[30] = {-597.5, 818.1, 41527.7, 86044.2, 133440.7, 183123.0, 234680.6, 287812.6, 342287.7, 397920.9, 454560.3, 512078.1, 570365.3, 629328.0, 688884.7, 748964.7, 809506.5, 870457.5, 931772.7, 993414.5, 1055352.3, 1117562.0, 1180026.2, 1242733.5, 1305678.6, 1368862.3, 1432291.2, 1495977.8, 1559940.3, 1624202.4};
  algorithm
    T := Modelica.Math.Vectors.interpolate(h_data, T_data, h);
    f := 0.0;
  end Tf_h;
end Mullite_20pct_porosity_50K_intervals;