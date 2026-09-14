within SolarTherm.Materials;
package Aluminium "Aluminium PCM, properties calculated using lookup tables at 50K intervals, sharp melting point of 933.47 K"
  extends SolarTherm.Materials.PartialMaterial(MM = 26.9815386e-3, T_melt = 933.47, cost = 1.8, year = 2018);

  //Full Property Tables
  constant SI.Temperature T_data[24] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 650.00, 700.00, 750.00, 800.00, 850.00, 900.00, 933.47, 933.47, 950.00, 1000.00, 1050.00, 1100.00, 1150.00, 1200.00, 1250.00, 1300.00};
  
  constant SI.SpecificEnthalpy h_data[24] = {-17.75, 1648.25, 47442.59, 94631.38, 142921.69, 192188.59, 242400.87, 293584.04, 345800.30, 399137.16, 453700.59, 509610.73, 566999.15, 626006.95, 666485.58, 1063354.83, 1082806.82, 1141645.27, 1200483.73, 1259322.18, 1318160.63, 1376999.09, 1435837.54, 1494675.99};
  
  constant Real f_data[24] = {0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00};
  
  constant SI.Density rho_data[24] = {2795.97, 2795.15, 2772.95, 2750.76, 2728.57, 2706.38, 2684.19, 2662.00, 2639.81, 2617.62, 2595.43, 2573.24, 2551.05, 2528.85, 2514.00, 2391.00, 2386.04, 2371.03, 2356.03, 2341.02, 2326.02, 2311.01, 2296.01, 2281.00};
  constant SI.ThermalConductivity k_data[24] = {204.39, 204.34, 202.86, 201.37, 199.88, 198.39, 196.91, 195.42, 193.93, 192.45, 190.96, 189.47, 187.98, 186.50, 185.50, 89.30, 89.83, 91.42, 93.02, 94.62, 96.21, 97.81, 99.40, 101.00};
  
  //Phasewise Property Tables
  //Solid Phase
    constant SI.Temperature T_s_data[15] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 650.00, 700.00, 750.00, 800.00, 850.00, 900.00, 933.47};
    
    constant SI.SpecificEnthalpy h_s_data[15] = {-17.75, 1648.25, 47442.59, 94631.38, 142921.69, 192188.59, 242400.87, 293584.04, 345800.30, 399137.16, 453700.59, 509610.73, 566999.15, 626006.95, 666485.58};
    
    constant SI.Density rho_s_data[15] = {2795.97, 2795.15, 2772.95, 2750.76, 2728.57, 2706.38, 2684.19, 2662.00, 2639.81, 2617.62, 2595.43, 2573.24, 2551.05, 2528.85, 2514.00};
    
    //Liquid Phase
    constant SI.Temperature T_l_data[9] = {933.47, 950.00, 1000.00, 1050.00, 1100.00, 1150.00, 1200.00, 1250.00, 1300.00};
    
    constant SI.SpecificEnthalpy h_l_data[9] = {1063354.83, 1082806.82, 1141645.27, 1200483.73, 1259322.18, 1318160.63, 1376999.09, 1435837.54, 1494675.99};
    
    constant SI.Density rho_l_data[9] = {2391.00, 2386.04, 2371.03, 2356.03, 2341.02, 2326.02, 2311.01, 2296.01, 2281.00};
    
  redeclare model State "A model which calculates state and properties"
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Absolute Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
  equation
    T = Modelica.Math.Vectors.interpolate(h_data,T_data,h);
    f = Modelica.Math.Vectors.interpolate(h_data,f_data,h);
    rho = Modelica.Math.Vectors.interpolate(h_data,rho_data,h);
    k = Modelica.Math.Vectors.interpolate(h_data,k_data,h);
  end State;
  
  redeclare function h_Tf "Find specific enthalpy from temperature and liquid mass fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    if T < T_melt then //Solid
      h := Modelica.Math.Vectors.interpolate(T_s_data,h_s_data,T);
    elseif T > T_melt then //Liquid
      h := Modelica.Math.Vectors.interpolate(T_l_data,h_l_data,T);
    else //Mushy
      h := (1.0-f)*h_s_data[end] + f*h_l_data[1];
    end if;
  end h_Tf;
  
  redeclare function rho_Tf "Find the density based on Temperature and liquid mass fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    if T < T_melt then //Solid
      rho := Modelica.Math.Vectors.interpolate(T_s_data,rho_s_data,T);
    elseif T > T_melt then //Liquid
      rho := Modelica.Math.Vectors.interpolate(T_l_data,rho_l_data,T);
    else //Mushy
      rho := (1.0-f)*rho_s_data[end] + f*rho_l_data[1];
    end if;
  end rho_Tf;
  annotation(
    Documentation(info = "<html><head></head><body><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Assumptions:</b><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Properties of Aluminium, enthalpy based on NIST-JANAF schomate equations. Rescaled to lookup tables with 50K intervals. Temperature range = 298.15 - 1300 K.&nbsp;</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Unit cost of 1.8 USD_2018/kg.</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>References:</b></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b><br></b></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">TBA</div></body></html>"));

end Aluminium;