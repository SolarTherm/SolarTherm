within SolarTherm.Models.Storage.Thermocline.Cascaded;

model Thermocline_Group_4
  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;

  //extends Interfaces.Models.StorageFluid;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Materials.PartialMaterial;
  replaceable package Filler_Package_A = SolarTherm.Materials.PartialMaterial; //Bottomer eg. PCM_520
  replaceable package Filler_Package_B = SolarTherm.Materials.PartialMaterial; //Lower Middle Tank eg. PigIron
  replaceable package Filler_Package_C = SolarTherm.Materials.PartialMaterial; //Upper Middle Tank
  replaceable package Filler_Package_D = SolarTherm.Materials.PartialMaterial; //Topper eg. PCM_710
  parameter Integer Correlation = 1 "Interfacial convection correlation {1 = WakaoKaguei, 2 = MelissariArgyropoulos, 3 = Conservative}";
  
  parameter SI.Energy E_max = 144.0e9 "Maximum storage capacity of entire group";
  parameter Real frac_1 = 0.1 "Fraction of storage capacity of Tank_A";
  parameter Real frac_2 = 0.1 "Fraction of storage capacity of Tank_B";
  parameter Real frac_3 = 0.1 "Fraction of storage capacity of Tank_C";
  
  parameter Real ar = 2.0 "Aspect ratio of tank";
  parameter Real eta = 0.26 "Porosity";
  parameter Real d_p = 0.3 "Filler diameter";
  
  parameter SI.Temperature T_min = CV.from_deg(515) "Minimum temperature (design) also starting T";
  parameter SI.Temperature T_max = CV.from_deg(715) "Maximum design temperature (design)";
  
  parameter Integer N_f_A = 25 "Number of fluid CVs in Tank_A";
  parameter Integer N_p_A = 5 "Number of filler CVs in Tank_A";
  
  parameter Integer N_f_B = 25 "Number of fluid CVs in Tank_B";
  parameter Integer N_p_B = 5 "Number of filler CVs in Tank_B";
  
  parameter Integer N_f_C = 25 "Number of fluid CVs in Tank_C";
  parameter Integer N_p_C = 5 "Number of filler CVs in Tank_C";
  
  parameter Integer N_f_D = 25 "Number of fluid CVs in Tank_D";
  parameter Integer N_p_D = 5 "Number of filler CVs in Tank_D";
  
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.1 "W/m2K";
  
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
        
//Tank_A is the Bottomer Tank
  SolarTherm.Models.Storage.Thermocline.Thermocline_Section2 Tank_A(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_A, Correlation = Correlation, E_max = E_max*frac_1, ar = ar, eta = eta, d_p = d_p, T_min = T_min, T_max = T_max, N_f = N_f_A, N_p = N_p_A, U_loss_tank = U_loss_tank, z_offset = 0.0);

//Tank_B is the Lower Middle Tank
  SolarTherm.Models.Storage.Thermocline.Thermocline_Section2 Tank_B(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_B, Correlation = Correlation, E_max = E_max*frac_2, ar = ar, eta = eta, d_p = d_p, T_min = T_min, T_max = T_max, N_f = N_f_B, N_p = N_p_B, U_loss_tank = U_loss_tank, z_offset = Tank_A.H_tank);

//Tank_C is the Upper Middle Tank
  SolarTherm.Models.Storage.Thermocline.Thermocline_Section2 Tank_C(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_C, Correlation = Correlation, E_max = E_max*frac_3, ar = ar, eta = eta, d_p = d_p, T_min = T_min, T_max = T_max, N_f = N_f_C, N_p = N_p_C, U_loss_tank = U_loss_tank, z_offset = Tank_A.H_tank + Tank_B.H_tank);
  
