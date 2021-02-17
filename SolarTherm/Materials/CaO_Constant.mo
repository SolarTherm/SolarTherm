within SolarTherm.Materials;
package CaO_Constant
  extends SolarTherm.Materials.PartialMaterial(MM = 56.077e-3, T_melt = 3200.0, cost = 0.2);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.MolarMass MM = 56.077e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 3200.0 "Melting point (K)";
  //constant Real cost = 0.2 "USD/kg";

  redeclare model State "A model which calculates state and properties"
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
	
  equation
    f= 0.0;
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
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 3340.0;
  end rho_Tf;
  
  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  protected
    SI.Temperature T_table[:] = {373.15,473.15,673.15,873.15,1073.15,1273.15};
    SI.ThermalConductivity k_table[:] = {15.22976,11.0876,9.16296,8.28432,7.99144,7.78224};
  algorithm
    k := Interpolate1D(T_table,k_table,T);
  end k_Tf;
  
  redeclare function T_h "Find temperature and liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absoulte temperature (K)";
  algorithm
    T := 298.15 + (h/900.0);
  end T_h;
  
  redeclare function f_h "Find temperature and liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output Real f "mass liquid fraction";
  algorithm
    f := 0.0;
  end f_h;
  /*
  function T_h "Find temperature from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absoulte temperature (K)";
  algorithm
    T := 298.15 + (h/900.0);
  end T_h;
  
  function f_h "Find liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output Real f "mass liquid fraction";
  algorithm
    f := 0.0;
  end f_h;
  */

end CaO_Constant;
