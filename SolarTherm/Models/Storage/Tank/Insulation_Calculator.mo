within SolarTherm.Models.Storage.Tank;

/*============================================= BASED ON THE MODEL CREATED BY ZEBEDEE KEE =======================================================*/

/*=======================FOR EACH U VALUE (FUNCTION OF TIME) VARY THE MICROPOROUS  THICKNESS AND FIND THE MIN COST ==============================*/

model Insulation_Calculator

 /* import CN = Modelica.Constants;
  import MA = Modelica.Blocks.Math;
  //Quadratic coefficients of Tuffcrete47
  parameter Real A = 0.000000069;
  parameter Real B = 5.4566e-5;
  parameter Real C = 1.4625565;

  //Quadratic coefficients of Concrete
  parameter Real D = 1.063e-6;
  parameter Real E = -0.002439;
  parameter Real F = 2.002557;
  
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
  U = q/(T1-T4);*/






//=============================================Configuration from J.Stent (Tuffcrete47 + Concrete) and MP in between ======================
  /*import CN = Modelica.Constants;
  import MA = Modelica.Blocks.Math;
  //Quadratic coefficients of Tuffcrete 47 personal email between Philipe Gunawan Gan and Jeremy Sment from SANDIA on Friday 14 Feb 2020
  parameter Real A = 9.63744106e-20;
  parameter Real B = -5.11682711e-16;
  parameter Real C = 7.96049346e-13;
  parameter Real D = -3.36343209e1;
  parameter Real E =  -8.39641163e-7 ;
  parameter Real F = 1.00903607e2 ;
  parameter Real G = 1.38394486e0;

  //Quadratic coefficients of concrete NSC Normal Strength Concrete (Properties of Concrete at Elevated Temperatures by Venkatesh Kodur on HINDAWI)
  parameter Real H = 2.40460380e-18 ;
  parameter Real I = -6.03532124e-15;
  parameter Real J = 4.36658212e-12;
  parameter Real K = -6.08211680e1;
  parameter Real L = 7.42039958e-8;
  parameter Real M = 1.82461325e2 ;
  parameter Real N = 1.82461325e0;
  
  parameter Real c1 = 3326.4 "USD/m3 Tuffcrete47";
  parameter Real c2 = 71 "USD/m3 NSC concrete";
  
  parameter Real T4 = 25.0 "degC ambient";
  parameter Real h = 10.0 "W/m2K ambient convection";
  parameter Real T1 = 800.0 "Particle temperature";
  
  //This is the max temperature (degC), a severe cost penalty applies if that is exceeded in Rockwool
  parameter Real T2_Max = 200 "Maximum tolerable rockwool temperature";
  
  parameter Integer t1_divs = 500 "number of divisions in thickness_1 expored";
  parameter Real t1_min = 1e-3 "1mm ==> minimum thickness of MP";
  parameter Real t1_max = 30 "1m ==> max thickness of MP";
  
  //Vary this manually
  //parameter Real U = 3.0 "W/m2K Target U value";
  Real U;
  Real R;
  //Calculation
  Real T2[t1_divs] (start = fill(400,t1_divs));
  Real T3[t1_divs] (start = fill(30,t1_divs));
  parameter Real t1[t1_divs] = ModelicaReference.Operators.linspace(t1_min,t1_max,t1_divs);
  Real t2[t1_divs] (start=fill(1e-2,t1_divs));
  
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
  1/U = 0.2 + time; //sweep U from 5 all the way down
  R = 1/U;
  for i in 1:t1_divs loop
    q * t1[i] = A/7 * (T1^7 - T2[i]^7) + B/6 * (T1^6-T2[i]^6) + C/5*(T1^5-T2[i]^5) + D/4*(T1^4-T2[i]^4) + E/3*(T1^3-T2[i]^3) + F/2*(T1^2-T2[i]^2)
    +G*(T1-T2[i]);
    /*q = ((A*(T1^7-T2[i]^7)/7.0)+(B*(T1^6-T2[i]^6)/6.0)+(C*(T1^5-T2[i]^5)/5.0)+(D*(T1^4-T2[i]^4)/4.0)+(E*(T1^3-T2[i]^3)/3.0)
    +(F*(T1^2-T2[i]^2)/2.0)+ (G*(T1^1-T2[i]^1)/1.0))/t1[i] ;
    
    q = ((H*(T2[i]^7-T3[i]^7)/7.0)+(I*(T2[i]^6-T3[i]^6)/6.0)+(J*(T2[i]^5-T3[i]^5)/5.0)+(K*(T2[i]^4-T3[i]^4)/4.0)+(L*(T2[i]^3-T3[i]^3)/3.0)
    +(M*(T2[i]^2-T3[i]^2)/2.0)+ (M*(T2[i]^1-T3[i]^1)/1.0))/t2[i];
    
    q = h*(T3[i]-T4);
  
    CpA[i] = max(0.0,c1*t1[i]+c2*t2[i]) + Penalty[i];
  end for;
  U = q/(T1-T4);
  CpA_min = min(CpA);  */
  
