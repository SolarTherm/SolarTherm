within SolarTherm.Materials;

package SS316L
  extends SolarTherm.Materials.PartialMaterial(MM = 54.97e-3, T_melt = 1371+273.15, cost = 4.00);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.MolarMass MM = 10.1646 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 1371+273.15 "Melting point (K)";
  //constant Real cost = 4.004 "USD/kg";

  redeclare model State "A model which calculates state and properties"
  	parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/SS316L.txt");
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
    Real T_data[9] = {298.15,418.15,533.15,648.15,758.15,868.15,978.15,1088.15,1198.15};
    Real h_data[9] = {0.0,58320.0,119040.0,182060.0,244210.0,307240.0,371700.0,439350.0,510740.0};
  algorithm
    h := Interpolate1D(T_data,h_data,T);
  end h_Tf;
  
  redeclare function rho_Tf "find density from temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  protected
    Real T_data[10] = {293.15,363.15,473.15,593.15,703.15,813.15,923.15,1033.15,1143.15,1253.15};
    Real rho_data[10] = {7950.0,7920.0,7880.0,7830.0,7790.0,7740.0,7690.0,7640.0,7590.0,7540.0};
  algorithm
    rho := Interpolate1D(T_data,rho_data,T);
  end rho_Tf;
  
  function sigma_yield "Obtain yield stress in Pa"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.Stress sigma "Yield stress (Pa)";
  protected
    Real T_C = T - 273.15 "Centigrade temperature";
    Real T_data[8] = {27,149,260,371,482,593,704,816} "Temperature in Celcius";
    Real sigma_data[8] = {290,201,172,159,148,140,131,110} "Yield stress in MPa";
  algorithm
    sigma := 1.0e6*Interpolate1D(T_data,sigma_data,T_C);
  end sigma_yield;
end SS316L;
