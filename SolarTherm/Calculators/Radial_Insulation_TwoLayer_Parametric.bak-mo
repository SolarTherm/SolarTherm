within SolarTherm.Calculators;

model Radial_Insulation_TwoLayer_Parametric
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Blocks.Math;
  //Cubic coefficients of Refractory (High-Temp Material)
  parameter Real A = 2.995E-2;
  parameter Real B = -2.915E-5;
  parameter Real C = 4.375E-8;
  parameter Real D = 0.0;

  //Cubic coefficient of Insulation (RockWool)
  parameter Real E = 1.929E-2;
  parameter Real F = -3.446E-6;
  parameter Real G = 1.717E-7;
  parameter Real H = 0.0;
 
  parameter Real c1 = 4269.0*(816.0/541.7) "Cost per unit volume of  Refractory (USD_2022)";
  parameter Real c2 = 44.0*(816.0/541.7) "Cost per unit volume of RockWool Insulation (USD_2022)";
  
  parameter SI.Temperature T1 = 600.0 + 273.15 "Inner Pipe temperature (K)"; 
  parameter SI.Length d1 = 0.1 "Pipe diameter (m)";
  
  parameter SI.Temperature T4 = 25.0 + 273.15 "Ambient temperature (K)";
  parameter SI.CoefficientOfHeatTransfer h_amb = 10.0 "Convective heat transfer coefficient of the outer surface (K)";

  parameter SI.Temperature T2_Max = 450.0 + 273.15 "Maximum tolerable insulation temperature (K)";
  
  SI.CoefficientOfHeatTransfer U "Overall heat loss coefficient using bare pipe area (W/m2K)";
  SI.ThermalInsulance R "Inverse of U (m2K/W)";
  
  SI.Length d3[t1_divs] "Total pipe diameter, including the insulating layers (m)";
  SI.Length t_sum[t1_divs] "Total thickness of refractory and insulation (m)";
  
  parameter Integer t1_divs = 11 "number of divisions in thickness_1 expored";
  parameter SI.Length t1_min = 1.0e-2 "1.0 cm";
  parameter SI.Length t1_max = 10.0e-2 "10.0 cm";
  //parameter Real QpL = 0.0001*18.5e6/1.0 "Acceptable Heat Rate per metre of piping (W/m)";
  //parameter SI.Temperature T3 = 50.0 + 273.15;

  //Calculation
  Real T2[t1_divs](start = fill(400,t1_divs));
  Real T3[t1_divs](start = fill(30,t1_divs));
  parameter Real r1 = d1/2.0;
  
  SI.Length r2[t1_divs](start = fill(r1 + 1e-2,t1_divs));
  SI.Length r3[t1_divs](start = fill(r1 + 1e-2+0.4,t1_divs));
  
  SI.Length t2[t1_divs] (start=fill(1e-2,t1_divs));
  parameter SI.Length t1[t1_divs] = linspace(t1_min,t1_max+t1_min,t1_divs);

  
  Real CpL[t1_divs] "Cost per length of piping (USD/m)";
  Real CpL_min "Min Cost per length of piping (USD/m)";
  Real Penalty[t1_divs] "Very large cost penalty for invalid design (USD/m)";
  //parameter Real QpL = CN.pi*d1*h_amb*(373.15-T4) "Heat loss rate per unit length (W/m)";
  Real QpL (min = 1e-12);
  
algorithm
  //if (T2 < T4) or (T3 < T4) or (r3 < r2) or (t2 < 1e-6) then
    //terminate("Invalid");
  //end if;
  
equation
  for i in 1:t1_divs loop
    if (T2[i] < T3[i]) or (T3[i] < T4) or (t2[i] < 0) or (T2[i] > T2_Max) then
      Penalty[i] = 100000.0;
    else
      Penalty[i] = 0.0;
    end if;
  end for;
  
  R = 1.0/U;
    
  U = 0.1 + time*0.1;
  //Sweep t1
  //t1 = 1e-3 + time*1e-3;
  //der(t_sum) = 0.01;
  
  QpL = CN.pi*d1*U*(T1-T4);
  for i in 1:t1_divs loop
    r2[i] = r1 + t1[i];
    r3[i] = r2[i] + t2[i];
    t1[i] + t2[i] = t_sum[i];
  
    d3[i] = 2.0*r3[i];
  
    QpL=(CN.pi*d3[i]*h_amb)*(T3[i]-T4);
    QpL= (2.0*CN.pi/log(r2[i]/r3[i]))*(((E/1)*(T3[i]^1-T2[i]^1))+((F/2)*(T3[i]^2-T2[i]^2))+((G/3)*(T3[i]^3-T2[i]^3))+((H/4)*(T3[i]^4-T2[i]^4)));
  
    (2.0*CN.pi/log(r1/r2[i]))*(((A/1)*(T2[i]^1-T1^1))+((B/2)*(T2[i]^2-T1^2))+((C/3)*(T2[i]^3-T1^3))+((D/4)*(T2[i]^4-T1^4))) = (2.0*CN.pi/log(r2[i]/r3[i]))*(((E/1)*(T3[i]^1-T2[i]^1))+((F/2)*(T3[i]^2-T2[i]^2))+((G/3)*(T3[i]^3-T2[i]^3))+((H/4)*(T3[i]^4-T2[i]^4)));
    
    CpL[i] = CN.pi*(r2[i]^2-r1^2)*c1 + CN.pi*(r3[i]^2-r2[i]^2)*c2 + Penalty[i];
  end for;
  
  CpL_min = min(CpL);
  

annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),experiment(StopTime = 4, StartTime = 0, Tolerance = 1.0e-5, Interval = 1, maxStepSize = 1, initialStepSize = 1),
    Documentation(info = "<html><head></head><body><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><font face=\"DejaVu Sans Mono\">Year - CEPCI</font></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><font face=\"DejaVu Sans Mono\">2015 - 556.8</font></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><font face=\"DejaVu Sans Mono\">2016 - 541.7</font></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><font face=\"DejaVu Sans Mono\">2017 - 567.5</font></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><font face=\"DejaVu Sans Mono\">2018 - 603.1</font></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><font face=\"DejaVu Sans Mono\">2019 - 607.5</font></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><font face=\"DejaVu Sans Mono\">2020 - 596.2</font></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><font face=\"DejaVu Sans Mono\">2021 - 708.8</font></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><font face=\"DejaVu Sans Mono\">2022 - 816.0</font></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><font face=\"DejaVu Sans Mono\">2023 - 797.9</font></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><font face=\"DejaVu Sans Mono\">2024 - 795.1 (Preliminary)</font></div></body></html>"));
end Radial_Insulation_TwoLayer_Parametric;