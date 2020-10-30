within SolarTherm.Models.Storage.Thermocline.Parallel;

model Thermocline_Parallel_A2 //Charge A-C, Discharge C-A
  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;

  //extends Interfaces.Models.StorageFluid;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Materials.PartialMaterial;
  replaceable package Filler_Package_A = SolarTherm.Materials.PartialMaterial; //Bottomer eg. PCM_520
  replaceable package Filler_Package_B = SolarTherm.Materials.PartialMaterial; //Main Tank eg. PigIron
  
  parameter Integer Correlation = 1 "Interfacial convection correlation {1 = WakaoKaguei, 2 = MelissariArgyropoulos, 3 = Conservative}";
  
  parameter SI.Energy E_max = 144.0e9 "Maximum storage capacity of entire group";
  parameter Real frac_1 = 1.0/2.0 "Fraction of storage capacity of Tank_A";
  
  parameter Real ar = 2.0 "Aspect ratio of tank";
  parameter Real eta = 0.26 "Porosity";
  parameter Real d_p = 0.3 "Filler diameter";
  
  parameter SI.Temperature T_min = CV.from_deg(515) "Minimum temperature (design) also starting T";
  parameter SI.Temperature T_max = CV.from_deg(715) "Maximum design temperature (design)";
  
  parameter Integer N_f_A = 20 "Number of fluid CVs in Tank_A";
  parameter Integer N_p_A = 5 "Number of filler CVs in Tank_A";
  
  parameter Integer N_f_B = 20 "Number of fluid CVs in Tank_B";
  parameter Integer N_p_B = 5 "Number of filler CVs in Tank_B";
  
  
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.1 "W/m2K";
  
  Integer Active_Tank(start=1);
  
  Modelica.Blocks.Interfaces.RealOutput T_top_measured "Temperature at the top of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_bot_measured "Temperature at the bottom of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {45, -55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {-27, -65}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_amb "Ambient Temperature" annotation (Placement(
        visible = true,transformation(
        
        origin={-50, 8.88178e-16},extent={{-10, -10}, {10, 10}},
        rotation=0), iconTransformation(
        
        origin={-46, 0},extent={{-6, -6}, {6, 6}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation (Placement(
        visible = true,transformation(
        
        origin={48, 8.88178e-16},extent={{10, -10}, {-10, 10}},
        rotation=0), iconTransformation(
        
        origin={46, 0},extent={{6, -6}, {-6, 6}},
        rotation=0)));
        
//Tank_A
  SolarTherm.Models.Storage.Thermocline.Thermocline_Section2 Tank_A(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_A, Correlation = Correlation, E_max = E_max*frac_1, ar = ar, eta = eta, d_p = d_p, T_min = T_min, T_max = T_max, N_f = N_f_A, N_p = N_p_A, U_loss_tank = U_loss_tank, z_offset = 0.0);

//Tank_B
  SolarTherm.Models.Storage.Thermocline.Thermocline_Section2 Tank_B(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_B, Correlation = Correlation, E_max = E_max*(1.0 - frac_1), ar = ar, eta = eta, d_p = d_p, T_min = T_min, T_max = T_max, N_f = N_f_B, N_p = N_p_B, U_loss_tank = U_loss_tank, z_offset = Tank_A.H_tank);


  Medium.BaseProperties fluid_top;
  Medium.BaseProperties fluid_bot;

  parameter Real C_filler = Tank_A.C_filler + Tank_B.C_filler;
  parameter Real C_fluid = Tank_A.C_fluid + Tank_B.C_fluid;
  parameter Real C_total = Tank_A.C_section + Tank_B.C_section;
  parameter Real C_tank = Tank_A.C_tank + Tank_B.C_tank;
  parameter Real C_insulation = Tank_A.C_insulation + Tank_B.C_insulation;
  
  parameter SI.Temperature T_bot_high = 273.15 + 525.0;
  parameter SI.Temperature T_top_low = 273.15 + 690.0;
  
  Modelica.Blocks.Interfaces.RealOutput Level "Level of the entire storage"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 21}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));


algorithm

  when Tank_A.T_f[1] > T_bot_high then
    if Active_Tank == 1 then
      Active_Tank := 2;
      //fluid_top.T := Tank_B.T_top;
      //fluid_bot.T := Tank_B.T_bot;
    end if;
  end when;
  
  when Tank_B.T_f[N_f_B] < T_top_low then
    if Active_Tank == 2 then
      Active_Tank := 1;
      //fluid_top.T := Tank_A.T_top;
      //fluid_bot.T := Tank_A.T_bot;
    end if;
  end when;
  
  if Active_Tank == 1 then
    //fluid_top.T := Tank_A.T_top;
    //fluid_bot.T := Tank_A.T_bot;
    //h_bot_outlet = max(Tank_A.h_f[1],fluid_bot.h);
    //h_bot_outlet := fluid_bot.h;
    T_bot_measured := Tank_A.T_f[1];
    T_top_measured := Tank_A.T_f[N_f_A];
  else
    //fluid_top.T := Tank_B.T_top;
    //fluid_bot.T := Tank_B.T_bot;
    //h_bot_outlet = max(Tank_B.h_f[1],fluid_bot.h);
    //h_bot_outlet := fluid_bot.h;
    T_bot_measured := Tank_B.T_f[1];
    T_top_measured := Tank_B.T_f[N_f_B];
  end if;
  

equation
  Level = (1-frac_1)*Tank_A.Level + frac_1*Tank_B.Level;
  fluid_top.p = fluid_a.p;
  fluid_bot.p = fluid_b.p;
  if Active_Tank == 1 then
    fluid_top.T = Tank_A.T_top;
    fluid_bot.T = Tank_A.T_bot;
    //h_bot_outlet = max(Tank_A.h_f[1],fluid_bot.h);
    h_bot_outlet = fluid_bot.h;
    //T_bot_measured = Tank_A.T_f[1];
    //T_top_measured = Tank_A.T_f[N_f_A];
  else
    fluid_top.T = Tank_B.T_top;
    fluid_bot.T = Tank_B.T_bot;
    //h_bot_outlet = max(Tank_B.h_f[1],fluid_bot.h);
    h_bot_outlet = fluid_bot.h;
    //T_bot_measured = Tank_B.T_f[1];
    //T_top_measured = Tank_B.T_f[N_f_A];
  end if;
  
  //h_bot_outlet = max(Tank_A.h_f[1],fluid_bot.h);
  
  fluid_a.h_outflow = fluid_top.h;
  fluid_b.h_outflow = fluid_bot.h;

  if fluid_a.m_flow > 1e-2 then// charging
    if Active_Tank == 1 then
      Tank_A.m_flow = -1.0*fluid_a.m_flow;
      Tank_A.h_top = inStream(fluid_a.h_outflow);
      Tank_B.m_flow = 0.0;
      Tank_B.h_bot = Tank_B.h_f[1];

    else
      Tank_B.m_flow = -1.0*fluid_a.m_flow;
      Tank_B.h_top = inStream(fluid_a.h_outflow);
      Tank_A.m_flow = 0.0;
      Tank_A.h_bot = Tank_A.h_f[1];

    end if;

  elseif fluid_a.m_flow < -1e-2 then //discharing
    if Active_Tank == 1 then
      Tank_A.m_flow = -1.0*fluid_a.m_flow;
      Tank_A.h_bot = inStream(fluid_b.h_outflow);
      Tank_B.m_flow = 0.0;
      Tank_B.h_bot = Tank_B.h_f[1];

    else
      Tank_B.m_flow = -1.0*fluid_a.m_flow;
      Tank_B.h_bot = inStream(fluid_b.h_outflow);
      Tank_A.m_flow = 0.0;
      Tank_A.h_bot = Tank_A.h_f[1];

    end if;      

  else //force standby
    Tank_A.m_flow = 0.0;
    Tank_B.m_flow = 0.0;

    //fluid_a.h_outflow = inStream(fluid_b.h_outflow);
    //fluid_b.h_outflow = inStream(fluid_a.h_outflow);

    //Tank_A.h_top = Tank_A.h_bot;//inStream(fluid_a.h_outflow);
    //Tank_A.h_top = Tank_A.h_f[N_f];
    Tank_A.h_bot = Tank_A.h_f[1];
    Tank_B.h_bot = Tank_B.h_f[1];

  end if;
  
  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  T_amb = Tank_A.T_amb;
  T_amb = Tank_B.T_amb;
  
/*  
  if Active_Tank == 1 then
    T_top_measured = Tank_A.T_f[N_f_A];
    T_bot_measured = Tank_A.T_f[1];
  elseif Active_Tank == 2 then
    T_top_measured = Tank_B.T_f[N_f_B];
    T_bot_measured = Tank_B.T_f[1];
  else
    T_top_measured = Tank_C.T_f[N_f_C];
    T_bot_measured = Tank_C.T_f[1];
  end if;
*/  
  
/*  if Active_Tank == 1 then
    T_bot_measured = Tank_A.T_f[1];
    T_top_measured = Tank_A.T_f[N_f_A];
  else
    T_bot_measured = Tank_B.T_f[1];
    T_top_measured = Tank_B.T_f[N_f_B];
  end if;
*/
  //T_bot_measured = Tank_B.T_f[1];
  //T_top_measured = Tank_A.T_f[N_f_A];
//Intertank connection
  fluid_a.m_flow = -1.0*fluid_b.m_flow; //always true for a steady state component
  //Tank_B.m_flow = Tank_A.m_flow;
  //Tank_C.m_flow = Tank_B.m_flow;
  
  //Tank_A.h_top = Tank_B.h_bot;
  //Tank_B.h_top = Tank_C.h_bot;

annotation(
    Icon(graphics = {Rectangle(origin = {9, 49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-49, 11}, {31, -109}}), Text(origin = {-35, 37}, extent = {{-5, 5}, {5, -7}}, textString = "A"), Text(origin = {17, 37}, extent = {{-5, 5}, {5, -7}}, textString = "B"), Rectangle(origin = {1, 3}, fillColor = {104, 104, 104}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, 15}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, 11}, fillColor = {124, 124, 124}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, -1}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {-5, 23}, fillColor = {203, 203, 203}, fillPattern = FillPattern.Solid, extent = {{-31, 7}, {-11, 3}}), Rectangle(origin = {1, -5}, fillColor = {89, 89, 89}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {-5, -17}, fillColor = {24, 24, 24}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {-7, 19}, fillColor = {184, 184, 184}, fillPattern = FillPattern.Solid, extent = {{-29, 7}, {-9, 3}}), Rectangle(origin = {-5, -13}, fillColor = {31, 31, 31}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {1, -9}, fillColor = {71, 71, 71}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, -13}, fillColor = {66, 66, 66}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {1, 7}, fillColor = {113, 113, 113}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {-5, -9}, fillColor = {47, 47, 47}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {47, 23}, fillColor = {203, 203, 203}, fillPattern = FillPattern.Solid, extent = {{-31, 7}, {-11, 3}}), Rectangle(origin = {53, -9}, fillColor = {71, 71, 71}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, 11}, fillColor = {124, 124, 124}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {47, -17}, fillColor = {24, 24, 24}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {53, 15}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, -13}, fillColor = {66, 66, 66}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {53, -1}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {45, 19}, fillColor = {184, 184, 184}, fillPattern = FillPattern.Solid, extent = {{-29, 7}, {-9, 3}}), Rectangle(origin = {53, 7}, fillColor = {113, 113, 113}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {47, -9}, fillColor = {47, 47, 47}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {53, 3}, fillColor = {104, 104, 104}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Rectangle(origin = {47, -13}, fillColor = {31, 31, 31}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {-11, -5}}), Rectangle(origin = {53, -5}, fillColor = {89, 89, 89}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {-17, 3}}), Line(origin = {-26, -34}, points = {{0, -12}, {0, 12}, {0, 12}}), Line(origin = {-26, 38}, points = {{0, 8}, {0, -8}, {0, -8}}), Line(origin = {-15.5, 46}, points = {{-10.5, 0}, {11.5, 0}, {9.5, 0}}), Line(origin = {15, 38}, points = {{-11, 8}, {11, 8}, {11, -8}, {11, -8}}), Line(origin = {0, 53}, points = {{0, 7}, {0, -7}, {0, -7}}), Line(origin = {0, -53}, points = {{0, -7}, {0, 7}, {0, 7}}), Line(origin = {-15, -46}, points = {{-11, 0}, {11, 0}, {11, 0}}), Line(origin = {15, -34}, points = {{11, 12}, {11, -12}, {-11, -12}, {-11, -12}}), Ellipse(origin = {-5, -41}, extent = {{1, -1}, {9, -9}}, endAngle = 360), Ellipse(origin = {-5, 51}, extent = {{1, -1}, {9, -9}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));

end Thermocline_Parallel_A2;