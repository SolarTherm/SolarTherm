within SolarTherm.Systems.PCMStorage;

model TrainingData_3PCMCascade
  //Part one of the baseline comparisons, this one is just the base case.
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  package Medium = SolarTherm.Media.Sodium.Sodium_pT;
  //Do not change
  package Fluid_Package = SolarTherm.Materials.Sodium_Table;
  //Do not change
  package Wall_Package = SolarTherm.Media.Materials.SS316L;  
  package PCM_Package1 = SolarTherm.Media.Materials.PCM710_UniSA;    //Can investigate different PCM
  package PCM_Package2 = SolarTherm.Media.Materials.PCM635_UniSA;      //Can investigate different PCM_Package
  package PCM_Package3 = SolarTherm.Media.Materials.PCM569_UniSA;        //Can investigate different PCM
  //Training Data Parameters
  parameter SI.Temperature T_max = CV.from_degC(740) "Maximum temperature"; //L6
  parameter SI.Temperature T_PB_start = CV.from_degC(710) "Minimum tolerated outlet temperature to PB"; //L5
  parameter SI.Temperature T_PB_min = CV.from_degC(680) "Minimum tolerated outlet temperature to PB"; //L4
  parameter SI.Temperature T_Recv_max = CV.from_degC(580) "Maximum tolerated outlet temperature to recv"; //L3 // Because the bottome PCM has a melting temperature of 569 deg. C, the cut-off temperature for charging is set to 580 deg.C, different from the thermocline system.  
  parameter SI.Temperature T_Recv_start = CV.from_degC(540) "Maximum tolerated outlet temperature to recv"; //L2
  parameter SI.Temperature T_min = CV.from_degC(510) "Minimum temperature"; //L1
  
  //Logged values
  Real L_recv_max(start=0.0); //L4
  Real L_recv_start(start=0.0); //L3
  Real L_PB_start(start=0.0); //L2
  Real L_PB_min(start=0.0); //L1

  Real t_stop_charge(start = 0.0);
  Real t_stop_discharge(start = 0.0);

  parameter Real t_storage(unit = "h") = 8.0 "Hours of storage";
  parameter SI.Power P_gross = 100.0e6 "Nameplate power block";
  parameter Real eff_PB = 0.51 "Power block heat to electricity conversion efficiency";
  
  //Design Parameters
  //Tanks
  //The design parameters below were obtained from a detailed simulation. Please DO NOT change.
  parameter SI.Length r_tube_in = 0.006265 "Tube inner radius"; 
  parameter SI.Length r_tube_out = 0.008575 "Tube outer radius";
  parameter SI.Length r_shell = 0.03 "Shell radius";
  parameter SI.Length L1 = 210 "Length of PCM1_PCM710tank";
  parameter SI.Length L2 = 66.4 "Length of PCM2_PCM635tank";
  parameter SI.Length L3 = 200 "Length of PCM3_PCM569tank";
  parameter Integer N_tube = 8040 "Number of tubes in PCM710tank, PCM635tank and PCM569tank";
  // Please DO NOT change the parameters above. 
   
  parameter Integer N_sec1 = 50 "Number of mesh elements in PCM710tank";  
  parameter Integer N_sec2 = 20 "Number of mesh elements in PCM635tank"; 
  parameter Integer N_sec3 = 50 "Number of mesh elements in PCM569tank"; 
  parameter SI.Energy E_max_total = (PCMTank.Tank_Top.E_max + PCMTank.Tank_Mid.E_max + PCMTank.Tank_Bot.E_max) * N_tube "Design storage capacity of combined storage tanks, J";   
  parameter SI.Energy E_max = t_discharge * (P_gross / eff_PB) "Storage capacity (J), t_discharge(s), 100MWe, 50% PB efficiency";  
  parameter SI.Time t_charge = t_storage * 3600.0 "Charging period";
  parameter SI.Time t_standby = 24.0 * 3600.0 - t_charge - t_discharge "Standby period between discharge and charge";
  //Optimise
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.0 "W/m2K";  
  parameter SI.Time t_discharge = t_storage * 3600.0 "Discharging period";
  //Derived
  parameter SI.Time t_cycle = t_charge + t_discharge + t_standby;
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0.0);
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 1.0);
  parameter SI.MassFlowRate m_charge = E_max / (t_charge * (h_f_max - h_f_min))/ N_tube;
  parameter SI.MassFlowRate m_discharge = E_max / (t_discharge * (h_f_max - h_f_min)) / N_tube;
  Modelica.Fluid.Sources.Boundary_pT Recv_outlet(redeclare package Medium = Medium, T = T_max, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT PB_outlet(redeclare package Medium = Medium, T = T_min, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {92, -60}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  //Control
  
  SolarTherm.Models.Storage.PCMTubeInTank_Test.Cascade3PCMStorageTank2 PCMTank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Wall_Package = Wall_Package, redeclare package PCM_Package1 = PCM_Package1, redeclare package PCM_Package2 = PCM_Package2, redeclare package PCM_Package3 = PCM_Package3, L1 = L1, L2 = L2, L3 = L3, N_sec1 = N_sec1, N_sec2 = N_sec2, N_sec3 = N_sec3, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max) annotation(Placement(visible = true, transformation(origin = {3, 5}, extent = {{-21, -21}, {21, 21}}, rotation = 0))); 
  
  SolarTherm.Models.Fluid.Sources.FluidSink Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-120, -36}, extent = {{26, -26}, {-26, 26}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-38, -2}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-103, 5}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction PCM_Splitter1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 67.5547}, extent = {{-16, 0}, {16, 22.4453}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction PCM_Splitter2(redeclare package Medium = Medium) annotation(
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
    Placement(visible = true, transformation(origin = {0, 56}, extent = {{-24, -24}, {24, 24}}, rotation = -90)));

  //Costs
  //parameter Real C_fluid = thermocline_Tank.C_fluid;
 // parameter Real C_filler = thermocline_Tank.C_filler;
  //parameter Real C_tank = thermocline_Tank.C_tank;
  //parameter Real C_insulation = thermocline_Tank.C_insulation;
  //parameter Real C_total = thermocline_Tank.C_total;
  //parameter Real C_encapsulation = thermocline_Tank.C_encapsulation;
  
  //Energies
  SI.Energy E_charged(start = 0);
  SI.Energy E_discharged(start = 0);
  //SI.Energy E_lost(start = 0);
  //SI.Energy E_pump(start = 0);
  SI.MassFlowRate m_Recv_signal(start = m_charge);
  //starts in charging state
  SI.MassFlowRate m_PB_signal(start = 0.0);
  Real T_top_degC;
  Real T_bot_degC;
  Real T_outlet_degC;
    
  //Efficiency
  parameter SI.Energy denominator = m_charge * t_charge * (h_f_max - h_f_min);
  SI.Energy numerator(start = 0.0);
  //Real der_numerator "rate of change of the numerator for eff_storage calculations";
  Real eff_storage(start = 0.0) "Storage efficiency";
  
  //PCMStorage Analysis
  Real L(start = 0.0) "Tank charging/discharging Level";
  Real der_L "Rate of change of L";
  //Real M "nondimensional mass flow rate";
  Real e_out "outlet effectiveness";
  Real e_bot "outlet effectiveness";
  Real e_top "outlet effectiveness";
  
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
  
  when PCMTank.T_bot_measured > T_Recv_max then//stop charge
    m_Recv_signal := 0.0;
    if time > t_cycle*10.0 then //Log this level
      L_recv_max := L;
	  t_stop_charge := time; //Log stop charge time
    end if;
  end when;

  when PCMTank.T_top_measured < T_PB_min then//stop discharge
    m_PB_signal := 0.0;
    if time > t_cycle*10.0 then //Log this level
      L_PB_min := L;
	  t_stop_discharge := time; //Log stop charge time
    end if;
  end when;

  when PCMTank.T_bot_measured > T_Recv_start then
    if time > t_cycle*10.0 and time < t_cycle*10.0 + t_charge then
      L_recv_start := L;
    end if;
  end when;
  
  when PCMTank.T_top_measured < T_PB_start then
    if time > t_cycle*10.0 + t_charge and time < t_cycle*10.0 + t_charge + t_discharge then
      L_PB_start := L;
    end if;
  end when;  
/*
  if time > t_cycle * 5.0 and time < t_cycle * 6.0 then
    der_numerator := PB_Sink.port_a.m_flow * (thermocline_Tank.fluid_top.h - h_f_min);
  else
    der_numerator := 0.0;
  end if;
*/
equation

  L = PCMTank.Level;
  der_L = der(L);
  //M = 3600.0*thermocline_Tank.Tank_A.m_flow*(h_f_max-h_f_min)/E_max;
  e_top = (PCMTank.T_top_measured - T_min)/(T_max-T_min);
  e_bot = (T_max - PCMTank.T_bot_measured)/(T_max-T_min);
  
  if PCMTank.Tank_Bot.m_flow > 1e-6 then //discharge
    e_out = (PCMTank.T_top_measured - T_min)/(T_max-T_min);
  elseif PCMTank.Tank_Top.m_flow < -1e-6 then //charge
    e_out = (T_max - PCMTank.T_bot_measured)/(T_max-T_min);
  else
    e_out = 0.0;
  end if;
  //der(numerator) = der_numerator;
  if time > t_cycle * 10.0 and time < t_cycle * 11.0 then
    der(numerator) = PB_Sink.port_a.m_flow * (PCMTank.fluid_top.h - h_f_min);
  else
    der(numerator) = 0.0;
  end if;
  
  T_top_degC = PCMTank.T_top_measured - 273.15;
  T_bot_degC = PCMTank.T_bot_measured - 273.15;
  if PCMTank.Tank_Bot.m_flow > 1e-3 then
//dicharging
    T_outlet_degC = T_top_degC;
  elseif PCMTank.Tank_Top.m_flow < (-1e-3) then
//charging
    T_outlet_degC = T_bot_degC;
  else
    T_outlet_degC = 25.0;
//reference value
  end if;
  
//efficiency
  if time > t_cycle * 10.0 and time < t_cycle * 11.0 then
    if time < t_cycle * 10.0 + t_charge then
//charging
      der(E_charged) = PCMTank.fluid_a.m_flow * (inStream(PCMTank.fluid_a.h_outflow) - PCMTank.fluid_b.h_outflow);
      der(E_discharged) = 0.0;
    elseif time > t_cycle * 10.0 + t_charge and time < t_cycle * 10.0 + t_charge + t_discharge then
      der(E_charged) = 0.0;
      der(E_discharged) = PCMTank.fluid_b.m_flow * (PCMTank.fluid_a.h_outflow - inStream(PCMTank.fluid_b.h_outflow));
    else
      der(E_charged) = 0.0;
      der(E_discharged) = 0.0;
    end if;
    //der(E_lost) = PCMTank.Tank_A.Q_loss_total;
    //der(E_pump) = PCMTank.Tank_A.W_loss_pump;
  else
    der(E_charged) = 0.0;
    der(E_discharged) = 0.0;
    //der(E_lost) = 0.0;
    //der(E_pump) = 0.0;
  end if;
  if time > t_cycle * 10.0 + 100.0 then
//eff_storage = (numer)/denom;
    //eff_storage = (numerator - E_pump) / denominator;
    eff_storage = numerator / denominator;
//subtract pumping power
  else
    eff_storage = 0.0;
  end if;
  connect(PCMTank.fluid_b, PCM_Splitter2.fluid_c) annotation(
    Line(points = {{3, -19}, {3, -39}, {0, -39}, {0, -46}}, color = {0, 127, 255}));
  connect(PCM_Splitter2.fluid_b, pumpSimple_EqualPressure2.fluid_a) annotation(
    Line(points = {{-12, -60}, {-34, -60}, {-34, -36}, {-46, -36}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure2.m_flow) annotation(
    Line(points = {{-82, 5}, {-56, 5}, {-56, -27}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure3.fluid_b, PCM_Splitter2.fluid_a) annotation(
    Line(points = {{30, -60}, {12, -60}}, color = {0, 127, 255}));
  connect(PCMTank.T_amb, Tamb.y) annotation(
    Line(points = {{-4, 9}, {-21, 9}, {-21, -2}, {-25, -2}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure.fluid_b, PCM_Splitter1.fluid_a) annotation(
    Line(points = {{-44, 48}, {-30, 48}, {-30, 92}, {-13, 92}}, color = {0, 127, 255}));
  connect(PCM_Splitter1.fluid_b, pumpSimple_EqualPressure1.fluid_a) annotation(
    Line(points = {{13, 92}, {22, 92}, {22, 44}, {34, 44}}, color = {0, 127, 255}));
  connect(PCMTank.p_amb, p_amb.y) annotation(
    Line(points = {{10, 9}, {22, 9}, {22, -2}, {27, -2}}, color = {0, 0, 127}));
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
  connect(mass_loop_breaker.port_b, PCMTank.fluid_a) annotation(
    Line(points = {{0, 36}, {0, 32}, {3, 32}, {3, 27}}, color = {0, 127, 255}));
  connect(PCM_Splitter1.fluid_c, mass_loop_breaker.port_a) annotation(
    Line(points = {{0, 78}, {0, 64}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 1296000, StartTime = 0, Tolerance = 1e-3, Interval = 60));
end TrainingData_3PCMCascade;
