within SolarTherm.Media.Materials;
package PCM635_UniSA "40.55%NaCl + 59.45%Na2CO3"
  extends SolarTherm.Media.Materials.PartialMaterial(MM = 79.699e-3, T_melt = 908.15, cost = 0.12);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  redeclare model State "A model which calculates state and properties"
    parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/PCM635_UniSA.txt");
	
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
    if T <= 907.65 then //solid 
      h := 1250.0*(T-298.15);
    elseif T >= 908.65 then //liquid
      h := 1073475.0 + 1550.0*(T-908.65);
    else
      h := 761875.0 + (T - 907.65)*311600.0;
    end if;
  end h_Tf;
  
  redeclare function rho_Tf "Find the density based on Temperature and liquid mass fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 2070.0;
  end rho_Tf;

//  redeclare function k_T "find thermal conductivity from Temperature"
//    input SI.Temperature T "Absolute temperature (K)";
//    input Real f "Liquid mass fraction";
//    output SI.ThermalConductivity k "Specific Enthalpy (J/kg)";
//  algorithm
//    if T <= 907.65 then //solid 
//      k := 1.5;
//    elseif T >= 908.65 then //liquid
//      k := 0.5;
//    else
//      k := 0.5 + (1.0 - ((T - 907.65)));
//    end if;
//  end k_T;

end PCM635_UniSA;
