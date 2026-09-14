within SolarTherm.Calculators;

model Planar_Insulation_Parametric_OneLayer
  import CN = Modelica.Constants;
  import MA = Modelica.Blocks.Math;
  
  //Quadratic coefficients of thermal conductivity k = A + BT + CT^2
  parameter Real A = 0.072685;
  parameter Real B = 0.0001;
  parameter Real C = 0.0;
  
  parameter Real c1 = 102.375 "Volumetric cost USD_2024/m3"; //Mullite insulation 175 USD_2024/ton and 585 kg/m3
  
  parameter Real T3 = 25.0 + 273.15 "Ambient temperature (K)";
  parameter Real h = 10.0 "Ambient convective coefficient (W/m2K)";
  parameter Real T1 = 1500.0 + 273.15 "Internal storage temperature (K)";
  
  parameter Real T2_Max = 1500.0 + 273.15 "Maximum tolerable insulation temperature";
  
  Real T1_var;
 
  Real U;
  Real R;
  //Calculation
  Real T2;
  Real t1;

  Real CpA "Cost per Area";
  Real q "heat loss rate per area";

equation
  T1_var = 1.00*T1 + 0.00;
  //Sweep t1
  U = 10.0^(-2.0+time); //sweep U from 5 all the way down
  R = 1/U;
  
  q = ((C*(T1^3-T2^3)/3.0)+(B*(T1^2-T2^2)/2.0)+A*(T1-T2))/t1;
  q = h*(T2-T3);
  
  CpA = max(0.0,c1*t1);

  U = q/(T1-T3);
annotation(experiment(StopTime = 2, StartTime = 0, Tolerance = 1e-6, Interval = 0.1));

end Planar_Insulation_Parametric_OneLayer;