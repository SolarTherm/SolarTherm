within SolarTherm.Systems;

model WindPVannularTESsystem
  extends Modelica.Icons.Example;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Constants.*;
  parameter String elec_input = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/heater_input.motab");
  parameter String schd_input = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/schedule_mflow.motab");
  
  replaceable package Fluid = SolarTherm.Materials.Air_Table;
  replaceable package Filler = SolarTherm.Materials.Concrete_Laing_2006_Variation;
  parameter Integer N_f = 20; 
  parameter Integer N_p = 5;
  parameter SI.Length L_pipe = 23.0;
  parameter SI.Length D_pipe = 0.020;
  parameter SI.Length D_solid = 0.080;//0.09003;
  parameter Real U_loss_tank = 0.0;
  parameter Integer Correlation = 1; //1:Liquid 2:Gas
  
  parameter Modelica.SIunits.Energy E_max = t_storage * 3600.0 * Q_flow_des "Maximum tank stored energy";
  parameter Real t_storage(unit = "h") = 10 "Hours of storage";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_des = 800e6 "Heat to power block at design";
  //parameter Real ar = 0.48/0.5;
  
  replaceable package Medium = SolarTherm.Media.Air.Air_amb_p;
  parameter Modelica.SIunits.Temperature T_hot_set = from_degC(565) "Ideal hot temperature";
  parameter Modelica.SIunits.Temperature T_cold_set = from_degC(280) "Ideal cold temperature";
  
  parameter Medium.ThermodynamicState state_air_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold air thermodynamic state at design";
  parameter Medium.ThermodynamicState state_air_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hold air thermodynamic state at design";
  parameter Modelica.SIunits.SpecificEnthalpy h_air_cold_set = Medium.specificEnthalpy(state_air_cold_set) "Cold air specific enthalpy at design";  
  parameter Modelica.SIunits.SpecificEnthalpy h_air_hot_set = Medium.specificEnthalpy(state_air_hot_set) "Hot air specific enthalpy at design";
  
  replaceable package SaltRef = SolarTherm.Media.MoltenSalt.MoltenSalt_ph;
  parameter Medium.ThermodynamicState state_salt_cold_set = SaltRef.setState_pTX(SaltRef.p_default, T_cold_set) "Cold salt thermodynamic state at design";
  parameter Medium.ThermodynamicState state_salt_hot_set = SaltRef.setState_pTX(SaltRef.p_default, T_hot_set) "Hold salt thermodynamic state at design";
  parameter Modelica.SIunits.SpecificEnthalpy h_salt_cold_set = SaltRef.specificEnthalpy(state_salt_cold_set) "Cold salt specific enthalpy at design";  
  parameter Modelica.SIunits.SpecificEnthalpy h_salt_hot_set = SaltRef.specificEnthalpy(state_salt_hot_set) "Hot salt specific enthalpy at design";
  
  parameter Modelica.SIunits.HeatFlowRate Q_start = 1e-3;
  parameter Modelica.SIunits.HeatFlowRate Q_stop = 1e-3;
  Modelica.SIunits.HeatFlowRate Q_scheduled;
  
  SolarTherm.Models.Storage.Thermocline.Thermocline_Annular_SingleTank_Final thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler, N_f = N_f, N_p = N_p, T_max = T_hot_set, T_min = T_cold_set, Correlation = 2, E_max = E_max, L_pipe = L_pipe, D_pipe = D_pipe, D_solid = D_solid, U_loss_tank = U_loss_tank) annotation(
    Placement(visible = true, transformation(origin = {56, 0}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater annotation(
    Placement(visible = true, transformation(origin = {-48, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe(redeclare package Medium = Medium, diameter = 0.254, length = 1, modelStructure = Modelica.Fluid.Types.ModelStructure.a_vb, nNodes = 1, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {-20, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  SolarTherm.Models.Fluid.HeatExchangers.Boiler boiler(T_cold_set = T_cold_set)  annotation(
    Placement(visible = true, transformation(origin = {158, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Sources.GridInput gridInput(Q_start = Q_start, Q_stop = Q_stop, W_curtailment = Q_flow_des, elec_input = elec_input)  annotation(
    Placement(visible = true, transformation(origin = {-88, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {10, -64}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction Splitter_Top(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {56, 53.6883}, extent = {{-18, 0}, {18, 21.8731}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction_LoopBreaker Splitter_Bot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {58, -51.4824}, extent = {{18, 17.8256}, {-18, -17.8256}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpHot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {91, 77}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {17, 0}, extent = {{-9, -12}, {9, 12}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {107, 2.22045e-16}, extent = {{11, -12}, {-11, 12}}, rotation = 0)));
  inner Modelica.Fluid.System system(T_start = from_degC(290), allowFlowReversal = false, p_start = Medium.p_default) annotation(
    Placement(visible = true, transformation(origin = {-136, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.WindPV_TESControl Control annotation(
    Placement(visible = true, transformation(origin = {108, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Demand(y = Q_scheduled)  annotation(
    Placement(visible = true, transformation(origin = {180, 70}, extent = {{16, -10}, {-16, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression h_boiler_out(y = h_air_cold_set)  annotation(
    Placement(visible = true, transformation(origin = {182, 90}, extent = {{18, -10}, {-18, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Supply(y = gridInput.grid_input.y[1])  annotation(
    Placement(visible = true, transformation(origin = {-73, 56}, extent = {{-21, -10}, {21, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable scheduler(fileName = schd_input, tableName = "m_flow", tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {184, 38}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  gridInput.Q_defocus_y = min(gridInput.grid_input.y[1], scheduler.y[1] * (h_salt_hot_set - h_salt_cold_set));
  Q_scheduled = scheduler.y[1] * (h_salt_hot_set - h_salt_cold_set);


  connect(gridInput.electricity, heater.Q_flow) annotation(
    Line(points = {{-78, 6}, {-58, 6}}, color = {0, 0, 127}));
  connect(heater.port, pipe.heatPorts[1]) annotation(
    Line(points = {{-38, 6}, {-24, 6}}, color = {191, 0, 0}));
  connect(thermocline_Tank.fluid_b, Splitter_Bot.fluid_c) annotation(
    Line(points = {{56, -30}, {56, -39.5}, {58, -39.5}, {58, -51}}, color = {0, 127, 255}));
  connect(Tamb.y, thermocline_Tank.T_amb) annotation(
    Line(points = {{27, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(p_amb.y, thermocline_Tank.p_amb) annotation(
    Line(points = {{95, 0}, {74, 0}}, color = {0, 0, 127}));
  connect(Splitter_Bot.fluid_b, pumpCold.fluid_a) annotation(
    Line(points = {{43, -66}, {31.5, -66}, {31.5, -64}, {20, -64}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, pipe.port_a) annotation(
    Line(points = {{0, -64}, {-20, -64}, {-20, -4}}, color = {0, 127, 255}));
  connect(pipe.port_b, Splitter_Top.fluid_a) annotation(
    Line(points = {{-20, 16}, {-20, 78}, {42, 78}}, color = {0, 127, 255}));
  connect(Control.curtail, gridInput.defocus) annotation(
    Line(points = {{119, 22}, {130, 22}, {130, 98}, {-126, 98}, {-126, 6}, {-98, 6}}, color = {255, 0, 255}));
  connect(Control.m_flow_PB, pumpCold.m_flow) annotation(
    Line(points = {{119, 27}, {132, 27}, {132, -90}, {-16, -90}, {-16, -42}, {10, -42}, {10, -56}}, color = {0, 0, 127}));
  connect(thermocline_Tank.h_bot_outlet, Control.h_tank_outlet) annotation(
    Line(points = {{46, -26}, {46, -32}, {86, -32}, {86, 60}, {104, 60}, {104, 37}}, color = {0, 0, 127}));
  connect(thermocline_Tank.T_top_measured, Control.T_top_tank) annotation(
    Line(points = {{74, 20}, {78, 20}, {78, 24}, {97, 24}}, color = {0, 0, 127}));
  connect(thermocline_Tank.T_bot_measured, Control.T_bot_tank) annotation(
    Line(points = {{74, -22}, {82, -22}, {82, 20}, {97, 20}}, color = {0, 0, 127}));
  connect(thermocline_Tank.Level, Control.Level) annotation(
    Line(points = {{74, 8}, {92, 8}, {92, 54}, {97, 54}, {97, 29}}, color = {0, 0, 127}));
  connect(Demand.y, Control.Q_demand) annotation(
    Line(points = {{162, 70}, {115, 70}, {115, 37}}, color = {0, 0, 127}));
  connect(h_boiler_out.y, Control.h_PB_outlet) annotation(
    Line(points = {{162, 90}, {110, 90}, {110, 37}, {109, 37}}, color = {0, 0, 127}));
  connect(Control.Q_rcv_raw, Supply.y) annotation(
    Line(points = {{97, 33}, {24, 33}, {24, 56}, {-50, 56}}, color = {0, 0, 127}));
  connect(Splitter_Top.fluid_c, thermocline_Tank.fluid_a) annotation(
    Line(points = {{56, 60}, {56, 60}, {56, 30}, {56, 30}}, color = {0, 127, 255}));
  connect(Control.m_flow_recv, pumpHot.m_flow) annotation(
    Line(points = {{120, 32}, {126, 32}, {126, 94}, {92, 94}, {92, 84}, {92, 84}}, color = {0, 0, 127}));
  connect(Splitter_Top.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{70, 78}, {82, 78}, {82, 76}, {82, 76}}, color = {0, 127, 255}));
  connect(pumpHot.fluid_b, boiler.fluid_a) annotation(
    Line(points = {{100, 78}, {158, 78}, {158, 12}, {158, 12}}, color = {0, 127, 255}));
  connect(boiler.fluid_b, Splitter_Bot.fluid_a) annotation(
    Line(points = {{158, -8}, {158, -8}, {158, -66}, {72, -66}, {72, -66}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-200, -100}, {200, 100}}, initialScale = 0.1), graphics = {Text(origin = {107, -76}, extent = {{-11, 4}, {23, -10}}, textString = "Hot Pump"), Text(origin = {7, -78}, extent = {{-11, 4}, {23, -10}}, textString = "Cold Pump")}),
    Icon(coordinateSystem(extent = {{-200, -100}, {200, 100}}, preserveAspectRatio = false)));
end WindPVannularTESsystem;