within SolarTherm.Materials;
package PCM_650 "33.4%LiF + 49.9%NaF + 17.1%MgF2"
  extends SolarTherm.Materials.PartialMaterial(MM = 36.357e-3, T_melt = 923.15, cost = 2.387);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.MolarMass MM = 26.9815386e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 933.47 "Melting point (K)";
  //constant Real cost = 1.8 "USD/kg";

  redeclare model State "A model which calculates state and properties"
    parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/334LiF_499NaF_171MgF2.txt");
	
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
    input Real f "liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    if f <= 0.0 then //solid
      h := 1420.0*(T-298.15); //h := cp_s*(T-298.15)
    elseif f >= 1.0 then //liquid
      h := 1747500.0 + 1420.0*(T-923.15); //h := cp_s*(T_melt-298.15) + h_melt + cp_l*(T-T_melt)
    else
      h := 887500.0 + f*(860000); //h := cp_s*(T_melt-298.15) + f*h_melt
    end if;
  end h_Tf;
  
  redeclare function rho_Tf "Find the density based on Temperature and liquid mass fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 2820.0;
  end rho_Tf;

end PCM_650;