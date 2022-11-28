within SolarTherm.Materials;
package Copper
  extends SolarTherm.Materials.PartialMaterial(MM = 63.546e-3, T_melt = 1358.0, cost = 8.00);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  
  //constant SI.MolarMass MM = 59e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 1290+273.15 "Melting point (K)";
  //constant Real cost = 34.5 "USD/kg";
    
  redeclare model State "A model which calculates state and properties"
  	parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/Copper.txt");
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
	Tables.CombiTable1Ds Tab (tableOnFile=true, tableName="table_1D_1", columns=2:5, fileName=table_file);
	
  equation
	Tab.u = h;
	T = Tab.y[1];
	f = Tab.y[2];
	rho = Tab.y[3];
	k = Tab.y[4];
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  protected
    Real T_data[6] = {298.15,400.0,600.0,800.0,1000.0,1200.0};
    Real h_data[6] = {0.0,39371.17,120771.17,205771.17,294171.17,387271.17};
  algorithm
    h := Interpolate1D(T_data,h_data,T);
  end h_Tf;
  
  redeclare function rho_Tf "find density from temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 8933.0;
  end rho_Tf;
end Copper;