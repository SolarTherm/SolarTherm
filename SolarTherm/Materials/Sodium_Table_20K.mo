within SolarTherm.Materials;
package Sodium_Table_20K
  extends SolarTherm.Materials.PartialMaterial(MM = 22.989769e-3, T_melt = 97.79 + 273.15, cost = 3.0);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  
  //constant SI.MolarMass MM = 22.989769e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 97.79 + 273.15 "Melting point (K)";
  //constant Real cost = 3.0 "USD/kg";
  constant SI.SpecificEnthalpy h_data[22] = {503167.0, 528775.6, 554299.2, 579744.3, 605117.7, 630425.8, 655675.4, 680873.4, 706026.3, 731141.1, 756224.6, 781283.7, 806325.2, 831356.1, 856383.3, 881413.8, 906454.4, 931512.2, 956594.2, 981707.3, 1006858.6, 1032055.0};
  constant SI.Temperature T_data[22] = {673.15, 693.15, 713.15, 733.15, 753.15, 773.15, 793.15, 813.15, 833.15, 853.15, 873.15, 893.15, 913.15, 933.15, 953.15, 973.15, 993.15, 1013.15, 1033.15, 1053.15, 1073.15, 1093.15};
  constant SI.SpecificHeatCapacity cp_data[22] = {1282.661, 1278.250, 1274.164, 1270.406, 1266.980, 1263.888, 1261.133, 1258.715, 1256.637, 1254.901, 1253.507, 1252.458, 1251.753, 1251.395, 1251.383, 1251.719, 1252.403, 1253.436, 1254.819, 1256.551, 1258.634, 1261.068};
  constant SI.DynamicViscosity mu_data[22] = {0.0002771840, 0.0002675282, 0.0002586400, 0.0002504326, 0.0002428316, 0.0002357730, 0.0002292011, 0.0002230678, 0.0002173307, 0.0002119527, 0.0002069013, 0.0002021475, 0.0001976657, 0.0001934332, 0.0001894296, 0.0001856368, 0.0001820383, 0.0001786195, 0.0001753671, 0.0001722690, 0.0001693144, 0.0001664934};
  constant SI.ThermalConductivity k_data[22] = {69.47130, 68.37259, 67.29835, 66.24803, 65.22106, 64.21686, 63.23487, 62.27451, 61.33523, 60.41645, 59.51760, 58.63811, 57.77743, 56.93497, 56.11017, 55.30247, 54.51128, 53.73606, 52.97621, 52.23119, 51.50041, 50.78332};
  constant SI.Density rho_data[22] = {857.7316, 853.1361, 848.5273, 843.9050, 839.2690, 834.6191, 829.9549, 825.2763, 820.5830, 815.8747, 811.1512, 806.4121, 801.6572, 796.8862, 792.0988, 787.2946, 782.4733, 777.6347, 772.7782, 767.9037, 763.0106, 758.0986};
  
  redeclare model State
    parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/Sodium_20K.txt");
    parameter SI.SpecificEnthalpy h_start=700000;
    SI.Density rho;
    SI.SpecificEnthalpy h (start=h_start);
    SI.Temperature T;
    SI.DynamicViscosity mu;
    SI.SpecificHeatCapacity cp;
    SI.ThermalConductivity k;
    Tables.CombiTable1Ds Tab (tableOnFile=true, tableName="table_1D_1", columns=2:6, fileName=table_file);
  equation
    	Tab.u = h;
	T = Tab.y[1];
	cp = Tab.y[2];
    mu = Tab.y[3];
    k = Tab.y[4];
    rho = Tab.y[5];
  end State;

  redeclare function h_Tf
    input SI.Temperature T;
    input Real f = 0 "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificEnthalpy h;
  algorithm
    h := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,h_data,T);
  end h_Tf;
  
  redeclare function rho_Tf
    input SI.Temperature T;
    input Real f = 0 "Liquid mass melt fraction (No effect on result)";
    output SI.Density rho;
  algorithm
    rho := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,rho_data,T);
  end rho_Tf;
  
  function mu_T
    input SI.Temperature T;
    output SI.DynamicViscosity mu;
  algorithm
    mu := SolarTherm.Utilities.Interpolation.Interpolate1D(T_data,mu_data,T);
  end mu_T;
end Sodium_Table_20K;