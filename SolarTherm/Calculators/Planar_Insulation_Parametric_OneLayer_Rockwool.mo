within SolarTherm.Calculators;

model Planar_Insulation_Parametric_OneLayer_Rockwool "Sweep U with time, solves for t1 for each U"
  import CN = Modelica.Constants;
  import MA = Modelica.Blocks.Math;
  //Quadratic coefficients of Rockwool
  parameter Real A = 1.72e-7;
  parameter Real B = 9.04e-5;
  parameter Real C = 3.12e-2;
  parameter Real c1 = 44.0 "USD/m3 RockWool";
  
  parameter Real T3 = 25.0 "degC ambient";
  parameter Real h = 10.0 "W/m2K ambient convection";
  parameter Real T1 = 640.0 "Sodium temperature degC";
  
  //This is the max temperature (degC), a severe cost penalty applies if that is exceeded in Rockwool
  parameter Real T2_Max = 650.0 "Maximum tolerable rockwool temperature";
 
  
  //Vary this manually
  //parameter Real U = 3.0 "W/m2K Target U value";
  Real U;
  Real R;
  //Calculation
  Real T2;
  Real t1;

  Real CpA "Cost per Area";
  Real q "heat loss rate per area";

equation
  
  //Sweep t1
  //1/U = 0.2 + time*0.1; //sweep U from 5 all the way down
  1/U = 0.2 + time*0.1;
  R = 1/U;
  
  q = ((A*(T1^3-T2^3)/3.0)+(B*(T1^2-T2^2)/2.0)+C*(T1-T2))/t1;
  q = h*(T2-T3);
  
  CpA = max(0.0,c1*t1);

  U = q/(T1-T3);
annotation(experiment(StopTime = 198, StartTime = 0, Tolerance = 1e-3, Interval = 1));
end Planar_Insulation_Parametric_OneLayer_Rockwool;