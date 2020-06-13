within SolarTherm.Materials;
package Graphite
  extends SolarTherm.Materials.PartialMaterial(MM = 12.011e-3, T_melt = 3600, cost = 1.8);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.MolarMass MM = 12.011e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 933.47 "Melting point (K)"; 
	//https://nucleus.iaea.org/sites/graphiteknowledgebase/wiki/Guide_to_Graphite/What%20is%20Graphite.aspx
  //constant Real cost = 1.8 "USD/kg";

  redeclare model State "A model which calculates state and properties"
    parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/Graphite.txt");
	
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";

	Tables.CombiTable1Ds Tab(tableOnFile=true, tableName="table_1D_1", columns=2:5, fileName=table_file);
	
  equation 
	Tab.u = h;
	T = Tab.y[1];
	f = Tab.y[2];
	rho = Tab.y[3];
	k = Tab.y[4];
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature"
	// reference: https://webbook.nist.gov/cgi/cbook.cgi?ID=C7782425&Mask=2#Thermo-Condensed
	// Butland and Maddison, 1973
	// Butland, A.T.D.; Maddison, R.J., The specific heat of graphite: an evaluation of measurements, J. Nucl. Mater., 1973, 49, 45-56.
	//T = 200 to 3500 K. Least squares fit of 'best' data gives: 
	// Cp = 0.538657 + 9.11129x10-6T - 90.2725T^-1 - 43449.3T^-2 + 1.59309x107T^-3 - 1.43688x109T^-4 cal/g*K (250 to 3000 K)
    input SI.Temperature T "Absolute temperature (K)";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";

  protected
	constant Real Tref=298.15 "the reference temperature to calculate enthalpy(K)";
	constant Real cal_to_Joule=4.184;
    constant Real A1=0.538657;
    constant Real B1=9.11129e-6;
    constant Real C1=-90.2725;
    constant Real D1=-43449.3;
    constant Real E1=1.59309e7;
    constant Real F1=-1.43688e9;

  algorithm
    //the specific heat capacity formula is cal/gK, therefore multiply 4.184*1000 to J/kgK
    h:=(A1+B1*T+C1*T^(-1)+D1*T^(-2)+E1*T^(-3)+F1*T^(-4))*cal_to_Joule*1000*(T-Tref);
  end h_Tf;
  
end Graphite;
