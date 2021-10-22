within SolarTherm.Models.PowerBlocks;

model sCO2PBCalculator
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
  
  // *********************PB Params - Sim Set-up
  parameter Boolean test_mode = true;
  parameter Boolean external_parasities = true;
  // *********************PB Params - Changeable Design Param
  parameter SI.Power P_net = 100e6;
  parameter SI.Temperature T_in_ref_blk = 1073.15;
  parameter SI.AbsolutePressure p_high =  25e6 "high pressure of the cycle";
  parameter Real PR = 2.75 "Pressure ratio";
  parameter Modelica.SIunits.TemperatureDifference dTemp_HTF_PHX = 250 "T_in_ref_blk - T_cold_set";
  parameter Modelica.SIunits.TemperatureDifference delta = 50 "T_in_ref_blk - T_high";
  parameter SI.Temperature T_cold_set = T_in_ref_blk - dTemp_HTF_PHX;
  // *********************PB Params - Changeable Operation Param
  parameter Real load = 0.56;
  parameter SI.Temperature T_HTF_in = 975.92;
  parameter SI.Temperature T_amb_input = 305.9;
  // *********************PB Params - Other params
  parameter SI.Temperature T_low = from_degC(41) "Cooler outlet temperature at design point";
  parameter SI.Temperature T_high = T_in_ref_blk - delta "Turbine inlet temperature at design point";
  parameter SI.Temperature blk_T_amb_des = from_degC(39);
  parameter Real nu_min_blk = 0.5;
  parameter Integer N_exch_parameter = 15;
  parameter Integer N_HTR = 15;
  parameter Integer N_LTR_parameter = 15 "PG";
  parameter Real f_fixed_load = 0.0055;
  parameter SI.Efficiency eta_motor = 0.95 "electrical generator efficiency";
  // *********************PB Params - Financial
  parameter Real pinch_recuperator = 5;
  parameter Real par_fr = 0.1;
  parameter Real pri_recuperator = 5.2;
  parameter Real pri_turbine = 9923.7;
  parameter Real pri_compressor = 643.15;
  parameter Real pri_cooler = 76.25;
  parameter Real pri_generator = 108900;
  parameter FI.Money pri_exchanger = 150 "price of the primary exchanger in $/(kW_th). Objective for next-gen CSP with particles  --> value from v.9 EES sandia result c_hx";
  parameter SI.MassFlowRate m_HTF_des(fixed = false);
  parameter SI.MassFlowRate m_HTF_in = load * m_HTF_des;
  // *********************Medium
  replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
  replaceable package MedPB = SolarTherm.Media.CarbonDioxide_ph "Medium props for sCO2";
  //Components instanstiation
  SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign.recompPB powerBlock(redeclare package MedRec = Medium, P_nom = P_net, T_HTF_in_des = T_in_ref_blk, p_high = p_high, PR = PR, T_HTF_out = T_cold_set, T_amb_des = blk_T_amb_des, T_low = T_low, external_parasities = external_parasities, nu_min = nu_min_blk, N_exch = N_exch_parameter, N_LTR = N_LTR_parameter, f_fixed_load = f_fixed_load, pri_recuperator = pri_recuperator, pri_turbine = pri_turbine, pri_compressor = pri_compressor, pri_cooler = pri_cooler, pri_generator = pri_generator, pri_exchanger = pri_exchanger, eta_motor = eta_motor, pinch_recuperator = pinch_recuperator, par_fr = par_fr, test_mode = test_mode, T_high = T_high) annotation(
    Placement(visible = true, transformation(origin = {38, -14.1111}, extent = {{-38, -40.1111}, {38, 40.1111}}, rotation = 0)));
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
  // ********************* Variables
  SI.Power P_elec;
  SI.Energy E_elec;
  Real eta_gross;
  Real eta_Q;
initial algorithm
  m_HTF_des := powerBlock.m_HTF_des;
equation
  P_elec = powerBlock.W_net;
  der(E_elec) = P_elec;
  eta_gross = powerBlock.W_gross / powerBlock.exchanger.Q_HX;
  eta_Q = powerBlock.exchanger.Q_HX / powerBlock.Q_HX_des;
  connect(powerBlock.fluid_b, sink.ports[1]) annotation(
    Line(points = {{16, -32}, {-18, -32}, {-18, -56}, {-72, -56}}, color = {0, 127, 255}));
  connect(T_amb_in.y, powerBlock.T_amb) annotation(
    Line(points = {{-47, 60}, {30, 60}, {30, 10}}, color = {0, 0, 127}));
  connect(always_false.y, powerBlock.ramping) annotation(
    Line(points = {{-46, 80}, {38, 80}, {38, 10}, {38, 10}}, color = {255, 0, 255}));
  connect(parasities_input.y, powerBlock.parasities) annotation(
    Line(points = {{-46, 98}, {46, 98}, {46, 10}, {46, 10}}, color = {0, 0, 127}));
  connect(source.ports[1], liftSimple.fluid_a) annotation(
    Line(points = {{-80, 16}, {-42, 16}, {-42, 16}, {-42, 16}}, color = {0, 127, 255}));
  connect(liftSimple.fluid_b, powerBlock.fluid_a) annotation(
    Line(points = {{-28, 16}, {2, 16}, {2, 0}, {22, 0}, {22, 0}}, color = {0, 127, 255}));
  connect(m_dot.y, liftSimple.m_flow) annotation(
    Line(points = {{-86, 44}, {-40, 44}, {-40, 28}, {-38, 28}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end sCO2PBCalculator;