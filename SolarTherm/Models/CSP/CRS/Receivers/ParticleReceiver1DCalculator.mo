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
  // 2 way in designing the receiver, specifcy the area and calculate the mass flow rate to reach certain outlet temperature
  // Or specify the mass flow rate and calculate the area to reach certain outlet temperature
  parameter SI.Area A_ap_des = 1000 "aperture area";
  parameter SI.MassFlowRate m_in(fixed = false);
  parameter SI.Power P_gross_design = 111e6;
  parameter Real eff_block_design = 0.502;
  parameter SI.Efficiency eta_opt_des = 0.5;
  parameter Real SolarMultiple = 2.5;
  parameter SI.Length H_drop_design = 15;
  parameter SI.HeatFlowRate Q_in = 6e8;
  parameter Real T_in_design = 823.15;
  parameter Real T_out_design = 1073.15;
  parameter Real T_amb_design = 283.15;
  parameter Real Wspd_design = 0;
  parameter Real Wspd_dir = 4;
  parameter Real eta_rec_determined = 0.4247535903;
  parameter SI.MassFlowRate m_design = 206.821541380436;
  parameter Real ar_rec = 1;
  parameter Real CR = 1200;
  parameter SI.HeatFlux dni_des = 950;
  parameter SI.Efficiency eta_rec_assumption = 0.88;
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
  parameter Real std_deviation = 0.1;
  //********************* Simulation Set up
  parameter Boolean with_detail_h_ambient = true "using size dependent advection heat transfer coefficient";
  parameter Boolean with_wind_effect = true "using wind effect (direction and speed)";
  parameter Boolean test_mode = false;
  parameter Boolean fixed_geometry = true "true H_drop = H_drop_design, false T_out = T_out_design ";
  parameter Boolean iterate_Q_flow = true "true T_out=T_out_design else heat.Q_flow / A_ap";
  parameter Boolean with_iterate_mdot = false "true T_out = T_out_design, false mdot = fluid_a.m_flow";
  parameter Boolean with_pre_determined_eta = false "true eta_rec = eta_rec_determined, false eta_rec = Qnet/Qtotal";
  //********************** Variables
  SI.HeatFlowRate Q_in_rcv_calculated;
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, T = T_in_design, nPorts = 1, p = 1e5, use_T = true, use_p = false) annotation(
    Placement(visible = true, transformation(origin = {60, -14}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Medium, T = 300.0, d = 3300, nPorts = 1, p = 1e5, use_T = true) annotation(
    Placement(visible = true, transformation(extent = {{34, 22}, {14, 42}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Heat(Q_flow = Q_in, T_ref = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-78, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression Operation(y = true) annotation(
    Placement(visible = true, transformation(origin = {-78, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = T_amb_design) annotation(
    Placement(visible = true, transformation(origin = {-56, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.LiftSimple liftSimple(m_flow_fixed = m_in, use_input = false) annotation(
    Placement(visible = true, transformation(origin = {22, -16}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  SolarTherm.Models.CSP.CRS.Receivers.ParticleReceiver1D particleReceiver1D(N = 30, fixed_cp = false, test_mode = false, with_isothermal_backwall = false, with_uniform_curtain_props = false, with_wall_conduction = true, Q_in = Q_in, h_conv_backwall = h_conv_backwall, h_conv_curtain = h_conv_curtain, H_drop_design = H_drop_design, phi_max = phi_max, T_amb = T_amb_design, eps_w = eps_w, th_w = th_w, k_w = k_w, F = F, d_p = d_p, cp_s = cp_s, rho_s = rho_s, eps_s = eps_s, abs_s = abs_s, AR=ar_rec, T_out_design = T_out_design, with_detail_h_ambient = with_detail_h_ambient, with_wind_effect = with_wind_effect, fixed_geometry = fixed_geometry, iterate_Q_flow = iterate_Q_flow, iterate_mdot = with_iterate_mdot, eta_rec_determined = eta_rec_determined, with_pre_determined_eta = with_pre_determined_eta) annotation(
    Placement(visible = true, transformation(origin = {-29, 33}, extent = {{-27, -27}, {27, 27}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = Wspd_design) annotation(
    Placement(visible = true, transformation(origin = {-56, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = Wspd_dir) annotation(
    Placement(visible = true, transformation(origin = {-56, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation
  if iterate_Q_flow == true then
    m_in = m_design;
  else
    m_in = Q_in * eta_rec_assumption / (Util.h_T(T_out_design) - Util.h_T(T_in_design));
  end if;
equation
  Q_in_rcv_calculated = particleReceiver1D.q_solar * particleReceiver1D.A_ap;
  connect(source.ports[1], liftSimple.fluid_a) annotation(
    Line(points = {{50, -14}, {27, -14}}, color = {0, 127, 255}));
  connect(particleReceiver1D.fluid_a, liftSimple.fluid_b) annotation(
    Line(points = {{-24, 8}, {-14, 8}, {-14, -14}, {16, -14}, {16, -14}}, color = {0, 127, 255}));
  connect(Operation.y, particleReceiver1D.on) annotation(
    Line(points = {{-66, -4}, {-42, -4}, {-42, 8}, {-34, 8}, {-34, 8}}, color = {255, 0, 255}));
  connect(Heat.port, particleReceiver1D.heat) annotation(
    Line(points = {{-68, 44}, {-56, 44}, {-56, 42}, {-56, 42}}, color = {191, 0, 0}));
  connect(particleReceiver1D.fluid_b, sink.ports[1]) annotation(
    Line(points = {{-20, 46}, {14, 46}, {14, 32}, {14, 32}}, color = {0, 127, 255}));
  connect(realExpression.y, particleReceiver1D.Tamb) annotation(
    Line(points = {{-45, 96}, {-22, 96}, {-22, 54}}, color = {0, 0, 127}));
  connect(realExpression1.y, particleReceiver1D.Wspd) annotation(
    Line(points = {{-44, 82}, {-28, 82}, {-28, 54}, {-28, 54}}, color = {0, 0, 127}));
  connect(realExpression2.y, particleReceiver1D.Wdir) annotation(
    Line(points = {{-44, 68}, {-36, 68}, {-36, 54}, {-36, 54}}, color = {0, 0, 127}));
protected
  annotation(
    uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.02),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    Diagram);
end ParticleReceiver1DCalculator;