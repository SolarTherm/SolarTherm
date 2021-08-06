within SolarTherm.Calculators;

model Planar_Insulation_Parametric
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
  parameter Real T1 = 760.0 "Sodium temperature";
  
  //This is the max temperature (degC), a severe cost penalty applies if that is exceeded in Rockwool
  parameter Real T2_Max = 650.0 "Maximum tolerable rockwool temperature";
  
  parameter Integer t1_divs = 1001 "number of divisions in thickness_1 expored";
  parameter Real t1_min = 1.0e-3 "1.0mm";
  //parameter Real t1_max = 0.050 "5cm";
  parameter Real t1_max = 1.00 "100cm";
  
  //Vary this manually
  //parameter Real U = 3.0 "W/m2K Target U value";
  Real U;
  Real R;
  //Calculation
  Real T2[t1_divs] (start = fill(400,t1_divs));
  Real T3[t1_divs] (start = fill(30,t1_divs));
  parameter Real t1[t1_divs] = ModelicaReference.Operators.linspace(t1_min,t1_max+t1_min,t1_divs);
  Real t2[t1_divs] (start=fill(1e-3,t1_divs));
  
  Real CpA[t1_divs] "Cost per Area";
  Real q "heat loss rate per area";
  Real Penalty[t1_divs];
  
  Real CpA_min; //minimum cost per area
  

equation
  for i in 1:t1_divs loop
    if (T2[i] < T3[i]) or (T3[i] < T4) or (t2[i] < 0) or (T2[i] > T2_Max) then
      Penalty[i] = 10000.0;
    else
      Penalty[i] = 0.0;
    end if;
  end for;
  
  //Sweep t1
  //1/U = 0.2 + time*0.1; //sweep U from 5 all the way down
  1/U = 0.2 + time*0.1;
  R = 1/U;
  for i in 1:t1_divs loop
    q = ((A*(T1^3-T2[i]^3)/3.0)+(B*(T1^2-T2[i]^2)/2.0)+C*(T1-T2[i]))/t1[i];
    q = ((D*(T2[i]^3-T3[i]^3)/3.0)+(E*(T2[i]^2-T3[i]^2)/2.0)+F*(T2[i]-T3[i]))/t2[i];
    q = h*(T3[i]-T4);
  
    CpA[i] = max(0.0,c1*t1[i]+c2*t2[i]) + Penalty[i];
  end for;
  U = q/(T1-T4);
  CpA_min = min(CpA);
annotation(experiment(StopTime = 198, StartTime = 0, Tolerance = 1e-3, Interval = 1));
end Planar_Insulation_Parametric;