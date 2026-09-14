within SolarTherm.Validation.Laing2006_Annular.Resources.Laing2006_ConcreteVar_Dataset.Materials;

package Concrete_Laing_2006_Constant
  extends SolarTherm.Materials.PartialMaterial(MM = 100.0, T_melt = 1500.00, cost = 1.000, year = 2006);
  
  //Properties of Quartzite_Sand are defined by constant cp_1, rho_1 and k_1
  constant SI.SpecificHeatCapacity cp_1 = 916.0 "Specific heat capacity of PCM solid (J/kgK)";
  constant SI.Density rho_1 = 2750.0 "Density of PCM solid (kg/m3)";
  constant SI.ThermalConductivity k_1 = 1.0 "Thermal conductivity of solid (W/mK)";
  
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
  annotation(
      Documentation(info = "<html><head></head><body></body></html>"));end rho_Tf;
  annotation(
    Documentation(info = "<html><head></head><body><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Assumptions:</b><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Properties of High temperature concrete [1] used for validation. Constant cp, density and thermal conductivity (provided at 350.0 degC).</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">cp = 916.0 J/kgK</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">rho = 2750 kg/m3</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">k = 1.0 W/mK</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Ignore molar mass, melting temperature and unit cost.</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>References:</b></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b><br></b></div><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">[1] Laing D, Steinmann W, Tamme R, Richter C. 2006. Solid media thermal storage for parabolic trough power plants, Solar Energy, vol 80. pp 1283-1289.</span></div><div><br></div><div><br></div></body></html>"));
end Concrete_Laing_2006_Constant;