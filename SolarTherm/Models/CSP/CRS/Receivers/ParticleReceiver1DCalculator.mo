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
  //2 way in designing the receiver, specifcy the area and calculate the mass flow rate to reach certain outlet temperature
  //Or specify the mass flow rate and calculate the area to reach certain outlet temperature
  parameter SI.Area A_ap_des = 1000 "aperture area";
  parameter SI.Length H_drop_design = sqrt(A_ap_des);
  parameter SI.MassFlowRate m_in(fixed = false);
  parameter SI.Power P_gross_design = 111e6;
  parameter Real eff_block_design = 0.502;
  parameter SI.Efficiency eta_opt_des = 0.5;
  parameter Real SolarMultiple = 2.5;
  parameter Real T_out_design = from_degC(800);
  parameter Real T_in_design = from_degC(580.3);
  parameter Real T_amb_design = from_degC(10);
  parameter Real CR = 1200;
  parameter SI.HeatFlux dni_des = 950;
  parameter SI.Efficiency eta_rec_assumption = 0.88;
  parameter SI.HeatFlowRate Q_in = 100e6;
  parameter SI.Length th_w = 0.05 "Backwall thickness of the receiver";
  parameter SI.ThermalConductance k_w = 0.2 "Thermal conductance of the back wall of the receiver";
  parameter SI.CoefficientOfHeatTransfer h_conv_curtain = 32. "Convective heat transfer coefficient (curtain) [W/m^2-K]";
  parameter SI.CoefficientOfHeatTransfer h_conv_backwall = 10. "Convective heat transfer coefficient (backwall) [W/m^2-K]";
  parameter SI.Length d_p = 0.00035 "Particle diameter [m]";
  parameter SI.SpecificHeatCapacity cp_s = 1200 "particle specific heat capacity [J/kgK]";
  parameter SI.Density rho_s = 3300 "Particle density [kg/m3]";
  parameter Real eps_s = 0.9 "Particle emmisivity";
  parameter Real abs_s = 0.9 "Particle absorptivity";
  parameter Real F = 0.54 "View Factor of the particle curtain";
  parameter Real eps_w = 0.8 "Receiver wall emmisivity";
  parameter Real phi_max = 0.6;
  SI.HeatFlowRate Q_in_calculated;
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
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D_v11 particleReceiver1D(N = 30, fixed_cp = false, fixed_geometry = false, test_mode = true, with_isothermal_backwall = false, with_uniform_curtain_props = false, with_wall_conduction = true, Q_in = Q_in, h_conv_backwall = h_conv_backwall, h_conv_curtain = h_conv_curtain, phi_max = phi_max, T_amb = T_amb_design, eps_w = eps_w, th_w = th_w, k_w = k_w, F = F, d_p = d_p, cp_s = cp_s, rho_s = rho_s, eps_s = eps_s, abs_s = abs_s, T_out_design = T_out_design) annotation(
    Placement(visible = true, transformation(origin = {-29, 33}, extent = {{-27, -27}, {27, 27}}, rotation = 0)));
initial equation
  m_in = Q_in * eta_rec_assumption / (Util.h_T(T_out_design) - Util.h_T(T_in_design));
equation
  Q_in_calculated = particleReceiver1D.A_ap * particleReceiver1D.q_solar;
  connect(source.ports[1], liftSimple.fluid_a) annotation(
    Line(points = {{50, -14}, {27, -14}}, color = {0, 127, 255}));
  connect(particleReceiver1D.fluid_a, liftSimple.fluid_b) annotation(
    Line(points = {{-24, 8}, {-14, 8}, {-14, -14}, {16, -14}, {16, -14}}, color = {0, 127, 255}));
  connect(Operation.y, particleReceiver1D.on) annotation(
    Line(points = {{-66, -4}, {-42, -4}, {-42, 8}, {-34, 8}, {-34, 8}}, color = {255, 0, 255}));
  connect(Heat.port, particleReceiver1D.heat) annotation(
    Line(points = {{-68, 44}, {-56, 44}, {-56, 42}, {-56, 42}}, color = {191, 0, 0}));
  connect(realExpression.y, particleReceiver1D.Tamb) annotation(
    Line(points = {{-44, 80}, {-30, 80}, {-30, 54}, {-28, 54}}, color = {0, 0, 127}));
  connect(particleReceiver1D.fluid_b, sink.ports[1]) annotation(
    Line(points = {{-20, 46}, {14, 46}, {14, 32}, {14, 32}}, color = {0, 127, 255}));
protected
  annotation(
    uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")),
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 1),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    Diagram);
end ParticleReceiver1DCalculator;