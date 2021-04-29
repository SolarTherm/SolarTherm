within SolarTherm.Materials;
package Sodium_Poly
  extends SolarTherm.Materials.PartialMaterial(MM = 22.989769e-3, T_melt = 97.79 + 273.15, cost = 3.0);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  
  //constant SI.MolarMass MM = 22.989769e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 97.79 + 273.15 "Melting point (K)";
  //constant Real cost = 3.0 "USD/kg";
  
  redeclare model State
    parameter SI.SpecificEnthalpy h_start=700000;
    SI.Density rho;
    SI.SpecificEnthalpy h (start=h_start);
    SI.Temperature T;
    SI.DynamicViscosity mu;
    SI.SpecificHeatCapacity cp;
    SI.ThermalConductivity k;
  equation
    k = SolarTherm.Media.Sodium.Sodium_Poly_utilities.lamda_T(T);
    cp = SolarTherm.Media.Sodium.Sodium_Poly_utilities.cp_T(T);
    mu = SolarTherm.Media.Sodium.Sodium_Poly_utilities.eta_T(T);
    rho = SolarTherm.Media.Sodium.Sodium_Poly_utilities.rho_T(T);
    h = SolarTherm.Media.Sodium.Sodium_Poly_utilities.h_T(T);
  end State;

  redeclare function h_Tf
    input SI.Temperature T;
    input Real f = 0 "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificEnthalpy h;
  algorithm
    h := SolarTherm.Media.Sodium.Sodium_Poly_utilities.h_T(T);
  end h_Tf;
  
  redeclare function rho_Tf
    input SI.Temperature T;
    input Real f = 0 "Liquid mass melt fraction (No effect on result)";
    output SI.Density rho;
  algorithm
    //rho := SolarTherm.Media.Sodium.Sodium_utilities.rho_T(T);
    rho := SolarTherm.Media.Sodium.Sodium_Poly_utilities.rho_T(T);//-0.23465*T + 1014.5;
  end rho_Tf;
  
  function mu_T
    input SI.Temperature T;
    output SI.DynamicViscosity mu;
  algorithm
    mu := SolarTherm.Media.Sodium.Sodium_Poly_utilities.eta_T(T);
  end mu_T;
end Sodium_Poly;