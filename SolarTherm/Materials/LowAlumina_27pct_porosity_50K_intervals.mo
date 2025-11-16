within SolarTherm.Materials;

package LowAlumina_27pct_porosity_50K_intervals
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
    Real h_data[30] = {-553.6139319, 864.4509465, 41686.85008, 86368.87736, 133947.8479, 183811.4304, 235540.5884, 288831.0498, 343451.0223, 399217.0298, 455979.4155, 513613.2796, 572012.6175, 631086.41, 690755.9496, 750952.9681, 811618.2995, 872700.9076, 934157.167, 995950.324, 1058050.087, 1120432.312, 1183078.756, 1245976.884, 1309119.721, 1372505.722, 1436138.68, 1500027.643, 1564186.851, 1628635.676};
  algorithm
    h := Modelica.Math.Vectors.interpolate(T_data, h_data, T);
  end h_Tf;

  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 2159.76;
  end rho_Tf;

  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  protected
    Real T_data[30] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 650.00, 700.00, 750.00, 800.00, 850.00, 900.00, 950.00, 1000.00, 1050.00, 1100.00, 1150.00, 1200.00, 1250.00, 1300.00, 1350.00, 1400.00, 1450.00, 1500.00, 1550.00, 1600.00, 1650.00, 1700.00};
    Real k_data[30] = {1.6900, 1.6884, 1.6456, 1.6067, 1.5720, 1.5412, 1.5145, 1.4918, 1.4731, 1.4585, 1.4479, 1.4413, 1.4388, 1.4403, 1.4458, 1.4553, 1.4689, 1.4865, 1.5081, 1.5338, 1.5634, 1.5971, 1.6349, 1.6767, 1.7225, 1.7723, 1.8261, 1.8840, 1.9459, 2.0119};
  algorithm
    k := Modelica.Math.Vectors.interpolate(T_data, k_data, T);
  end k_Tf;

  function Tf_h "Find temperature and liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absoulte temperature (K)";
    output Real f "mass liquid fraction";
  protected
    Real T_data[30] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 650.00, 700.00, 750.00, 800.00, 850.00, 900.00, 950.00, 1000.00, 1050.00, 1100.00, 1150.00, 1200.00, 1250.00, 1300.00, 1350.00, 1400.00, 1450.00, 1500.00, 1550.00, 1600.00, 1650.00, 1700.00};
    Real h_data[30] = {-553.6139319, 864.4509465, 41686.85008, 86368.87736, 133947.8479, 183811.4304, 235540.5884, 288831.0498, 343451.0223, 399217.0298, 455979.4155, 513613.2796, 572012.6175, 631086.41, 690755.9496, 750952.9681, 811618.2995, 872700.9076, 934157.167, 995950.324, 1058050.087, 1120432.312, 1183078.756, 1245976.884, 1309119.721, 1372505.722, 1436138.68, 1500027.643, 1564186.851, 1628635.676};
  algorithm
    T := Modelica.Math.Vectors.interpolate(h_data, T_data, h);
    f := 0.0;
  end Tf_h;
end LowAlumina_27pct_porosity_50K_intervals;