within SolarTherm.Materials;
package RT20_Paraffin_Melting "Broad melting temperature"
  extends SolarTherm.Materials.PartialMaterial(MM = 353.0e-3, T_melt = 288.1, cost = 0.049); 

  //Property Tables
  constant SI.Temperature T_data[32] = {273.1500, 273.2113, 280.0121, 280.9312, 281.9728, 283.0143, 284.3623, 285.8327, 287.1806, 288.2222, 289.3863, 290.3054, 291.1019, 292.0209, 292.6336, 293.1850, 293.4914, 293.8590, 294.2879, 294.5329, 294.9005, 295.2682, 295.3294, 295.4520, 295.6358, 295.7583, 295.8809, 296.1872, 301.1500, 310.0000, 320.0000, 330.0000};
  constant SI.SpecificEnthalpy h_data[32] = {0.00, 111.74, 12514.55, 14414.08, 16820.15, 19416.17, 23267.38, 28362.59, 34098.42, 39480.42, 47123.24, 54888.96, 63313.93, 75772.62, 86350.39, 97982.22, 105561.71, 115930.91, 129618.70, 138274.59, 152308.77, 166208.86, 168272.27, 171758.46, 175903.91, 177863.03, 179054.89, 180488.85, 192556.45, 214076.21, 238392.32, 262708.43};
  constant Real f_data[32] = {0.00, 0.00, 0.00, 0.01, 0.03, 0.04, 0.06, 0.09, 0.13, 0.16, 0.21, 0.25, 0.30, 0.38, 0.44, 0.51, 0.55, 0.62, 0.70, 0.75, 0.83, 0.91, 0.93, 0.95, 0.97, 0.98, 0.99, 1.00, 1.00, 1.00, 1.00, 1.00};
  constant SI.Density rho_data[32] = {880.00, 880.00, 880.00, 878.53, 876.67, 874.66, 871.68, 867.73, 863.30, 859.13, 853.22, 847.21, 840.68, 831.04, 822.86, 813.85, 807.99, 799.96, 789.37, 782.67, 771.81, 761.05, 759.45, 756.76, 753.55, 752.03, 751.11, 750.00, 750.00, 750.00, 750.00, 750.00};
  constant SI.ThermalConductivity k_data[32] = {0.2000, 0.2000, 0.2000, 0.1998, 0.1995, 0.1992, 0.1987, 0.1981, 0.1974, 0.1968, 0.1959, 0.1950, 0.1940, 0.1925, 0.1912, 0.1898, 0.1889, 0.1877, 0.1861, 0.1850, 0.1834, 0.1817, 0.1815, 0.1810, 0.1805, 0.1803, 0.1802, 0.1800, 0.1800, 0.1800, 0.1800, 0.1800};

  redeclare model State "A model which calculates state and properties"
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Absolute Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
  equation
    T = Modelica.Math.Vectors.interpolate(h_data,T_data,h);
    f = Modelica.Math.Vectors.interpolate(h_data,f_data,h);
    rho = Modelica.Math.Vectors.interpolate(h_data,rho_data,h);
    k = Modelica.Math.Vectors.interpolate(h_data,k_data,h);
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := Modelica.Math.Vectors.interpolate(T_data,h_data,T);
  end h_Tf;
  
  redeclare function rho_Tf "find density from temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := Modelica.Math.Vectors.interpolate(T_data,rho_data,T);
  end rho_Tf;
  
end RT20_Paraffin_Melting;
