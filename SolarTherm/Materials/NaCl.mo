within SolarTherm.Materials;
package NaCl "Pure sodium chloride, sharp melting point"
  extends SolarTherm.Materials.PartialMaterial(MM = 58.443e-3, T_melt = 1073.0, cost = 0.049);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  
  //constant SI.MolarMass MM = 58.443e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 1073.0 "Melting point (K)";
  //constant Real cost = 0.049 "USD/kg";

  redeclare model State "A model which calculates state and properties"
    parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/NaCl.txt");
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

  redeclare function h_Tf "Find the specific enthalpy based on Temperature and liquid mass fraction"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy";
  protected
    SI.SpecificEnthalpy h_s "Solid Specific Enthalpy";
    SI.SpecificEnthalpy h_l "Liquid Specific Enthalpy";
    Real t "Temperature (K) divided by 1000";
    constant Real MM = 58.443e-3 "Molar mass (kg/mol)";
    constant Real h_latent = 1000*(-385.92+411.12)/(58.443e-3) "Difference between formation enthalpies of liquid and solid (J/kg)";
    //Solid Phase schomate
    constant Real A1 = 50.72389;
    constant Real B1 = 6.672267;
    constant Real C1 = -2.517167;
    constant Real D1 = 10.15934;
    constant Real E1 = -0.200675;
    constant Real F1 = -427.2115;
    constant Real G1 = 130.3973;
    constant Real H1 = -411.1203;
    //Liquid Phase schomate
    constant Real A2 = -42.44780;
    constant Real B2 = 113.5260;
    constant Real C2 = -43.64660;
    constant Real D2 = 5.896630;
    constant Real E2 = 39.13860;
    constant Real F2 = -305.5610;
    constant Real G2 = 91.06390;
    constant Real H2 = -385.9230;
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
  protected
    SI.Density rho_sol "Density of solid (kg/m3)";
    SI.Density rho_liq "Density of liquid (kg/m3)";
  algorithm
    rho_sol := 2230.0 - 0.313*T;
    rho_liq := 2061.0 - 0.4759*T;
    rho := (rho_liq*rho_sol)/(f*rho_sol+rho_liq-f*rho_liq);
  end rho_Tf;
end NaCl;
