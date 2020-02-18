within SolarTherm.Models.Storage.Tank;
model Insulation_Calculator

/*============================================= BASED ON THE MODEL CREATED BY ZEBEDEE KEE =======================================================*/

/*=======================FOR EACH U VALUE (FUNCTION OF TIME) VARY THE MICROPOROUS  THICKNESS AND FIND THE MIN COST ==============================*/

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

//Quadratic coefficients of Microporous
  parameter Real D = 4.37e-8;
  parameter Real E = -5.25e-6;
  parameter Real F = 2.53e-2;
parameter Real t2_max = 1 "Max thickness of the Microporous according to J.Stent";

//Quadratic coefficients of Concrete
parameter Real k_concrete = 1.7355 "conductance of the concrete with 5.4% steelbar reinforcement volume fraction tudy on Thermal Conductivity of Reinforced Concrete Plate Shun Bo Zhao DOI: 10.4028/www.scientific.net/AMM.438-439.321 ";
parameter Real T3_max = 200 "maximum temperature at the concrete inner layer";
parameter Real t3 = 0.6 "Thickness of the concrete";

//Cost ==> based on personal email with J.Stent of Sandia with philipe Gunawan and Jphn Pye (18 Feb 2020)
parameter Real c1 = 2700 "USD/m3 Tuffcrete47";
parameter Real c2 = 4000 "USD/m3 MP";
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