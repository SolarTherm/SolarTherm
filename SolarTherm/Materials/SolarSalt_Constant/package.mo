within SolarTherm.Materials;

package SolarSalt_Constant
  extends SolarTherm.Materials.PartialMaterial(MM = 93.04895e-3, T_melt = 260+273.15, cost = 1.0);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  import SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.*;
  
  redeclare model State "A model which calculates state and properties"
    parameter SI.SpecificEnthalpy h_start;
    SI.Density rho;
    SI.SpecificEnthalpy h (start=h_start);
    SI.Temperature T;
    SI.DynamicViscosity mu;
    SI.SpecificHeatCapacity cp;
    SI.ThermalConductivity k;
  equation
    k = 0.57;
    cp = 1550.0;
    mu = 0.0021;
    rho = 1733.0;
    h = 1550.0*T;
  end State;
  
  redeclare function h_Tf "Specific enthalpy of liquid sodium vs Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f = 0 "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := 1550.0*T;
  end h_Tf;
  
  redeclare function rho_Tf "Density of liquid solar salt vs Temperature"
    input SI.Temperature T;
    input Real f = 0 "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificEnthalpy rho;
  algorithm
    rho := 1733.0;
  end rho_Tf;
end SolarSalt_Constant;
