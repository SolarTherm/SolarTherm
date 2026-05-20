within SolarTherm.Materials;
package SolarSalt_Constant "60% NaNO3 + 40% KNO3 wt, constant properties"
  extends SolarTherm.Materials.PartialMaterial(MM = 93.04895e-3, T_melt = 260+273.15, cost = 1.0);
  
   redeclare model State "A model which calculates state and properties"
    SI.Density rho "Density (kg/m3)";
    SI.SpecificEnthalpy h "Specific enthalpy (J/kg)";
    SI.Temperature T "Absolute temperature (K)";
    SI.DynamicViscosity mu "Dynamic viscosity (Pa.s)";
    SI.SpecificHeatCapacity cp "Specific heat capacity (J/kgK)";
    SI.ThermalConductivity k "Thermal conductivity (W/mK)"; 
    Real f "Liquid Mass Fraction";
  equation
    k = 0.57;
    cp = 1550.0;
    mu = 2.1e-3;
    rho = 1733.0;
    h = 1550.0*T - (1550.0*298.15);
    f = 1.0;
  end State;
  
  redeclare function h_Tf "Specific enthalpy of liquid sodium vs Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f = 1 "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := 1550.0*T - (1550.0*298.15);
  end h_Tf;
  
  redeclare function rho_Tf "Density of liquid solar salt vs Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f = 1 "Liquid mass melt fraction (-) No effect on calculation";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 1733.0;
  end rho_Tf;
  
  function mu_Tf "Dynamic visocisty from temperature"
    input SI.Temperature T;
    input Real f = 1 "Liquid mass melt fraction (No effect on result)";
    output SI.DynamicViscosity mu;    
  algorithm
    mu := 2.1e-3;
  end mu_Tf;
  
  function cp_Tf "Specific heat capacity from temperature"
    input SI.Temperature T;
    input Real f = 1 "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificHeatCapacity cp;
  algorithm
    cp := 1550.0;
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
    cp := 1550.0;
    mu := 2.1e-3;
    k := 0.57;
    Pr := cp*mu/k;
  end Pr_Tf;
  
  annotation(
    Documentation(info = "<html><head></head><body><div><b>Assumptions:</b></div><div><br></div><div>Solar Salt heat-transfer fluid, constant properties [1].</div><div>Specific enthalpy measured relative to liquid phase at 298.15 K.</div><div><br></div><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Unit Cost of 0.49 USD_2002/kg (Sandia National Labs) [2].</span></div><div><br></div><div><b>References:</b></div><div><br></div><div>[1] J. T. Van Lew, P. Li, C. L. Chan, W. Karaki, and J. Stephens, 2011. Analysis of heatstorage and delivery of a thermocline tank having solid filler material. <i>Journal of Solar Energy Engineering</i>, vol. 133, no. 2, ISSN 0199-6231. doi: 10.1115/1.4003685.</div><div><br></div><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">[2] J. E. Pacheco, S. K. Showalter, W. J. Kolb, 2002. Development of a Molten-Salt Thermocline Thermal Storage System for Parabolic Trough Plant.</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">&nbsp;</span><i style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Journal of Solar Energy Engineering</i><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">. vol. 124, doi: 10.1115/1.1464123.</span></div><div><br></div><div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div></div></body></html>"));
  
end SolarSalt_Constant;