//Tank_D is the Topper Tank
  SolarTherm.Models.Storage.Thermocline.Thermocline_Section2 Tank_D(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package_D, Correlation = Correlation, E_max = E_max*(1.0-frac_1-frac_2-frac_3), ar = ar, eta = eta, d_p = d_p, T_min = T_min, T_max = T_max, N_f = N_f_D, N_p = N_p_D, U_loss_tank = U_loss_tank, z_offset = Tank_A.H_tank + Tank_B.H_tank + Tank_C.H_tank);

  Medium.BaseProperties fluid_top;
  Medium.BaseProperties fluid_bot;

  parameter Real C_filler = Tank_A.C_filler + Tank_B.C_filler + Tank_C.C_filler + Tank_D.C_filler;
  parameter Real C_fluid = Tank_A.C_fluid + Tank_B.C_fluid + Tank_C.C_fluid + Tank_D.C_fluid;
  parameter Real C_total = Tank_A.C_section + Tank_B.C_section + Tank_C.C_section + Tank_D.C_section;
  parameter Real C_tank = Tank_A.C_tank + Tank_B.C_tank + Tank_C.C_tank + Tank_D.C_tank;
  parameter Real C_insulation = Tank_A.C_insulation + Tank_B.C_insulation + Tank_C.C_insulation + Tank_D.C_insulation;

  //Theoretical tank level
  Real Level;
  parameter Real ZDH[N_f_A+N_f_B+N_f_C+N_f_D] = cat(1,((Tank_A.ZDH.*Tank_A.H_tank).+Tank_A.z_offset)./(Tank_A.H_tank+Tank_B.H_tank+Tank_C.H_tank+Tank_D.H_tank),((Tank_B.ZDH.*Tank_B.H_tank).+Tank_B.z_offset)./(Tank_A.H_tank+Tank_B.H_tank+Tank_C.H_tank+Tank_D.H_tank),((Tank_C.ZDH.*Tank_C.H_tank).+Tank_C.z_offset)./(Tank_A.H_tank+Tank_B.H_tank+Tank_C.H_tank+Tank_D.H_tank),((Tank_D.ZDH.*Tank_D.H_tank).+Tank_D.z_offset)./(Tank_A.H_tank+Tank_B.H_tank+Tank_C.H_tank+Tank_D.H_tank));
  Real T_f_degC[N_f_A+N_f_B+N_f_C+N_f_D](start=fill(T_min,N_f_A+N_f_B+N_f_C+N_f_D));

equation
  T_f_degC = (cat(1,Tank_A.T_f,Tank_B.T_f,Tank_C.T_f,Tank_D.T_f)).-273.15;
  Level = (Tank_A.Level*Tank_A.E_max+Tank_B.Level*Tank_B.E_max+Tank_C.Level*Tank_C.E_max+Tank_D.Level*Tank_D.E_max)/E_max;
  fluid_top.p = fluid_a.p;
  fluid_bot.p = fluid_b.p;
  fluid_top.T = Tank_D.T_top;
  fluid_bot.T = Tank_A.T_bot;
  
  h_bot_outlet = max(Tank_A.h_f[1],fluid_bot.h);
  

  if fluid_a.m_flow > 1e-2 then// charging
    Tank_D.m_flow = -1.0*fluid_a.m_flow;
    Tank_D.h_top = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
  elseif fluid_a.m_flow < -1e-2 then //discharing
    Tank_D.m_flow = -1.0*fluid_a.m_flow;
    Tank_A.h_bot = inStream(fluid_b.h_outflow);
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
  else //force standby
    Tank_D.m_flow = 0.0;
    //fluid_a.h_outflow = inStream(fluid_b.h_outflow);
    //fluid_b.h_outflow = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
    //Tank_A.h_top = Tank_A.h_bot;//inStream(fluid_a.h_outflow);
    //Tank_A.h_top = Tank_A.h_f[N_f];
    Tank_A.h_bot = Tank_A.h_f[1];
  end if;
  
  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  T_amb = Tank_A.T_amb;
  T_amb = Tank_B.T_amb;
  T_amb = Tank_C.T_amb;
  T_amb = Tank_D.T_amb;
  
  T_top_measured = Tank_D.T_f[N_f_D];
  T_bot_measured = Tank_A.T_f[1];
  
  //Intertank connection
  fluid_a.m_flow = -1.0*fluid_b.m_flow; //always true for a steady state component
  Tank_B.m_flow = Tank_A.m_flow;
  Tank_C.m_flow = Tank_B.m_flow;
  Tank_D.m_flow = Tank_C.m_flow;
  
  Tank_A.h_top = Tank_B.h_bot;
  Tank_B.h_top = Tank_C.h_bot;
  Tank_C.h_top = Tank_D.h_bot;

