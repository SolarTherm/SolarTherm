within SolarTherm.Materials;

package Brick_Stack
  extends SolarTherm.Materials.PartialMaterial(MM = 319.54e-3, T_melt = 1830.0+273.15, cost = 0.50);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  //As of 21 Sept 2021, cost = 0.63 USD/kg (supplier), c_p = 1247 J/kgK (avg 500-720), density = 2902 kg/m3 calculated via worst case scenario 720C, k-T relationship updated for higher pore fraction
  // This is based on a sample of 2981 kg/m3 at 25C MgO with pore fraction of 0.1833 w.r.t the theoretical pure density of 3650 kg/m3.

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
    h :=  0.1734*T*T +641.9*T - 2.006E5;
  end h_Tf;

  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 2530.11;
  end rho_Tf;

  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  algorithm
    k := (-2.758E-10)*T*T*T + (9.816E-7)*T*T - (1.247E-3)*T + 2.499;
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
    T := (-641.9+(max(1.0e-3,0.6936*h+551171.77))^0.5)/0.3468;
    f := 0.0;
  end Tf_h;
end Brick_Stack;