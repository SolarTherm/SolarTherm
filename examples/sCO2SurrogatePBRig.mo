within examples;

model sCO2SurrogatePBRig
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import Utils = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  import SolarTherm.Types.Solar_angles;
  import SolarTherm.Types.Currency;
  import Modelica.Math;
  import metadata = SolarTherm.Utilities.Metadata_Optics;
  import Modelica.SIunits.Conversions.*;
  extends SolarTherm.Media.CO2.PropCO2;
  // *********************Simulation setup
  parameter Boolean test_mode = true;
  parameter Boolean external_parasities = true;
  parameter Integer inputsize_PB = 9;
  parameter Integer outputsize_PB = 2;
  parameter String saved_model_dir_eta_gross = "/home/philgun/Documents/codecodecode/codecodecode/ML/script/sCO2_Trained_Model/concept-2/eta_gross/surrogate_model_7";
  parameter String saved_model_dir_eta_Q = "/home/philgun/Documents/codecodecode/codecodecode/ML/script/sCO2_Trained_Model/concept-2/eta_Q/surrogate_model_7";
  // *********************Changeable PB Design Param -  For Surrogates
  parameter SI.Power P_net = 1;
  parameter SI.Temperature T_in_ref_blk = 1;
  parameter SI.AbsolutePressure p_high = 1 "high pressure of the cycle";
  parameter Real PR = 1 "Pressure ratio";
  parameter SI.TemperatureDifference pinch_exchanger = 21;
  parameter SI.TemperatureDifference dTemp_HTF_PHX = 1 "T_in_ref_blk - T_cold_set";
  parameter SI.Temperature T_cold_set = T_in_ref_blk - dTemp_HTF_PHX;
  // ********************* Changeable PB Operation Param -  For Surrogates
  parameter Real load = 0.98;
  parameter SI.Temperature T_HTF_in = 1103.67;
  parameter SI.Temperature T_amb_input = 280.67;
  parameter SI.MassFlowRate m_HTF_des(fixed = false);
  parameter SI.MassFlowRate m_HTF_in = load * m_HTF_des;
  // *********************Changeable PB Design Param
  parameter Real f_fixed_load = 0.0055;
  parameter SI.Efficiency eta_motor = 0.95 "electrical generator efficiency";
  // *********************Unchangable PB Design Param
  parameter SI.Temperature T_low = from_degC(41) "Cooler outlet temperature at design point";
  parameter SI.Temperature blk_T_amb_des = from_degC(39);
  parameter Real nu_min_blk = 0.5;
  parameter Integer N_exch_parameter = 15;
  parameter Integer N_HTR = 15;
  parameter Integer N_LTR_parameter = 15;
  parameter SI.HeatFlowRate Q_flow_des(fixed = false);
  // *********************PB Specific cost
  parameter Real pinch_recuperator = 15;
  parameter Real par_fr = 0.1;
  parameter Real pri_recuperator = 5.2;
  parameter Real pri_turbine = 9923.7;
  parameter Real pri_compressor = 643.15;
  parameter Real pri_cooler = 76.25;
  parameter Real pri_generator = 108900;
  parameter FI.Money pri_exchanger = 150 "price of the primary exchanger in $/(kW_th). Objective for next-gen CSP with particles  --> value from v.9 EES sandia result c_hx";
  // ********************* Surrogate boundaries
  parameter Real[inputsize_PB] X_max_PB = {2.0000000e+08, 1.2953200e+03, 2.5463104e+07, 3.9700000e+00, 2.9930000e+01, 2.9922000e+02, 1.0600000e+00, 1.2960700e+03, 3.2514000e+02};
  parameter Real[inputsize_PB] X_min_PB = {2.00000000e+07, 1.02541000e+03, 2.00104576e+07, 2.71000000e+00, 1.51800000e+01, 1.00060000e+02, 4.50000000e-01, 1.00615000e+03, 2.50360000e+02};
  parameter Real eta_gross_max = 0.55391357;
  parameter Real eta_gross_min = 0.00554803;
  parameter Real eta_Q_max = 1.02810827;
  parameter Real eta_Q_min = 0.04315899;
  // ********************* Medium
  replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
  replaceable package MedPB = SolarTherm.Media.CarbonDioxide_ph "Medium props for sCO2";
  // ********************* Components instantiation
  Modelica.Fluid.Sources.FixedBoundary source(nPorts = 1, redeclare package Medium = Medium, T = T_HTF_in, use_T = true, use_p = false, p = 1e5) annotation(
    Placement(visible = true, transformation(origin = {-90, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Medium, T = 300.0, d = 3300, nPorts = 1, p = 1e5, use_T = true) annotation(
    Placement(visible = true, transformation(origin = {-82, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression T_amb_in(y = T_amb_input) annotation(
    Placement(visible = true, transformation(origin = {-58, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression always_false(y = false) annotation(
    Placement(visible = true, transformation(origin = {-58, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression parasities_input(y = 0) annotation(
    Placement(visible = true, transformation(origin = {-58, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftSimple(use_input = true) annotation(
    Placement(visible = true, transformation(origin = {-35, 13}, extent = {{21, -21}, {-21, 21}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_dot(y = m_HTF_in) annotation(
    Placement(visible = true, transformation(origin = {-98, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.SurrogatesCO2PB2 powerBlock(P_net = P_net, T_in_ref_blk = T_in_ref_blk, p_high = p_high, PR = PR, pinch_PHX = pinch_exchanger, dTemp_HTF_PHX = dTemp_HTF_PHX, Q_HX_des = Q_flow_des, m_HTF_des = m_HTF_des, inputsize = inputsize_PB, outputsize = outputsize_PB, X_max = X_max_PB, X_min = X_min_PB, eta_gross_max = eta_gross_max, eta_gross_min = eta_gross_min, eta_Q_max = eta_Q_max, eta_Q_min = eta_Q_min, saved_model_dir_eta_gross = saved_model_dir_eta_gross, saved_model_dir_eta_Q = saved_model_dir_eta_Q, test_mode = test_mode, eta_motor = eta_motor, f_fixed_load = f_fixed_load) annotation(
    Placement(visible = true, transformation(origin = {39, -5}, extent = {{-55, -55}, {55, 55}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.sCO2PBCalculator_Using_JPidea sCO2PBDesignPointCalculator(redeclare package Medium = Medium, P_net = P_net, T_in_ref_blk = T_in_ref_blk, p_high = p_high, PR = PR, pinch_PHX = pinch_exchanger, dTemp_HTF_PHX = dTemp_HTF_PHX, T_HTF_in = T_in_ref_blk, T_amb_input = blk_T_amb_des, load = 1, f_fixed_load = f_fixed_load, blk_T_amb_des = blk_T_amb_des, T_low = T_low, nu_min_blk = nu_min_blk, N_exch_parameter = N_exch_parameter, N_LTR_parameter = N_LTR_parameter, pri_recuperator = pri_recuperator, pri_turbine = pri_turbine, pri_compressor = pri_compressor, pri_cooler = pri_cooler, pri_generator = pri_generator, pri_exchanger = pri_exchanger, eta_motor, pinch_recuperator = pinch_recuperator) annotation(
    Placement(visible = true, transformation(origin = {136, 72}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  // ********************* Variables
  Real eta_gross;
  Real eta_Q;
initial equation
  m_HTF_des = sCO2PBDesignPointCalculator.powerBlock.m_HTF_des;
  Q_flow_des = sCO2PBDesignPointCalculator.powerBlock.Q_HX_des;
equation
  eta_gross = powerBlock.eta_gross;
  eta_Q = powerBlock.eta_Q;
/*Assigning the input to the surrogate model*/
  powerBlock.raw_input[1] = P_net;
  powerBlock.raw_input[2] = T_in_ref_blk;
  powerBlock.raw_input[3] = p_high;
  powerBlock.raw_input[4] = PR;
  powerBlock.raw_input[5] = pinch_exchanger;
  powerBlock.raw_input[6] = dTemp_HTF_PHX;
  powerBlock.raw_input[7] = load;
  powerBlock.raw_input[8] = T_HTF_in;
  powerBlock.raw_input[9] = T_amb_input;
/*Connection*/
  connect(source.ports[1], liftSimple.fluid_a) annotation(
    Line(points = {{-80, 16}, {-42, 16}, {-42, 16}, {-42, 16}}, color = {0, 127, 255}));
  connect(m_dot.y, liftSimple.m_flow) annotation(
    Line(points = {{-86, 44}, {-40, 44}, {-40, 28}, {-38, 28}}, color = {0, 0, 127}));
  connect(liftSimple.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{-28, 16}, {14, 16}, {14, 14}, {14, 14}}, color = {0, 127, 255}));
  connect(powerBlock.fluid_b, sink.ports[1]) annotation(
    Line(points = {{8, -30}, {-32, -30}, {-32, -56}, {-72, -56}, {-72, -56}}, color = {0, 127, 255}));
  connect(T_amb_in.y, powerBlock.T_amb) annotation(
    Line(points = {{-46, 60}, {28, 60}, {28, 28}, {28, 28}}, color = {0, 0, 127}));
  connect(always_false.y, powerBlock.ramping) annotation(
    Line(points = {{-46, 80}, {40, 80}, {40, 28}, {40, 28}}, color = {255, 0, 255}));
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{-46, 98}, {50, 98}, {50, 28}, {50, 28}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end sCO2SurrogatePBRig;