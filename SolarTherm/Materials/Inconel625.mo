within SolarTherm.Materials;
package Inconel625 "Inconel 625, temperature dependent properties calculated using lookup table at 50K intervals, constant density of 8440 kg/m3"
  extends SolarTherm.Materials.PartialMaterial(MM = 61.457e-3, T_melt = 1290+273.15, cost = 34.5, year = 2018);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  
  //Property Tables
  constant SI.Temperature T_data[22] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 550.00, 600.00, 650.00, 700.00, 750.00, 800.00, 850.00, 900.00, 950.00, 1000.00, 1050.00, 1100.00, 1150.00, 1200.00, 1250.0, 1300.0};
  
  constant SI.SpecificEnthalpy h_data[22] = {0.00, 758.50, 21595.95, 42945.95, 65118.10, 87918.10, 111139.35, 135189.35, 159399.85, 184949.85, 210499.85, 237158.60, 263958.60, 290758.60, 317558.60, 348784.50, 378284.50, 408125.00, 439125.00, 470133.75, 502383.75, 534633.75};
    
  constant SI.ThermalConductivity k_data[22] = {9.87, 9.90, 10.59, 11.32, 12.08, 12.83, 13.54, 14.26, 14.98, 15.70, 16.51, 17.32, 18.03, 18.70, 19.45, 20.26, 21.10, 22.00, 22.93, 24.01, 25.09, 26.17};
    
  redeclare model State "A model which calculates state and properties"
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Absolute Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
  equation
    T = Modelica.Math.Vectors.interpolate(h_data,T_data,h);
    f = 0.0;
    rho = 8440.0;
    k = Modelica.Math.Vectors.interpolate(h_data,k_data,h);
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := Interpolate1D(T_data,h_data,T);
  end h_Tf;
  
  redeclare function rho_Tf "find density from temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 8440.0;
  end rho_Tf;
  annotation(
    Documentation(info = "<html><head></head><body><b>Assumptions:</b><div><br></div><div>Properties of Inconel [1]. Rescaled to lookup tables with 50K intervals. Temperature range = 298.15 - 1300 K. Density assumed constant at 8440 kg/m3</div><div><br></div><div>Unit cost of 34.5 USD_2018/kg [2].</div><div><br></div><div><b>References:</b></div><div><b><br></b></div><div>[1] Special Metals Corporation. 2013. Inconel alloy 625. url: https://www.specialmetals.com/documents/technical-bulletins/inconel/inconel-alloy-625.pdf.</div><div><br></div><div>[2] MetalMiner. Nickel Alloy 625 Sheet US. url: https://agmetalminer.com/metal-prices/nickel-alloy/.</div></body></html>"));
end Inconel625;