within SolarTherm.Materials;

package FeSi2
  extends SolarTherm.Materials.PartialMaterial(MM = 112.02e-3, T_melt = 1400.0, cost = 3.0);
  //import SolarTherm.Models.Chemistry.Property_Tables.FeSi2.*;

  constant SI.SpecificEnthalpy h_melt = 729833.20 "Specific latent heat of fusion (J/kg)";
  
  constant SI.SpecificHeatCapacity cp1 = 714.83 "Specific heat capacity of PCM solid (J/kgK)";
  constant SI.SpecificHeatCapacity cp2 = 879.63 "Specific heat capacity of PCM liquid (J/kgK)"; 
  
  constant SI.Density rho1 = 4504.49 "Density of PCM solid (kg/m3)";
  constant SI.Density rho2 = 4012.01 "Density of PCM liquid (kg/m3)";
  
  constant SI.ThermalConductivity k1 = 17.04 "Thermal conductivity of solid (W/mK)";
  constant SI.ThermalConductivity k2 = 20.47 "Thermal conducitvity of liquid (W/mK)";
  
  redeclare model State "A model which calculates state and properties"
	
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
	
  equation
	(T, f) = Tf_h(h);
    rho = rho_Tf(T,f);
    k = k_Tf(T,f); 
  end State;
  
  function Tf_h "Find temperature and liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absoulte temperature (K)";
    output Real f "mass liquid fraction";
  algorithm
    if h < cp1*(T_melt-298.15) then
      T := 298.15 + h/cp1;
      f := 0.0;
    elseif h > cp1*(T_melt-298.15)+h_melt then
      T := T_melt + (h-h_melt-cp1*(T_melt-298.15))/cp2;
      f := 1.0;
    else
      T := T_melt;
      f := (h-cp1*(T_melt-298.15))/h_melt;
    end if;
  end Tf_h;

  redeclare function h_Tf "find specific enthalpy from Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    if T < T_melt then
      h := cp1*(T-298.15);
    elseif T > T_melt then
      h := cp1*(T_melt-298.15)+h_melt+cp2*(T-T_melt);
    else
      h := cp1*(T_melt-298.15)+f*h_melt;
    end if;
  end h_Tf;
  
  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  algorithm
    k := k1*k2*((f-1)*rho2-f*rho1)/((f-1)*k2*rho2 - f*k1*rho1);
  end k_Tf;
    
  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := rho1*rho2/(rho2+f*rho1-f*rho2);
  end rho_Tf;
end FeSi2;