annotation(
    Icon(graphics = {Rectangle(origin = {9, 49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-49, 11}, {31, -109}}), Rectangle(origin = {15, 53}, fillColor = {99, 0, 1}, fillPattern = FillPattern.Solid, extent = {{-31, 7}, {1, 3}}), Rectangle(origin = {15, -55}, fillColor = {24, 24, 24}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {1, -5}}), Rectangle(origin = {7, 33}, fillColor = {144, 144, 144}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Line(origin = {0, 44}, points = {{0, 4}, {0, -4}}), Line(origin = {0, -44}, points = {{0, 4}, {0, -4}, {0, -4}}), Rectangle(origin = {7, 23}, fillColor = {124, 124, 124}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Rectangle(origin = {7, 13}, fillColor = {113, 113, 113}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Rectangle(origin = {7, -17}, fillColor = {89, 89, 89}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Rectangle(origin = {7, -27}, fillColor = {71, 71, 71}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Rectangle(origin = {7, -37}, fillColor = {66, 66, 66}, fillPattern = FillPattern.Solid, extent = {{-37, 7}, {23, -3}}), Rectangle(origin = {15, -51}, fillColor = {31, 31, 31}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {1, -5}}), Rectangle(origin = {15, -47}, fillColor = {47, 47, 47}, fillPattern = FillPattern.Solid, extent = {{-31, -1}, {1, -5}}), Rectangle(origin = {15, 53}, fillColor = {203, 203, 203}, fillPattern = FillPattern.Solid, extent = {{-31, 7}, {1, 3}}), Rectangle(origin = {15, 49}, fillColor = {184, 184, 184}, fillPattern = FillPattern.Solid, extent = {{-31, 7}, {1, 3}}), Rectangle(origin = {15, 45}, fillColor = {157, 157, 157}, fillPattern = FillPattern.Solid, extent = {{-31, 7}, {1, 3}}), Text(origin = {-35, -53}, extent = {{-5, 5}, {5, -7}}, textString = "A"), Text(origin = {-35, -25}, extent = {{-5, 5}, {5, -7}}, textString = "B"), Text(origin = {-35, 27}, extent = {{-5, 5}, {5, -7}}, textString = "C"), Ellipse(origin = {-25, 35}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {25, 35}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {15, 35}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {5, 35}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-5, 35}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-15, 35}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-21, -35}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {19, -35}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {9, -35}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-1, -35}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-11, -35}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-21, 25}, fillColor = {80, 0, 20}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-11, 25}, fillColor = {80, 0, 20}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {19, 25}, fillColor = {80, 0, 20}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-1, 25}, fillColor = {80, 0, 20}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {9, 25}, fillColor = {80, 0, 20}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-25, 15}, fillColor = {60, 0, 40}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-15, 15}, fillColor = {60, 0, 40}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {15, 15}, fillColor = {60, 0, 40}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-5, 15}, fillColor = {60, 0, 40}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {5, 15}, fillColor = {60, 0, 40}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {25, 15}, fillColor = {60, 0, 40}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-21, -15}, fillColor = {40, 0, 60}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-11, -15}, fillColor = {40, 0, 60}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {19, -15}, fillColor = {40, 0, 60}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {9, -15}, fillColor = {40, 0, 60}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-1, -15}, fillColor = {40, 0, 60}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-25, -25}, fillColor = {20, 0, 80}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-15, -25}, fillColor = {20, 0, 80}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {25, -25}, fillColor = {20, 0, 80}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {15, -25}, fillColor = {20, 0, 80}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {5, -25}, fillColor = {20, 0, 80}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-5, -25}, fillColor = {20, 0, 80}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {5, -5}}, endAngle = 360), Ellipse(origin = {-11, 55}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {17, 55}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {13, 55}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {9, 55}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {5, 55}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {1, 55}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-3, 55}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-7, 55}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-9, 51}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {15, 51}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {11, 51}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {7, 51}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {3, 51}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-1, 51}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-5, 51}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-11, 47}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {17, 47}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {13, 47}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {9, 47}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {5, 47}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {1, 47}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-3, 47}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-7, 47}, fillColor = {100, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-11, -53}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {17, -53}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {13, -53}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {9, -53}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {5, -53}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {1, -53}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-3, -53}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-7, -53}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {11, -57}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-1, -57}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-5, -57}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-9, -57}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {3, -57}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {15, -57}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {7, -57}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {13, -61}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {1, -61}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-3, -61}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-7, -61}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {5, -61}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {17, -61}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {9, -61}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Ellipse(origin = {-11, -61}, fillColor = {0, 0, 100}, fillPattern = FillPattern.Sphere, extent = {{-5, 5}, {-1, 1}}, endAngle = 360), Text(origin = {-35, 55}, extent = {{-5, 5}, {5, -7}}, textString = "D"), Line(points = {{0, 10}, {0, -10}})}, coordinateSystem(initialScale = 0.1)));
end Thermocline_Group_4;