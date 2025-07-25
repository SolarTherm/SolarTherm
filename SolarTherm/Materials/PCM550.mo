within SolarTherm.Materials;
package PCM550 "20%Li2CO3 + 60%Na2CO3 + 20%K2CO3, sharp melting point of 823.15 K and constant phasewise properties"
  extends SolarTherm.Materials.PartialMaterial(MM = 106.012e-3, T_melt = 823.15, cost = 0.46, year = 2010);
  
  constant SI.SpecificEnthalpy h_melt = 283000.0 "Specific latent heat of fusion (J/kg)";
  
  constant SI.SpecificHeatCapacity cp_1 = 1590.0 "Specific heat capacity of PCM solid (J/kgK)";
  constant SI.SpecificHeatCapacity cp_2 = 1880.0 "Specific heat capacity of PCM liquid (J/kgK)"; 
  
  constant SI.Density rho_1 = 2380.0 "Density of PCM solid (kg/m3)";
  constant SI.Density rho_2 = 2380.0 "Density of PCM liquid (kg/m3)";
  
  constant SI.ThermalConductivity k_1 = 1.83 "Thermal conductivity of solid (W/mK)";
  constant SI.ThermalConductivity k_2 = 1.83 "Thermal conducitvity of liquid (W/mK)";
  
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
    if h < cp_1*(T_melt-298.15) then
      T := 298.15 + h/cp_1;
      f := 0.0;
    elseif h > cp_1*(T_melt-298.15)+h_melt then
      T := T_melt + (h-h_melt-cp_1*(T_melt-298.15))/cp_2;
      f := 1.0;
    else
      T := T_melt;
      f := (h-cp_1*(T_melt-298.15))/h_melt;
    end if;
  end Tf_h;

  redeclare function h_Tf "find specific enthalpy from Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    if T < T_melt then
      h := cp_1*(T-298.15);
    elseif T > T_melt then
      h := cp_1*(T_melt-298.15)+h_melt+cp_2*(T-T_melt);
    else
      h := cp_1*(T_melt-298.15)+f*h_melt;
    end if;
  end h_Tf;
  
  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.ThermalConductivity k "Thermal conductivity (W/mK)";
  algorithm
    k := k_1*k_2*((f-1.0)*rho_2-f*rho_1)/((f-1.0)*k_2*rho_2 - f*k_1*rho_1);
  end k_Tf;
    
  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := rho_1*rho_2/(rho_2+f*rho_1-f*rho_2);
  end rho_Tf;
  
  annotation(
    Documentation(info = "<html><head></head><body><p style=\"font-size: 12px;\"><b style=\"font-family: 'DejaVu Sans Mono';\">Assumptions:</b></p><div class=\"htmlDoc\" style=\"font-family: 'DejaVu Sans Mono';\"><div class=\"htmlDoc\" style=\"font-size: 12px;\"><div>Constant phasewise cp, density, thermal conductivity:</div><div><br></div><div><div>Enthalpy of fusion:</div><div>T_melt &nbsp;= 550 degC or 823.15 K</div><div>h_melt = 283000 J/kg</div></div><div><br></div><div>Solid Phase:</div><div>cp_1 = 1590.0 J/kgK</div><div>rho_1 = 2380 kg/m3 (assumed equal to solid at 25 degC)</div><div>k_1 = &nbsp;1.83 W/mK (assumed equal to k_2)</div><div><br></div><div>Liquid Phase:</div><div>cp_2 = 1880.0 J/kgK</div><div>rho_2 = 2380 kg/m3 (assumed equal to solid at 25 degC)</div><div>k_2 = 1.83 W/mK</div><div><br></div><div><br></div><div>Unit Cost:</div><div>0.43 USD_2010/kg</div><div><br></div><div><b>References:</b></div><div><b><br></b></div><div>[1] M. M. Kenisarin. 2010. High-temperature phase change materials for thermal energy storage. <i>Renewable and Sustainable Energy Reviews. </i>vol 14. pp. 955-970.</div></div></div></body></html>"));

end PCM550;