within SolarTherm.Tests;

model Properties_Test
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  
  //package Utility_Package = SolarTherm.Media.SolidParticles.Fe2O3_utilities;
  
  SI.Temperature T;
  Real T_C;
  SI.Pressure p;
  parameter SI.Temperature T_start = 600.0+273.15;
  parameter SI.Temperature T_end = 1000.0+273.15;
  parameter SI.Pressure p_fixed = 1.0*1.0e5; //1bar
  
  SI.SpecificEnthalpy h_Fe;
  SI.SpecificEnthalpy h_FeO;
  SI.SpecificEnthalpy h_Fe3O4;
  SI.SpecificEnthalpy h_Fe2O3;
  
  SI.SpecificEnthalpy h_H2;
  SI.SpecificEnthalpy h_H2O;
  
  SI.SpecificHeatCapacity cp_Fe;
  SI.SpecificHeatCapacity cp_FeO;
  SI.SpecificHeatCapacity cp_Fe3O4;
  SI.SpecificHeatCapacity cp_Fe2O3;
  
  SI.MolarEnthalpy H_FeO;
  SI.MolarEnthalpy H_Fe2O3;
  
  //SI.SpecificEntropy s;
  //SI.Density rho;
  //SI.ThermalConductivity k;
equation
  p = p_fixed;
  T = T_start+(time/400)*(T_end-T_start); // + 
  T_C = T - 273.15;
  
  h_Fe = SolarTherm.Media.SolidParticles.Fe_utilities.h_T(T);
  h_FeO = SolarTherm.Media.SolidParticles.FeO_utilities.h_T(T);
  h_Fe3O4 = SolarTherm.Media.SolidParticles.Fe3O4_utilities.h_T(T);
  h_Fe2O3 = SolarTherm.Media.SolidParticles.Fe2O3_utilities.h_T(T);
  
  h_H2 = Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_fixed,T);
  h_H2O = Modelica.Media.Water.IF97_Utilities.h_pT(p_fixed,T);
  //s = Utility_Package.s_T(T);
  //rho = Utility_Package.rho_T(T);
  //k = Utility_Package.k_T(T);
  cp_Fe = SolarTherm.Media.SolidParticles.Fe_utilities.cp_T(T);
  cp_FeO = SolarTherm.Media.SolidParticles.FeO_utilities.cp_T(T);
  cp_Fe3O4 = SolarTherm.Media.SolidParticles.Fe3O4_utilities.cp_T(T);
  cp_Fe2O3 = SolarTherm.Media.SolidParticles.Fe2O3_utilities.cp_T(T);
  
  H_FeO = SolarTherm.Models.Chemistry.ChemTable.FeO.Hf0 + h_FeO*SolarTherm.Models.Chemistry.ChemTable.FeO.M;
  H_Fe2O3 = SolarTherm.Models.Chemistry.ChemTable.Fe2O3.Hf0 + h_Fe2O3*SolarTherm.Models.Chemistry.ChemTable.Fe2O3.M;

annotation(experiment(StopTime = 400, StartTime = 0, Tolerance = 1e-3, Interval = 1.0),
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end Properties_Test;