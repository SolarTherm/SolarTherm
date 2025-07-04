within SolarTherm.Materials;

package SS316L "Stainless Steel 316L, variable properties calculated using 50K-interval lookup table, 298.15 - 1200 K"
  extends SolarTherm.Materials.PartialMaterial(MM = 54.97e-3, T_melt = 1371+273.15, cost = 4.004, year = 2018);
  
  //Property Tables
  constant SI.Temperature T_data[20] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 650.00, 700.00, 750.00, 800.00, 850.00, 900.00, 950.00, 1000.00, 1050.00, 1100.00, 1150.00, 1200.00};
  
  constant SI.SpecificEnthalpy h_data[20] = {0.00, 899.10, 25199.10, 49499.10, 75136.80, 101536.80, 128273.80, 155673.80, 183105.25, 211355.25, 239605.25, 268190.05, 296840.05, 325904.10, 355204.10, 385137.75, 415887.75, 447040.65, 479490.65, 511940.65};
  
  constant SI.Density rho_data[20] = {7947.85, 7947.06, 7925.64, 7906.60, 7888.42, 7868.81, 7847.98, 7827.51, 7809.33, 7791.15, 7768.70, 7745.98, 7723.25, 7700.52, 7677.80, 7655.07, 7632.34, 7609.61, 7586.89, 7564.16};
  
  constant SI.ThermalConductivity k_data[20] = {13.35, 13.38, 14.13, 14.83, 15.52, 16.21, 16.91, 17.61, 18.26, 18.91, 19.33, 19.73, 20.53, 21.47, 22.20, 22.74, 23.34, 24.03, 24.73, 25.44};
  
  redeclare model State "A model which calculates state and properties"
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Absolute Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
 equation
    T = Modelica.Math.Vectors.interpolate(h_data,T_data,h);
    f = 0.0;
    rho = Modelica.Math.Vectors.interpolate(h_data,rho_data,h);
    k = Modelica.Math.Vectors.interpolate(h_data,k_data,h);
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := Modelica.Math.Vectors.interpolate(T_data,h_data,T);
  end h_Tf;
  
  redeclare function rho_Tf "find density from temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := Modelica.Math.Vectors.interpolate(T_data,rho_data,T);
  end rho_Tf;
  
  function sigma_yield "Obtain yield stress in Pa"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.Stress sigma "Yield stress (Pa)";
  protected
    Real T_C = T - 273.15 "Centigrade temperature";
    Real T_C_data[8] = {27,149,260,371,482,593,704,816} "Temperature in Celcius";
    Real sigma_data[8] = {290,201,172,159,148,140,131,110} "Yield stress in MPa";
  algorithm
    sigma := 1.0e6*Modelica.Math.Vectors.interpolate(T_C_data,sigma_data,T_C);
  end sigma_yield;
  annotation(
    Documentation(info = "<html><head></head><body><b>Assumptions:</b><div><b><br></b></div><div>Stainless Steel 316L properties [1] rescaled to a lookup table with 50K temperature intervals. Temperature range = 298.15 - 1200 K</div><div><br></div><div>Unit cost of 4.004 USD_2018/kg [2]</div><div><br></div><div><b>References:</b></div><div><b><br></b></div><div>[1] INCO. 1963. Engineering properties at elevated temperatures. Report No: INCO-2980.</div><div><br></div><div>[2] MEPS. World Stainless Steel Prices - US/metric ton.</div></body></html>"));
end SS316L;