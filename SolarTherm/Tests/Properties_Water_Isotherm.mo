within SolarTherm.Tests;

model Properties_Water_Isotherm
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  
  //package Utility_Package = SolarTherm.Media.SolidParticles.Fe2O3_utilities;
  
  SI.Temperature T;
  Real T_C;
  SI.Pressure p;
  parameter SI.Temperature T_fixed = 25.0 +273.15;
  parameter SI.Pressure p_start = 0.01*1e5;
  parameter SI.Pressure p_end = 1e5; //1bar
  
  //SI.SpecificEnthalpy h_H2;
  SI.SpecificEnthalpy h_H2O;
  //SI.SpecificEntropy s;
  //SI.Density rho;
  //SI.ThermalConductivity k;
equation
  p = p_start*((10^(0.01*log10(p_end/p_start)))^time);
  T = T_fixed;//T_start + (time/100)*(T_end-T_start);
  T_C = T - 273.15;
  
  //h = Utility_Package.h_T(T);
  //s = Utility_Package.s_T(T);
  //rho = Utility_Package.rho_T(T);
  //k = Utility_Package.k_T(T);
  //h_H2 = Modelica.Media.IdealGases.SingleGases.H2.specificEnthalpy_pT(p_fixed,T);
  h_H2O = Modelica.Media.Water.IF97_Utilities.h_pT(p,T);
annotation(experiment(StopTime = 100, StartTime = 0, Tolerance = 1e-3, Interval = 0.1),
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end Properties_Water_Isotherm;