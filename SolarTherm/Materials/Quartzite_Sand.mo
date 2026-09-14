within SolarTherm.Materials;
package Quartzite_Sand
  extends SolarTherm.Materials.PartialMaterial(MM = 60.08e-3, T_melt = 1670.0+273.15, cost = 0.072, year = 2002);
  
  //Properties of Quartzite_Sand are defined by constant cp_1, rho_1 and k_1
  constant SI.SpecificHeatCapacity cp_1 = 1050.0 "Specific heat capacity of PCM solid (J/kgK)";
  constant SI.Density rho_1 = 2640.0 "Density of PCM solid (kg/m3)";
  constant SI.ThermalConductivity k_1 = 2.50 "Thermal conductivity of solid (W/mK)";
  
  redeclare model State "A model which calculates state and properties"
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Temperature (K)";
	Real f "Liquid Mass Fraction (-)";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
  equation
	//h = cp1*T - (cp1*298.15);
	T = 298.15 + h/cp_1;
	f = 0.0;
	rho = rho_1;
	k = k_1; 
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := cp_1*(T - 298.15);
  end h_Tf;
  
  redeclare function rho_Tf "find density from temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := rho_1;
  end rho_Tf;
  annotation(
    Documentation(info = "<html><head></head><body><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Assumptions:</b><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Properties of Quartzite-Sand from Van Lew 2011 [1]. Constant cp, density and thermal conductivity.</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">cp = 1050.0 J/kgK</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">rho = 2640.0 kg/m3</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">k = 2.50 W/mK</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Unit cost of 0.072 USD_2002/kg based on a mixed-filler cost of $72/tonne in Pacheco's work [2].</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>References:</b></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b><br></b></div><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">[1] </span><font face=\"DejaVu Sans Mono\">J. T. Van Lew, P. Li, C. L. Chan, W. Karaki, and J. Stephens. 2011. Analysis of heat&nbsp;</font><span style=\"font-family: 'DejaVu Sans Mono';\">storage and delivery of a thermocline tank having solid filler material. <i>Journal of&nbsp;</i></span><span style=\"font-family: 'DejaVu Sans Mono';\"><i>Solar Energy Engineering</i> vol. 133, no. 2, doi: 10.1115/1.4003685.</span></div><div><span style=\"font-family: 'DejaVu Sans Mono';\"><br></span></div><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">[2] J. E. Pacheco, S. K. Showalter, W. J. Kolb, 2002. Development of a Molten-Salt Thermocline Thermal Storage System for Parabolic Trough Plant.&nbsp;</span><i style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Journal of Solar Energy Engineering</i><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">. vol. 124, doi: 10.1115/1.1464123</span></div><div><br></div><div><br></div></body></html>"));
    
end Quartzite_Sand;