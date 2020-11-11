within SolarTherm.Systems.Publications.Thermocline.Constant_Charging.Temperature_Controlled;

model Part6b_CaO_7pctPCM_6h_10h_8h
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  package Medium = SolarTherm.Media.Sodium.Sodium_pT; //Do not change
  package Fluid_Package = SolarTherm.Materials.Sodium; //Do not change
  package Filler_Package = SolarTherm.Materials.CaO_Constant;//MgO_Constant;  //Can investigate different filler
  package PCM_Top_Package = SolarTherm.Materials.PCM_710;
  package PCM_Bot_Package = SolarTherm.Materials.PCM_520;
  //Design Parameters
  //Fixed
  parameter Integer Correlation = 3 "Conservative";
  parameter SI.Temperature T_min = 510 + 273.15 "Minimum temperature";
  parameter SI.Temperature T_max = 720 + 273.15 "Maximum temperature";
  
  parameter SI.Temperature T_PB_min = 680 + 273.15 "Minimum tolerated outlet temperature to PB";
  parameter SI.Temperature T_Recv_max = 550 + 273.15 "Maximum tolerated outlet temperature to recv";
  parameter Real eta = 0.26 "Porosity"; //0.36 if randomly packed, 0.26 for perfect packing.
  //Tanks
  parameter Integer N_f_A = integer(frac_1*100);//5 "Number of fluid CVs in topper";
  parameter Integer N_p_A = 10 "Number of filler CVs  in topper";
  parameter Integer N_f_B = 100 - N_f_A - N_f_C;//90 "Number of fluid CVs in main tank";
  parameter Integer N_p_B = 10 "Number of filler CVs  in main tank";
  parameter Integer N_f_C = integer(frac_2*100);//5 "Number of fluid CVs in bottomer";
  parameter Integer N_p_C = 10 "Number of filler CVs  in bottomer";

  
  parameter SI.Energy E_max = t_discharge * (P_name / eff_PB) "Storage capacity (J), t_discharge(s), 100MWe, 50% PB efficiency";
  parameter Real eff_PB = 0.50 "Power block heat to electricity conversion efficiency";
  parameter SI.Time t_charge = 6.0 * 3600.0 "Charging period";
  parameter SI.Time t_standby = (24.0 * 3600.0) - t_charge - t_discharge "Standby period between discharge and charge";
  parameter SI.Length d_p = 0.10 "Filler diameter";
  //Optimise
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.1 "W/m2K";
  parameter SI.Power P_name = 100.0e6 * (t_charge/t_discharge) "Nameplate power block";
  parameter SI.Time t_discharge = 10.0 * 3600.0 "Discharging period";
  parameter Real ar = 2.0 "Tank aspect ratio";
  parameter Real frac_1 = 0.20 "fraction of energy storage capacity in topper";
  //Derived
  parameter Real frac_2 = frac_1 "fraction of energy storage capacity in bottomer";
  parameter SI.Time t_cycle = t_charge + t_discharge + t_standby;
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0.0);
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 1.0);
  parameter SI.MassFlowRate m_charge = E_max / (t_charge * (h_f_max - h_f_min));
  parameter SI.MassFlowRate m_discharge = E_max / (t_discharge * (h_f_max - h_f_min));

  Modelica.Fluid.Sources.Boundary_pT Recv_outlet(redeclare package Medium = Medium, T = T_max, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT PB_outlet(redeclare package Medium = Medium, T = T_min, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {92, -60}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  //Efficiency
  parameter SI.Energy denom = m_charge * t_charge * (h_f_max - h_f_min);
  SI.Energy numer(start = 0.0);
  Real eff_storage(start = 0.0) "Storage efficiency";
  //COntrol

  
  SolarTherm.Models.Storage.Thermocline.Cascaded.Thermocline_Group_3 thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Filler_Package_A = PCM_Bot_Package,  redeclare package Filler_Package_B = Filler_Package, redeclare package Filler_Package_C = PCM_Top_Package, N_f_A = N_f_A, N_p_A = N_p_A, N_f_B = N_f_B, N_p_B = N_p_B, N_f_C = N_f_C, N_p_C = N_p_C, frac_1=frac_1, frac_2=frac_2, T_max = T_max, T_min = T_min, E_max = E_max, ar = ar, eta = eta, d_p = d_p,U_loss_tank=U_loss_tank,Correlation=Correlation) annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
    
    
  SolarTherm.Models.Fluid.Sources.FluidSink Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-120, -36}, extent = {{26, -26}, {-26, 26}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-38, -2}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-103, 5}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));

  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.Thermocline_Splitter thermocline_Splitter1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 67.5547}, extent = {{-16, 0}, {16, 22.4453}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.Thermocline_Splitter thermocline_Splitter2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -36.3493}, extent = {{-14, 0}, {14, 21.6507}}, rotation = 180)));

  Modelica.Blocks.Sources.RealExpression m_flow_PB(y = m_PB_signal) annotation(
    Placement(visible = true, transformation(origin = {110, 3}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {40, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink PB_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {102, 44}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {41, -2}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {44, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.mass_loop_breaker mass_loop_breaker(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {2.44249e-15, 56}, extent = {{-24, -24}, {24, 24}}, rotation = -90)));
  //Costs
  parameter Real C_fluid = thermocline_Tank.C_fluid;
  parameter Real C_filler = thermocline_Tank.C_filler;
  parameter Real C_tank = thermocline_Tank.C_tank;
  parameter Real C_insulation = thermocline_Tank.C_insulation;
  parameter Real C_total = thermocline_Tank.C_total;
  //Energies
  SI.Energy E_charged(start=0);
  SI.Energy E_discharged(start=0);
  SI.Energy E_lost(start=0);
  SI.Energy E_pump(start=0);


  SI.MassFlowRate m_Recv_signal(start = m_charge); //starts in charging state
  SI.MassFlowRate m_PB_signal(start = 0.0);
  
  Real T_top_degC;
  Real T_bot_degC;
  Real T_outlet_degC;
  
algorithm
  when rem(time, t_cycle) > 1e-6 then
    m_Recv_signal := m_charge;
    m_PB_signal := 0.0;
  end when;
  when rem(time, t_cycle) > t_charge + 1e-6  then
    m_Recv_signal := 0.0;
    m_PB_signal := m_discharge;
  end when;
  when rem(time, t_cycle) > t_charge + t_discharge + 1e-6  then
    m_Recv_signal := 0.0;
    m_PB_signal := 0.0;
  end when;

  when thermocline_Tank.T_bot_measured > T_Recv_max then
  //when thermocline_Tank.fluid_bot.T > T_Recv_max then
    //if rem(time, t_cycle) < t_charge then
      m_Recv_signal := 0.0;
    //end if;
  end when;
  
  when thermocline_Tank.T_top_measured < T_PB_min then
  //when thermocline_Tank.fluid_top.T < T_PB_min then
    //if rem(time, t_cycle) >= t_charge and rem(time, t_cycle) < t_discharge + t_charge then
      m_PB_signal := 0.0;
    //end if;
  end when;
  
equation
  T_top_degC = thermocline_Tank.T_top_measured - 273.15;
  T_bot_degC = thermocline_Tank.T_bot_measured - 273.15;
  if thermocline_Tank.Tank_A.m_flow > 1e-3 then //dicharging
    T_outlet_degC = T_top_degC;
  elseif thermocline_Tank.Tank_A.m_flow < -1e-3 then //charging
    T_outlet_degC = T_bot_degC;
  else
    T_outlet_degC = 298.15; //reference value
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
  if time > t_cycle*5.0 and time < t_cycle*6.0 then
    der(numer) = PB_Sink.port_a.m_flow*(inStream(PB_Sink.port_a.h_outflow)-h_f_min);
    if time < t_cycle*5.0+t_charge then //charging
      der(E_charged) = thermocline_Tank.fluid_a.m_flow*(inStream(thermocline_Tank.fluid_a.h_outflow) - thermocline_Tank.fluid_b.h_outflow);
      der(E_discharged) = 0.0;
    elseif time > t_cycle*5.0+t_charge and time < t_cycle*5.0+t_charge+t_discharge then
      der(E_charged)=0.0;
      der(E_discharged) = thermocline_Tank.fluid_b.m_flow*(thermocline_Tank.fluid_a.h_outflow-inStream(thermocline_Tank.fluid_b.h_outflow));
    else
      der(E_charged)=0.0;
      der(E_discharged) = 0.0;
    end if;
    der(E_lost) = thermocline_Tank.Tank_A.Q_loss_total + thermocline_Tank.Tank_B.Q_loss_total + thermocline_Tank.Tank_C.Q_loss_total;
    der(E_pump) = thermocline_Tank.Tank_A.W_loss_pump + thermocline_Tank.Tank_B.W_loss_pump + thermocline_Tank.Tank_C.W_loss_pump;
  else
    der(numer) = 0.0;
    der(E_charged)=0.0;
    der(E_discharged) = 0.0;
    der(E_lost) = 0.0;
    der(E_pump) = 0.0;
  end if;
  
  if time > t_cycle*5.0 + 100.0 then
    //eff_storage = (numer)/denom;
    eff_storage = (numer-E_pump)/denom; //subtract pumping power
  else
    eff_storage = 0.0;
  end if;
  
  connect(thermocline_Tank.fluid_b, thermocline_Splitter2.fluid_c) annotation(
    Line(points = {{0, -32}, {0, -46}}, color = {0, 127, 255}));
  connect(thermocline_Splitter2.fluid_b, pumpSimple_EqualPressure2.fluid_a) annotation(
    Line(points = {{-12, -60}, {-34, -60}, {-34, -36}, {-46, -36}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure2.m_flow) annotation(
    Line(points = {{-82, 5}, {-56, 5}, {-56, -27}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure3.fluid_b, thermocline_Splitter2.fluid_a) annotation(
    Line(points = {{30, -60}, {12, -60}}, color = {0, 127, 255}));
  connect(thermocline_Tank.T_amb, Tamb.y) annotation(
    Line(points = {{-17, -2}, {-25, -2}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure.fluid_b, thermocline_Splitter1.fluid_a) annotation(
    Line(points = {{-44, 48}, {-30, 48}, {-30, 92}, {-13, 92}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_b, pumpSimple_EqualPressure1.fluid_a) annotation(
    Line(points = {{13, 92}, {22, 92}, {22, 44}, {34, 44}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_c, mass_loop_breaker.port_a) annotation(
    Line(points = {{0, 78}, {0, 78}, {0, 70}, {0, 70}}, color = {0, 127, 255}));
  connect(mass_loop_breaker.port_b, thermocline_Tank.fluid_a) annotation(
    Line(points = {{0, 42}, {0, 28}}, color = {0, 127, 255}));
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
  annotation(
    experiment(StopTime = 518400, StartTime = 0, Tolerance = 1e-3, Interval = 60));

end Part6b_CaO_7pctPCM_6h_10h_8h;