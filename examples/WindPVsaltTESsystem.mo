within examples;

model WindPVsaltTESsystem
  extends Modelica.Icons.Example;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Constants.*;
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph;
  parameter String elec_input = "/home/arfontalvo/solartherm-master/examples/pv_electricity.motab";
  parameter Modelica.SIunits.Temperature T_hot_set = from_degC(565) "Hot tank temperature";
  parameter Modelica.SIunits.Temperature T_cold_set = from_degC(290) "Hot tank temperature";
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold salt thermodynamic state at design";
  parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hold salt thermodynamic state at design";
  
  parameter Modelica.SIunits.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";
  parameter Real t_storage(unit = "h") = 4 "Hours of storage";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_des = 80*(h_hot_set - h_cold_set) "Heat to power block at design";
  parameter Real tank_ar = 9.2/60.1 "storage aspect ratio";
  parameter Modelica.SIunits.Length tank_min_l = 1.8 "Storage tank fluid minimum height";

  parameter Modelica.SIunits.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";  
  parameter Modelica.SIunits.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot salt specific enthalpy at design";
  parameter Modelica.SIunits.Density rho_cold_set = Medium.density(state_cold_set) "Cold salt density at design";
  parameter Modelica.SIunits.Density rho_hot_set = Medium.density(state_hot_set) "Hot salt density at design";
  parameter Modelica.SIunits.Mass m_max = E_max/(h_hot_set - h_cold_set) "Max salt mass in tanks";
  parameter Modelica.SIunits.Volume V_max = m_max/((rho_hot_set + rho_cold_set)/2) "Max salt volume in tanks";
  parameter Modelica.SIunits.Length H_storage = (4*V_max*tank_ar^2/pi)^(1/3) + tank_min_l "Storage tank height";
  parameter Modelica.SIunits.Diameter D_storage = (0.5*V_max/(H_storage - tank_min_l)*4/pi)^0.5 "Storage tank diameter";

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable pv_wind(fileName = elec_input, tableName = "p_pelec", tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-86, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe(redeclare package Medium = Medium, diameter = 0.254, length = 1, modelStructure = Modelica.Fluid.Types.ModelStructure.a_vb, nNodes = 1, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {-16, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  inner Modelica.Fluid.System system(T_start = from_degC(290), allowFlowReversal = false, p_start = Medium.p_default) annotation(
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary hotTank(nPorts = 1, redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {76, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-16, 30}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {30, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary coldTank(redeclare package Medium = Medium, T = from_degC(290), nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {70, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression bool(y = on_pv) annotation(
    Placement(visible = true, transformation(origin = {30, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Boolean on_pv;
  Integer state_con(start = 1);
  SolarTherm.Models.Control.ReceiverControl controlCold(Kp = -1000, T_ref = from_degC(565))  annotation(
    Placement(visible = true, transformation(origin = {76, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression L_mea(y = 50)  annotation(
    Placement(visible = true, transformation(origin = {30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Storage.Tank.Tank tankHot(redeclare package Medium = Medium, D = D_storage, H = H_storage, T_start = T_cold_set, W_max = 30e6, use_L = true) annotation(
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {48, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression T_amb(y = from_degC(25)) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_atm(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.PowerBlockControl controlHot(m_flow_on = 80)  annotation(
    Placement(visible = true, transformation(origin = {80, 84}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
algorithm
  when state_con == 1 and pv_wind.y[1] > 1e-3 then
    state_con := 2;
  elsewhen state_con == 2 and pv_wind.y[1] < 1e-3 then
    state_con := 1;
  end when;
equation
  if state_con == 1 then
    on_pv = false;
  else
    on_pv = true;
  end if;
  connect(heater.port, pipe.heatPorts[1]) annotation(
    Line(points = {{-40, 0}, {-20, 0}}, color = {191, 0, 0}));
  connect(pv_wind.y[1], heater.Q_flow) annotation(
    Line(points = {{-74, 0}, {-60, 0}}, color = {0, 0, 127}));
  connect(pipe.port_b, temperature.fluid_a) annotation(
    Line(points = {{-16, 10}, {-16, 20}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_b, pipe.port_a) annotation(
    Line(points = {{20, -70}, {-16, -70}, {-16, -10}}, color = {0, 127, 255}));
  connect(pumpCold.fluid_a, coldTank.ports[1]) annotation(
    Line(points = {{40, -70}, {60, -70}}, color = {0, 127, 255}));
  connect(temperature.T, controlCold.T_mea) annotation(
    Line(points = {{-6, 30}, {65, 30}}, color = {0, 0, 127}));
  connect(L_mea.y, controlCold.L_mea) annotation(
    Line(points = {{41, 10}, {45.5, 10}, {45.5, 24}, {65, 24}}, color = {0, 0, 127}));
  connect(controlCold.m_flow, pumpCold.m_flow) annotation(
    Line(points = {{87, 24}, {96, 24}, {96, -48}, {30, -48}, {30, -62}}, color = {0, 0, 127}));
  connect(bool.y, controlCold.sf_on) annotation(
    Line(points = {{41, -10}, {54, -10}, {54, 18}, {65, 18}}, color = {255, 0, 255}));
  connect(temperature.fluid_b, tankHot.fluid_a) annotation(
    Line(points = {{-16, 40}, {-16, 55}, {0, 55}}, color = {0, 127, 255}));
  connect(tankHot.fluid_b, pumpSimple.fluid_a) annotation(
    Line(points = {{20, 43}, {29, 43}, {29, 50}, {38, 50}}, color = {0, 127, 255}));
  connect(pumpSimple.fluid_b, hotTank.ports[1]) annotation(
    Line(points = {{58, 50}, {66, 50}}, color = {0, 127, 255}));
  connect(T_amb.y, tankHot.T_amb) annotation(
    Line(points = {{-59, 70}, {6, 70}, {6, 60}}, color = {0, 0, 127}));
  connect(p_atm.y, tankHot.p_top) annotation(
    Line(points = {{-59, 90}, {14.5, 90}, {14.5, 60}}, color = {0, 0, 127}));
  connect(controlCold.m_flow, controlHot.m_flow_in) annotation(
    Line(points = {{87, 24}, {96, 24}, {96, 79}, {91, 79}}, color = {0, 0, 127}));
  connect(controlHot.m_flow, pumpSimple.m_flow) annotation(
    Line(points = {{68, 84}, {48, 84}, {48, 58}}, color = {0, 0, 127}));
  connect(tankHot.L, controlHot.L_mea) annotation(
    Line(points = {{20, 54}, {28, 54}, {28, 98}, {98, 98}, {98, 90}, {90, 90}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 3.1536e+07, Tolerance = 1e-06, Interval = 60));
end WindPVsaltTESsystem;