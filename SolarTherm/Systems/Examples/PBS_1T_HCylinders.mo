within SolarTherm.Systems.Examples;

model PBS_1T_HCylinders "Packed-bed storage with sodium fluid and horizontal cylinders of MgO"
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  package Fluid_Package = SolarTherm.Materials.Sodium_Table;
  package Filler_Package = SolarTherm.Materials.MgO;
  //Heat Transfer Convection Coefficient
  parameter Integer Correlation = 1 "Conservative";
  //Temperature Controls
  parameter SI.Temperature T_max = 720 + 273.15 "Maximum temperature";
  parameter SI.Temperature T_PB_des = T_max - 0.5*T_tol_PB "Design blended Power Block inlet temperature";
  parameter SI.Temperature T_PB_min = T_max - T_tol_PB "Minimum tolerated outlet temperature to PB";
  parameter SI.Temperature T_Recv_max = T_min + T_tol_Recv "Maximum tolerated outlet temperature to recv";
  parameter SI.Temperature T_Recv_des = T_min + 0.5*T_tol_Recv "Design blended receiver inlet temperature";
  parameter SI.Temperature T_min = 500 + 273.15 "Minimum temperature";
  //Temp Tolerance Settings
  parameter SI.TemperatureDifference T_tol_Recv = 40.0 "Power block Temperature Tolerance (K)";
  parameter SI.TemperatureDifference T_tol_PB = 20.0 "Power block Temperature Tolerance (K)";
  //Numerical Discretisation
  parameter Integer N_f = 200 "Number of fluid CVs in each tank";//360
  parameter Integer N_p = 10 "Number of filler CVs  in main tank";
  //Tank Geometry
  parameter Real eta = 0.26 "Porosity"; 
  parameter SI.Energy E_max = t_discharge * (P_name / eff_PB) "Storage capacity (J), t_discharge(s), 100MWe, 50% PB efficiency";
  parameter Real eff_PB = 0.40 "Power block heat to electricity conversion efficiency";
  parameter SI.Time t_charge = 6.0 * 3600.0 "Charging period";
  parameter SI.Time t_discharge = 12.0 * 3600.0 "Discharging period";
  parameter SI.Time t_extension = 2.0 * 3600.0 "Extension period to make sure charging and discharging complete, applied twice";
  parameter SI.Time t_standby = 24.0 * 3600.0 - t_charge - t_discharge - 2.0*t_extension "Standby period between discharge and charge";
  parameter SI.Power P_name = 100.0e6 "Nameplate power block";
  //Tank Geometry being studied
  parameter Real ar = 0.75 "Tank aspect ratio";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.1 "W/m2K";
  parameter SI.Length d_p = 0.10 "Filler diameter";
  //Derived Parameters
  parameter SI.Time t_cycle = t_charge + t_discharge + t_standby + 2.0*t_extension; //this is 24 hours
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0.0);
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 1.0);
  parameter SI.MassFlowRate m_flow_charge = E_max / (t_charge * (h_f_max - h_f_min));
  parameter SI.MassFlowRate m_flow_discharge = E_max / (t_discharge * (h_f_max - h_f_min));
  //Output signals
  Modelica.Fluid.Sources.Boundary_pT Recv_outlet(redeclare package Medium = Medium, T = T_max, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT PB_outlet(redeclare package Medium = Medium, T = T_min, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {92, -60}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  //Storage Model
  SolarTherm.Models.Storage.Thermocline.Thermocline_HCylinders_SingleTank_Final thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Filler_Package = Filler_Package, N_f = N_f, N_p = N_p, T_max = T_max, T_min = T_min, E_max = E_max, ar = ar, eta = eta, d_p = d_p, U_loss_tank = U_loss_tank, Correlation = Correlation) annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  //Componenets and Connectors
  SolarTherm.Models.Fluid.Sources.FluidSink2 Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-120, -36}, extent = {{26, -26}, {-26, 26}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-38, -2}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-103, 5}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction thermocline_Splitter1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 69.5547}, extent = {{-16, 0}, {16, 22.4453}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction thermocline_Splitter2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -38.3493}, extent = {{-14, 0}, {14, 21.6507}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression m_flow_PB(y = m_PB_signal) annotation(
    Placement(visible = true, transformation(origin = {110, 3}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {40, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink2 PB_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {102, 44}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {41, -2}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {44, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.mass_loop_breaker mass_loop_breaker(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 50}, extent = {{-24, -24}, {24, 24}}, rotation = -90)));
  //Costs
  parameter Real C_fluid = thermocline_Tank.C_fluid;
  parameter Real C_filler = thermocline_Tank.C_filler;
  parameter Real C_tank = thermocline_Tank.C_tank;
  parameter Real C_insulation = thermocline_Tank.C_insulation;
  parameter Real C_total = thermocline_Tank.C_total;
  parameter Real C_encapsulation = thermocline_Tank.C_encapsulation;
  //Mass flow Signals starts in charging state
  SI.MassFlowRate m_Recv_signal(start = m_flow_charge);
  SI.MassFlowRate m_PB_signal(start = 0.0);
  //Measured Temperatures
  Real T_top_degC;
  Real T_bot_degC;
  Real T_outlet_degC;
  //Energies and Exergies for final cycle calculation
  SI.Energy E_chg(start = 0) "Charged energy into storage";
  SI.Energy E_dis(start = 0) "Discharged energy into storage";
  SI.Energy E_lost(start = 0) "Externally lost energy from storage";
  SI.Energy E_pump(start = 0) "Pumping energy consumed";
  //Utilisation and efficiencies
  Real util_energy(start=0.0) "Energetic utilisation (1st Law)";
  Real eff_energy(start=0.0) "Energetic efficiency (1st Law)";
  //Individual Tank Utilization Calculations
  parameter SI.Energy E_max_A = thermocline_Tank.Tank_A.E_max "Maximum energy capacity of Tank A";
  SI.Energy E_dis_A (start = 0.0) "Discharged energy from Tank A";
  SI.Energy E_pump_A (start = 0.0) "Pumping energy of Tank A";
  Real util_energy_A(start = 0.0) "Storage utilisation of Tank A";
  //Stats to determine if stable cycle has been reached
  SI.Energy E_dis_total(start = 0.0) "Total discharged energy for entire simulation";
  SI.Energy E_pump_total(start = 0.0) "Total pump energy losses for entire simulation";
  SI.Energy E_dis_prev(start = 0.001) "Total discharged energy for previous cycle";
  SI.Energy E_pump_prev(start = 0.001) "Total pump energy losses for previous cycle";
  Real util_prev(start=0.001) "Previous day's level, starts at 0.1% to prevent divbyzero";
  Real time_stop(start=3600.0*24.0*10.0) "The maximum time this simulation can last";
algorithm
  //Mass flow controls
  when rem(time, t_cycle) > 1e-6 then //Start charging
    m_Recv_signal := m_flow_charge;
    m_PB_signal := 0.0;
  end when;
  when rem(time, t_cycle) > t_charge + 1e-6 + t_extension then //Stop charging and start discharging time is up
    m_Recv_signal := 0.0;
    m_PB_signal := m_flow_discharge;
  end when;
  when rem(time, t_cycle) > t_charge + t_discharge + 1e-6 + 2.0*t_extension then //Stop discharging time is up
    m_Recv_signal := 0.0;
    m_PB_signal := 0.0;
  end when;
  when thermocline_Tank.T_bot_measured > T_Recv_max then //Force stop charging, unacceptable bottom outlet Temperature
    m_Recv_signal := 0.0;
  end when;
  when thermocline_Tank.T_top_measured < T_PB_min then //Force stop discharging, unacceptable top outlet Temperature
    m_PB_signal := 0.0;
  end when;
  //Utilisation convergence
  when time > time_stop - 10.0 then
    terminate("Stable cycle has been reached");
  end when;
  when rem(time,t_cycle) > 1.0e-6 then
    //Replace time + t_cycle - 1.0e-6 with 3600.0*24.0*10.0 to bypass the 1% check and simulate the full 10 days
    if abs((((E_dis_total - E_dis_prev) - (E_pump_total - E_pump_prev))/E_max) - util_prev)/(util_prev) < 0.01 and div(time,t_cycle) > 0.0 then //stable cycle
      time_stop := 3600.0*24.0*10.0;//time + t_cycle - 1.0e-6;
    end if;
    if div(time,t_cycle) > 0.0 then //calculate utilisation
      util_prev := ((E_dis_total - E_dis_prev) - (E_pump_total - E_pump_prev))/E_max;
      E_dis_prev := E_dis_total;
      E_pump_prev := E_pump_total;
    end if;
  end when;
equation
  //Measured temperature sensors
  T_top_degC = thermocline_Tank.T_top_measured - 273.15;
  T_bot_degC = thermocline_Tank.T_bot_measured - 273.15;
  //Combined storage outlet temperatures (25degC if no flow)
  if thermocline_Tank.fluid_a.m_flow > 1.0e-3 then //there is mass flow
    T_outlet_degC = thermocline_Tank.fluid_bot.T - 273.15;
  elseif thermocline_Tank.fluid_a.m_flow < -1.0e-3 then
    T_outlet_degC = thermocline_Tank.fluid_top.T - 273.15;
  else
    T_outlet_degC = 25.0;
  end if;
  if time > time_stop - t_cycle then //this is the final cycle
    //Charging Phase
    if rem(time,t_cycle) < t_charge + t_extension then
      der(E_chg) = thermocline_Tank.fluid_a.m_flow * (inStream(thermocline_Tank.fluid_a.h_outflow) - thermocline_Tank.fluid_b.h_outflow);
      der(E_dis) = 0.0;
      der(E_dis_A) = 0.0;

    elseif rem(time,t_cycle) > t_charge + t_extension and rem(time,t_cycle) < t_charge + t_discharge + 2.0*t_extension then //discharging phase
      der(E_chg) = 0.0;
      der(E_dis) = thermocline_Tank.fluid_b.m_flow * (thermocline_Tank.fluid_a.h_outflow - inStream(thermocline_Tank.fluid_b.h_outflow));
      der(E_dis_A) = thermocline_Tank.Tank_A.m_flow*(thermocline_Tank.Tank_A.fluid_out.h - thermocline_Tank.Tank_A.fluid_in.h);
    else
      der(E_chg) = 0.0;
      der(E_dis) = 0.0;
      der(E_dis_A) = 0.0;
    end if;    
    der(E_lost) = thermocline_Tank.Tank_A.Q_loss_total;
    der(E_pump) = thermocline_Tank.Tank_A.W_loss_pump;
    der(E_pump_A) = thermocline_Tank.Tank_A.W_loss_pump;
  else
    der(E_chg) = 0.0;
    der(E_dis) = 0.0;
    der(E_dis_A) = 0.0;
    der(E_lost) = 0.0;
    der(E_pump) = 0.0;
    der(E_pump_A) = 0.0;
  end if;
  //Utilisation Convergence
  if rem(time,t_cycle) < t_charge + t_extension then
    der(E_dis_total) = 0.0;
  else
    der(E_dis_total) = thermocline_Tank.fluid_b.m_flow * (thermocline_Tank.fluid_a.h_outflow - inStream(thermocline_Tank.fluid_b.h_outflow));
  end if;
  der(E_pump_total) = thermocline_Tank.Tank_A.W_loss_pump;
  if time > time_stop - t_cycle + t_charge + 100.0 then //We can calculate these efficiencies without division by zero
    util_energy = (E_dis - E_pump) / E_max; 
    eff_energy = (E_dis - E_pump) / E_chg; 
    util_energy_A = (E_dis_A - E_pump_A)/E_max_A;
  else
    util_energy = 0.0;
    eff_energy = 0.0;
    util_energy_A = 0.0;
  end if;
//Connectors
  connect(thermocline_Tank.fluid_b, thermocline_Splitter2.fluid_c) annotation(
    Line(points = {{0, -32}, {0, -49}}, color = {0, 127, 255}));
  connect(thermocline_Splitter2.fluid_b, pumpSimple_EqualPressure2.fluid_a) annotation(
    Line(points = {{-11, -58}, {-34, -58}, {-34, -36}, {-46, -36}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure2.m_flow) annotation(
    Line(points = {{-82, 5}, {-56, 5}, {-56, -27}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure3.fluid_b, thermocline_Splitter2.fluid_a) annotation(
    Line(points = {{30, -60}, {21, -60}, {21, -58}, {11, -58}}, color = {0, 127, 255}));
  connect(thermocline_Tank.T_amb, Tamb.y) annotation(
    Line(points = {{-17, -2}, {-25, -2}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure.fluid_b, thermocline_Splitter1.fluid_a) annotation(
    Line(points = {{-44, 48}, {-30, 48}, {-30, 90}, {-13, 90}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_b, pumpSimple_EqualPressure1.fluid_a) annotation(
    Line(points = {{13, 90}, {22, 90}, {22, 44}, {34, 44}}, color = {0, 127, 255}));
  connect(thermocline_Tank.p_amb, p_amb.y) annotation(
    Line(points = {{17, -2}, {27, -2}}, color = {0, 0, 127}));
  connect(Recv_outlet.ports[1], pumpSimple_EqualPressure.fluid_a) annotation(
    Line(points = {{-96, 48}, {-64, 48}}, color = {0, 127, 255}));
  connect(PB_outlet.ports[1], pumpSimple_EqualPressure3.fluid_a) annotation(
    Line(points = {{76, -60}, {50, -60}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure.m_flow) annotation(
    Line(points = {{-82, 5}, {-74, 5}, {-74, 72}, {-54, 72}, {-54, 56}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure1.m_flow) annotation(
    Line(points = {{88, 3}, {70, 3}, {70, 70}, {44, 70}, {44, 52}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure3.m_flow) annotation(
    Line(points = {{88, 3}, {70, 3}, {70, -30}, {40, -30}, {40, -52}}, color = {0, 0, 127}));
  connect(Recv_Sink.port_a, pumpSimple_EqualPressure2.fluid_b) annotation(
    Line(points = {{-94, -36}, {-66, -36}, {-66, -36}, {-66, -36}}, color = {0, 127, 255}));
  connect(PB_Sink.port_a, pumpSimple_EqualPressure1.fluid_b) annotation(
    Line(points = {{78, 44}, {54, 44}, {54, 44}, {54, 44}}, color = {0, 127, 255}));
  connect(mass_loop_breaker.port_b, thermocline_Tank.fluid_a) annotation(
    Line(points = {{0, 36}, {0, 28}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_c, mass_loop_breaker.port_a) annotation(
    Line(points = {{0, 81}, {0, 64}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 864000, StartTime = 0, Tolerance = 1e-4, Interval = 60),
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false)),
    Icon(coordinateSystem(extent = {{-150, -100}, {150, 100}}, preserveAspectRatio = false)),
  Documentation(info = "<html><head></head><body><u>Notes:</u><div><br></div><div>Thermal energy storage tank with:</div><div><br></div><div>Fluid = Liquid Sodium</div><div>Filler = Horizontal Cylinder MgO</div><div><br></div><div><u>Test Results:</u></div><div><u><br></u></div><div>Settings:</div><div>Non-linear Solver</div><div>N_p = 10</div><div><br></div><div>Result Table:</div><div>N_f = 128, util_energy = 0.433644</div><div>N_f = 160, util_energy = 0.454087</div><div>N_f = 200, util energy = 0.470666</div></body></html>"));
end PBS_1T_HCylinders;