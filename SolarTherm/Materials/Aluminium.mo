within SolarTherm.Materials;
package Aluminium
  extends SolarTherm.Media.Materials.PartialMaterial(MM = 26.9815386e-3, T_melt = 933.47, cost = 1.8);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.MolarMass MM = 26.9815386e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 933.47 "Melting point (K)";
  //constant Real cost = 1.8 "USD/kg";

  redeclare model State "A model which calculates state and properties"
    parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/Aluminium.txt");
	
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
  protected
    SI.SpecificEnthalpy h_s "Solid Specific Enthalpy";
    SI.SpecificEnthalpy h_l "Liquid Specific Enthalpy";
    Real t "Temperature/1000";
    constant SI.SpecificEnthalpy h_latent=391378.7185 "J/kg";
    constant Real MM=26.9815386e-3 "kg/mol";
    //Solid Phase Schomate
    constant Real A1=28.08920;
    constant Real B1=-5.414849;
    constant Real C1=8.560423;
    constant Real D1=3.427370;
    constant Real E1=-0.277375;
    constant Real F1=-9.147187;
    constant Real G1=61.90981;
    constant Real H1=0.000000;
    //Liquid Phase schomate
    constant Real A2 = 31.75104;
    constant Real B2 = 3.935826e-8;
    constant Real C2 = -1.786515e-8;
    constant Real D2 = 2.694171e-9;
    constant Real E2 = 5.480037e-9;
    constant Real F2 = -0.945684;
    constant Real G2 = 73.39949;
    constant Real H2 = 10.56201;
  algorithm
    t := T/1000;
    //Specific enthalpy schomate formula is kJ/mol, therefore multiply by 1000 and divide by MM
    h_s := 1000.0*(A1*t + (B1/2)*(t^2) + (C1/3)*(t^3) + (D1/4)*(t^4) - E1/t + F1 - H1)/MM;
    h_l := h_latent + 1000.0*(A2*t + (B2/2)*(t^2) + (C2/3)*(t^3) + (D2/4)*(t^4) - E2/t + F2 - H2)/MM;
    h := (1-f)*h_s + f*h_l;
  end h_Tf;
  
  redeclare function rho_Tf "Find the density based on Temperature and liquid mass fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    if f <= 0.0 then //solid
      rho := -0.44382*T + 2928.3;
    elseif f >= 1.0 then //liquid
      rho := -0.30011*T + 3211.1;
    else
      rho := f*(2391.0-2514.0) + 2514.0;
    end if;
  end rho_Tf;

end Aluminium;
