within SolarTherm.Media.Materials;
package PCM569_UniSA "25.43%NaCl + 33.0% KCl + 41.57%Na2CO3"
  extends SolarTherm.Media.Materials.PartialMaterial(MM = 78.742e-3, T_melt = 842.39, cost = 0.13);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  redeclare model State "A model which calculates state and properties"
    parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/PCM569_UniSA.txt");
	
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
    if T <= 841.89 then //solid 
      h := 1340.0*(T-298.15);
    elseif T >= 842.89 then //liquid
      h := 972691.6 + 1410.0*(T-842.89);
    else
      h := 728611.6 + (T - 841.89)*244080.0;
    end if;
  end h_Tf;

  redeclare function rho_Tf "Find the density based on Temperature and liquid mass fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    if T<= 842.39 then
      rho := 2000.0;
    else 
      rho := 1700.0;
    end if;
  end rho_Tf;
  
end PCM569_UniSA;
