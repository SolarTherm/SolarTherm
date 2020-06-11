within examples;

model EffCurve_Rcv1D
  //======================================          MODEL EXPLANATION CONTROL               ===============================================//
  
  //            This model is used to generate the efficiency lookup table of a 1-D particle receiver with PID controller                  //
  
  // ************************************************************************************************************************************* //

  extends SolarTherm.Icons.ToDo;
  import SI = Modelica.SIunits;
  import Modelica.SIunits.Conversions.*;
  replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
  import sin = Modelica.Math.Sin;
  // Receiver design params
  parameter SI.Length H_rcv=28.16;
  parameter SI.MassFlowRate m_flow_des=2600;
  parameter SI.Irradiance dni_des = 950;
  parameter SI.CoefficientOfHeatTransfer h_conv_backwall = 10;
  parameter SI.CoefficientOfHeatTransfer h_conv_curtain = 32;
  parameter SI.Efficiency eta_opt_des = 0.88;
  parameter SI.HeatFlowRate Q_in = 475e6;
  parameter SI.Temperature T_in_design = from_degC(580.3);
  parameter SI.Temperature T_out_design = from_degC(800);
  parameter SI.Temperature T_amb_des = from_degC(25);
  parameter SI.Temperature T_amb = 294.25;
  parameter SI.Power P_net = 100e6;
  parameter SI.Efficiency par_fr = 0.1;
  parameter SI.Power P_gross = P_net / (1 - par_fr);
  parameter Real SM = 2.5;
  parameter Real eff_blk = 0.501;
  // Params PID
  parameter Real Ti = 0.1 "Time constant for integral component of receiver control";
  parameter Real Kp = -1000 "Gain of proportional component in receiver control";
  parameter SI.MassFlowRate m_flow_max = 3 * m_flow_des;
  parameter SI.MassFlowRate m_flow_min = 0;
  //Connections
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D particleReceiver1D(H_drop_design = H_rcv, N = 20, fixed_cp = false, test_mode = false, with_detail_h_ambient = false, with_isothermal_backwall = false, with_uniform_curtain_props = false, with_wall_conduction = true, h_conv_curtain = h_conv_curtain, h_conv_backwall = h_conv_backwall) annotation(
    Placement(visible = true, transformation(origin = {-28, 22}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_in_design, nPorts = 1, p = 1e5, use_T = true, use_p = false) annotation(
    Placement(visible = true, transformation(origin = {60, -14}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftSimple(redeclare package Medium = Medium, cont_m_flow = true, use_input = true, dh = 0, CF = 0, eff = 0.8) annotation(
    Placement(visible = true, transformation(origin = {12, -24}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression Operation(y = true) annotation(
    Placement(visible = true, transformation(origin = {-84, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = T_amb) annotation(
    Placement(visible = true, transformation(origin = {-80, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Wind_dir(y = 1) annotation(
    Placement(visible = true, transformation(origin = {-83, 53}, extent = {{-11, -13}, {11, 13}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = 1) annotation(
    Placement(visible = true, transformation(extent = {{-96, 60}, {-70, 80}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Medium, T = 300.0, d = 3300, nPorts = 1, p = 1e5, use_T = true) annotation(
    Placement(visible = true, transformation(extent = {{76, 58}, {56, 78}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sensors.Temperature temperature annotation(
    Placement(visible = true, transformation(origin = {22, 70}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  SolarTherm.Models.Control.ReceiverControl receiverControl(Kp = Kp, T_ref = T_out_design, Ti = Ti, m_flow_max = m_flow_max, m_flow_min = m_flow_min) annotation(
    Placement(visible = true, transformation(origin = {30, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = 80) annotation(
    Placement(visible = true, transformation(origin = {107, 20}, extent = {{13, -10}, {-13, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression heat_in(y = Q_in) annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
    Placement(visible = true, transformation(origin = {-74, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(particleReceiver1D.fluid_a, liftSimple.fluid_b) annotation(
    Line(points = {{-22, -2}, {-10, -2}, {-10, -22}, {6, -22}, {6, -22}}, color = {0, 127, 255}));
  connect(liftSimple.fluid_a, source.ports[1]) annotation(
    Line(points = {{18, -22}, {30, -22}, {30, -14}, {50, -14}, {50, -14}}, color = {0, 127, 255}));
  connect(Operation.y, particleReceiver1D.on) annotation(
    Line(points = {{-72, -20}, {-56, -20}, {-56, -2}, {-32, -2}, {-32, -2}}, color = {255, 0, 255}));
  connect(realExpression.y, particleReceiver1D.Tamb) annotation(
    Line(points = {{-68, 84}, {-22, 84}, {-22, 42}, {-22, 42}}, color = {0, 0, 127}));
  connect(Wind_dir.y, particleReceiver1D.Wdir) annotation(
    Line(points = {{-70, 54}, {-34, 54}, {-34, 42}, {-34, 42}}, color = {0, 0, 127}));
  connect(Wspd_input.y, particleReceiver1D.Wspd) annotation(
    Line(points = {{-68, 70}, {-28, 70}, {-28, 42}, {-28, 42}}, color = {0, 0, 127}));
  connect(temperature.fluid_b, sink.ports[1]) annotation(
    Line(points = {{32, 70}, {56, 70}, {56, 68}, {56, 68}}, color = {0, 127, 255}));
  connect(temperature.fluid_a, particleReceiver1D.fluid_b) annotation(
    Line(points = {{12, 70}, {-2, 70}, {-2, 34}, {-20, 34}, {-20, 34}}, color = {0, 127, 255}));
  connect(receiverControl.m_flow, liftSimple.m_flow) annotation(
    Line(points = {{18, 20}, {14, 20}, {14, -12}, {14, -12}}, color = {0, 0, 127}));
  connect(temperature.T, receiverControl.T_mea) annotation(
    Line(points = {{22, 60}, {22, 60}, {22, 36}, {60, 36}, {60, 26}, {42, 26}, {42, 26}}, color = {0, 0, 127}));
  connect(Operation.y, receiverControl.sf_on) annotation(
    Line(points = {{-72, -20}, {-56, -20}, {-56, -44}, {84, -44}, {84, 14}, {42, 14}, {42, 14}}, color = {255, 0, 255}));
  connect(realExpression1.y, receiverControl.L_mea) annotation(
    Line(points = {{92, 20}, {42, 20}, {42, 20}, {40, 20}}, color = {0, 0, 127}));
  connect(heat_in.y, prescribedHeatFlow.Q_flow) annotation(
    Line(points = {{-98, 30}, {-84, 30}, {-84, 30}, {-84, 30}}, color = {0, 0, 127}));
  connect(prescribedHeatFlow.port, particleReceiver1D.heat) annotation(
    Line(points = {{-64, 30}, {-54, 30}, {-54, 30}, {-54, 30}}, color = {191, 0, 0}));
  connect(prescribedHeatFlow.Q_flow, receiverControl.Q_input) annotation(
    Line(points = {{-84, 30}, {20, 30}, {20, 32}, {20, 32}}, color = {0, 0, 127}));
  connect(particleReceiver1D.eta_rec_out, receiverControl.eta_rec_in) annotation(
    Line(points = {{-20, 16}, {6, 16}, {6, 44}, {40, 44}, {40, 32}, {40, 32}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 6000, Tolerance = 1e-06, Interval = 1));

end EffCurve_Rcv1D;