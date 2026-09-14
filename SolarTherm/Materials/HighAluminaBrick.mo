within SolarTherm.Materials;

package HighAluminaBrick
  //Molar mass based on Stoichiometry of 3Al2O3.2SiO2 ~72wt% is assumed which is typical of sintered mullite. Properties are obtained for high-alumina checkerbrick material.
  extends SolarTherm.Materials.PartialMaterial(MM = 426.0524e-3, T_melt = 1840.0 + 273.15, cost = 0.56446, year = 2022);

  //Property Tables
  constant Real T_data[6] = {298.15, 300.00, 500.00, 1000.00, 1500.00, 2000.00};
  
  constant Real h_data[6] = {0.00, 1521.09, 183221.09, 724471.09, 1329471.09, 1962721.09};
  
  constant Real k_data[6] = {1.700, 1.700, 1.723, 1.780, 1.870, 1.960};
  
  constant SI.Density rho_1 = 2570.0 "Density of solid (kg/m3)";

  redeclare model State "A model which calculates state and properties"
    SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
    SI.Temperature T "Temperature (K)";
    Real f "Liquid Mass Fraction";
    SI.Density rho "Density (kg/m3)";
    SI.ThermalConductivity k "Thermal conductivity (W/mK)";
  equation
    T = Modelica.Math.Vectors.interpolate(h_data,T_data,h);
    f = 0.0;
    rho = rho_1;
    k = Modelica.Math.Vectors.interpolate(h_data,k_data,h);
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := Modelica.Math.Vectors.interpolate(T_data, h_data, T);
  end h_Tf;

  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 2570.0;
  end rho_Tf;

  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;    
  algorithm
    k := Modelica.Math.Vectors.interpolate(T_data, k_data, T);
  end k_Tf;

  function Tf_h "Find temperature and liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absoulte temperature (K)";
    output Real f "mass liquid fraction";
  algorithm
    T := Modelica.Math.Vectors.interpolate(h_data, T_data, h);
    f := 0.0;
  end Tf_h;
end HighAluminaBrick;