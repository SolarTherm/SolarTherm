within SolarTherm.Materials;
package CaO
  extends SolarTherm.Materials.PartialMaterial(MM = 56.077e-3, T_melt = 3200.0, cost = 0.2, year = 2020);

  //Properties of CaO are defined by constant cp_1, rho_1
  constant SI.SpecificHeatCapacity cp_1 = 900.0 "Specific heat capacity of PCM solid (J/kgK)";
  constant SI.Density rho_1 = 3340.0 "Density of PCM solid (kg/m3)";
  
  //Thermal Conductivity lookup tables
  constant SI.Temperature T_data[6] = {373.15,473.15,673.15,873.15,1073.15,1273.15} "Absolute temperature table (K)";
  constant SI.ThermalConductivity k_data[6] = {15.22976,11.0876,9.16296,8.28432,7.99144,7.78224} "Thermal conductivity table (K)";

  redeclare model State "A model which calculates state and properties"
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
	
  equation
    T = 298.15 + h/cp_1;
    f = 0.0;
    rho = rho_1;
    k = k_Tf(T,0);
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := cp_1*(T-298.15);
  end h_Tf;
    
  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := rho_1;
  end rho_Tf;
  
  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction (-) not used";
    output SI.ThermalConductivity k "Thermal conductivity (W/mK)";
  algorithm
    k := Modelica.Math.Vectors.interpolate(T_data,k_data,T);
  end k_Tf;
  annotation(
    Documentation(info = "<html><head></head><body><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Assumptions:</b><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Constant cp, density:</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">cp = 900.0 J/kgK</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">rho = 3340.0 kg/m3</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Lookup table for thermal conductivity:</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">k = f(T)&nbsp;</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Unit cost of 0.2 USD_2020/kg (Private comm.)</div></body></html>"));
end CaO;