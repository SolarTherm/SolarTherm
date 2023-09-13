within SolarTherm.Materials;
package Therminol_66_Table
  extends SolarTherm.Materials.PartialMaterial(MM = 252.0e-3, T_melt = -3.0 + 273.15, cost = 2.10); //Cost from Heller et al. 2013
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  
  //constant SI.MolarMass MM = 22.989769e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 97.79 + 273.15 "Melting point (K)";
  //constant Real cost = 3.0 "USD/kg";
  constant SI.SpecificEnthalpy h_data[40] = {-42500.00, -38500.00, -23300.00, -7900.00, 0.00, 7900.00, 24000.00, 40500.00, 57300.00, 74500.00, 92000.00, 109900.00, 128100.00, 146600.00, 165500.00, 184800.00, 204400.00, 224300.00, 244600.00, 265300.00, 286400.00, 307800.00, 329500.00, 351600.00, 374100.00, 397000.00, 420200.00, 443800.00, 467800.00, 492200.00, 516900.00, 542000.00, 567500.00, 593400.00, 619700.00, 646300.00, 673400.00, 700900.00, 728700.00, 757000.00};
  constant SI.Temperature T_data[40] = {270.15, 273.15, 283.15, 293.15, 298.15, 303.15, 313.15, 323.15, 333.15, 343.15, 353.15, 363.15, 373.15, 383.15, 393.15, 403.15, 413.15, 423.15, 433.15, 443.15, 453.15, 463.15, 473.15, 483.15, 493.15, 503.15, 513.15, 523.15, 533.15, 543.15, 553.15, 563.15, 573.15, 583.15, 593.15, 603.15, 613.15, 623.15, 633.15, 643.15};
  constant SI.SpecificHeatCapacity cp_data[40] = {1490.0, 1490.0, 1530.0, 1560.0, 1580.0, 1600.0, 1630.0, 1660.0, 1700.0, 1730.0, 1770.0, 1800.0, 1840.0, 1870.0, 1910.0, 1940.0, 1980.0, 2010.0, 2050.0, 2090.0, 2120.0, 2160.0, 2190.0, 2230.0, 2270.0, 2300.0, 2340.0, 2380.0, 2420.0, 2450.0, 2490.0, 2530.0, 2570.0, 2610.0, 2650.0, 2690.0, 2730.0, 2770.0, 2810.0, 2850.0};
  constant SI.DynamicViscosity mu_data[40] = {2.0500000, 1.3200000, 0.3440000, 0.1230000, 0.0893000, 0.0556000, 0.0295000, 0.0176000, 0.0115000, 0.0080600, 0.0059300, 0.0045500, 0.0036000, 0.0029200, 0.0024200, 0.0020500, 0.0017500, 0.0015200, 0.0013300, 0.0011800, 0.0010600, 0.0009500, 0.0008600, 0.0007840, 0.0007180, 0.0006610, 0.0006110, 0.0005670, 0.0005290, 0.0004950, 0.0004640, 0.0004370, 0.0004130, 0.0003910, 0.0003710, 0.0003530, 0.0003360, 0.0003210, 0.0003080, 0.0002950};
  constant SI.ThermalConductivity k_data[40] = {0.1180, 0.1183, 0.1179, 0.1176, 0.1174, 0.1172, 0.1167, 0.1163, 0.1158, 0.1152, 0.1147, 0.1141, 0.1135, 0.1128, 0.1121, 0.1114, 0.1107, 0.1099, 0.1091, 0.1083, 0.1074, 0.1065, 0.1056, 0.1046, 0.1036, 0.1026, 0.1015, 0.1004, 0.0993, 0.0982, 0.0970, 0.0958, 0.0946, 0.0933, 0.0920, 0.0906, 0.0893, 0.0879, 0.0865, 0.0850};
  constant SI.Density rho_data[40] = {1023.0, 1021.0, 1015.0, 1008.0, 1005.0, 1002.0, 995.0, 989.0, 982.0, 975.0, 969.0, 962.0, 955.0, 948.0, 941.0, 934.0, 928.0, 921.0, 914.0, 907.0, 899.0, 892.0, 885.0, 878.0, 870.0, 863.0, 856.0, 848.0, 840.0, 832.0, 825.0, 817.0, 809.0, 800.0, 792.0, 783.0, 775.0, 766.0, 757.0, 748.0};
  
  redeclare model State
    parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/Therminol_66.txt");
    parameter SI.SpecificEnthalpy h_start=0.0;
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
end Therminol_66_Table;