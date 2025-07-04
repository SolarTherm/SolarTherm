within SolarTherm.Materials;
package Air_CoolProp_Table_1bar "Air is free for now, they will make us pay for it eventually"
  extends SolarTherm.Materials.PartialMaterial(MM = 28.97e-3, T_melt = 58, cost = 0.0, year = 2022);
  
  redeclare model State "A model which calculates state and properties"
    SI.Density rho "Density (kg/m3)";
    SI.SpecificEnthalpy h "Specific enthalpy (J/kg)";
    SI.Temperature T "Absolute temperature (K)";
    SI.DynamicViscosity mu "Dynamic viscosity (Pa.s)";
    SI.SpecificHeatCapacity cp "Specific heat capacity (J/kgK)";
    SI.ThermalConductivity k "Thermal conductivity (W/mK)";
    Real f "Liquid Mass fraction (-)";
  equation
	T = SolarTherm.Media.Air.Air_CoolProp_1bar_utilities.T_h(h);
	rho = SolarTherm.Media.Air.Air_CoolProp_1bar_utilities.rho_T(T);
	cp = SolarTherm.Media.Air.Air_CoolProp_1bar_utilities.cp_T(T);
	mu = SolarTherm.Media.Air.Air_CoolProp_1bar_utilities.mu_T(T);
	k = SolarTherm.Media.Air.Air_CoolProp_1bar_utilities.k_T(T);
	f = 1.0;
  end State;
  
  redeclare function h_Tf "Specific enthalpy of air vs Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f = 1 "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := SolarTherm.Media.Air.Air_CoolProp_1bar_utilities.h_T(T);
  end h_Tf;
  
  redeclare function rho_Tf "Density of air vs Temperature"
    input SI.Temperature T;
    input Real f = 1 "Liquid mass melt fraction (No effect on result)";
    output SI.Density rho;    
  algorithm
    rho := SolarTherm.Media.Air.Air_CoolProp_1bar_utilities.rho_T(T);
  end rho_Tf;


  function Tf_h "Temperature interpolated from enthalpy"
    input SI.SpecificEnthalpy h;
    output SI.Temperature T;
    output Real f;
  algorithm
    T := SolarTherm.Media.Air.Air_CoolProp_1bar_utilities.T_h(h);
    f := 1.0;
  end Tf_h;
end Air_CoolProp_Table_1bar;