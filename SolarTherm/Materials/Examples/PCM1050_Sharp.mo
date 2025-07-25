within SolarTherm.Materials.Examples;

package PCM1050_Sharp"A ficticious PCM material that melts at 1050degC with a sharp melting temperature"
  extends SolarTherm.Materials.PartialMaterial(MM = 100.00e-3, T_melt = 1323.15, cost = 4.00, year = 2022);
  
  constant SI.SpecificEnthalpy h_melt = 500000.0 "Specific latent heat of fusion (J/kg)";
  
  constant SI.SpecificHeatCapacity cp_1 = 900.0 "Specific heat capacity of PCM solid (J/kgK)";
  constant SI.SpecificHeatCapacity cp_2 = 1100.0 "Specific heat capacity of PCM liquid (J/kgK)"; 
  
  constant SI.Density rho_1 = 2600.0 "Density of PCM solid (kg/m3)";
  constant SI.Density rho_2 = 2400.0 "Density of PCM liquid (kg/m3)";
  
  constant SI.ThermalConductivity k_1 = 22.0 "Thermal conductivity of solid (W/mK)";
  constant SI.ThermalConductivity k_2 = 18.0 "Thermal conducitvity of liquid (W/mK)";
  
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
    Documentation(info = "<html><head></head><body><p style=\"font-size: 12px;\"><b style=\"font-family: 'DejaVu Sans Mono';\">Model Description:</b></p><p style=\"font-size: 12px;\"><span style=\"font-family: 'DejaVu Sans Mono';\">Note that this is a ficticious PCM material, not to be used for any technoeconomics.</span></p><p style=\"font-size: 12px;\">1. Phase change material with constant phasewise cp, density and thermal conductivity.</p><p style=\"font-size: 12px;\">2. Sharp melting temperature T_melt.</p><p style=\"font-size: 12px;\">3. Thermal conductivity is calculated based on a sharp melting front.</p><div class=\"htmlDoc\" style=\"font-family: 'DejaVu Sans Mono';\"><div class=\"htmlDoc\" style=\"font-size: 12px;\"><div><b>Properties:</b></div><div><br></div><div>Unit storage cost = 4.00 USD</div><div>T_melt = 1323.15 K or 1050 degC</div><div>h_melt = 500000 J/kg</div><div><br></div><div>Specific heat capacity:</div><div>cp_1 = 900.0 J/kgK (solid)</div><div>cp_2 = 1100.0 J/kgK (liquid)</div><div><br></div><div>Density:</div><div>rho_1 = 2600.0 kg/m3 (solid)</div><div>rho_2 = 2400.0 kg/m3 (liquid)</div><div><br></div><div>Thermal conductivity:</div><div>k_1 = 22.0 W/mK (solid)</div><div>k_2 = 18.0 W/mK (liquid)</div><div><br></div></div></div></body></html>"));
end PCM1050_Sharp;