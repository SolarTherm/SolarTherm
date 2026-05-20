within SolarTherm.Materials;
package PigIron "Pig Iron constant cp and density and thermal conductivity"
  extends SolarTherm.Materials.PartialMaterial(MM = 55.845e-3, T_melt = 1811.150, cost = 0.5, year = 2020);

  //Properties of Al2O3 are defined by constant cp_1, rho_1
  constant SI.SpecificHeatCapacity cp_1 = 700.0 "Specific heat capacity of solid (J/kgK)";
  constant SI.Density rho_1 = 7900.0 "Density of solid (kg/m3)";
  constant SI.ThermalConductivity k_1 = 51.0 "Thermal conductivity of solid (W/mK)";

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
    k = k_1;
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
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  algorithm
    k := k_1;
  end k_Tf;
  annotation(
    Documentation(info = "<html><head></head><body><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>Assumptions:</b></p><div class=\"htmlDoc\" style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><div>Constant cp, density, thermal conductivity:</div><div><br></div><div>cp = 700.0 J/kgK</div><div>rho = 7900.0 kg/m3</div><div>k = 51.0 W/mK</div><div><br></div><div>Unit cost of 0.5 USD_2020/kg (Private comm.)</div></div></body></html>"));
end PigIron;