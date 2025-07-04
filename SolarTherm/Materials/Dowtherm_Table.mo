within SolarTherm.Materials;
package Dowtherm_Table
  extends SolarTherm.Materials.PartialMaterial(MM = 166.0e-3, T_melt = 12.0 + 273.15, cost = 2.10, year = 2013); //Cost from Heller et al. 2013
  
  redeclare model State
	SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
	SI.Temperature T "Absolute Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
    //Additional variables for a fluid
    SI.DynamicViscosity mu "Dynamic viscosity (Pas)";
    SI.SpecificHeatCapacity cp "Specific heat capacity (J/kgK)";
  equation
  
    T = SolarTherm.Media.DowthermA.DowthermA_ph_utilities.T_h(h);
    f = 1.0; //This is a liquid
    rho = SolarTherm.Media.DowthermA.DowthermA_ph_utilities.rho_T(T);
    k = SolarTherm.Media.DowthermA.DowthermA_ph_utilities.k_T(T);
    mu = SolarTherm.Media.DowthermA.DowthermA_ph_utilities.mu_T(T);
    cp = SolarTherm.Media.DowthermA.DowthermA_ph_utilities.cp_T(T);
  end State;
  
  redeclare function h_Tf "Specific enthalpy of air vs Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f = 1 "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := SolarTherm.Media.DowthermA.DowthermA_ph_utilities.h_T(T);
  end h_Tf;
  
  redeclare function rho_Tf "Density of air vs Temperature"
    input SI.Temperature T;
    input Real f = 1 "Liquid mass melt fraction (No effect on result)";
    output SI.Density rho;    
  algorithm
    rho := SolarTherm.Media.DowthermA.DowthermA_ph_utilities.rho_T(T);
  end rho_Tf;


  function Tf_h "Temperature interpolated from enthalpy"
    input SI.SpecificEnthalpy h;
    output SI.Temperature T;
    output Real f;
  algorithm
    T := SolarTherm.Media.DowthermA.DowthermA_ph_utilities.T_h(h);
    f := 1.0;
  end Tf_h;
end Dowtherm_Table;