/*import CN = Modelica.Constants;
  import MA = Modelica.Blocks.Math;
  //Quadratic coefficients of Tuffcrete47
  parameter Real A = 6.9e-8;
  parameter Real B = 5.46e-5;
  parameter Real C = 1.46;
  
  //Quadratic coefficients of microporous
  parameter Real D = 4.37e-8;
  parameter Real E = -5.25e-6;
  parameter Real F = 2.53e-2;
  
  //Quadratic coefficients of Concrete
  parameter Real G = 1.063e-6;
  parameter Real H = -0.002439;
  parameter Real I = 2.002557;
  
  //FIXME
  //parameter Real A = -6.3e-7;
 // parameter Real B = 6.05e-4;
  //parameter Real C = 1.38;
  /*parameter Real A = 8.11e-17;
    parameter Real B =-6.06e-13;
    parameter Real C = 1.59e-9;
    parameter Real A1 = -1.72e-6;
    parameter Real A2 = 8.56e-4;
    parameter Real A3 = 1.37;
    
  parameter Real c1 = 3264 "USD/m3 Tuffcrete47";
  parameter Real c2 = 4000 "USD/m3 MP";
  parameter Real c3 = 71 "USD/m3 concrete";
  
  parameter Real T1 = 800.0 "Particle temperature";
  parameter Real T3_max = 200 "maximum allowable in concrete";
  parameter Real T5 = 25.0 "degC ambient";
  parameter Real h = 10.0 "W/m2K ambient convection";
    
  parameter Integer t1_divs = 500 "number of divisions in thickness_1 expored";
  parameter Real t1_min = 0.5 "50cm minimum of the tuffcrete47 thickness";
  parameter Real t1_max = 5 "5m maximum of the tuffcrete47 thickness";
  parameter Real t1[t1_divs] = ModelicaReference.Operators.linspace(t1_min,t1_max,t1_divs) "thickness of the tuffcrete47";
 
  Real t1_minima;
  Real U;
  Real R;
  //Calculation
  Real T2[t1_divs]  (max = fill(800,t1_divs), start = linspace(750,620,t1_divs));
  Real T3[t1_divs] (max = fill(800,t1_divs),start = linspace(600,150,t1_divs));
  Real T4[t1_divs] (max = fill(200,t1_divs), start=fill(30,t1_divs));
  Real t2[t1_divs] (start=linspace(0.05,1,t1_divs)) "thickness of MP start from 5 cm";
  //Real t3[t1_divs] (start=linspace(0.5,3,t1_divs)) "thickness of concrete start from 5 cm";
  parameter Real t3 = 1;
  Real CpA[t1_divs] "Cost per Area";
  Real q "heat loss rate per area";
  Real Penalty[t1_divs];
  
  Real CpA_min; //minimum ;cost per area
  
algorithm

for i in 1:t1_divs loop
  if CpA[i] == CpA_min then
     t1_minima := t1[i];
  end if;1
end for;

equation
  for i in 1:t1_divs loop
    if (T2[i] < T3[i]) or (T3[i]<T4[i]) or (T4[i] < T5) or (t2[i] < 0) or (T3[i] > T3_max) then
      Penalty[i] = 10000.0;
    else
      Penalty[i] = 0.0;
    end if;
  end for;
  
  //Sweep t1
  1/U = 0.2 + time*1.0; //sweep U from 5 all the way down
  R = 1/U;
  U = q/(T1-T5);
  for i in 1:t1_divs loop
    q = ((A*(T1^3-T2[i]^3)/3.0)+(B*(T1^2-T2[i]^2)/2.0)+(C*(T1^1-T2[i]^1)/1.0))/t1[i];
    q = ((D*(T2[i]^3-T3[i]^3)/3.0)+(E*(T2[i]^2-T3[i]^2)/2.0)+F*(T2[i]-T3[i]))/t2[i];
    q = ((G*(T3[i]^3-T4[i]^3)/3.0)+(H*(T3[i]^2-T4[i]^2)/2.0)+I*(T3[i]-T4[i]))/t3;
    q = h*(T4[i]-T5);
    CpA[i] = max(max(0.0,c1*t1[i]+c2*t2[i] +c3*t3), Penalty[i]);
  end for;
  CpA_min = min(CpA);*/
  

