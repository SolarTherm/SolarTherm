within examples;

model WindPVsaltTESsystem
  extends Modelica.Icons.Example;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Constants.*;
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph;
  parameter String elec_input = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/heater_input.motab");
  parameter String schd_input = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/schedule_mflow.motab");
  parameter Modelica.SIunits.Temperature T_hot_set = from_degC(565) "Hot tank temperature";
  parameter Modelica.SIunits.Temperature T_cold_set = from_degC(280) "Hot tank temperature";
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold salt thermodynamic state at design";
  parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hold salt thermodynamic state at design";
  
  parameter Modelica.SIunits.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";
  parameter Real t_storage(unit = "h") = 10 "Hours of storage";
  parameter Modelica.SIunits.MassFlowRate m_flow_hot = Q_flow_des/(h_hot_set - h_cold_set) "Nominal hot salt mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_des = 800e6 "Heat to power block at design";
  parameter Real tank_ar = 1.05 "storage aspect ratio";
  parameter Modelica.SIunits.Length tank_min_l = 1.8 "Storage tank fluid minimum height";

  parameter Modelica.SIunits.MassFlowRate m_flow_heater_max = 2.5*m_flow_hot "Nominal hot salt mass flow rate";
  parameter Modelica.SIunits.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";  
  parameter Modelica.SIunits.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot salt specific enthalpy at design";
  parameter Modelica.SIunits.Density rho_cold_set = Medium.density(state_cold_set) "Cold salt density at design";
  parameter Modelica.SIunits.Density rho_hot_set = Medium.density(state_hot_set) "Hot salt density at design";
  parameter Modelica.SIunits.Mass m_max = E_max/(h_hot_set - h_cold_set) "Max salt mass in tanks";
  parameter Modelica.SIunits.Volume V_max = m_max/((rho_hot_set + rho_cold_set)/2) "Max salt volume in tanks";
  parameter Modelica.SIunits.Length H_storage = 19 "Storage tank height";
  parameter Modelica.SIunits.Diameter D_storage = 20 "Storage tank diameter";

  parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound"; // Level (below which) to stop disptach
  parameter Real hot_tnk_empty_ub = 10 "Hot tank empty trigger upper bound"; // Level (above which) to start disptach

  parameter Real hot_tnk_full_lb = 90 "Hot tank full trigger lower bound";
  parameter Real hot_tnk_full_ub = 99 "Hot tank full trigger upper bound";

  parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound"; // Level (below which) to stop disptach
  parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound"; // Level (above which) to start disptach

  parameter Real cold_tnk_crit_lb = 0 "Cold tank critically empty trigger lower bound"; // Level (below which) to stop disptach
  parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound"; // Level (above which) to start disptach

  parameter Modelica.SIunits.HeatFlowRate Q_start = 1e-3;
  parameter Modelica.SIunits.HeatFlowRate Q_stop = 1e-3;

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe(redeclare package Medium = Medium, diameter = 0.254, length = 1, modelStructure = Modelica.Fluid.Types.ModelStructure.a_vb, nNodes = 1, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  inner Modelica.Fluid.System system(T_start = from_degC(290), allowFlowReversal = false, p_start = Medium.p_default) annotation(
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, 30}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {20, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.ReceiverControl controlCold(Kp = -1000,	L_df_off = cold_tnk_defocus_ub, L_df_on = cold_tnk_defocus_lb, L_off = cold_tnk_crit_lb, L_on = cold_tnk_crit_ub, T_ref = from_degC(565), m_flow_max = m_flow_heater_max, m_flow_min = 0)  annotation(
    Placement(visible = true, transformation(origin = {70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Storage.Tank.Tank tankHot(redeclare package Medium = Medium, D = D_storage, H = H_storage, T_start = T_hot_set, W_max = 30e6, use_L = true) annotation(
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Storage.Tank.Tank tankCold(redeclare package Medium = Medium, D = D_storage, H = H_storage, L_start = 30, T_start = T_cold_set, W_max = 30e6, use_L = true) annotation(
    Placement(visible = true, transformation(origin = {70, -74}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpHot(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {66, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression T_amb(y = system.T_ambient) annotation(
    Placement(visible = true, transformation(origin = {-50, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_atm(y = system.p_ambient) annotation(
    Placement(visible = true, transformation(origin = {-18, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.HotPumpControl controlHot(L_df_off = hot_tnk_full_lb, L_df_on = hot_tnk_full_ub,L_off = hot_tnk_empty_lb, L_on = hot_tnk_empty_ub, m_flow_on = m_flow_hot)  annotation(
    Placement(visible = true, transformation(origin = {82, 70}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  SolarTherm.Models.Sources.GridInput gridInput(Q_start = Q_start, Q_stop = Q_stop, W_curtailment = Q_flow_des, elec_input = elec_input)  annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.Boiler boiler(T_cold_set = T_cold_set)  annotation(
    Placement(visible = true, transformation(origin = {130, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable scheduler(fileName = schd_input, tableName = "m_flow", tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {124, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Boolean curtail;
  Modelica.SIunits.HeatFlowRate Q_scheduled;
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {-116, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
equation
  boiler.m_flow = controlHot.m_flow;
  curtail = controlCold.defocus or controlHot.defocus;
  gridInput.Q_defocus_y = min(gridInput.grid_input.y[1], scheduler.y[1] * (h_hot_set - h_cold_set));
  Q_scheduled = scheduler.y[1] * (h_hot_set - h_cold_set);
  connect(heater.port, pipe.heatPorts[1]) annotation(
    Line(points = {{-40, 0}, {-24, 0}}, color = {191, 0, 0}));
  connect(pipe.port_b, temperature.fluid_a) annotation(
    Line(points = {{-20, 10}, {-20, 20}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, pipe.port_a) annotation(
    Line(points = {{10, -80}, {-20, -80}, {-20, -10}}, color = {0, 127, 255}));
  connect(temperature.T, controlCold.T_mea) annotation(
    Line(points = {{-10, 30}, {49.5, 30}, {49.5, -24}, {59, -24}}, color = {0, 0, 127}));
  connect(controlCold.m_flow, pumpCold.m_flow) annotation(
    Line(points = {{81, -30}, {96, -30}, {96, -48}, {20, -48}, {20, -71}}, color = {0, 0, 127}));
  connect(temperature.fluid_b, tankHot.fluid_a) annotation(
    Line(points = {{-20, 40}, {-20, 55}, {0, 55}}, color = {0, 127, 255}));
  connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(
    Line(points = {{20, 43}, {29, 43}, {29, 42}, {56, 42}}, color = {0, 127, 255}));
  connect(T_amb.y, tankHot.T_amb) annotation(
    Line(points = {{-39, 64}, {6, 64}, {6, 60}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(p_atm.y, tankHot.p_top) annotation(
    Line(points = {{-7, 76}, {14.5, 76}, {14.5, 60}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(controlHot.m_flow, pumpHot.m_flow) annotation(
    Line(points = {{71, 70}, {66, 70}, {66, 51}}, color = {0, 0, 127}));
  connect(gridInput.electricity, heater.Q_flow) annotation(
    Line(points = {{-80, 0}, {-60, 0}}, color = {0, 0, 127}));
  connect(pumpCold.fluid_a, tankCold.fluid_b) annotation(
    Line(points = {{30, -80}, {50, -80}, {50, -81}, {60, -81}}, color = {0, 127, 255}));
  connect(tankCold.L, controlCold.L_mea) annotation(
    Line(points = {{60, -70}, {50, -70}, {50, -30}, {60, -30}}, color = {0, 0, 127}));
  connect(tankCold.fluid_a, boiler.fluid_b) annotation(
    Line(points = {{80, -68}, {130, -68}, {130, -20}}, color = {0, 127, 255}));
  connect(boiler.fluid_a, pumpHot.fluid_b) annotation(
    Line(points = {{130, 0}, {130, 42}, {76, 42}}, color = {0, 127, 255}));
  connect(tankHot.L, controlHot.L_mea) annotation(
    Line(points = {{20, 54}, {36, 54}, {36, 96}, {106, 96}, {106, 78}, {93, 78}}, color = {0, 0, 127}));
  connect(scheduler.y[1], controlHot.m_flow_sch) annotation(
    Line(points = {{113, 70}, {93, 70}}, color = {0, 0, 127}));
  connect(gridInput.on_pv, controlCold.sf_on) annotation(
    Line(points = {{-90, -12}, {-90, -36}, {60, -36}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(or1.y, gridInput.defocus) annotation(
    Line(points = {{-112, 0}, {-100, 0}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(controlCold.defocus, or1.u2) annotation(
    Line(points = {{70, -42}, {70, -46}, {-136, -46}, {-136, -4}, {-120, -4}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(controlCold.m_flow, controlHot.m_flow_in) annotation(
    Line(points = {{82, -30}, {100, -30}, {100, 62}, {92, 62}}, color = {0, 0, 127}));
  connect(controlHot.defocus, or1.u1) annotation(
    Line(points = {{82, 82}, {82, 90}, {-136, 90}, {-136, 0}, {-120, 0}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(p_atm.y, tankCold.T_amb) annotation(
    Line(points = {{-6, 76}, {30, 76}, {30, -54}, {74, -54}, {74, -64}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(T_amb.y, tankCold.p_top) annotation(
    Line(points = {{-38, 64}, {-4, 64}, {-4, -60}, {66, -60}, {66, -64}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  annotation(
    experiment(StartTime = 0, StopTime = 3.1536e+07, Tolerance = 1e-06, Interval = 300),
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}}), graphics = {Bitmap(extent = {{-18, 64}, {-18, 64}})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end WindPVsaltTESsystem;
