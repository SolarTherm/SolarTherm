within SolarTherm.Media.Materials;
package PCM710_UniSA "40.55%NaCl + 59.45%Na2CO3"
  extends SolarTherm.Media.Materials.PartialMaterial(MM = 120.873e-3, T_melt = 980.07, cost = 0.51);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  redeclare model State "A model which calculates state and properties"
    parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/PCM710_UniSA.txt");
	
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
    if T <= 979.57 then //solid 
      h := 1540.0*(T-298.15);
    elseif T >= 980.57 then //liquid
      h := 1182526.80+ 1500.0*(T-980.57);
    else
      h := 1049386.80  + (T - 979.57)*133140;
    end if;
  end h_Tf;
  
  redeclare function rho_Tf "Find the density based on Temperature and liquid mass fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
      rho := 2000.0;
  end rho_Tf;

end PCM710_UniSA;
