within SolarTherm.Media.Materials;

package SolarSalt "60% NaNO3 + 40% KNO3 wt"
  extends SolarTherm.Media.Materials.PartialMaterial;
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  
  constant SI.MolarMass MM = 93.04895e-3 "Molar mass (kg/mol)";
  constant SI.Temperature T_melt = 260+273.15 "Melting point (K)";
  constant Real cost = 0.0 "USD/kg";
  
  redeclare model State "A model which calculates state and properties"
    parameter SI.SpecificEnthalpy h_start;
    SI.Density rho;
    SI.SpecificEnthalpy h (start=h_start);
    SI.Temperature T;
    SI.DynamicViscosity mu;
    SI.SpecificHeatCapacity cp;
    SI.ThermalConductivity k;
  equation
    k = SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.lamda_T(T);
    cp = SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.cp_T(T);
    mu = SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.eta_T(T);
    rho = SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.rho_T(T);
    h = SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.h_T(T);
  end State;
  
  redeclare function h_Tf "Specific enthalpy of liquid sodium vs Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.h_T(T);
  end h_Tf;
  
  redeclare function rho_Tf "Density of liquid solar salt vs Temperature"
    input SI.Temperature T;
    input Real f "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificEnthalpy rho;
  algorithm
    rho := SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.rho_T(T);
  end rho_Tf;
  
end SolarSalt;