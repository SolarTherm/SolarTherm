within SolarTherm.Systems;

model WindPVannularTESsystem
  extends Modelica.Icons.Example;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Constants.*;
  replaceable package Medium = SolarTherm.Media.Air.Air_amb_p;
  parameter String elec_input = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/heater_input.motab");
  
  SolarTherm.Models.Storage.Thermocline.Thermocline_Annular_SingleTank_VD_Final thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid, redeclare package Filler_Package = Filler, N_f = N_f, N_p = N_p, T_max = T_max, T_min = T_min, Correlation = Correlation, E_max = E_max, L_pipe = L_pipe, D_pipe = D_pipe, D_solid = D_solid, Tank_A.T_f_start = T_f_start, Tank_A.h_f_start = h_f_start, Tank_A.T_p_start = T_p_start, Tank_A.h_p_start = h_p_start, Tank_A.Multiplier = Multiplier, Multiplier = Multiplier) annotation(
    Placement(visible = true, transformation(origin = {56, 0}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater annotation(
    Placement(visible = true, transformation(origin = {-48, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe(redeclare package Medium = Medium, diameter = 0.254, length = 1, modelStructure = Modelica.Fluid.Types.ModelStructure.a_vb, nNodes = 1, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {-20, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  SolarTherm.Models.Fluid.HeatExchangers.Boiler boiler(T_cold_set = T_cold_set)  annotation(
    Placement(visible = true, transformation(origin = {144, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression curtailment(y = curtail) annotation(
    Placement(visible = true, transformation(origin = {-134, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Sources.GridInput gridInput(Q_start = Q_start, Q_stop = Q_stop, W_curtailment = Q_flow_des, elec_input = elec_input)  annotation(
    Placement(visible = true, transformation(origin = {-88, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction Splitter_Top(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {56, 53.6883}, extent = {{-18, 0}, {18, 21.8731}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink Boiler_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {184, -22}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink StorBot_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-6, -64}, extent = {{24, -24}, {-24, 24}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction Splitter_Bot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {56, -31.6568}, extent = {{18, 0}, {-18, -21.6512}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT AmbAir_Left(redeclare package Medium = Medium, T = 25.0 + 273.15,nPorts = 1, p = 101325, use_T_in = false) annotation(
    Placement(visible = true, transformation(origin = {-125, -31}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpHot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {111, -65}, extent = {{9, -9}, {-9, 9}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT AmbAir_Right(redeclare package Medium = Medium, T = 25.0 + 273.15, nPorts = 1, p = 101325, use_T_in = false) annotation(
    Placement(visible = true, transformation(origin = {183, -65}, extent = {{11, -11}, {-11, 11}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {17, 0}, extent = {{-9, -12}, {9, 12}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {103, 2.22045e-16}, extent = {{11, -12}, {-11, 12}}, rotation = 0)));
    
  SolarTherm.Models.Fluid.Sensors.Temperature Temp_Left(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-88, -30}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  SolarTherm.Models.Fluid.Sensors.Temperature Temp_Right(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {149, -65}, extent = {{-9, 9}, {9, -9}}, rotation = 180)));
  inner Modelica.Fluid.System system(T_start = from_degC(290), allowFlowReversal = false, p_start = Medium.p_default) annotation(
    Placement(visible = true, transformation(origin = {-162, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(gridInput.electricity, heater.Q_flow) annotation(
    Line(points = {{-78, 38}, {-58, 38}}, color = {0, 0, 127}));
  connect(curtailment.y, gridInput.defocus) annotation(
    Line(points = {{-123, 38}, {-98, 38}}, color = {255, 0, 255}));
  connect(heater.port, pipe.heatPorts[1]) annotation(
    Line(points = {{-38, 38}, {-24, 38}}, color = {191, 0, 0}));
  connect(Splitter_Top.fluid_c, thermocline_Tank.fluid_a) annotation(
    Line(points = {{56, 60}, {56, 30}}, color = {0, 127, 255}));
  connect(boiler.fluid_b, Boiler_Sink.port_a) annotation(
    Line(points = {{144, -10}, {144, -22}, {160, -22}}, color = {0, 127, 255}));
  connect(thermocline_Tank.fluid_b, Splitter_Bot.fluid_c) annotation(
    Line(points = {{56, -30}, {56, -47}}, color = {0, 127, 255}));
  connect(pumpHot.fluid_b, Splitter_Bot.fluid_a) annotation(
    Line(points = {{102, -65}, {70, -65}}));
  connect(Tamb.y, thermocline_Tank.T_amb) annotation(
    Line(points = {{27, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(p_amb.y, thermocline_Tank.p_amb) annotation(
    Line(points = {{91, 0}, {74, 0}}, color = {0, 0, 127}));
  connect(AmbAir_Right.ports[1], Temp_Right.fluid_a) annotation(
    Line(points = {{172, -65}, {158, -65}}, color = {0, 127, 255}));
  connect(Temp_Right.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{140, -65}, {120, -65}}, color = {0, 127, 255}));
  connect(Splitter_Top.fluid_b, boiler.fluid_a) annotation(
    Line(points = {{70, 77}, {144, 77}, {144, 10}}, color = {0, 127, 255}));
  connect(Splitter_Bot.fluid_b, StorBot_Sink.port_a) annotation(
    Line(points = {{42, -64}, {18, -64}}));
  connect(Splitter_Top.fluid_a, pipe.port_b) annotation(
    Line(points = {{42, 77}, {-20, 77}, {-20, 48}}, color = {0, 127, 255}));
  connect(pipe.port_a, pumpCold.fluid_b) annotation(
    Line(points = {{-20, 28}, {-20, -30}, {-46, -30}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_a, Temp_Left.fluid_b) annotation(
    Line(points = {{-66, -30}, {-78, -30}}, color = {0, 127, 255}));
  connect(AmbAir_Left.ports[1], Temp_Left.fluid_a) annotation(
    Line(points = {{-114, -30}, {-98, -30}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-200, -100}, {200, 100}}, initialScale = 0.1), graphics = {Text(origin = {107, -76}, extent = {{-11, 4}, {23, -10}}, textString = "Hot Pump"), Text(origin = {-61, -42}, extent = {{-11, 4}, {23, -10}}, textString = "Cold Pump")}),
    Icon(coordinateSystem(extent = {{-200, -100}, {200, 100}}, preserveAspectRatio = false)));
end WindPVannularTESsystem;