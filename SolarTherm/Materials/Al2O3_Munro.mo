within SolarTherm.Materials;
package Al2O3_Munro //Properties are based on Munro 1997. Specific enthalpy was obtained by integrating specific heat capacity with reference temperature of 273.15K or 0degC as Anderson's minimum temperature was below RTP.
  extends SolarTherm.Materials.PartialMaterial(MM = 101.9613e-3, T_melt = 2327.0, cost = 1.5);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.MolarMass MM = 56.077e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 3200.0 "Melting point (K)";
  //constant Real cost = 0.2 "USD/kg";

  redeclare model State "A model which calculates state and properties"
	
	parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/Al2O3_Munro.txt");
	
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

  redeclare function h_Tf "find specific enthalpy from Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := -368386.06+1078.76*T+0.07*T*T+68500.0*exp(1.6389-0.006*T);
  end h_Tf;
    
  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  protected
    Real TC "Temperature in degC";
  algorithm
    TC := T - 273.15;
    rho := 1000.0*(3.9853 - (7.158E-5)*TC - (3.035E-8)*(TC^2.0) + (7.232E-12)*(TC^3.0));
  end rho_Tf;
end Al2O3_Munro;