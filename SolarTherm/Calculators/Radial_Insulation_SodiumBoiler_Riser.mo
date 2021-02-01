within SolarTherm.Calculators;

model Radial_Insulation_SodiumBoiler_Riser
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
  parameter Real h = 20.0 "W/m2K ambient convection";
  parameter Real T1 = 800.0 "Pipe temperature";
  parameter Real T2_Max = 650.0 "Maximum tolerable rockwool temperature";
  
  //Receiver Thermal Output is 4.0485 MWth
  //Riser length is  26.4895 m, outer diameter is 0.1016m
  //Inputs
  parameter Real d1 = 0.1016 "Pipe diameter";
  parameter Real QpL = 1e-2*4.0485e6/26.4895 "Acceptable Heat Rate per unit m (currently 0.1% of design receiver heat)";

  //Calculation
  Real T2 (start = 400);
  Real T3 (start = 30);
  parameter Real r1 = d1/2.0;
  Real r2 (start=r1+1e-3);
  Real r3 (start=r1+1e-3+15e-3);
  
  Real t1 (min=0.0,start=1e-3)"Thickness of Microporous";
  Real t2 (min=0.0,start=5e-3)"Thickness of RockWool";
  
  Real CpL "Cost per length";
  Real Penalty;
  
algorithm
  if (T2 < T4) or (T3 < T4) or (r3 < r2) or (t2 < 0) then
    terminate("Invalid");
  end if;
  
equation
  if T2 > T2_Max then
    Penalty = 10000.0;
  else
    Penalty = 0.0;
  end if;
  //Sweep t1
  t1 = 1e-4 + time*1e-4;
  r2 = r1 + t1;
  r3 = r2 + t2;
  
  QpL=(2.0*CN.pi/log(r1/r2))*(((A/3)*(T2^3-T1^3))+((B/2)*(T2^2-T1^2))+((C/1)*(T2^1-T1^1)));
  QpL=(2.0*CN.pi/log(r2/r3))*(((D/3)*(T3^3-T2^3))+((E/2)*(T3^2-T2^2))+((F/1)*(T3^1-T2^1)));
  QpL=(2.0*CN.pi*r3*h)*(T3-T4);

  CpL = CN.pi*(r2^2-r1^2)*c1 + CN.pi*(r3^2-r2^2)*c2 + Penalty;
end Radial_Insulation_SodiumBoiler_Riser;