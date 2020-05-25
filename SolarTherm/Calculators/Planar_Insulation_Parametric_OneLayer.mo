within SolarTherm.Calculators;

model Planar_Insulation_Parametric_OneLayer "Sweep U with time, solves for t1 for each U"
  import CN = Modelica.Constants;
  import MA = Modelica.Blocks.Math;
  //Quadratic coefficients of Calcium Silicate //wrong
  parameter Real A = 4.37e-8;
  parameter Real B = -5.25e-6;
  parameter Real C = 2.53e-2;
  
  parameter Real c1 = 4269.0 "USD/m3 Calcium Silicate //Wrong";
  
  parameter Real T3 = 25.0 "degC ambient";
  parameter Real h = 10.0 "W/m2K ambient convection";
  parameter Real T1 = 700.0 "Sodium temperature degC";
  
  //This is the max temperature (degC), a severe cost penalty applies if that is exceeded in Rockwool
  parameter Real T2_Max = 700.0 "Maximum tolerable rockwool temperature";
 
  
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
  1/U = 0.2 + time*0.1; //sweep U from 5 all the way down
  R = 1/U;
  
  q = ((A*(T1^3-T2^3)/3.0)+(B*(T1^2-T2^2)/2.0)+C*(T1-T2))/t1;
  q = h*(T2-T3);
  
  CpA = max(0.0,c1*t1);

  U = q/(T1-T3);
annotation(experiment(StopTime = 99, StartTime = 0, Tolerance = 1e-6, Interval = 1));
end Planar_Insulation_Parametric_OneLayer;