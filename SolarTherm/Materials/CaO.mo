within SolarTherm.Materials;
package CaO
  extends SolarTherm.Media.Materials.PartialMaterial(MM = 56.077e-3, T_melt = 3200.0, cost = 0.2);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.MolarMass MM = 56.077e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 3200.0 "Melting point (K)";
  //constant Real cost = 0.2 "USD/kg";

  redeclare model State "A model which calculates state and properties"
	
	parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/MaterialTables/CaO.txt");
	
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
  protected
    SI.SpecificEnthalpy h_s "Solid Specific Enthalpy";
    Real t "Temperature/1000";
    //constant SI.SpecificEnthalpy h_latent=391378.7185 "J/kg";
    constant Real MM=56.077e-3 "kg/mol";
    //Solid Phase Schomate
    constant Real A1=49.95403;
    constant Real B1=4.887916;
    constant Real C1=-0.352056;
    constant Real D1=0.046187;
    constant Real E1=-0.825097;
    constant Real F1=-652.9718;
    constant Real G1=92.56096;
    constant Real H1=-635.0894;
  algorithm
    t := T/1000;
    //Specific enthalpy schomate formula is kJ/mol, therefore multiply by 1000 and divide by MM
    h_s := 1000.0*(A1*t + (B1/2)*(t^2) + (C1/3)*(t^3) + (D1/4)*(t^4) - E1/t + F1 - H1)/MM;
    h := h_s;
  end h_Tf;
    
  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy rho "Density (kg/m3)";
  algorithm
    rho := 3382.77 - 0.155*T +(3.04e-5)*(T^2);
  end rho_Tf;
end CaO;
