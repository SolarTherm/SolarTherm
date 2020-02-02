within SolarTherm.Models.CSP.CRS.Receivers;

model ParticleReceiver1DCalculator
  extends SolarTherm.Icons.ToDo;
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  import Modelica.Math;
  import Modelica.Blocks;
  replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
  // Design Condition
  parameter SI.MassFlowRate m_in(fixed = false);
  parameter SI.Power P_gross_design = 100e6;
  parameter Real eff_block_design = 0.502;
  parameter Real SolarMultiple = 2.5;
  parameter Real T_out_design = from_degC(800);
  parameter Real T_in_design = from_degC(580.3);
  parameter Real T_amb_design = from_degC(25);
  parameter Real CR = 1200;
  parameter SI.HeatFlux dni_des = 909.6;
  parameter SI.Efficiency eta_rec_assumption = 0.88;
  parameter SI.HeatFlowRate Q_in(fixed = false);
  
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_in_design, nPorts = 1, p = 1e5, use_T = true, use_p = false) annotation(
    Placement(visible = true, transformation(origin = {60, -14}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Medium, T = 300.0, d = 3300, nPorts = 1, p = 1e5, use_T = true) annotation(
    Placement(visible = true, transformation(extent = {{34, 22}, {14, 42}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Heat(Q_flow = Q_in, T_ref = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-78, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression Operation(y = true) annotation(
    Placement(visible = true, transformation(origin = {-78, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = T_amb_design) annotation(
    Placement(visible = true, transformation(origin = {-56, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftSimple(m_flow_fixed = m_in, use_input = false) annotation(
    Placement(visible = true, transformation(origin = {22, -16}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D_v11 particleReceiver1D_v11(N = 20, with_uniform_curtain_props = false, dni_des = dni_des, CR =CR) annotation(
    Placement(visible = true, transformation(origin = {-21, 29}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
initial equation
  Q_in = P_gross_design / eff_block_design / eta_rec_assumption * SolarMultiple;
  m_in = P_gross_design / eff_block_design / eta_rec_assumption * SolarMultiple / (Util.h_T(T_out_design) - Util.h_T(T_in_design));
equation
/*connect(Operation.y, receiver.on) H_drop
		annotation(
		Line(points = {{-69, -4}, {-39.5, -4}, {-39.5, 5}, {-25, 5}}, color = {255, 0, 255}));*/
  connect(source.ports[1], liftSimple.fluid_a) annotation(
    Line(points = {{50, -14}, {27, -14}}, color = {0, 127, 255}));
  connect(realExpression.y, particleReceiver1D_v11.Tamb) annotation(
    Line(points = {{-44, 80}, {-20, 80}, {-20, 48}, {-20, 48}}, color = {0, 0, 127}));
  connect(Heat.port, particleReceiver1D_v11.heat) annotation(
    Line(points = {{-68, 44}, {-46, 44}, {-46, 36}, {-46, 36}}, color = {191, 0, 0}));
  connect(Operation.y, particleReceiver1D_v11.on) annotation(
    Line(points = {{-66, -4}, {-26, -4}, {-26, 6}, {-26, 6}}, color = {255, 0, 255}));
  connect(particleReceiver1D_v11.fluid_b, sink.ports[1]) annotation(
    Line(points = {{-12, 42}, {14, 42}, {14, 32}, {14, 32}}, color = {0, 127, 255}));
  connect(particleReceiver1D_v11.fluid_a, liftSimple.fluid_b) annotation(
    Line(points = {{-16, 6}, {-16, 6}, {-16, -14}, {16, -14}, {16, -14}}, color = {0, 127, 255}));
protected
  annotation(
    uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")),
    experiment(StartTime = 0, StopTime = 35000, Tolerance = 1e-06, Interval = 972.222),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    Diagram);
end ParticleReceiver1DCalculator;