//====================================================  ALLIED MINERAL DESIGN FROM J.STENT =======================================================//

import CN = Modelica.Constants;
import MA = Modelica.Blocks.Math; 

parameter Real h = 10 "Convective coefficient of ambient (W/m2.K)";
parameter Real T5 = 25 "ambient temperature degC";

//Quadratic coefficients of Tuffcrete47
parameter Real A = -3.88e-7;
parameter Real B = 4.68e-4;
parameter Real C = 1.4;
parameter Real T1 = 800 "Particle Temperature";
parameter Real t1_max = 0.1 "max thickness of Tuffcrete47 according to J.Stent";
parameter Real t1_min = 0.01 "Minimum thickness of Tuffcrete47";
parameter Integer t1_divs = 500;
parameter Real t1[t1_divs] = ModelicaReference.Operators.linspace(t1_min,t1_max,t1_divs) "thickness of the tuffcrete47";

//Quadratic coefficients of Pumplite60
parameter Real D = 6.55e-8;
parameter Real E = -1.84e-5;
parameter Real F= 4.99e-3;
parameter Real t2_max = 0.5 "Max thickness of the Pumplite60 according to J.Stent";

//Quadratic coefficients of Concrete
parameter Real k_concrete = 1.7355 "conductance of the concrete with 5.4% steelbar reinforcement volume fraction tudy on Thermal Conductivity of Reinforced Concrete Plate Shun Bo Zhao DOI: 10.4028/www.scientific.net/AMM.438-439.321 ";
parameter Real T3_max = 200 "maximum temperature at the concrete inner layer";
parameter Real t3 = 0.6 "Thickness of the concrete";

//Cost ==> based on personal email with J.Stent of Sandia with philipe Gunawan and Jphn Pye (18 Feb 2020)
parameter Real c1 = 2700 "USD/m3 Tuffcrete47";
parameter Real c2 = 2700 "USD/m3 Pumplite 60";
parameter Real c3 = 71 "USD/m3 concrete";


//variables
Real t2[t1_divs]  (start = linspace(t2_max,0.01,t1_divs), max = fill(t2_max,t1_divs));
Real T2[t1_divs]  (start = linspace(700,100,t1_divs));
Real T3[t1_divs]  (start = linspace(200,100,t1_divs));
Real T4[t1_divs]  (max = fill(200,t1_divs), start=fill(30,t1_divs));
Real Penalty[t1_divs];
Real U;
Real R;
Real CpA[t1_divs] "Cost per Area";
Real q "heat loss rate per area";
Real CpA_min;
Real t1_minima;
Real t2_minima;

algorithm
for i in 1:t1_divs loop
  if CpA[i] == CpA_min then
     t1_minima := t1[i];
     t2_minima := t2[i];
  end if;
end for;

equation

for i in 1:t1_divs loop
    if (T2[i] < T3[i]) or (T3[i] < T4[i]) or (t2[i] < 0) or (T3[i] > T3_max) or(t2[i] > t2_max) then
      Penalty[i] = 10000.0;
    else
      Penalty[i] = 0.0;
    end if;
end for;

//Sweep U
1/U = 0.2 + time*1.0; //sweep U from 5 all the way down
R = 1/U;
U = q/(T1-T5);

//sweep t1
for i in 1:t1_divs loop
    q = ((A*(T1^3-T2[i]^3)/3.0)+(B*(T1^2-T2[i]^2)/2.0)+(C*(T1^1-T2[i]^1)/1.0))/t1[i];
    q = ((D*(T2[i]^3-T3[i]^3)/3.0)+(E*(T2[i]^2-T3[i]^2)/2.0)+F*(T2[i]-T3[i]))/t2[i];
    q = k_concrete *(T3[i]-T4[i])/t3;
    q = h*(T4[i]-T5);
    CpA[i] = max(max(0.0,c1*t1[i]+c2*t2[i] +c3*t3), Penalty[i]);
end for;
CpA_min = min(CpA);
  
    

  
annotation(
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.689655));
end Insulation_Calculator;