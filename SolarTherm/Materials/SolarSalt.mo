within SolarTherm.Materials;
package SolarSalt "60% NaNO3 + 40% KNO3 wt, temperature-dependent properties based on Zavoico"
  extends SolarTherm.Materials.PartialMaterial(MM = 93.04895e-3, T_melt = 260+273.15, cost = 0.49, year = 2002);
  
   redeclare model State "A model which calculates state and properties"
    SI.Density rho "Density (kg/m3)";
    SI.SpecificEnthalpy h "Specific enthalpy (J/kg)";
    SI.Temperature T "Absolute temperature (K)";
    SI.DynamicViscosity mu "Dynamic viscosity (Pa.s)";
    SI.SpecificHeatCapacity cp "Specific heat capacity (J/kgK)";
    SI.ThermalConductivity k "Thermal conductivity (W/mK)";
    Real f "Liquid Mass Fraction";
  equation
    k = SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.lamda_T(T); //Someone misspelt lambda in the old SolarTherm master branch
    cp = SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.cp_T(T);
    mu = SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.eta_T(T);
    rho = SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.rho_T(T);
    h = SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.h_T(T);
    f = 1.0;
  end State;
  
  redeclare function h_Tf "Specific enthalpy of liquid sodium vs Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f = 1 "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.h_T(T);
  end h_Tf;
  
  redeclare function rho_Tf "Density of liquid solar salt vs Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f = 1 "Liquid mass melt fraction (-) No effect on calculation";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.rho_T(T);
  end rho_Tf;
  
  function mu_Tf "Dynamic visocisty from temperature"
    input SI.Temperature T;
    input Real f = 1 "Liquid mass melt fraction (No effect on result)";
    output SI.DynamicViscosity mu;    
  algorithm
    mu := SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.eta_T(T);
  end mu_Tf;
  
  function cp_Tf "Specific heat capacity from temperature"
    input SI.Temperature T;
    input Real f = 1 "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificHeatCapacity cp;
  algorithm
    cp := SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.cp_T(T);
  end cp_Tf;
  
  function Pr_Tf "Prandtl number from temperature"
    input SI.Temperature T;
    input Real f = 1 "Liquid mass melt fraction (No effect on result)";
    output Real Pr "Prandtl number (-)";
  protected
    SI.SpecificHeatCapacity cp;
    SI.DynamicViscosity mu;
    SI.ThermalConductivity k;
  algorithm
    cp := cp_Tf(T,1.0);
    mu := mu_Tf(T,1.0);
    k := SolarTherm.Media.MoltenSalt.MoltenSalt_utilities.k_T(T);
    Pr := cp*mu/k;
  end Pr_Tf;
  
  annotation(
    Documentation(info = "<html><head></head><body><b>Assumptions:</b><div><b><br></b></div><div>Temperature dependent properties [1].</div><div><br></div><div>Unit Cost of 0.49 USD_2002/kg (Sandia National Labs) [2].<br><div><b><br></b></div><div><b>References:</b></div><div><b><br></b></div><div><div>[1] A. B. Zavoico, 2001. Solar power tower design basis document, revision 0. Report SAND2001-2100, doi: 10.2172/786629, url: https://www.osti.gov/servlets/purl/786629.</div></div></div><div><br></div><div>[2] J. E. Pacheco, S. K. Showalter, W. J. Kolb, 2002. Development of a Molten-Salt Thermocline Thermal Storage System for Parabolic Trough Plant. <i>Journal of Solar Energy Engineering</i>. vol. 124, doi: 10.1115/1.1464123</div><div><br></div><div><br></div></body></html>"));
  
end SolarSalt;