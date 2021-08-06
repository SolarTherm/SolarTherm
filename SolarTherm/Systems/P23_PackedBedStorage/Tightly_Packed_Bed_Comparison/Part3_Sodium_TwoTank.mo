within SolarTherm.Systems.P23_PackedBedStorage.Tightly_Packed_Bed_Comparison;

model Part3_Sodium_TwoTank
  //The comparison study for Medhi/Felipe aims to investigate how similar or different the results are when a sphere-based model with 5% porosity is used to model a brick filler system. Due to computational cost of CFD, only 2 days will be simulated, with the last day being used to calculate efficiency & effectiveness
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  //Do not change
  package Fluid_Package = SolarTherm.Materials.Sodium_Table;
  //Do not change
  //package Filler_Package = SolarTherm.Materials.MgO_Constant;
  //MgO_Constant;  //Can investigate different filler
  //Design Parameters
  //Fixed
  //parameter Integer Correlation = 3 "Conservative";
  parameter SI.Temperature T_min = 520 + 273.15 "Minimum temperature";
  parameter SI.Temperature T_max = 740 + 273.15 "Maximum temperature";
  parameter SI.Temperature T_PB_min = 700 + 273.15 "Minimum tolerated outlet temperature to PB";
  parameter SI.Temperature T_Recv_max = 560 + 273.15 "Maximum tolerated outlet temperature to recv";
  //parameter Real eta = 0.26 "Porosity";
  //0.36 if randomly packed, 0.26 for perfect packing.
  //Tanks
  parameter Integer N_f = 50 "Number of fluid CVs in main tank";
  //parameter Integer N_p = 10 "Number of filler CVs  in main tank";
  parameter SI.Energy E_max = t_discharge * (P_name / eff_PB) "Storage capacity (J), t_discharge(s), 100MWe, 50% PB efficiency";
  parameter Real eff_PB = 0.50 "Power block heat to electricity conversion efficiency";
  parameter SI.Time t_charge = 6.0 * 3600.0 "Charging period";
  parameter SI.Time t_standby = 24.0 * 3600.0 - t_charge - t_discharge "Standby period between discharge and charge";
  parameter SI.Length d_p = 0.1104 "Filler diameter is equal to the side-length of a brick";
  //Optimise
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.0 "W/m2K Ignore heat-loss";
  parameter SI.Power P_name = 100.0e6 * (t_charge / t_discharge) "Nameplate power block";
  parameter SI.Time t_discharge = 10.0 * 3600.0 "Discharging period";
  parameter Real ar = 1.0 "Tank aspect ratio";
  parameter SI.Length H_tank_hot = Tank.H_tank_hot "Tank height m";
  parameter SI.Length D_tank_hot = Tank.D_tank_hot "Tank diameter m";
  parameter SI.Length H_tank_cold = Tank.H_tank_cold "Tank height m";
  parameter SI.Length D_tank_cold = Tank.D_tank_cold "Tank diameter m";
  
  //Derived
  parameter SI.Time t_cycle = t_charge + t_discharge + t_standby;
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0.0);
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 1.0);
  parameter SI.MassFlowRate m_charge = E_max / (t_charge * (h_f_max - h_f_min));
  parameter SI.MassFlowRate m_discharge = E_max / (t_discharge * (h_f_max - h_f_min));
  Modelica.Fluid.Sources.Boundary_pT Recv_outlet(redeclare package Medium = Medium, T = T_max, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-112, 34}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT PB_outlet(redeclare package Medium = Medium, T = T_min, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {92, -74}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  //Efficiency
  parameter SI.Energy denom = m_charge * t_charge * (h_f_max - h_f_min);
  SI.Energy numer(start = 0.0);
  Real effectiveness_storage(start = 0.0) "Storage effectiveness";
  Real efficiency_storage(start = 0.0) "Storage 1st law efficiency";
  //COntrol
  SolarTherm.Models.Fluid.Sources.FluidSink Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-120, -50}, extent = {{26, -26}, {-26, 26}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-64, 84}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-103, -9}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_PB(y = m_PB_signal) annotation(
    Placement(visible = true, transformation(origin = {110, -11}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {48, -62}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink PB_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {102, 30}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {51, 84}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-54, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {44, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Costs
  parameter Real C_fluid = Tank.C_fluid;
  parameter Real C_filler = Tank.C_filler;
  parameter Real C_tank = Tank.C_tank;
  parameter Real C_insulation = Tank.C_insulation;
  parameter Real C_total = Tank.C_total;
  parameter Real C_encapsulation = Tank.C_encapsulation;
  //Energies
  SI.Energy E_charged(start = 0);
  SI.Energy E_discharged(start = 0);
  SI.Energy E_lost(start = 0);
  SI.Energy E_pump(start = 0);
  SI.MassFlowRate m_Recv_signal(start = m_charge);
  //starts in charging state
  SI.MassFlowRate m_PB_signal(start = 0.0);
  Real T_top_degC;
  Real T_bot_degC;
  Real T_outlet_degC;
  SolarTherm.Models.Storage.Tank.Sodium_Sensible_Tank Tank(redeclare package Medium = Medium, redeclare package Fluid_Package =  Fluid_Package, E_max = E_max, T_max = T_max, T_min = T_min, ar = ar)  annotation(
    Placement(visible = true, transformation(origin = {-5, -13}, extent = {{-49, -53}, {49, 53}}, rotation = 0)));
algorithm
  when rem(time, t_cycle) > 1e-6 then
    m_Recv_signal := m_charge;
    m_PB_signal := 0.0;
  end when;
  when rem(time, t_cycle) > t_charge + 1e-6 then
    m_Recv_signal := 0.0;
    m_PB_signal := m_discharge;
  end when;
  when rem(time, t_cycle) > t_charge + t_discharge + 1e-6 then
    m_Recv_signal := 0.0;
    m_PB_signal := 0.0;
  end when;
  when Tank.L_hot > 0.99 then
    m_Recv_signal := 0.0;
  end when;
  when Tank.L_hot < 0.01 then
    m_PB_signal := 0.0;
  end when;
//when thermocline_Tank.fluid_top.T < T_PB_min then
//if rem(time, t_cycle) >= t_charge and rem(time, t_cycle) < t_discharge + t_charge then
//end if;
equation
  T_top_degC = Tank.fluid_hot.T - 273.15;
  T_bot_degC = Tank.fluid_cold.T - 273.15;
  if abs(Tank.fluid_ha.m_flow) > 1.0e-3 then
    T_outlet_degC = Tank.fluid_hot.T - 273.15;
  else
    T_outlet_degC = 25.0;
  end if;
/*
//controls
  if rem(time, t_cycle) < t_charge and thermocline_Tank.T_bot_measured < T_Recv_max then
//charging
    m_Recv_signal = m_charge;
    m_PB_signal = 0.0;
  elseif rem(time, t_cycle) >= t_charge and rem(time, t_cycle) < t_discharge + t_charge and thermocline_Tank.T_top_measured > T_PB_min then
//discharging
    m_Recv_signal = 0.0;
    m_PB_signal = m_discharge;
  else
    m_Recv_signal = 0.0;
    m_PB_signal = 0.0;
  end if;
*/
//efficiency
  if time > t_cycle * 5.0 and time < t_cycle * 6.0 then
    der(numer) = PB_Sink.port_a.m_flow * (Tank.fluid_hot.h - h_f_min);
    if time < t_cycle * 5.0 + t_charge then
//charging
      der(E_charged) = Tank.fluid_ha.m_flow*inStream(Tank.fluid_ha.h_outflow) + Tank.fluid_hb.m_flow * Tank.fluid_hb.h_outflow;
      der(E_discharged) = 0.0;
    elseif time > t_cycle * 5.0 + t_charge and time < t_cycle * 5.0 + t_charge + t_discharge then
      der(E_charged) = 0.0;
      der(E_discharged) = -1.0*(Tank.fluid_ha.m_flow*inStream(Tank.fluid_ha.h_outflow) + Tank.fluid_hb.m_flow * Tank.fluid_hb.h_outflow);
    else
      der(E_charged) = 0.0;
      der(E_discharged) = 0.0;
    end if;
    der(E_lost) = 0.0 - Tank.Q_loss_hot - Tank.Q_loss_cold;
    der(E_pump) = 0.0;
//Obtain this inside
  else
    der(numer) = 0.0;
    der(E_charged) = 0.0;
    der(E_discharged) = 0.0;
    der(E_lost) = 0.0;
    der(E_pump) = 0.0;
  end if;
  if time > t_cycle * 5.0 + 100.0 then
//eff_storage = (numer)/denom;
    effectiveness_storage = numer / denom;
//subtract pumping power
    efficiency_storage = E_discharged / E_charged;
  else
    effectiveness_storage = 0.0;
    efficiency_storage = 0.0;
  end if;
  connect(m_flow_Recv.y, pumpSimple_EqualPressure2.m_flow) annotation(
    Line(points = {{-82, -9}, {-56, -9}, {-56, -41}}, color = {0, 0, 127}));
  connect(Recv_outlet.ports[1], pumpSimple_EqualPressure.fluid_a) annotation(
    Line(points = {{-96, 34}, {-64, 34}}, color = {0, 127, 255}));
  connect(PB_outlet.ports[1], pumpSimple_EqualPressure3.fluid_a) annotation(
    Line(points = {{76, -74}, {65, -74}, {65, -62}, {58, -62}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure.m_flow) annotation(
    Line(points = {{-82, -9}, {-74, -9}, {-74, 72}, {-54, 72}, {-54, 43}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure1.m_flow) annotation(
    Line(points = {{88, -11}, {70, -11}, {70, 70}, {44, 70}, {44, 39}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure3.m_flow) annotation(
    Line(points = {{88, -11}, {70, -11}, {70, -30}, {48, -30}, {48, -53}}, color = {0, 0, 127}));
  connect(Recv_Sink.port_a, pumpSimple_EqualPressure2.fluid_b) annotation(
    Line(points = {{-94, -50}, {-66, -50}}, color = {0, 127, 255}));
  connect(PB_Sink.port_a, pumpSimple_EqualPressure1.fluid_b) annotation(
    Line(points = {{78, 30}, {54, 30}}, color = {0, 127, 255}));
  connect(Tank.fluid_ha, pumpSimple_EqualPressure.fluid_b) annotation(
    Line(points = {{-30, 19}, {-36, 19}, {-36, 34}, {-44, 34}}, color = {0, 127, 255}));
  connect(Tank.fluid_hb, pumpSimple_EqualPressure1.fluid_a) annotation(
    Line(points = {{22, 19}, {30, 19}, {30, 30}, {34, 30}}, color = {0, 127, 255}));
  connect(Tank.fluid_cb, pumpSimple_EqualPressure2.fluid_a) annotation(
    Line(points = {{-30, -33}, {-38, -33}, {-38, -50}, {-46, -50}}, color = {0, 127, 255}));
  connect(Tank.fluid_ca, pumpSimple_EqualPressure3.fluid_b) annotation(
    Line(points = {{22, -33}, {30, -33}, {30, -62}, {38, -62}}, color = {0, 127, 255}));
  connect(Tamb.y, Tank.T_amb) annotation(
    Line(points = {{-51, 84}, {-20, 84}, {-20, 39}}, color = {0, 0, 127}));
  connect(p_amb.y, Tank.p_amb) annotation(
    Line(points = {{37, 84}, {14, 84}, {14, 39}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 518400, StartTime = 0, Tolerance = 1e-3, Interval = 120),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}}, preserveAspectRatio = false)),
    Icon(coordinateSystem(extent = {{-200, -100}, {200, 100}}, preserveAspectRatio = false)));
end Part3_Sodium_TwoTank;