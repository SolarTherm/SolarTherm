within SolarTherm.Systems.PCMStorage;
model Constant_Cycling_3PCMCascade_10cycles
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  package Medium = SolarTherm.Media.Sodium.Sodium_pT;  
  package Fluid_Package = SolarTherm.Media.Materials.Sodium; 
  package Wall_Package = SolarTherm.Media.Materials.SS316L;  
  package PCM_Package1 = SolarTherm.Media.Materials.PCM710_UniSA;        //Can investigate different PCM
  package PCM_Package2 = SolarTherm.Media.Materials.PCM635_UniSA;          //Can investigate different PCM_Package
  package PCM_Package3 = SolarTherm.Media.Materials.PCM569_UniSA;          //Can investigate different PCM
  //Design Parameters
  parameter SI.Temperature T_min = CV.from_degC(540) "Design cold Temperature of everything in the tank (K)";
  parameter SI.Temperature T_max = CV.from_degC(750) "Design hot Temperature of everything in the tank (K)";
  parameter SI.Length r_tube_in = 0.006265 "Tube inner radius";
  parameter SI.Length r_tube_out = 0.008575 "Tube outer radius";
  parameter SI.Length r_shell = 0.03 "Shell radius";
  parameter SI.Length L1 = 210 "Length of PCM1_PCM710tank";
  parameter SI.Length L2 = 66.4 "Length of PCM2_PCM635tank";
  parameter SI.Length L3 = 120 "Length of PCM3_PCM569tank";
  parameter Integer N_tube1 = 1 "Number of tubes in PCM710tank"; 
  parameter Integer N_tube2 = 1 "Number of tubes in PCM635tank";  
  parameter Integer N_tube3 = 1 "Number of tubes in PCM569tank";
  parameter Integer N_sec1 = 50 "Number of mesh elements in PCM710tank";  
  parameter Integer N_sec2 = 20 "Number of mesh elements in PCM635tank"; 
  parameter Integer N_sec3 = 30 "Number of mesh elements in PCM569tank"; 
  parameter SI.Energy E_max_total = PCMTank.Tank_Top.E_max + PCMTank.Tank_Mid.E_max + PCMTank.Tank_Bot.E_max "Design storage capacity of combined storage tanks, J";   
  
  parameter SI.Time t_charge = 6.0 * 3600.0 "Charging period";
  parameter SI.Time t_standby = 8 * 3600.0 "Standby period between discharge and charge";
  parameter SI.Time t_discharge = 10.0 * 3600.0 "Discharging period";
  parameter SI.Time t_cycle = t_charge + t_standby + t_discharge;

  parameter SI.MassFlowRate m_charge = 0.096735;
  parameter SI.MassFlowRate m_discharge = 0.058781;
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0.0);
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 1.0);
    
  Modelica.Fluid.Sources.Boundary_pT Recv_outlet(redeclare package Medium = Medium, T = T_max, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-117, 42}, extent = {{-11, -10}, {11, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT PB_outlet(redeclare package Medium = Medium, T = T_min, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {122, -82}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  //Efficiency
  parameter SI.Energy denom = m_charge * t_charge * (h_f_max - h_f_min);
  SI.Energy numer(start = 0.0);
  Real eff_storage(start = 0.0) "Storage efficiency";
  //COntrol
  SI.MassFlowRate m_Recv_signal(start = m_charge);
  SI.MassFlowRate m_PB_signal(start = 0.0);

  SolarTherm.Models.Storage.PCMTubeInTank_Test.Cascade3PCMStorageTank PCMTank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Wall_Package = Wall_Package, redeclare package PCM_Package1 = PCM_Package1, redeclare package PCM_Package2 = PCM_Package2, redeclare package PCM_Package3 = PCM_Package3, L1 = L1, L2 = L2, L3 = L3, N_sec1 = N_sec1, N_sec2 = N_sec2, N_sec3 = N_sec3, r_tube_in = r_tube_in, r_tube_out = r_tube_out, r_shell = r_shell, T_min = T_min, T_max = T_max) annotation(Placement(visible = true, transformation(origin = {1, 11}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
    
  SolarTherm.Models.Fluid.Sources.FluidSink Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, -50}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-60, -14}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-107, 3}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-58,-66}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.Thermocline_Splitter PCM_Splitter1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 71.5547}, extent = {{-16, 0}, {16, 22.4453}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.Thermocline_Splitter PCM_Splitter2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {2, -42.3493}, extent = {{-14, 0}, {14, 21.6507}}, rotation = 180)));

  Modelica.Blocks.Sources.RealExpression m_flow_PB(y = m_PB_signal) annotation(
    Placement(visible = true, transformation(origin = {118, 3}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {44, -76}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink PB_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {102, 44}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {49, -4}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {44, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.HeatExchangers.mass_loop_breaker mass_loop_breaker(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 56}, extent = {{-24, -24}, {24, 24}}, rotation = -90)));

//Costs
  //parameter Real C_fluid = PCMTank.C_fluid;
  //parameter Real C_filler = PCMTank.C_filler;
  //parameter Real C_total = PCMTank.C_total;
  //Analyiics
  SI.Energy E_stored_total(start = 0.0) "Make sure the tank starts from T_min)";
  Real Level_total(start = 0.0) "Tank charging level (0-1)";
  //Real LiquidFraction(start = 0.0) "Average liquid fraction of PCM (0-1)";
  //Energies
  //SI.Energy E_charged(start=0);
  //SI.Energy E_discharged(start=0);

equation
  Level_total = E_stored_total / E_max_total;
//controls
  if rem(time, t_cycle) < t_charge then
//charging
    m_Recv_signal = m_charge;
    m_PB_signal = 0.0;
    der(E_stored_total) = m_charge * (PCMTank.fluid_top.h - PCMTank.fluid_bot.h);
  elseif rem(time, t_cycle) >= t_charge and rem(time, t_cycle) < t_discharge + t_charge then
//discharging
    m_Recv_signal = 0.0;
    m_PB_signal = m_discharge;
    der(E_stored_total) = m_discharge * (PCMTank.fluid_bot.h - PCMTank.fluid_top.h);
  else
    m_Recv_signal = 0.0;
    m_PB_signal = 0.0;
    der(E_stored_total) = 0.0;
  end if;
//efficiency
  if time > t_cycle * 5.0 and time < t_cycle * 6.0 then
    der(numer) = PB_Sink.port_a.m_flow * (inStream(PB_Sink.port_a.h_outflow) - h_f_min);
  else
    der(numer) = 0.0;
  end if;
  
  if time > t_cycle*5.0 + 100.0 then
    eff_storage = numer/denom;
  else
    eff_storage = 0.0;
  end if;
  connect(PCMTank.fluid_b, PCM_Splitter2.fluid_c) annotation(
    Line(points = {{1, -6}, {1, -39}, {2, -39}, {2, -48}}, color = {0, 127, 255}));
  connect(PCM_Splitter2.fluid_b, pumpSimple_EqualPressure2.fluid_a) annotation(
    Line(points = {{-9, -65}, {-34, -65}, {-34, -66}, {-48, -66}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure2.m_flow) annotation(
    Line(points = {{-82, 5}, {-58, 5}, {-58, -57}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure3.fluid_b, PCM_Splitter2.fluid_a) annotation(
    Line(points = {{34, -76}, {21, -76}, {21, -65}, {13, -65}}, color = {0, 127, 255}));
  connect(PCMTank.T_amb, Tamb.y) annotation(
    Line(points = {{-9, 11}, {-21, 11}, {-21, -14}, {-47, -14}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure.fluid_b, PCM_Splitter1.fluid_a) annotation(
    Line(points = {{-44, 48}, {-30, 48}, {-30, 92}, {-13, 92}}, color = {0, 127, 255}));
  connect(PCM_Splitter1.fluid_b, pumpSimple_EqualPressure1.fluid_a) annotation(
    Line(points = {{13, 92}, {22, 92}, {22, 44}, {34, 44}}, color = {0, 127, 255}));
  connect(PCM_Splitter1.fluid_c, mass_loop_breaker.port_a) annotation(
    Line(points = {{0, 78}, {0, 70}}, color = {0, 127, 255}));
  connect(mass_loop_breaker.port_b, PCMTank.fluid_a) annotation(
    Line(points = {{0, 42}, {0, 35}, {1, 35}, {1, 28}}, color = {0, 127, 255}));
  connect(PCMTank.p_amb, p_amb.y) annotation(
    Line(points = {{11, 11}, {22, 11}, {22, -4}, {35, -4}}, color = {0, 0, 127}));
  connect(Recv_outlet.ports[1], pumpSimple_EqualPressure.fluid_a) annotation(
    Line(points = {{-96, 48}, {-64, 48}}, color = {0, 127, 255}));
  connect(PB_outlet.ports[1], pumpSimple_EqualPressure3.fluid_a) annotation(
    Line(points = {{106, -82}, {63, -82}, {63, -76}, {54, -76}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure.m_flow) annotation(
    Line(points = {{-82, 5}, {-74, 5}, {-74, 72}, {-54, 72}, {-54, 56}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure1.m_flow) annotation(
    Line(points = {{96, 3}, {70, 3}, {70, 70}, {44, 70}, {44, 52}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure3.m_flow) annotation(
    Line(points = {{96, 3}, {70, 3}, {70, -30}, {44, -30}, {44, -67}}, color = {0, 0, 127}));
  connect(Recv_Sink.port_a, pumpSimple_EqualPressure2.fluid_b) annotation(
    Line(points = {{-94, -36}, {-80, -36}, {-80, -66}, {-68, -66}}, color = {0, 127, 255}));
  connect(PB_Sink.port_a, pumpSimple_EqualPressure1.fluid_b) annotation(
    Line(points = {{-94, -36}, {-80, -36}, {-80, -66}, {-68, -66}}, color = {0, 127, 255}));
  annotation(
    Documentation(info = "<html>
    <p>This is a test case for charging and discharging a 3-PCM cascade storage system during consecutive ten cycles. Each cycle consists of 6 hours of charging, 10 hours of discharging and 8 hours of standby before the next charging process begins. This cascade storage system is designed to provide a 1000 MWh<sub>th</sub> discharge capacity for a hypothetical CSP plant being investigated by ASTRI. The detail of the design and the simulation condition was described in the publication (https://doi.org/10.1016/j.renene.2019.11.115). Initially, all three PCMs have a temperature of 540<sup>o</sup>C, below their solidification temperatures. During charging and discharging, liquid sodium enters at 750<sup>o</sup>C and 540<sup>o</sup>C, respectively. </p>
    
  		<img src=\"modelica://SolarTherm/Resources/Images/PCMModels/3PCMCascadeCycling.png\">
  		
  		<p>By Ming Liu on 23/06/2021</p>  		
  		</html>"),
  experiment(StopTime = 1728000, StartTime = 0, Tolerance = 1.0e-6, Interval = 20));

end Constant_Cycling_3PCMCascade_10cycles;
