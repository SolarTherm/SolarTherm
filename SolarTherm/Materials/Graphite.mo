within SolarTherm.Materials;
package Graphite
  extends SolarTherm.Materials.PartialMaterial(MM = 12.011e-3, T_melt = 3600, cost = 1.8, year = 2020);

  //Property Tables
  constant SI.Temperature T_data[11] = {295.75, 374.15, 472.45, 574.75, 674.75, 774.75, 874.75, 974.85, 1074.45, 1173.95, 1274.05};
  
  constant SI.SpecificEnthalpy h_data[11] = {-1742.856, 70919.400, 201224.121, 370939.962, 559940.178, 764242.398, 978738.138, 1200195.120, 1424960.754, 1652354.344, 1882940.496};
  
  constant SI.Density rho_data[11] = {1888.50, 1886.30, 1883.50, 1880.40, 1877.20, 1873.90, 1870.50, 1867.00, 1863.40, 1859.60, 1855.70};
  
  constant SI.ThermalConductivity k_data[11] = {133.02, 128.54, 117.62, 106.03, 96.70, 88.61, 82.22, 76.52, 71.78, 67.88, 64.26};

  redeclare model State "A model which calculates state and properties"
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Absolute Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";
 equation
    T = Modelica.Math.Vectors.interpolate(h_data,T_data,h);
    f = 0.0;
    rho = Modelica.Math.Vectors.interpolate(h_data,rho_data,h);
    k = Modelica.Math.Vectors.interpolate(h_data,k_data,h);
  end State;

  redeclare function h_Tf "find specific enthalpy from Temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := Modelica.Math.Vectors.interpolate(T_data,h_data,T);
  end h_Tf;
  
  redeclare function rho_Tf "find density from temperature and liquid fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := Modelica.Math.Vectors.interpolate(T_data,rho_data,T);
  end rho_Tf;

  /*
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
  */
  
end Graphite;
