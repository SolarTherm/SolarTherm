within SolarTherm.Materials;
package Al2O3_Constant
  extends SolarTherm.Media.Materials.PartialMaterial(MM = 101.9613e-3, T_melt = 2327.0, cost = 1.5);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.MolarMass MM = 101.9613e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 2327.0 "Melting point (K)";
  //constant Real cost = 1.5 "USD/kg";

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
    h := 900.0*(T-298.15);
  end h_Tf;
    
  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy rho "Density (kg/m3)";
  algorithm
    rho := 3300.0;
  end rho_Tf;
  
  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  algorithm
    k := 85.868 + (-0.22972*T) + ((2.607e-4)*(T^2)) + ((-1.3607e-7)*(T^3)) + ((2.7092e-11)*(T^4));
  end k_Tf;
end Al2O3_Constant;
