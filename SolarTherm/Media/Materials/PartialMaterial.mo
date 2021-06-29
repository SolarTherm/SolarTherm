within SolarTherm.Media.Materials;
partial package PartialMaterial
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  package Tables = Modelica.Blocks.Tables;
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  
  constant SI.MolarMass MM = 0.0 "Molar mass (kg/mol)";
  constant SI.Temperature T_melt = 0.0 "Melting point (K)";
  constant Real cost = 0.0 "USD/kg";
  
  replaceable partial function h_Tf
    "Return specific enthalpy as a function of temperature and liquid mass fraction f"
    extends Modelica.Icons.Function;
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  end h_Tf;
  
  replaceable partial function rho_Tf
    "Return specific enthalpy as a function of temperature and liquid mass fraction f"
    extends Modelica.Icons.Function;
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Specific Enthalpy (J/kg)";
  end rho_Tf;
  
  replaceable partial model State "A model which calculates state and properties"
    SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
	SI.SpecificHeatCapacity cp "Specific heat capacity (J/kgK)";
	SI.DynamicViscosity mu "Dynamic viscosity";
  end State;
  
  /*
  replaceable partial function T_h "Return Temperature from h"
    extends Modelica.Icons.Function;
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absolute temperature (K)";
  end T_h;
  
  replaceable partial function f_h "Return mass liquid fraction from h"
    extends Modelica.Icons.Function;
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output Real f "Liquid mass fraction";
  end f_h;
  */
  replaceable partial function T_h "Return absolute temperature (K) from h (J/kg)"
    extends Modelica.Icons.Function;
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absolute temperature (K)";
  end T_h;
  
  replaceable partial function f_h "Return Temperature from h"
    extends Modelica.Icons.Function;
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output Real f "Liquid mass fraction";
  end f_h;
end PartialMaterial;
