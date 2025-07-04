within SolarTherm.Materials;
package Al2O3 "Al2O3 constant cp and density, variable thermal conductivity"
  extends SolarTherm.Materials.PartialMaterial(MM = 101.9613e-3, T_melt = 2327.0, cost = 1.5, year = 2020);

  //Properties of Al2O3 are defined by constant cp_1, rho_1
  constant SI.SpecificHeatCapacity cp_1 = 900.0 "Specific heat capacity of solid (J/kgK)";
  constant SI.Density rho_1 = 3300.0 "Density of solid (kg/m3)";

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
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  algorithm
    k := 85.868 + (-0.22972*T) + ((2.607e-4)*(T^2)) + ((-1.3607e-7)*(T^3)) + ((2.7092e-11)*(T^4));
  end k_Tf;
  
  annotation(
    Documentation(info = "<html><head></head><body><p style=\"font-size: 12px;\"><b style=\"font-family: 'DejaVu Sans Mono';\">Assumptions:</b></p><div class=\"htmlDoc\" style=\"font-family: 'DejaVu Sans Mono';\"><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">Constant cp, density:</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">cp = 900.0 J/kgK</div><div style=\"font-size: 12px;\">rho = 3300.0 kg/m3</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">Lookup table for thermal conductivity:</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">k = f(T)&nbsp;</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">Unit cost of 1.5 USD_2020/kg (Private comm.)</div></div></body></html>"));
end Al2O3;