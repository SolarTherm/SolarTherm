within SolarTherm.Materials;

package FeSi2
  extends SolarTherm.Materials.PartialMaterial(MM = 112.02e-3, T_melt = 1270.0, cost = 0.55);
  import SolarTherm.Models.Chemistry.Property_Tables.FeSi2.*;

  redeclare model State "A model which calculates state and properties"
    SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
    SI.Temperature T "Temperature (K)";
    Real f "Liquid Mass Fraction";
    SI.Density rho "Density (kg/m3)";
    SI.ThermalConductivity k "Thermal conductivity (W/mK)";
  equation
    T = T_h(h);
    f = f_h(h);
    rho = rho_h(h);
    k = k_h(h);
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := Modelica.Math.Vectors.interpolate(T_table, h_table, T);
  end h_Tf;

  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := Modelica.Math.Vectors.interpolate(T_table, rho_table, T);
  end rho_Tf;

  function k_h "find thermal conductivity from specific enthalpy"
    input SI.SpecificEnthalpy h;
    output SI.ThermalConductivity k;
  algorithm
    k := Modelica.Math.Vectors.interpolate(h_table, k_table, h);
  end k_h;

  function T_h "Find temperature from specific enthalpy"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absolute temperature (K)";
  algorithm
    T := Modelica.Math.Vectors.interpolate(h_table, T_table, h);
  end T_h;
  
  function rho_h "Find density from specific enthalpy"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := Modelica.Math.Vectors.interpolate(h_table, rho_table, h);
  end rho_h;
  
  function f_h "Find density from specific enthalpy"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output Real f "Liquid Mass Fraction (-)";
  algorithm
    f := Modelica.Math.Vectors.interpolate(h_table, f_table, h);
  end f_h;
end FeSi2;