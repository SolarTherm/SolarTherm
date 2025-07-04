within SolarTherm.Materials;
package Sodium_Table
  extends SolarTherm.Materials.PartialMaterial(MM = 22.989769e-3, T_melt = 97.79 + 273.15, cost = 3.0, year = 2018);

  //Property Tables
  constant SI.Temperature T_data[22] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 650.00, 700.00, 750.00, 800.00, 850.00, 900.00, 950.00, 1000.00, 1050.00, 1100.00, 1150.00, 1200.00, 1250.00, 1300.00};
  
  constant SI.SpecificEnthalpy h_data[22] = {0.18, 2610.52, 72674.06, 141753.58, 209841.68, 276978.45, 343229.91, 408677.19, 473410.70, 537526.85, 601126.04, 664311.39, 727187.97, 789862.24, 852441.70, 915034.60, 977749.80, 1040696.62, 1103984.70, 1167723.99, 1232024.67, 1296997.09};
  
  constant SI.Density rho_data[22] = {941.69, 941.28, 930.31, 919.27, 908.17, 896.99, 885.75, 874.43, 863.03, 851.56, 840.00, 828.35, 816.62, 804.79, 792.85, 780.82, 768.67, 756.41, 744.03, 731.52, 718.87, 706.08};
  
  constant SI.ThermalConductivity k_data[22] = {95.33, 95.18, 91.09, 87.22, 83.56, 80.09, 76.81, 73.71, 70.77, 68.00, 65.38, 62.90, 60.56, 58.34, 56.24, 54.24, 52.35, 50.54, 48.81, 47.16, 45.57, 44.03};
  
  constant SI.SpecificHeatCapacity cp_data[22] = {1411.33, 1410.67, 1391.57, 1371.60, 1352.06, 1333.63, 1316.70, 1301.49, 1288.17, 1276.81, 1267.50, 1260.27, 1255.15, 1252.18, 1251.36, 1252.72, 1256.26, 1261.98, 1269.91, 1280.03, 1292.36, 1306.90};
  
  constant SI.DynamicViscosity mu_data[22] = {0.0010829, 0.0010679, 0.0007707, 0.0005992, 0.0004899, 0.0004152, 0.0003614, 0.0003209, 0.0002895, 0.0002644, 0.0002440, 0.0002271, 0.0002128, 0.0002006, 0.0001900, 0.0001808, 0.0001727, 0.0001656, 0.0001591, 0.0001533, 0.0001481, 0.0001434};
  
  redeclare model State
	SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
	SI.Temperature T "Absolute Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
    //Additional variables for a fluid
    SI.DynamicViscosity mu "Dynamic viscosity (Pas)";
    SI.SpecificHeatCapacity cp "Specific heat capacity (J/kgK)";
  equation
    T = Modelica.Math.Vectors.interpolate(h_data,T_data,h);
    f = 1.0; //This is a liquid
    rho = Modelica.Math.Vectors.interpolate(h_data,rho_data,h);
    k = Modelica.Math.Vectors.interpolate(h_data,k_data,h);
    mu = Modelica.Math.Vectors.interpolate(h_data,mu_data,h);
    cp = Modelica.Math.Vectors.interpolate(h_data,cp_data,h);
  end State;

  redeclare function h_Tf "Find specific enthalpy from Temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f = 1.0 "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := Modelica.Math.Vectors.interpolate(T_data,h_data,T);
  end h_Tf;
  
  redeclare function rho_Tf "Find density from temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f = 1.0 "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := Modelica.Math.Vectors.interpolate(T_data,rho_data,T);
  end rho_Tf;
  
  function mu_Tf "Find dynamic viscosity from temperature and liquid fraction"
    input SI.Temperature T;
    input Real f = 1.0 "Liquid mass fraction";
    output SI.DynamicViscosity mu "Dynamic viscosity (Pa.s)";
  algorithm
    mu := Modelica.Math.Vectors.interpolate(T_data,mu_data,T);
  end mu_Tf;
end Sodium_Table;