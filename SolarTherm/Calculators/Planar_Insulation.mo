within SolarTherm.Calculators;

model Planar_Insulation
  import CN = Modelica.Constants;
  import MA = Modelica.Blocks.Math;
  //Quadratic coefficients of Microporous
  parameter Real A = 4.37e-8;
  parameter Real B = -5.25e-6;
  parameter Real C = 2.53e-2;

  //Quadratic coefficients of RockWool
  parameter Real D = 1.72e-7;
  parameter Real E = 9.04e-5;
  parameter Real F = 3.12e-2;
  
  parameter Real c1 = 4269.0 "USD/m3 Microporous";
  parameter Real c2 = 44.0 "USD/m3 RockWool";
  
  parameter Real T4 = 25.0 "degC ambient";
  parameter Real h = 10.0 "W/m2K ambient convection";
  parameter Real T1 = 800.0 "Sodium temperature";
  
  //This is the max temperature (degC), a severe cost penalty applies if that is exceeded in Rockwool
  parameter Real T2_Max = 650.0 "Maximum tolerable rockwool temperature";
  
  //Vary this manually
  parameter Real U = 3.0 "W/m2K Target U value";
  

  
  //Calculation
  Real T2 (start = 400);
  Real T3 (start = 30);
  Real t1 (start=1e-3);
  Real t2 (start=1e-3);
  
  Real CpA "Cost per Area";
  Real q "heat loss rate per area";
  Real Penalty;
  
  
algorithm
  if (T2 < T3) or (T3 < T4) or (t2 < 0) then
    terminate("Invalid");
  end if;
  
equation
  if T2 > T2_Max then
    Penalty = 10000.0;
  else
    Penalty = 0.0;
  end if;
  //Sweep t1
  t1 = 1e-3 + time*1e-3; //sweep at 1mm intervals for t1
  
  q = ((A*(T1^3-T2^3)/3.0)+(B*(T1^2-T2^2)/2.0)+C*(T1-T2))/t1;
  q = ((D*(T2^3-T3^3)/3.0)+(E*(T2^2-T3^2)/2.0)+F*(T2-T3))/t2;
  q = h*(T3-T4);
  
  CpA = c1*t1+c2*t2 + Penalty;
  U = q/(T1-T4);
annotation(experiment(StopTime = 100, StartTime = 0, Tolerance = 1e-6, Interval = 1.0));
end Planar_Insulation;