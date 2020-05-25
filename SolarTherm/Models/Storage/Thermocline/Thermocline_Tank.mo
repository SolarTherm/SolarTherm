within SolarTherm.Models.Storage.Thermocline;

model Thermocline_Tank
extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;

  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  replaceable package Fluid_Package = SolarTherm.Media.Materials.PartialMaterial;
  replaceable package Filler_Package = SolarTherm.Media.Materials.PartialMaterial;
  
  parameter Integer Correlation = 1 "Interfacial convection correlation {1 = WakaoKaguei, 2 = MelissariArgyropoulos, 3 = Conservative}";
  parameter SI.Energy E_max = 144.0e9 "Maximum storage capacity";
  parameter Real ar = 2.0 "Aspect ratio of tank";
  parameter Real eta = 0.22 "Porosity";
  parameter SI.Length d_p = 0.015 "Filler sphere diameter";
  parameter SI.Temperature T_min = CV.from_deg(290);
  parameter SI.Temperature T_max = CV.from_deg(574);
  parameter Integer N_f = 10;
  parameter Integer N_p = 5;
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.1 "W/m2K";

  Modelica.Blocks.Interfaces.RealOutput T_top_measured "Temperature at the top of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {45, 55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_bot_measured "Temperature at the bottom of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          extent = {{40, -70}, {60, -50}}, rotation = 0), iconTransformation(origin = {45, -55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
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
  
  SolarTherm.Models.Storage.Thermocline.Thermocline_Section2 Tank_A(redeclare replaceable package Fluid_Package = Fluid_Package, redeclare replaceable package Filler_Package = Filler_Package, Correlation = Correlation, E_max = E_max, ar = ar, eta = eta, d_p = d_p, T_min = T_min, T_max = T_max, N_f = N_f, N_p = N_p, U_loss_tank = U_loss_tank);
  //Try
  Medium.BaseProperties fluid_top;
  Medium.BaseProperties fluid_bot;
  //End Try
  //Costs
  parameter Real C_filler = Tank_A.C_filler;
  parameter Real C_fluid = Tank_A.C_fluid;
  parameter Real C_total = Tank_A.C_section;
  parameter Real C_tank = Tank_A.C_tank;
  parameter Real C_insulation = Tank_A.C_insulation;
equation
  /*
  Tank_A.m_flow = -1.0*fluid_a.m_flow;
  fluid_a.m_flow = -1.0*fluid_b.m_flow;
  if fluid_a.m_flow > 0.0 then //Hot Fluid is flowing into the top (charging)
  //if fluid_a.m_flow > 0.0 then //Hot Fluid is flowing into the top (charging)
    Tank_A.h_top = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = Tank_A.h_top;
    fluid_b.h_outflow = Tank_A.h_bot;
  else //Cold fluid is flowing to the bottom
    Tank_A.h_bot = inStream(fluid_b.h_outflow);
    fluid_a.h_outflow = Tank_A.h_top;
    fluid_b.h_outflow = Tank_A.h_bot;
  end if;
  */
  //Try
  fluid_top.p = fluid_a.p;
  fluid_bot.p = fluid_b.p;
  fluid_top.T = Tank_A.T_top;
  fluid_bot.T = Tank_A.T_bot;
  
  fluid_a.m_flow = -1.0*fluid_b.m_flow; //always true for a steady state component
  if fluid_a.m_flow > 1e-6 then// charging
    Tank_A.m_flow = -1.0*fluid_a.m_flow;
    Tank_A.h_top = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
  elseif fluid_a.m_flow < -1e-6 then //discharing
    Tank_A.m_flow = -1.0*fluid_a.m_flow;
    Tank_A.h_bot = inStream(fluid_b.h_outflow);
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
  else //force standby
    Tank_A.m_flow = 0.0;
    //fluid_a.h_outflow = inStream(fluid_b.h_outflow);
    //fluid_b.h_outflow = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = fluid_top.h;
    fluid_b.h_outflow = fluid_bot.h;
    //Tank_A.h_top = Tank_A.h_bot;//inStream(fluid_a.h_outflow);
    //Tank_A.h_top = Tank_A.h_f[N_f];
    Tank_A.h_bot = Tank_A.h_f[1];
  end if;
  //End try
  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  T_amb = Tank_A.T_amb;
  T_top_measured = Tank_A.T_f[N_f-1];
  T_bot_measured = Tank_A.T_f[2];

annotation(
    Icon(graphics = {Text(origin = {7, -16}, extent = {{-49, 42}, {35, -10}}, textString = "TC")}, coordinateSystem(initialScale = 0.1)));
end Thermocline_Tank;