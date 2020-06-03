within SolarTherm.Materials;
package Inconel625
  extends SolarTherm.Media.Materials.PartialMaterial(MM = 59e-3, T_melt = 1290+273.15, cost = 34.5);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  
  //constant SI.MolarMass MM = 59e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 1290+273.15 "Melting point (K)";
  //constant Real cost = 34.5 "USD/kg";
    
  redeclare model State "A model which calculates state and properties"
  	parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/Inconel625.txt");
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
    Real T_data[11] = {298.15,330.15,421.65,533.15,644.65,755.65,866.65,977.65,1088.65,1199.65,1310.65};
    Real h_data[11] = {0.0,13120.0,52190.5,103034.5,156666.0,213387.0,272883.0,335598.0,401088.0,469908.0,541503.0};
  algorithm
    h := Interpolate1D(T_data,h_data,T);
  end h_Tf;
  
  redeclare function rho_Tf "find density from temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy rho "Density (kg/m3)";
  algorithm
    rho := 8440.0;
  end rho_Tf;
end Inconel625;
