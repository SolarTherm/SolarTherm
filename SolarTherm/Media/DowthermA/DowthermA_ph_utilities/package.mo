within SolarTherm.Media.DowthermA;
package DowthermA_ph_utilities
	extends Modelica.Icons.UtilitiesPackage;
	import SolarTherm.Models.Chemistry.Property_Tables.Mixtures.DowthermA_Liquid.*;
	
  function cp_T "Specific heat capacity (J/kgK) of air at ambient pressure as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T "Temperature (K)";
    output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity (J/kgK)";
  algorithm
    cp := Modelica.Math.Vectors.interpolate(T_table, cp_table, T);
  end cp_T;

  function mu_T "Dynamic viscosity (Ns/m2) of air at ambient pressure as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T "Temperature (K)";
    output Modelica.SIunits.DynamicViscosity mu "Dynamic Viscosity (Ns/m2)";
  algorithm
    mu := Modelica.Math.Vectors.interpolate(T_table, mu_table, T);
  end mu_T;

  function h_T "Specific enthalpy (J/kg) of air at ambient pressure as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T "Temperature (K)";
    output Modelica.SIunits.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := Modelica.Math.Vectors.interpolate(T_table, h_table, T);
  end h_T;

  function k_T "Thermal conductivity (W/mK) of air at ambient pressure as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T "Temperature (K)";
    output Modelica.SIunits.ThermalConductivity k "Thermal Conductivity (W/mK)";
  algorithm
    k := Modelica.Math.Vectors.interpolate(T_table, k_table, T);
  end k_T;

  function rho_T "Density (kg/m3) of air at ambient pressure as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T "Temperature (K)";
    output Modelica.SIunits.Density rho "Density (kg/m3)";
  algorithm
    rho := Modelica.Math.Vectors.interpolate(T_table, rho_table, T);
  end rho_T;

  function T_h "Temperature (K) of air at ambient pressure as a function of specific enthalpy"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output Modelica.SIunits.Temperature T "Temperature (K)";
  algorithm
    T := Modelica.Math.Vectors.interpolate(h_table, T_table, h);
  end T_h;
  annotation();
  
	annotation ();
end DowthermA_ph_utilities;