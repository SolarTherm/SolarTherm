within SolarTherm.Materials;
package PCM_520 "17%NaF + 21%KF + 62%K2CO3"
  extends SolarTherm.Materials.PartialMaterial(MM = 82.308e-3, T_melt = 793.15, cost = 0.40);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.MolarMass MM = 26.9815386e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 933.47 "Melting point (K)";
  //constant Real cost = 1.8 "USD/kg";

  redeclare model State "A model which calculates state and properties"
    parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/17NaF_21KF_62K2CO3.txt");
	
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
    if T < T_melt then
    //if f <= 0.0 then //solid
      h := 1170.0*(T-298.15);
    elseif T > T_melt then
    //elseif f >= 1.0 then //liquid
      h := 853150.0 + 1380.0*(T-793.15);
    else
      h := 579150.0 + f*(274000.0);
    end if;
  end h_Tf;
  
  redeclare function rho_Tf "Find the density based on Temperature and liquid mass fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 2380.0;
  end rho_Tf;

  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  algorithm
    k := 1.50;
  end k_Tf;
  
  function Tf_h "Find temperature and liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absoulte temperature (K)";
    output Real f "mass liquid fraction";
  algorithm
    if h <= 579150.0 then
      f := 0.0;
      T := 298.15 + (h/1170.0);
    elseif h >= 853150.0 then
      f := 1.0;
      T := 793.15 + (h - 853150.0)/1380.0;
    else
      T := 793.15;
      f := (h - 579150.0)/274000.0;
    end if;
  end Tf_h;
end PCM_520;