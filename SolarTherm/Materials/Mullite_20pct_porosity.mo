within SolarTherm.Materials;

package Mullite_20pct_porosity
  extends SolarTherm.Materials.PartialMaterial(MM = 319.54e-3, T_melt = 1830.0+273.15, cost = 0.50);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  
  redeclare model State "A model which calculates state and properties"
    SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
    SI.Temperature T "Temperature (K)";
    Real f "Liquid Mass Fraction";
    SI.Density rho "Density (kg/m3)";
    SI.ThermalConductivity k "Thermal conductivity (W/mK)";
  equation
    f = 0.0;
    h = h_Tf(T, 0);
    rho = rho_Tf(T, 0);
    k = k_Tf(T, 0);
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := -289246.3 + 879.9408*T + 0.1550128*T*T;
  end h_Tf;

  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 2560.0;
  end rho_Tf;

  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  algorithm
    k := 2.439683 + 220.5276/T + 147344.8/(T*T);
  end k_Tf;

  function Tf_h "Find temperature and liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absoulte temperature (K)";
    output Real f "mass liquid fraction";
  algorithm
    //if h < 557805.68 then
      //T := (-396000.0 + (534600.0*h+396000.0^2.0)^0.5)/486.0;
    //else
     // T := 10.0 * (((22.0^0.5) *(1929.0*h + 1557868950.0)^0.5)-185130.0)/1929.0;
    //end if;
    T := (-879.9408 + (0.6200512*h + 953643.3)^0.5)/0.3100256;
    f := 0.0;
  end Tf_h;
end Mullite_20pct_porosity;