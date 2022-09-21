within SolarTherm.Materials;
package MgO_Constant
  extends SolarTherm.Materials.PartialMaterial(MM = 40.3044e-4, T_melt = 3105.0, cost = 0.630);
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
    h = h_Tf(T,0);
    rho = rho_Tf(T,0);
    k = k_Tf(T,0);
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := 1247*(T-298.15);
  end h_Tf;
    
  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 2902.0;
  end rho_Tf;
  
  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  protected
    SI.Temperature T_table[:] = {400,450,500,550,600,650,700,750,800,850,900,950,1000,1050,1100,1150,1200,1250,1300};
    SI.ThermalConductivity k_table[:] = {25.82,20.20,18.08,16.41,14.97,13.90,12.61,11.62,10.86,9.95,9.34,8.89,8.43,7.98,7.60,7.22,6.76,6.30,6.15};
  algorithm
    k := Interpolate1D(T_table,k_table,T);
  end k_Tf;
  
  function Tf_h "Find temperature and liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absoulte temperature (K)";
    output Real f "mass liquid fraction";
  algorithm
    T := 298.15 + (h/1247.0);
    f := 0.0;
  end Tf_h;
end MgO_Constant;
