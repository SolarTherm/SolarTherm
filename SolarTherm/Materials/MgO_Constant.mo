within SolarTherm.Materials;
package MgO_Constant
  extends SolarTherm.Materials.PartialMaterial(MM = 40.3044e-4, T_melt = 3105.0, cost = 1.0);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.MolarMass MM = 40.3044e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 3105.0 "Melting point (K)";
  //constant Real cost = 1.0 "USD/kg";

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
    h := 1200*(T-298.15);
  end h_Tf;
    
  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy rho "Density (kg/m3)";
  algorithm
    rho := 2880.0;
  end rho_Tf;
  
  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  protected
    SI.Temperature T_table[:] = {400,450,500,550,600,650,700,750,800,850,900,950,1000,1050,1100,1150,1200,1250,1300};
    SI.ThermalConductivity k_table[:] = {29.4,26.6,23.8,21.6,19.7,18.3,16.6,15.3,14.3,13.1,12.3,11.7,11.1,10.5,10.0,9.5,8.9,8.3,8.1};
  algorithm
    k := Interpolate1D(T_table,k_table,T);
  end k_Tf;
end MgO_Constant;
