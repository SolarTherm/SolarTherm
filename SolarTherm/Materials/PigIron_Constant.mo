within SolarTherm.Materials;
package PigIron_Constant
  extends SolarTherm.Media.Materials.PartialMaterial(MM = 55.845e-3, T_melt = 1811.150, cost = 0.5);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.MolarMass MM = 55.845e-3 "Molar mass (kg/mol)"; //not used
  //constant SI.Temperature T_melt = 1811.150 "Melting point (K)"; //not used
  //constant Real cost = 0.5 "USD/kg";

  redeclare model State "A model which calculates state and properties"
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
	
  equation
    f = 0.0;
    h = h_Tf(T,0);
    rho = rho_Tf(T,0);
    k = k_Tf(T,0);
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := 700.0*(T-298.15);
  end h_Tf;
    
  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy rho "Density (kg/m3)";
  algorithm
    rho := 7900.0;
  end rho_Tf;
  
  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  algorithm
    k := 51.0;
  end k_Tf;
end PigIron_Constant;
