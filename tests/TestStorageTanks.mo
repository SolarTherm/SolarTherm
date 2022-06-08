model TestStorageTanks
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Solar_angles;
  import SolarTherm.Types.Currency;
  extends Modelica.Icons.Example;
  // Input Parameters
  // *********************
  replaceable package Medium = Media.MoltenSalt.MoltenSalt_ph "Medium props for molten salt";
  // Storage
  parameter Real tank_ar = 20 / 18.667 "storage aspect ratio";
  parameter Real t_storage(unit = "h") = 4 "Hours of storage";
  parameter SI.Temperature T_cold_set = CV.from_degC(290) "Cold tank target temperature";
  parameter SI.Temperature T_hot_set = CV.from_degC(574) "Hot tank target temperature";
  //parameter SI.Temperature T_cold_start = CV.from_degC(290) "Cold tank starting temperature";
  parameter SI.Temperature T_hot_start = CV.from_degC(574) "Hot tank starting temperature";
  //parameter SI.Temperature T_cold_aux_set = CV.from_degC(280) "Cold tank auxiliary heater set-point temperature";
  parameter SI.Temperature T_hot_aux_set = CV.from_degC(500) "Hot tank auxiliary heater set-point temperature";
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold salt thermodynamic state at design";
  parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hold salt thermodynamic state at design";
  parameter Real tnk_fr = 0.01 "Tank loss fraction of tank in one day at design point";
  parameter SI.Temperature tnk_T_amb_des = 298.15 "Ambient temperature at design point";
  parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
  parameter SI.CoefficientOfHeatTransfer alpha = 3 "Tank constant heat transfer coefficient with ambient";
  //parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold pump parasitic power coefficient";
  //parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot pump parasitic power coefficient";
  parameter SI.Power W_heater_hot = 30e8 "Hot tank heater capacity";
  //parameter SI.Power W_heater_cold = 30e8 "Cold tank heater capacity";
  // Control
  parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real hot_tnk_empty_ub = 10 "Hot tank empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real hot_tnk_full_lb = 123 "Hot tank full trigger lower bound";
  parameter Real hot_tnk_full_ub = 120 "Hot tank full trigger upper bound";
  //parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound"; // Level (below which) to stop disptach
  //parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound"; // Level (above which) to start disptach
  //parameter Real cold_tnk_crit_lb = 0 "Cold tank critically empty trigger lower bound"; // Level (below which) to stop disptach
  //parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound"; // Level (above which) to start disptach
  // Calculated Parameters
  parameter SI.HeatFlowRate Q_flow_des = 1e6 "Heat to power block at design, W";
  parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";
  parameter SI.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot salt specific enthalpy at design";
  parameter SI.Density rho_cold_set = Medium.density(state_cold_set) "Cold salt density at design";
  parameter SI.Density rho_hot_set = Medium.density(state_hot_set) "Hot salt density at design";
  parameter SI.Mass m_max = E_max / (h_hot_set - h_cold_set) "Max salt mass in tanks";
  parameter SI.MassFlowRate m_flow_blk = Q_flow_des / (h_hot_set - h_cold_set) "Mass flow rate to power block at design point";
  parameter SI.Volume V_max = m_max / ((rho_hot_set + rho_cold_set) / 2) "Max salt volume in tanks";
  parameter SI.Length H_storage = ceil((4 * V_max * tank_ar ^ 2 / CN.pi) ^ (1 / 3)) "Storage tank height";
  parameter SI.Diameter D_storage = H_storage / tank_ar "Storage tank diameter";
  // Cost data in USD (default) or AUD
  parameter FI.EnergyPrice pri_storage = 37 / (1e3 * 3600) "Storage cost per energy capacity";
  // SAM 2018 cost data: 22 / (1e3 * 3600)
  parameter FI.Money C_storage = pri_storage * E_max "Storage cost";
  // Hot tank
  SolarTherm.Models.Storage.Tank.Tank tankHot(redeclare package Medium = Medium, D = D_storage, H = H_storage, L_start = (1 - split_cold) * 100, T_set = T_hot_aux_set, T_start = T_hot_start, W_max = W_heater_hot, alpha = alpha, enable_losses = true, use_L = true, use_p_top = true) annotation(
    Placement(visible = true, transformation(extent = {{-10, -8}, {10, 12}}, rotation = 0)));
  //Start value of level in %
  Modelica.Blocks.Sources.Constant T_amb(k = 273.15 + 25.0) annotation(
    Placement(visible = true, transformation(origin = {-20, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant p_amb(k = 101325) annotation(
    Placement(visible = true, transformation(origin = {18, 46}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Recv(redeclare package Medium = Medium, T = 565 + 273.15, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-86, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink fluidSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {84, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pump_recv(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-48, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pump_PB(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {46, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_recv_var(y = m_recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-64, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Real m_recv_signal "Signal value";
  Real m_pb_signal "Signal value";
  Real tank_full_checker;
  Modelica.Blocks.Sources.RealExpression m_flow_PB_var(y = m_pb_signal) annotation(
    Placement(visible = true, transformation(origin = {64, 32}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
initial equation
  m_recv_signal = 20;
  m_pb_signal = 12;
algorithm
  when tankHot.L > 99 then
    m_recv_signal := 0;
    tank_full_checker := 1;
  elsewhen tankHot.L < 90 then
    m_recv_signal := 12;
    tank_full_checker := 0;
  end when;
  when tankHot.L > 30 then
    m_pb_signal := 20;
  elsewhen tankHot.L < 20 then
    m_pb_signal := 0;
  end when;
equation
//m_recv_signal = 10.0 * sin(time * 2.0 * CN.pi * (1.0 / (3600.0 * 24)));
  connect(T_amb.y, tankHot.T_amb) annotation(
    Line(points = {{-9, 46}, {-4, 46}, {-4, 12}}, color = {0, 0, 127}));
  connect(p_amb.y, tankHot.p_top) annotation(
    Line(points = {{7, 46}, {4, 46}, {4, 12}}, color = {0, 0, 127}));
  connect(Recv.ports[1], pump_recv.fluid_a) annotation(
    Line(points = {{-76, 8}, {-58, 8}}, color = {0, 127, 255}));
  connect(pump_recv.fluid_b, tankHot.fluid_a) annotation(
    Line(points = {{-38, 8}, {-10, 8}}, color = {0, 127, 255}));
  connect(tankHot.fluid_b, pump_PB.fluid_a) annotation(
    Line(points = {{10, -4}, {36, -4}}, color = {0, 127, 255}));
  connect(pump_PB.fluid_b, fluidSink.port_a) annotation(
    Line(points = {{56, -4}, {74, -4}}, color = {0, 127, 255}));
  connect(m_flow_recv_var.y, pump_recv.m_flow) annotation(
    Line(points = {{-53, 32}, {-48, 32}, {-48, 16}}, color = {0, 0, 127}));
  connect(m_flow_PB_var.y, pump_PB.m_flow) annotation(
    Line(points = {{53, 32}, {46, 32}, {46, 5}}, color = {0, 0, 127}));
  connect(T_amb.y, tankHot.T_amb) annotation(
    Line(points = {{-9, 46}, {-4, 46}, {-4, 12}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.2"), SolarTherm(version = "0.2")));
end TestStorageTanks;