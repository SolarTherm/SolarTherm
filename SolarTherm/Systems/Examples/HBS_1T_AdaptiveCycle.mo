within SolarTherm.Systems.Examples;

model HBS_1T_AdaptiveCycle "This component analysis allows a variable cycle length where charging and discharging follow immediately after each other assuming the system temperate constraints have not been violated. Tank heights are fixed to 30m for all cases."
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  package Medium = SolarTherm.Media.Air.Air_CoolProp_1bar;
  //package Medium_Utilities = SolarTherm.Media.Air.Air_CoolProp_1bar_utilities;
  package Fluid_Package = SolarTherm.Materials.Air_CoolProp_Table_1bar;
  package Filler_Package = SolarTherm.Materials.Mullite_20pct_porosity_50K_intervals;
  //These parameters can be varied
  parameter Real HM = 2.0 "Heater Multiple (relative thermal size of heater to the demand)";
  parameter SI.Time t_discharge = 20.0*3600.0 "Rated discharging period (s)";
  //Numerical Discretisation Settings
  parameter Integer N_f = 100 "Number of vertical mesh elements";
  parameter Real t_storage_hours_ideal = t_discharge/3600.0 "Maximum number of storage hours assuming complete utilisation of storage material (h)";

  //TES Geometric Parameters
  parameter SI.Length d_p = 0.030 "Hole diameter in the filler (m), Default 1.5 cm";
  parameter Real epsilon = 0.5101 "Checkerbrick geometric porosity (fraction of hexagon occupied by air)";
  parameter SI.Length H_tank = 30.0 "Fixed tank height (m)";
  
  //Temperature Controls
  parameter SI.Temperature T_max = 1200.0 + 273.15 "Maximum temperature (K)";
  parameter SI.Temperature T_process_des = 1000.0 + 273.15 "Design process inlet temperature (K)";
  parameter SI.Temperature T_high_set = 1000.0 + 273.15 "TES hot blend temperature temperature (K)";
  parameter SI.Temperature T_process_min = 1000.0 + 273.15 "Minimum tolerated outlet temperature to process (K)";
  parameter SI.Temperature T_heater_max = 450.0 + 273.15 "Maximum tolerated outlet temperature to heater (K)";
  parameter SI.Temperature T_low_set = 450.0 + 273.15 "TES cold blend temperature (K)";
  parameter SI.Temperature T_heater_des = 317.3 + 273.15 "Design receiver inlet temperature (K)";
  parameter SI.Temperature T_min = 317.3 + 273.15 "Minimum temperature (K)";
  parameter SI.Temperature T_amb_des = 25.0 + 273.15 "Design ambient temperature (K)";
  parameter Integer Correlation = 1; //Gas Internal flow
  //parameter SI.SpecificEnthalpy h_tol = 0.05*(TES.Tank_A.h_f_max - TES.Tank_A.h_f_min);
  
  //Calculated TES Parameters
  parameter SI.EnergyDensity E_v = epsilon*rho_f_avg*(h_f_max-h_f_min)+(1.0-epsilon)*rho_p*(h_p_max-h_p_min) "Volumetric energy density (J/m3)";
  parameter Real ar = (0.25*CN.pi*E_v*H_tank*H_tank*H_tank/E_max)^0.5 "Aspect ratio H/D of tanks (-)";
  
  //Insulation Parameters
  parameter SI.Temperature T_ext_max = 323.15 "Maximum allowed external temperature of the HBS walls under worst-case conditions (K)";
  parameter SI.CoefficientOfHeatTransfer U_loss_top = 10.0*(T_ext_max-T_amb_des)/(T_max-T_amb_des) "Heat loss coefficient at the top of the tank (W/m2K)";
  parameter SI.CoefficientOfHeatTransfer U_loss_bot = 10.0*(T_ext_max-T_amb_des)/(T_max-T_amb_des) "Heat loss coefficient at the bottom of the tank (W/m2K)";
  
  
  //Tank Geometry
  parameter SI.MassFlowRate m_process_des = 30.0;
  parameter SI.SpecificEnthalpy h_f_amb_des = Fluid_Package.h_Tf(T_amb_des,0.0);
  parameter SI.SpecificEnthalpy h_f_process_des = Fluid_Package.h_Tf(T_process_des,1.0);
  parameter SI.Power Q_process_des = m_process_des*(h_f_process_des - h_f_min) "Design required process heat-rate (W_th)";
  parameter SI.Power Q_heater_des = HM * Q_process_des "Design heater output heat-rate (W_th)";
  parameter SI.Energy E_max = Q_process_des*t_discharge "Ideal storage capacity (J_thermal)"; //Note 3 tanks
  parameter SI.Time t_charge = t_discharge / (HM - 1.0) "Charging period (s)";
  parameter SI.MassFlowRate m_charge_des = (Q_heater_des - Q_process_des) / (h_f_max - h_f_min) "Design charging mass flow rate assuming design temperature outlet (kg/s)";
  parameter SI.MassFlowRate m_discharge_des = Q_process_des / (h_f_max - h_f_min)  "Design discharging mass flow rate assuming design temperature outlet (kg/s)";
  //Derived Parameters
  parameter SI.Time t_cycle = t_charge + t_discharge "Total max duration of one cycle (s)";
  //this is 24 hours
  //Storage sizing equations
  //Fluid
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0);
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 1.0);
  parameter SI.Density rho_f_min = Fluid_Package.rho_Tf(T_min, 0);
  parameter SI.Density rho_f_max = Fluid_Package.rho_Tf(T_max, 0);
  parameter SI.Density rho_f_avg = (rho_f_min + rho_f_max) / 2;
  //Filler
  parameter SI.SpecificEnthalpy h_p_max = Filler_Package.h_Tf(T_max, 1.0);
  parameter SI.SpecificEnthalpy h_p_min = Filler_Package.h_Tf(T_min, 0.0);
  parameter SI.Density rho_p_min = Filler_Package.rho_Tf(T_min, 0.0);
  parameter SI.Density rho_p_max = Filler_Package.rho_Tf(T_max, 1.0);
  parameter SI.Density rho_p = min(rho_p_min, rho_p_max) "kg/m3";
  
  //Output signals
  Modelica.Fluid.Sources.Boundary_pT Heater_outlet(redeclare package Medium = Medium, T = T_max, nPorts = 1, p = 100000) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT Process_outlet(redeclare package Medium = Medium, T = T_min, nPorts = 1, p = 100000) annotation(
    Placement(visible = true, transformation(origin = {107, -59}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  //Storage Model
  //Componenets and Connectors
  SolarTherm.Models.Fluid.Sources.FluidSink2 Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-125, -59}, extent = {{21, -21}, {-21, 21}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-40, -4}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Heater(y = m_Heater_signal) annotation(
    Placement(visible = true, transformation(origin = {-119, 3}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure heater_sink_pump(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = { -57, -59}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction thermocline_Splitter1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-2, 69.5547}, extent = {{-16, 0}, {16, 22.4453}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction thermocline_Splitter2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-2, -38.3493}, extent = {{-14, 0}, {14, 21.6507}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression m_flow_Process(y = m_Process_signal) annotation(
    Placement(visible = true, transformation(origin = {120, 3}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple process_source_pump(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {45, -59}, extent = {{13, -13}, {-13, 13}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink2 Process_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {112, 44}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 100000) annotation(
    Placement(visible = true, transformation(origin = {43, -4}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple heater_source_pump(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-52, 48}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure process_sink_pump(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {46, 44}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.mass_loop_breaker mass_loop_breaker(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-2, 50}, extent = {{-24, -24}, {24, 24}}, rotation = -90)));
  SolarTherm.Models.Storage.Thermocline.Thermocline_HBS_LC_SingleTank_Final TES(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Filler_Package = Filler_Package, N_f = N_f, T_max = T_max, T_min = T_min, Correlation = Correlation, E_max = E_max, ar = ar, d_p = d_p, eta = epsilon, U_loss_top = U_loss_top, U_loss_bot = U_loss_bot) annotation(
    Placement(visible = true, transformation(origin = {-2, -4}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  //Mass flow Signals starts in charging state //,h_tol=h_tol
  SI.MassFlowRate m_Heater_signal(start = m_charge_des);
  SI.MassFlowRate m_Process_signal(start = 0.0);
  //Measured Temperatures
  Real T_top_degC;
  Real T_bot_degC;
  Real T_outlet_degC;
  Real T_inlet_degC;
  //Energies and Exergies for final cycle calculation
  SI.Energy E_chg(start = 0) "Charged energy into storage";
  SI.Energy E_dis(start = 0) "Discharged energy into storage";
  //Utilisation and efficiencies
  Real util_energy(start = 0.0) "Energetic utilisation (1st Law)";
  Real eff_energy(start = 0.0) "Energetic efficiency (1st Law)";
  //Individual Tank Utilization Calculations
  
  SI.Energy E_stored(start = 0.0);
  SI.Energy E_pump(start=0.0);
  SI.Energy E_loss(start=0.0);
  
  //Counters
  Integer Cycle(start=1) "Which cycle number are we in?";
  Integer State(start=1) "Which state are we in? 1=Chg, 2=Discharging";
  
algorithm
//Mass flow controls
  //If we are in the charging cycle:
  when TES.T_bot_measured > T_heater_max then
    if State == 1 then
      State := 2; //Switch to discharging
    end if;
  end when;
  
  //If we are in the discharging cycle:
  when TES.T_top_measured < T_process_min then
    if State == 2 then
      State := 1;  //Switch back to charging
      Cycle := Cycle + 1; //Go to the next cycle
    end if;
  end when;

  when State < 2 then //we have switched to intended charging
    if TES.T_bot_measured > T_heater_max then //we cannot actually charge
      State := 2; //Try discharging instead
    end if;
  end when;
  
  when State > 1 then //we have switched to intended discharging
    if TES.T_top_measured < T_process_min then //we cannot actually discharge
      State := 1; //Try charging instead
      Cycle := Cycle + 1; //Go to the next cycle
    end if;
  end when;

//Force stop discharging, unacceptable top outlet Temperature
//Utilisation convergence
  when Cycle > 10 then
    terminate("Ten cycles have been reached");
  end when;
  when time > 12.0*t_cycle then //give like 20% leeway
    terminate("Exceeded expected time limit");
  end when;
  
equation
  der(E_stored) = TES.fluid_a.m_flow * (TES.fluid_a.h_outflow - TES.fluid_b.h_outflow);

  if State == 1 then
    m_Heater_signal = m_charge_des * (h_f_max - h_f_min) / (h_f_max - TES.h_bot_outlet);
    m_Process_signal = 1.0e-8;
  else 
    m_Process_signal = m_discharge_des * (h_f_max - h_f_min) / (TES.h_top_outlet - h_f_min);
    m_Heater_signal = 1.0e-8;
  end if;

//Measured temperature sensors
  T_top_degC = TES.T_top_measured - 273.15;
  T_bot_degC = TES.T_bot_measured - 273.15;
//Combined storage outlet temperatures (25degC if no flow)
  if TES.fluid_a.m_flow > 1.0e-3 then //there is mass flow
    T_outlet_degC = TES.fluid_bot.T - 273.15;
    T_inlet_degC = TES.fluid_top.T - 273.15;
  elseif TES.fluid_a.m_flow < (-1.0e-3) then
    T_outlet_degC = TES.fluid_top.T - 273.15;
    T_inlet_degC = TES.fluid_bot.T - 273.15;
  else
    T_outlet_degC = 25.0;
    T_inlet_degC = 25.0;
  end if;

  if Cycle == 10 and State == 1 then //last charging phase
    der(E_chg) = TES.fluid_a.m_flow * (inStream(TES.fluid_a.h_outflow) - TES.fluid_b.h_outflow);
    der(E_dis) = 0.0;
    der(E_pump) = TES.W_loss_pump;
  //elseif time >= 9.0 * t_cycle + t_charge + t_standby and time < 9.0 * t_cycle + t_charge + t_standby + t_discharge then
  elseif Cycle == 10 and State == 2 then //last discharging phase
    der(E_chg) = 0.0;
    der(E_dis) = TES.fluid_b.m_flow * (TES.fluid_a.h_outflow - inStream(TES.fluid_b.h_outflow));
    der(E_pump) = TES.W_loss_pump;
  else
    der(E_chg) = 0.0;
    der(E_dis) = 0.0;
    der(E_pump) = 0.0;
  end if;
  if Cycle > 9 then //we can calculate utilisation and efficiency because denominator is not zero;
    util_energy = (E_dis) / E_max;
    eff_energy = (E_dis) / max(E_chg,1.0); //Avoid division by zero
    der(E_loss) = TES.Q_loss_total;
  else
    util_energy = 0.0;
    eff_energy = 0.0;
    der(E_loss) = 0.0;
  end if;
//Connectors
  connect(thermocline_Splitter2.fluid_b, heater_sink_pump.fluid_a) annotation(
    Line(points = {{-13, -58}, {-27.5, -58}, {-27.5, -59}, {-42, -59}}, color = {0, 127, 255}));
  connect(m_flow_Heater.y, heater_sink_pump.m_flow) annotation(
    Line(points = {{-98, 3}, {-57, 3}, {-57, -46}}, color = {0, 0, 127}));
  connect(process_source_pump.fluid_b, thermocline_Splitter2.fluid_a) annotation(
    Line(points = {{32, -59}, {20.5, -59}, {20.5, -58}, {9, -58}}, color = {0, 127, 255}));
  connect(heater_source_pump.fluid_b, thermocline_Splitter1.fluid_a) annotation(
    Line(points = {{-40, 48}, {-30, 48}, {-30, 90}, {-15, 90}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_b, process_sink_pump.fluid_a) annotation(
    Line(points = {{11, 90}, {22, 90}, {22, 44}, {34, 44}}, color = {0, 127, 255}));
  connect(Heater_outlet.ports[1], heater_source_pump.fluid_a) annotation(
    Line(points = {{-96, 48}, {-64, 48}}, color = {0, 127, 255}));
  connect(Process_outlet.ports[1], process_source_pump.fluid_a) annotation(
    Line(points = {{92, -59}, {58, -59}}, color = {0, 127, 255}));
  connect(m_flow_Heater.y, heater_source_pump.m_flow) annotation(
    Line(points = {{-98, 3}, {-74, 3}, {-74, 72}, {-52, 72}, {-52, 58}}, color = {0, 0, 127}));
  connect(m_flow_Process.y, process_sink_pump.m_flow) annotation(
    Line(points = {{98, 3}, {70, 3}, {70, 70}, {46, 70}, {46, 54}}, color = {0, 0, 127}));
  connect(m_flow_Process.y, process_source_pump.m_flow) annotation(
    Line(points = {{98, 3}, {70, 3}, {70, -30}, {45, -30}, {45, -48}}, color = {0, 0, 127}));
  connect(Recv_Sink.port_a, heater_sink_pump.fluid_b) annotation(
    Line(points = {{-104, -59}, {-72, -59}}, color = {0, 127, 255}));
  connect(Process_Sink.port_a, process_sink_pump.fluid_b) annotation(
    Line(points = {{94, 44}, {58, 44}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_c, mass_loop_breaker.port_a) annotation(
    Line(points = {{-2, 81}, {-2, 64}}, color = {0, 127, 255}));
  connect(mass_loop_breaker.port_b, TES.fluid_a) annotation(
    Line(points = {{-2, 36}, {-2, 20}}, color = {0, 127, 255}));
  connect(TES.fluid_b, thermocline_Splitter2.fluid_c) annotation(
    Line(points = {{-2, -28}, {-2, -49}}, color = {0, 127, 255}));
  connect(Tamb.y, TES.T_amb) annotation(
    Line(points = {{-27, -4}, {-16, -4}}, color = {0, 0, 127}));
  connect(p_amb.y, TES.p_amb) annotation(
    Line(points = {{29, -4}, {12, -4}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 8640000, StartTime = 0, Tolerance = 1e-4, Interval = 300),
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false)),
    Icon(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false)),
  Documentation(info = "<html><head></head><body>Notes:<div><br></div><div>Hot Blast Stove TES:</div><div><br></div><div>Fluid = Air</div><div>Filler = Mullite checkerbricks</div></body></html>"));
end HBS_1T_AdaptiveCycle;